var Voting = artifacts.require("Voting.sol");

module.exports = function(deployer) {
  deployer.deploy(Voting, ["Ethereum Party", "Bitcoin Party"]);
};
