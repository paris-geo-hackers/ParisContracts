# Intro

Our project consists of different repo's:
Front-end: https://github.com/paris-geo-hackers/geoquete-app
ZK contracts: https://github.com/paris-geo-hackers/ParisCircuits
Smart contracts: https://github.com/paris-geo-hackers/ParisContracts
The Graph: 

# ParisContracts

Try running some of the following tasks to compile, test and deploy the contracts:

```shell
npx hardhat compile
pnx hardhat test
npx hardhat run scripts/deploy.ts --network polygonMumbai
```


# Deployment contracts

Goerli testnet: https://goerli.etherscan.io/address/0x32e57abe760167b676ae69e97bc269303a942ee7
Polygon Mumbai testnet: https://mumbai.polygonscan.com/address/0x82dede95871ab51d14bfa70da2c97c8c27631532
Polygon zkEMV testnet: https://testnet-zkevm.polygonscan.com/address/0x7eebf5cce9911765c6a9478ab9251f92f30ff4db
Mantle testnet: https://explorer.testnet.mantle.xyz/address/0x123a40a856d4a009Bb709c7828355C8Bc7309b57
Gnosis Chiado testnet: https://blockscout.chiadochain.net/address/0xE57bae05b7568E1b2b03104bD171ab94F54BcbFE
Linea testnet: https://explorer.goerli.linea.build/address/0x7EeBF5cCe9911765C6a9478aB9251f92f30Ff4db
Celo testnet: https://alfajores.celoscan.io/address/0xe57bae05b7568e1b2b03104bd171ab94f54bcbfe


# Sandboxed UMA V3 oracle on Polygon Mumbai:

The V3 Oracle by UMA was not available on Polygon Mumbai testnet. We used a sandboxed V3 Oracle on Mumbai for testing.

  Deployed Finder at 0xa7568E44Ae1f4B44279eaaC20c8F1f82b039711E

  Deployed Store at 0x300F22fc5659190Cd6dE4FfFe4C84f3F52C188CB

  Deployed AddressWhitelist at 0x902b9a1c61386522d487bbf7cEE61bDB96032113

  Deployed IdentifierWhitelist at 0x5a8e9B93F3d8c1E5678B1EA98bE0339c48B6f045

  Deployed MockOracleAncillary at 0xFA9861b79F7f23dD6d4f35379B3049dFf82Da657

  Deployed Optimistic Oracle V3 at 0xAfAE2dD69F115ec26DFbE2fa5a8642D94D7Cd37E
