//
// SPDX-License-Identifier: 
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/**
 * @title Time-locked Vault
 * @dev A smart contract for time-locked cryptocurrency storage
 * @author Your Name
 */
contract Project is Ownable, ReentrancyGuard {
    
    // Struct to store vault information
    struct Vault {
        uint256 amount;
        uint256 unlockTime;
        bool withdrawn;
        bool exists;
    }
    
    // Mapping from user address to their vault
    mapping(address => Vault) public vaults;
    
    // Events
    event VaultCreated(address indexed user, uint256 amount, uint256 unlockTime);
    event Withdrawal(address indexed user, uint256 amount);
    event EmergencyWithdrawal(address indexed user, uint256 amount, uint256 penalty);
    
    // Constants
    uint256 public constant MINIMUM_LOCK_TIME = 1 days;
    uint256 public constant MAXIMUM_LOCK_TIME = 365 days;
    uint256 public constant EMERGENCY_PENALTY_RATE = 10; // 10% penalty for emergency withdrawal
    
    // State variables
    uint256 public totalLockedFunds;
    bool public emergencyMode;
    
    constructor() Ownable(msg.sender) {}
    
    /**
     * @dev Deposit funds into a time-locked vault
     * @param _lockDuration Duration in seconds to lock the funds
     */
    function deposit(uint256 _lockDuration) external payable nonReentrant {
        require(msg.value > 0, "Deposit amount must be greater than 0");
        require(_lockDuration >= MINIMUM_LOCK_TIME, "Lock time too short");
        require(_lockDuration <= MAXIMUM_LOCK_TIME, "Lock time too long");
        require(!vaults[msg.sender].exists, "Vault already exists for this address");
        
        uint256 unlockTime = block.timestamp + _lockDuration;
        
        vaults[msg.sender] = Vault({
            amount: msg.value,
            unlockTime: unlockTime,
            withdrawn: false,
            exists: true
        });
        
        totalLockedFunds += msg.value;
        
        emit VaultCreated(msg.sender, msg.value, unlockTime);
    }
    
    /**
     * @dev Withdraw funds from vault after lock period expires
     */
    function withdraw() external nonReentrant {
        Vault storage userVault = vaults[msg.sender];
        
        require(userVault.exists, "No vault found for this address");
        require(!userVault.withdrawn, "Funds already withdrawn");
        require(block.timestamp >= userVault.unlockTime, "Vault is still locked");
        
        uint256 amount = userVault.amount;
        userVault.withdrawn = true;
        totalLockedFunds -= amount;
        
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "Transfer failed");
        
        emit Withdrawal(msg.sender, amount);
    }
    
    /**
     * @dev Emergency withdrawal with penalty (can be called before unlock time)
     */
    function emergencyWithdraw() external nonReentrant {
        require(!emergencyMode, "Emergency mode disabled");
        
        Vault storage userVault = vaults[msg.sender];
        
        require(userVault.exists, "No vault found for this address");
        require(!userVault.withdrawn, "Funds already withdrawn");
        
        uint256 penalty = (userVault.amount * EMERGENCY_PENALTY_RATE) / 100;
        uint256 withdrawAmount = userVault.amount - penalty;
        
        userVault.withdrawn = true;
        totalLockedFunds -= userVault.amount;
        
        // Transfer funds to user (minus penalty)
        (bool success, ) = payable(msg.sender).call{value: withdrawAmount}("");
        require(success, "Transfer failed");
        
        emit EmergencyWithdrawal(msg.sender, withdrawAmount, penalty);
    }
    
    /**
     * @dev Get vault information for a specific address
     * @param _user Address to query vault information for
     * @return amount Amount locked in vault
     * @return unlockTime Timestamp when vault can be unlocked
     * @return withdrawn Whether funds have been withdrawn
     * @return timeRemaining Seconds remaining until unlock (0 if already unlocked)
     */
    function getVaultInfo(address _user) external view returns (
        uint256 amount,
        uint256 unlockTime,
        bool withdrawn,
        uint256 timeRemaining
    ) {
        Vault memory userVault = vaults[_user];
        require(userVault.exists, "No vault found for this address");
        
        amount = userVault.amount;
        unlockTime = userVault.unlockTime;
        withdrawn = userVault.withdrawn;
        
        if (block.timestamp >= unlockTime) {
            timeRemaining = 0;
        } else {
            timeRemaining = unlockTime - block.timestamp;
        }
    }
    
    /**
     * @dev Check if vault is unlocked for a specific address
     * @param _user Address to check
     * @return true if vault is unlocked, false otherwise
     */
    function isVaultUnlocked(address _user) external view returns (bool) {
        require(vaults[_user].exists, "No vault found for this address");
        return block.timestamp >= vaults[_user].unlockTime;
    }
    
    /**
     * @dev Toggle emergency mode (only owner)
     */
    function toggleEmergencyMode() external onlyOwner {
        emergencyMode = !emergencyMode;
    }
    
    /**
     * @dev Withdraw accumulated penalties (only owner)
     */
    function withdrawPenalties() external onlyOwner {
        uint256 contractBalance = address(this).balance;
        uint256 availablePenalties = contractBalance - totalLockedFunds;
        
        require(availablePenalties > 0, "No penalties to withdraw");
        
        (bool success, ) = payable(owner()).call{value: availablePenalties}("");
        require(success, "Transfer failed");
    }
    
    /**
     * @dev Get contract statistics
     * @return totalLocked Total amount locked in all vaults
     * @return contractBalance Total contract balance
     * @return accumulatedPenalties Penalties available for withdrawal
     */
    function getContractStats() external view returns (
        uint256 totalLocked,
        uint256 contractBalance,
        uint256 accumulatedPenalties
    ) {
        totalLocked = totalLockedFunds;
        contractBalance = address(this).balance;
        accumulatedPenalties = contractBalance > totalLocked ? contractBalance - totalLocked : 0;
    }
    
    // Fallback function to reject direct transfers
    receive() external payable {
        revert("Direct transfers not allowed. Use deposit() function.");
    }
}
