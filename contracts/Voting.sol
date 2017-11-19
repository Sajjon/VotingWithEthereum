pragma solidity ^0.4.18;

contract Voting {

	struct Party {
        bytes32 name;
        bytes32 namehash;
        uint count;
    }
    
	Party[] public parties;

    mapping(address => bytes32) addressVote;

    function add(bytes32 namehash) private returns (bool) {
        for ( uint i=0 ; i<parties.length ; i++ ) {
            if(parties[i].namehash==namehash) {
                parties[i].count+=1;
                return true;
            }
        }
        return false;
    }

    //TODO: remove entires with less than 1 vote
    function sub(bytes32 namehash) {
        for (uint i=0; i<parties.length; i++) {
            if(parties[i].namehash==namehash) {
                parties[i].count-=1;
            }
        }
    }

    function voteAs(address voter, bytes32 name) {
        bytes32 oldnamehash = addressVote[voter];
        sub(oldnamehash);

        bytes32 namehash = keccak256(name);
        addressVote[voter]=namehash;

        //increment this vote
        bool found = add(namehash);

        if (!found) {
            parties.push(
                Party({
                    name: name,
                    namehash: keccak256(name),
                    count: 1
                })
            );
        }
    }

    function vote(bytes32 name) public {
        bytes32 oldnamehash = addressVote[msg.sender];
        sub(oldnamehash);
        
        bytes32 namehash = keccak256(name);
        addressVote[msg.sender]=namehash;

        //increment this vote
        bool found = add(namehash);
    
        if (!found) {
            parties.push(
                Party({
                    name: name,
                    namehash: keccak256(name),
                    count: 1
                })
            );
        }
    }

    function getMax() view returns (bytes32,uint) {
        uint max = 0;
		bytes32 maxname = "";
		for ( uint i=0; i<parties.length; i++) {
			if (parties[i].count>max) {
				max = parties[i].count;
				maxname = parties[i].name;
			}
		}
		
		return (maxname,max);
    }

    function getVoteCountByName(bytes32 name) public returns (uint) {
        bytes32 myhash = keccak256(name);
        for ( uint i=0; i<parties.length; i++) {
            if (parties[i].namehash==myhash) {
                return parties[i].count;
            }
        }
        return 0;
    }

}