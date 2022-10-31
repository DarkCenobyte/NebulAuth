var DummyToken = artifacts.require("DummyToken");

module.exports = function(deployer, network) {
  // deployment steps
  if (network != "ethereum" && network != "mainnet") {
    deployer.deploy(DummyToken, {overwrite: false});
  }
};