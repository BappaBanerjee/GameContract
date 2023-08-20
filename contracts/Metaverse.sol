// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./UserRegistration.sol";
import "./WelcomeKit.sol";

contract Metaverse is UserRegistration, WelcomeKit {
    //custom error
    error Game__Not_Authorised(); //when non user tries to access
    error Game__Is_Busy(); //throw error if user try to execute before particular interval

    uint256 private constant TIME_LOCK_IN_SEC = 10; //Time lock user for certer amount of time for further execution
    mapping(address => uint256) public waiting_time; //tracking user waiting time

    //modifiers
    modifier isBusy() {
        if (block.timestamp < waiting_time[msg.sender]) revert Game__Is_Busy();
        _;
    }

    /*
        @dev register a user to the game. It call the functio _register from the userRegistration contract
        @param user role, 0 for batsman and 1 for bowler and username of the user
        requirement :- 
            role should be a 0 for batsman and 1 for bowler 
            username can be string
        @event : emit the event userRegistered()
    */
    function register(string memory _username) public {
        _register(_username);
        safeMint(msg.sender);
    }

    /*
        @dev function to unregister a user
        requirements :
            **should be a already a user
        @event : emit the event userUnregisterd()
    */
    function unRegister(uint _tokenId) public {
        require(
            ownerOf(_tokenId) == msg.sender,
            "Only the owner of the token can burn it."
        );
        _unRegister();
        _burn(_tokenId);
    }
}
