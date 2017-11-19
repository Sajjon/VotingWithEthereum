pragma solidity ^0.4.18;

contract Voting {

	struct Party {
        bytes32 name;
        bytes32 nameHash;
        uint count;
    }
    
	Party[] public parties;

    mapping(address => bytes32) addressVote;

    function add(bytes32 nameHash) private returns (bool) {
        for (uint i = 0; i < parties.length; i++) {
            if(parties[i].nameHash == nameHash) {
                parties[i].count += 1;
                return true;
            }
        }
        return false;
    }

    //TODO: remove entires with less than 1 vote
    function sub(bytes32 nameHash) private {
        for (uint i = 0; i < parties.length; i++) {
            if(parties[i].nameHash == nameHash) {
                parties[i].count -= 1;
            }
        }
    }

    function voteAs(address voter, bytes32 nameOfParty) public {
        bytes32 nameHashOld = addressVote[voter];
        sub(nameHashOld);
        
        bytes32 nameHash = keccak256(nameOfParty);
        addressVote[voter] = nameHash;

        //increment this vote
        bool found = add(nameHash);
    
        if (!found) {
            parties.push(
                Party({
                    name: nameOfParty,
                    nameHash: nameHash,
                    count: 1
                })
            );
        }
    }

    function vote(bytes32 nameOfParty) public {
    	voteAs(msg.sender, nameOfParty);
    }

    function getWinningParty() public view returns (bytes32 nameOfParty, uint maxVoteCount) {
        maxVoteCount = 0;
		nameOfParty = "";
		for (uint i = 0; i < parties.length; i++) {
			if (parties[i].count > maxVoteCount) {
				maxVoteCount = parties[i].count;
				nameOfParty = parties[i].name;
			}
		}
		
		return (nameOfParty, maxVoteCount);
    }

    function getVoteCountByName(bytes32 nameOfParty) public view returns (uint) {
        bytes32 hashedName = keccak256(nameOfParty);
        for (uint i = 0; i < parties.length; i++) {
            if (parties[i].nameHash == hashedName) {
                return parties[i].count;
            }
        }
        return 0;
    }

}