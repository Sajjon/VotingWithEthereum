pragma solidity ^0.4.18;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Voting.sol";

contract TestVoting {
	Voting voting = Voting(DeployedAddresses.Voting());

	function testNoDuplicatesInArrayOfHashes() public {
		bytes32 foobarParty = "Party foobar";
		voting.vote(foobarParty);
		uint expectedPartyCount = 1;
		Assert.equal(voting.getNumberOfPartiesVotedFor(), expectedPartyCount, "should be 1 party in list");
		voting.vote(foobarParty);
		Assert.equal(voting.getNumberOfPartiesVotedFor(), expectedPartyCount, "should still be 1 party in list");
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
		voting.voteAs(voterA, partyA);
		uint expectedVoteCount = 1;
		Assert.equal(voting.getVoteCountByName(partyA), expectedVoteCount, "Party A should have 1 votes, even though we have voted multiple times");
		
		voting.voteAs(voterA, partyB);
		expectedVoteCount = 0;
		Assert.equal(voting.getVoteCountByName(partyA), expectedVoteCount, "Party A should have 0 votes, since voter A change her vote");
		expectedVoteCount = 1;
		Assert.equal(voting.getVoteCountByName(partyB), expectedVoteCount, "Party B should have 1 vote, since voter A change her vote");

		voting.voteAs(voterA, partyA);
		expectedVoteCount = 1;
		Assert.equal(voting.getVoteCountByName(partyA), expectedVoteCount, "Party A should have 1 votes, since we again change our vote");
		

		voting.voteAs(voterB, partyA);
		voting.voteAs(voterC, partyB);
		expectedVoteCount = 2;

		Assert.equal(voting.getVoteCountByName(partyA), expectedVoteCount, "Party A should have 2 votes");
		expectedVoteCount = 1;
		Assert.equal(voting.getVoteCountByName(partyB), expectedVoteCount, "Party B should have 1 votes");
		expectedVoteCount = 2;
		var (nameOfWinningParty, voteCountOfWinningParty) = voting.getWinningParty();
		bytes32 winner = nameOfWinningParty;
		Assert.equal(keccak256(winner) == keccak256(partyA), true, "Party A should be the winning party");
		Assert.equal(voteCountOfWinningParty, expectedVoteCount, "Winning Party A should have vote count of 2");
	}
}