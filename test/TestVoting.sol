pragma solidity ^0.4.18;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Voting.sol";

contract TestVoting {
	Voting voting = Voting(DeployedAddresses.Voting());

	bytes32 constant ethereumPartyName = "Ethereum Party";
	bytes32 constant bitcoinPartyName = "Bitcoin Party";

	function testVotingForParty() public {
		uint expected = 0;

		Assert.equal(voting.getVoteCountForParty(ethereumPartyName), expected, "Vote count for party A should start at 0");
		voting.voteForParty(ethereumPartyName);
		expected = 1;
		Assert.equal(voting.getVoteCountForParty(ethereumPartyName), expected, "Vote count for party A should be 1 after voting");
		expected = 0;
		Assert.equal(voting.getVoteCountForParty(bitcoinPartyName), expected, "Vote count for party B should be 0");
	}


	function testKek() public {
		Assert.equal(keccak256("fdfds"), keccak256("fdfds"),"kek not good");
		Assert.equal(keccak256("fdfds")!=keccak256("fdfds"),false,"kfdsfdsfsek not good");
	}

	function testGetName() public {
		bytes32 nonExistingParty = "nonExistingParty";
		bytes32 expected = "";
		bytes32 nameFromVoting = voting.getName(nonExistingParty);
		Assert.equal(nameFromVoting, expected, "name should be empty");
	}

	function testVotingForNonExistingParty() public {
		bytes32 nonExistingParty = "foobar";
		uint expected = 0;

		Assert.equal(voting.getVoteCountForParty(nonExistingParty), expected, "should be 0");
		voting.voteForParty(nonExistingParty);
		Assert.equal(voting.getVoteCountForParty(nonExistingParty), expected, "should still be 0");
		
	}
}