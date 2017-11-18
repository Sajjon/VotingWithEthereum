pragma solidity ^0.4.11;

contract Voting {

	uint constant public voteCount;

	function vote() public {
		voteCount += 1;
	}

}