pragma solidity ^0.4.18;

contract Voting {

	struct Party {
        bytes32 name;
        uint count;
    }
    
	bytes32[] public partyHashes;

    mapping(address => bytes32) addressVote;
    mapping(bytes32 => Party) partyByHash;


    function getNumberOfPartiesVotedFor() public view returns (uint) {
        return partyHashes.length;
    }

    function voteAs(address voter, bytes32 nameOfParty) public {
        bytes32 nameHash = keccak256(nameOfParty);
   
        if (keccak256(partyByHash[nameHash].name) != keccak256(nameOfParty)) {
            partyHashes.push(nameHash);        
            partyByHash[nameHash].name = nameOfParty;
        }
        
        partyByHash[addressVote[voter]].count -= 1;
        partyByHash[nameHash].count += 1;
        addressVote[voter] = nameHash;
    }

    function vote(bytes32 nameOfParty) public {
    	voteAs(msg.sender, nameOfParty);
    }

    function getWinningParty() public view returns (bytes32 nameOfParty, uint maxVoteCount) {
        maxVoteCount = 0;
		nameOfParty = "";
		for (uint i = 0; i < partyHashes.length; i++) {
            bytes32 partyHash = partyHashes[i];
			if (partyByHash[partyHash].count > maxVoteCount) {
				maxVoteCount = partyByHash[partyHash].count;
				nameOfParty = partyByHash[partyHash].name;
			}
		}
		
		return (nameOfParty, maxVoteCount);
    }

    function getVoteCountByName(bytes32 nameOfParty) public view returns (uint) {
        bytes32 nameHash = keccak256(nameOfParty);
        return partyByHash[nameHash].count;
    }

}