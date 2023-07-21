require("hardhat");

async function main() {
// Deploy the oracle with WMATIC as currency on the sandboxed contract on Mumbai 
  const oracle = await ethers.deployContract("OOV3_SettleWinner", ["0x9c3C9283D3e44854697Cd22D3Faa240Cfb032889", 20, "0xAfAE2dD69F115ec26DFbE2fa5a8642D94D7Cd37E"]);

  await oracle.waitForDeployment();

  console.log(
    `Oracle contract deployed to ${oracle.target}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
