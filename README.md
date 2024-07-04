
# GTX Token and Sale Contracts

This repository contains smart contracts for the GTX Token (ERC-20) and its associated token sale. The contracts are built using OpenZeppelin v5 libraries and include features for governance, role-based access control, and anti-sniper mechanisms.

## Contracts
#### GTXToken-contract address: 0x02b19d3db64c44c3D839eC3a182A21659dcA810E [Verify on Etherscan](https://sepolia.etherscan.io/address/0x02b19d3db64c44c3D839eC3a182A21659dcA810E)
#### TokenSale-contract address: 0xB09157B2C3ec65bEef9a90Cd2D1Daca5eeCfc1B9 [Verify on Etherscan](https://sepolia.etherscan.io/address/0xB09157B2C3ec65bEef9a90Cd2D1Daca5eeCfc1B9)
### GTXToken

The `GTXToken` contract is an ERC-20 token with the following features:

- ERC20 standard functionality
- Access control for minting and burning
- ERC20Permit for gasless approvals
- ERC20Votes for governance capabilities
- Maximum supply cap

### TokenSale

The `TokenSale` contract manages the public sale of GTX tokens with the following features:

- Configurable sale period
- Dynamic pricing
- Anti-sniper mechanisms (transfer limits)
- Owner-only functions for withdrawing funds and unsold tokens

## Features

- **Governance Model**: The GTX Token includes voting capabilities, allowing for future integration of governance functionalities.
- **Role-Based Access Control**: Minting and burning functions are restricted to specific roles.
- **Anti-Sniper Checks**: The TokenSale contract implements purchase limits to prevent sniping during the sale.
- **OpenZeppelin v5**: Utilizes the latest OpenZeppelin libraries for enhanced security and efficiency.

## Usage

1. Deploy the `GTXToken` contract
2. Deploy the `TokenSale` contract, passing the GTX Token address and sale parameters
3. Transfer GTX tokens to the TokenSale contract
4. Start the sale by setting the appropriate sale period
5. Users can purchase tokens by sending ETH to the TokenSale contract
6. The owner can withdraw funds and unsold tokens after the sale ends


## Security

These contracts use battle-tested OpenZeppelin libraries and implement best practices for smart contract development. However, a thorough audit is recommended before mainnet deployment.

## License

This project is licensed under the MIT License.

## Disclaimer

This code is provided as-is and should be carefully reviewed and audited before any real-world usage. The authors are not responsible for any losses incurred through the use of this software.
