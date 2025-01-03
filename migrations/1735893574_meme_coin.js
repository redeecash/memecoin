const MemeCoin = artifacts.require("MemeCoin");
const PriceOracle = artifacts.require("PriceOracle");

module.exports = async function (deployer) {
  // Retrieve deployed PriceOracle address
  const priceOracleInstance = await PriceOracle.deployed();
  const priceOracleAddress = priceOracleInstance.address;

  // Set initial supply for MemeCoin (e.g., 1,000,000 tokens)
  const initialSupply = web3.utils.toWei('1000000', 'ether'); // Assuming 18 decimals
  const initialPrice = 2000;

  // Deploy MemeCoin with initial supply and PriceOracle address
  await deployer.deploy(MemeCoin, initialSupply, priceOracleAddress, initialPrice);

  // Log the deployed address
  console.log("MemeCoin deployed at:", MemeCoin.address);
};
