pragma solidity ^0.4.18;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Voting.sol";

contract TestVoting {
	Voting voting = Voting(DeployedAddresses.Voting());


	function _testVote() {
		//att gemföra 2 bytes32 går toppen men inte litterals
		bytes32 partyA = "johannes partiet";
		bytes32 partyB = "inte johannes partiet";
		voting.vote(partyA);
		voting.vote(partyA);
		voting.vote(partyA);
		voting.vote(partyB);
		voting.vote(partyB);
		uint expected = 3;
		var (maxname,max) = voting.getMax();

		Assert.equal(max,expected, "count should be 1");
		Assert.equal(keccak256(maxname)==keccak256(partyA), true, "johannes partiet should reign supreme");
	}

	function _testVote2() {
		
		bytes32 partyA = "johannes partiet";
		bytes32 partyB = "inte johannes partiet";
		voting.vote(partyA);
		voting.vote(partyA);
		voting.vote(partyA);
		voting.vote(partyB);
		voting.vote(partyB);
		uint expected = 1;
		var (maxname,max) = voting.getMax();

		Assert.equal(max,expected, "count should be 1");
		Assert.equal(keccak256(maxname)==keccak256(partyB), true, "johannes partiet should reign supreme");
	}

	function _testVote3() {
		address voterA = 0x1234;
		address voterB = 0x1235;
		bytes32 partyA = "johannes partiet";
		bytes32 partyB = "inte johannes partiet";
		voting.voteAs(voterA,partyA);
		voting.voteAs(voterB,partyB);
		voting.voteAs(voterB,partyA);
		uint expected = 2;
		var (maxname,max) = voting.getMax();
		Assert.equal(max,expected, "count should be 12");
		Assert.equal(keccak256(maxname)==keccak256(partyA), true, "johannes partiet should reign supreme");
	}

	function testVote() {
		address voterA = 0x1234;
		address voterB = 0x1235;
		address voterC = 0x1236;
		bytes32 partyA = "johannes partiet";
		bytes32 partyB = "inte johannes partiet";
		voting.voteAs(voterA,partyA);
		voting.voteAs(voterB,partyA);
		voting.voteAs(voterC,partyB);

		uint expected = 2;
		Assert.equal(voting.getVoteCountByName(partyA),expected, "party A should have 2 votes");
		expected = 1;
		Assert.equal(voting.getVoteCountByName(partyB),expected, "party B should have 1 votes");
	}
}