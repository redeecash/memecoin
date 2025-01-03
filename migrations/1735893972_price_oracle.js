const PriceOracle = artifacts.require("PriceOracle");

module.exports = async function (deployer) {
  // Deploy PriceOracle
  await deployer.deploy(PriceOracle);

  // Log the deployed address
  console.log("PriceOracle deployed at:", PriceOracle.address);
};
