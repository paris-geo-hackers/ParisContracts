
const { ethers } = require("hardhat");
require('dotenv').config({ path: __dirname + '/.env' });

// // Deployment commands to run:
// yarn run ts-node --files .\scripts\deploy.js "0x328507DC29C95c170B56a1b3A758eB7a9E73455c" "200" "0x9923D42eF695B5dd9911D05Ac944d4cAca3c4EAB" --network goerli
// yarn run ts-node --files .\scripts\deploy.js "0x9c3C9283D3e44854697Cd22D3Faa240Cfb032889" "200" "0xAfAE2dD69F115ec26DFbE2fa5a8642D94D7Cd37E" --network polygonMumbai
// yarn run ts-node --files .\scripts\deploy.js "0x9c3C9283D3e44854697Cd22D3Faa240Cfb032889" "200" "0x22A9AaAC9c3184f68C7B7C95b1300C4B1D2fB95C" --network gnosis

async function main() {

  // const args = process.argv;
  // const game = await ethers.deployContract("Game", [args[2], args[3], args[4]]);
  // console.log(args[2]);
  // console.log(args[3]);
  // console.log(args[4]);

  // const game = await ethers.deployContract("Game", ["0x9c3C9283D3e44854697Cd22D3Faa240Cfb032889", 200, "0xAfAE2dD69F115ec26DFbE2fa5a8642D94D7Cd37E"], { gasLimit: 10000000});

  const game = await ethers.deployContract("Game", ["0x328507DC29C95c170B56a1b3A758eB7a9E73455c", 10, "0x9923D42eF695B5dd9911D05Ac944d4cAca3c4EAB"]);

  await game.waitForDeployment();
 

  console.log(
    `Contract deployed to ${game.target} . Run the script below to verify.`
  );

  console.log(
    `npx hardhat verify --network networkname ${game.target} ${args[2]} ${args[3]} ${args[4]}`
  )
  
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
