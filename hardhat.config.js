require('dotenv').config({ path: __dirname + '/.env' })
require("@nomicfoundation/hardhat-toolbox");


module.exports = {
  solidity: "0.8.16",
  networks: {
    goerli: {
      url: `https://goerli.infura.io/v3/${process.env.INFURA_API_KEY}`,
      accounts: [process.env.PRIVATE_KEY],
    },
    polygonMumbai: {
      url: `https://rpc.eu-north-1.gateway.fm/v4/polygon/non-archival/mumbai`,
      accounts: [process.env.PRIVATE_KEY],
    },
    zkEVMtestnet: {
      url: `https://rpc.public.zkevm-test.net`,
      accounts: [process.env.PRIVATE_KEY],
    },
    mantle: {
      url: 'https://rpc.testnet.mantle.xyz',
      accounts: [process.env.PRIVATE_KEY],
    },
    chiado: {
      url: "https://rpc.chiadochain.net",
      gasPrice: 1000000000,
      accounts: [process.env.PRIVATE_KEY],
    },
    linea: {
      url: `https://linea-goerli.infura.io/v3/${process.env.INFURA_API_KEY}`,
      accounts: [process.env.PRIVATE_KEY],
    },
    alfajores: {
      url: "https://alfajores-forno.celo-testnet.org",
      accounts: [process.env.PRIVATE_KEY],
      chainId: 44787
    }
  },
  etherscan: {
    apiKey: {
      goerli: process.env.POLYGON_API_KEY,
      polygonMumbai: process.env.POLYGON_API_KEY,
      mantle: process.env.MANTLE_API_KEY,
    },
    customChains: [
      {
        network: 'mantle',
        chainId: 5001,
        urls: {
          apiURL: 'https://explorer.testnet.mantle.xyz/api',
          browserURL: 'https://explorer.testnet.mantle.xyz',
        },
      },
      {
        network: "chiado",
        chainId: 10200,
        urls: {
          //Blockscout
          apiURL: "https://blockscout.com/gnosis/chiado/api",
          browserURL: "https://blockscout.com/gnosis/chiado",
        },
      },
      {
        network: "zkEVMtestnet",
        chainId: 1442,
        urls: {
          apiURL: "https://rpc.public.zkevm-test.net",
          browserURL: "https://testnet-zkevm.polygonscan.com",
        },
      },
    ],
  },

};
