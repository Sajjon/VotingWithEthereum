pragma solidity ^0.4.11;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Voting.sol";

contract TestVoting {
	Voting voting = Voting(DeployedAddresses.Voting());

	function testVoting() {
		Assert.equal(voting.voteCount, 0, "Vote count should start at 0");
		voting.vote();
		Assert.equal(voting.voteCount, 1, "Vote count should be 1 after voting");
	}
}