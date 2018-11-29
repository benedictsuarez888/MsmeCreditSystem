var CreditingSystem = artifacts.require("./CreditingSystem.sol");

module.exports = function(deployer) {
  deployer.deploy(CreditingSystem);
};
