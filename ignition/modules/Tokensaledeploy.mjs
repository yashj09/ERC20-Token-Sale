import hre from "hardhat";

async function main() {
  const TokenSale = await hre.ethers.getContractFactory("TokenSale");
  const [deployer] = await hre.ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  const tokenAddress = "0x02b19d3db64c44c3D839eC3a182A21659dcA810E";
  const price = hre.ethers.parseEther("0.001");
  const saleStart = Math.floor(Date.now() / 1000) + 3600; 
  const saleEnd = saleStart + 7 * 24 * 3600;

  console.log("Token Address:", tokenAddress);
  console.log("Price:", price.toString());
  console.log("Sale Start:", saleStart);
  console.log("Sale End:", saleEnd);

  const tokenSale = await TokenSale.deploy(tokenAddress, price, saleStart, saleEnd);
  await tokenSale.waitForDeployment();

  const tokenSaleAddress = await tokenSale.getAddress();
  console.log("TokenSale deployed to:", tokenSaleAddress);

  if (hre.network.name !== "hardhat" && hre.network.name !== "localhost") {
    console.log("Waiting for a few block confirmations...");
    await tokenSale.deploymentTransaction().wait(5);

    console.log("Verifying contract on Etherscan...");
    try {
      await hre.run("verify:verify", {
        address: tokenSaleAddress,
        constructorArguments: [tokenAddress, price, saleStart, saleEnd],
      });
    } catch (error) {
      console.error("Error during verification:", error);
    }
  }
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });