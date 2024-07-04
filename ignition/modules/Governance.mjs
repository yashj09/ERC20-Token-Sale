import hre from "hardhat";

async function main() {
  const GTXToken = await hre.ethers.getContractFactory("GTXToken");
  const gtxToken = await GTXToken.deploy();
  await gtxToken.waitForDeployment();
  console.log("GTXToken deployed to:",await gtxToken.getAddress());
}
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
