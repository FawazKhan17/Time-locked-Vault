# Time-locked Vault

A secure smart contract system for time-locked cryptocurrency storage built on Solidity using the Hardhat development framework.

## Project Description

The Time-locked Vault is a decentralized smart contract that allows users to deposit cryptocurrency for a predetermined period, ensuring funds cannot be accessed until the lock period expires. This contract provides a secure way to implement time-based savings, vesting schedules, or self-imposed spending restrictions.

The contract features emergency withdrawal capabilities (with penalties), owner management functions, and comprehensive vault tracking. All funds are secured through battle-tested OpenZeppelin contracts and include reentrancy protection.

## Project Vision

Our vision is to create a trustless, transparent, and secure time-locking mechanism that empowers individuals and organizations to:

- **Exercise Financial Discipline**: Help users save money by preventing impulsive spending
- **Implement Vesting Schedules**: Enable companies to create employee token vesting programs
- **Create Trust Funds**: Allow parents to set aside funds for their children's future
- **Build DeFi Infrastructure**: Provide a foundational component for more complex DeFi protocols

We aim to make time-locked storage accessible, secure, and user-friendly while maintaining complete decentralization and transparency.

## Key Features

### Core Functionality
- **⏰ Flexible Time Locks**: Set custom lock periods from 1 day to 365 days
- **💰 Secure Deposits**: Safe ETH deposits with event logging and tracking
- **🔐 Automatic Unlocking**: Funds automatically become available after lock period
- **📊 Vault Information**: Comprehensive vault details including time remaining

### Security Features
- **🛡️ Reentrancy Protection**: Built-in protection against reentrancy attacks
- **✅ Access Control**: Owner-based permissions for administrative functions
- **🔒 Input Validation**: Comprehensive validation of all user inputs
- **💾 State Management**: Proper state updates and fund tracking

### Advanced Features
- **🚨 Emergency Withdrawal**: Access funds early with a 10% penalty fee
- **📈 Statistics Tracking**: Monitor total locked funds and contract metrics
- **⚡ Gas Optimized**: Efficient smart contract design for lower transaction costs
- **🎛️ Admin Controls**: Owner functions for emergency mode and penalty withdrawal

### User Experience
- **📱 Simple Interface**: Easy-to-use functions for deposit and withdrawal
- **📊 Real-time Status**: Check vault status and remaining lock time
- **🔔 Event Logging**: Comprehensive event system for transaction tracking
- **💡 Clear Error Messages**: Descriptive error messages for better user experience

## Future Scope

### Phase 1: Enhanced Features
- **Multi-token Support**: Extend beyond ETH to support ERC-20 tokens
- **Partial Withdrawals**: Allow users to withdraw portions of their locked funds
- **Interest Generation**: Integrate with lending protocols to earn yield on locked funds
- **Mobile App Integration**: Develop mobile applications for easier access

### Phase 2: Advanced Functionality
- **NFT Integration**: Support for locking NFTs with time-based unlocking
- **Governance Token**: Implement platform governance through voting tokens
- **Cross-chain Support**: Deploy on multiple blockchain networks
- **Social Recovery**: Add social recovery mechanisms for lost private keys

### Phase 3: Ecosystem Expansion
- **DeFi Integrations**: Connect with major DeFi protocols for enhanced functionality
- **Institutional Features**: Add features tailored for institutional use cases
- **Analytics Dashboard**: Comprehensive analytics and reporting tools
- **API Development**: RESTful APIs for third-party integrations

### Phase 4: Innovation
- **AI-powered Recommendations**: Smart suggestions for optimal lock periods
- **Insurance Integration**: Optional insurance coverage for locked funds
- **Regulatory Compliance**: Features to support regulatory requirements
- **Layer 2 Solutions**: Deploy on Layer 2 networks for reduced fees

## Installation & Setup

```bash
# Clone the repository
git clone <repository-url>
cd time-locked-vault

# Install dependencies
npm install

# Copy environment file and configure
cp .env.example .env
# Edit .env file with your private key

# Compile contracts
npm run compile

# Deploy to Core Testnet 2
npm run deploy

# Run local tests
npm test
```

## Usage

### Deploying the Contract
```bash
# Deploy to Core Testnet 2
npx hardhat run scripts/deploy.js --network core_testnet2

# Deploy to local network
npx hardhat run scripts/deploy.js --network localhost
```

### Interacting with the Contract
```javascript
// Deposit funds (lock for 30 days)
await contract.deposit(30 * 24 * 60 * 60, { value: ethers.utils.parseEther("1.0") });

// Check vault information
const vaultInfo = await contract.getVaultInfo(userAddress);

// Withdraw funds (after lock period)
await contract.withdraw();

// Emergency withdrawal (with penalty)
await contract.emergencyWithdraw();
```

## Contract Architecture

The smart contract is built using:
- **Solidity 0.8.19**: Latest stable Solidity version
- **OpenZeppelin Contracts**: Industry-standard security implementations
- **Hardhat Framework**: Professional development and testing environment
- **Core Testnet 2**: Deployed on Core blockchain testnet

## Security Considerations

- All funds are secured in the smart contract with proper access controls
- Reentrancy protection prevents common attack vectors  
- Emergency withdrawal includes penalty mechanism to discourage abuse
- Owner functions are protected and limited in scope
- Comprehensive input validation prevents invalid operations

## Contributing

We welcome contributions! Please read our contributing guidelines and submit pull requests for any improvements.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

0xc65A7602074f072106dd22f29C257B666F333205
![Uploading image.png…]()

---

**⚠️ Disclaimer**: This smart contract is for educational and demonstration purposes. Always conduct thorough testing and audits before using in production environments with real funds.
