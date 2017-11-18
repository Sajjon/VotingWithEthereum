pragma solidity ^0.4.18;

contract Voting {

	Party[] public parties;
	mapping(bytes32 => Party) public partyByName;

	struct Party {
		bytes32 name;
		uint voteCount;
	}

	function Voting(bytes32[] partyNames) public {
		for (uint i = 0; i < partyNames.length; i++) {
			parties.push(Party({
				name: partyNames[i],
				voteCount: 0
			}));
		}
	}

	function getVoteCountForParty(bytes32 partyName) 
		public
		view
		returns (uint)
	{
	  return partyByName[partyName].voteCount;
	}

	function voteForParty(bytes32 partyName) 
		public
	{
		require(partyByName[partyName].name.length > 0);
		partyByName[partyName].voteCount += 1;
	}

	function getName(bytes32 partyName) 
		public
		view
		returns (bytes32)
	{
		return partyByName[partyName].name;
	}

	// function getWinner() public view return (Party) {

	// }

}