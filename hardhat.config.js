require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.16",

  // networks: {
  //   hardhat: {
  //     forking: {
  //       url: `https://polygon-mumbai.g.alchemy.com/v2/${process.env.MUMBAI_API_KEY}`,
  //     },
  //   },
  //   polygonMumbai: {
  //     url: `https://rpc.eu-north-1.gateway.fm/v4/polygon/non-archival/mumbai`,
  //     accounts: [process.env.PRIVATE_KEY],
  //   },
  //   scroll: {
  //     url: 'https://alpha-rpc.scroll.io/l2' || '',
  //     accounts: [process.env.PRIVATE_KEY],
  //   },
  //   taiko: {
  //     url: 'http://rpc.test.taiko.xyz',
  //     accounts: [process.env.PRIVATE_KEY],
  //   },
  //   mantle: {
  //     url: 'https://rpc.testnet.mantle.xyz',
  //     accounts: [process.env.PRIVATE_KEY],
  //   },
  //   optimisticEthereum: {
  //     url: 'https://mainnet.optimism.io',
  //     accounts: [process.env.PRIVATE_KEY],
  //   }
  },
};
