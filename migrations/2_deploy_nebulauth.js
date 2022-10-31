var NebulAuth = artifacts.require("NebulAuth");

module.exports = function(deployer) {
    // deployment steps
    deployer.deploy(NebulAuth, {overwrite: true});
};