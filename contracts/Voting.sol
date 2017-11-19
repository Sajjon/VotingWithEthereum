pragma solidity ^0.4.18;

contract Voting {

	struct Party {
        bytes32 name;
        bytes32 nameHash;
        uint count;
    }
    
	bytes32[] public partyHashes;

    mapping(address => bytes32) addressVote;
    mapping(bytes32 => Party) partyByHash;

    function add(bytes32 nameHash) private returns (bool) {        
        bool exists = ((partyByHash[nameHash].nameHash == nameHash) && (partyByHash[nameHash].count > 0));
        partyByHash[nameHash].count += 1;
        return exists;
    }

    //TODO: remove entires with less than 1 vote
    function sub(bytes32 nameHash) private {
        partyByHash[nameHash].count -= 1;
    }

    function voteAs(address voter, bytes32 nameOfParty) public {
        bytes32 nameHashOld = addressVote[voter];
        sub(nameHashOld);
        
        bytes32 nameHash = keccak256(nameOfParty);
        addressVote[voter] = nameHash;

        //increment this vote
        bool found = add(nameHash);
    
        if (!found) {
            partyByHash[nameHash] = Party({
                name: nameOfParty,
                nameHash: nameHash,
                count: 1
            });
            partyHashes.push(nameHash);
        }
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