pragma solidity ^0.4.18;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Voting.sol";

contract TestVoting {
	Voting voting = Voting(DeployedAddresses.Voting());

	function _testNoDuplicatesInArrayOfHashes() public {
		address voterA = 0x1234;
		address voterB = 0x1235;
		address voterC = 0x1236;
		bytes32 partyA = "Party A";
		bytes32 partyB = "Party B";
		voting.voteAs(voterA, partyA);
		Assert.equal(voting.getNumberOfPartiesVotedFor(), 1, "should be 1 party in list");
		voting.voteAs(voterB, partyA);
		Assert.equal(voting.getNumberOfPartiesVotedFor(), 1, "should still be 1 party in list");
		voting.voteAs(voterC, partyB);
		Assert.equal(voting.getNumberOfPartiesVotedFor(), 2, "should be 2 parties in list");
	}

	function testVote() public {
		address voterA = 0x1234;
		address voterB = 0x1235;
		address voterC = 0x1236;
		bytes32 partyA = "Party A";
		bytes32 partyB = "Party B";

		// Voting multiple times should note increase the counter.
		voting.voteAs(voterA, partyA);
		voting.voteAs(voterA, partyA);
		Assert.equal(voting.getVoteCountByName(partyA), 1, "Party A should have 1 votes, even though we have voted multiple times");
		
		voting.voteAs(voterA, partyB);
		Assert.equal(voting.getVoteCountByName(partyA), 0, "Party A should have 0 votes, since voter A change her vote");
		Assert.equal(voting.getVoteCountByName(partyB), 1, "Party B should have 1 vote, since voter A change her vote");

		voting.voteAs(voterA, partyA);
		Assert.equal(voting.getVoteCountByName(partyA), 1, "Party A should have 1 votes, since we again change our vote");

		voting.voteAs(voterB, partyA);
		voting.voteAs(voterC, partyB);

		Assert.equal(voting.getVoteCountByName(partyA), 2, "Party A should have 2 votes");
		Assert.equal(voting.getVoteCountByName(partyB), 1, "Party B should have 1 votes");
		
		var (nameOfWinningParty, voteCountOfWinningParty) = voting.getWinningParty();
		Assert.equal(keccak256(nameOfWinningParty), keccak256(partyA), "Party A should be the winning party");
		Assert.equal(voteCountOfWinningParty, 2, "Winning Party A should have vote count of 2");
	}
}