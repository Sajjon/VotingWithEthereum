pragma solidity ^0.4.18;

contract Voting {

	uint8 public voteCount = 0;

	function getVoteCount() public 
		returns (uint8) 
	{
	  return voteCount;
	}

	function vote() public {
		voteCount += 1;
	}

}