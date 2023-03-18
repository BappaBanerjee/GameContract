// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./UserRegistration.sol";
import "./Practice.sol";

contract Game is UserRegistration, Practice {
    //custom error
    error Game_Not_Authorised(); //when non user tries to access
    error Game__Is_Busy(); //throw error if user try to execute before particular interval

    uint256 private constant TIME_LOCK_IN_SEC = 60; //Time lock user for certer amount of time for further execution
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
    function register(Role _role, string memory _username) public {
        _register(_role, _username);
    }

    /*
        @dev function to unregister a user
        requirements :
            **should be a already a user
        @event : emit the event userUnregisterd()
    */
    function unRegister() public {
        _unRegister();
    }

    /*
        @dev skill up the particular shots
        @param give the shot number 
            1 for coverdrive
            2 for strightdrive
            3 for pull shot
            4 for squarecut
        
        requirements : 
            *has to be the batsman role
            *shot number must be in range 
            *waiting time must be less than block.timestamp or 0
    */
    function practiceShots(uint256 _shot) public isBusy {
        if (_getPlayerRole(msg.sender) != Role.Batsman)
            revert Game_Not_Authorised();
        require(_shot > 0 && _shot < 5, "Invalid selection");
        waiting_time[msg.sender] = block.timestamp + TIME_LOCK_IN_SEC;
        if (_shot == 1) {
            _practiceCoverDrive();
        } else if (_shot == 2) {
            _practiceStraightDrive();
        } else if (_shot == 3) {
            _practicePull();
        } else if (_shot == 4) {
            _practiceSquareCut();
        }
    }

    /*
        @dev skill up the particular shots
        @param give the shot number 
            1 for yocker
            2 for strightdrive
            3 for pull shot
            4 for squarecut
        requirements : 
            *has to be the batsman role
            *shot number must be in range 
            *waiting time must be less than block.timestamp or 0
    */
    function practiceBowling(uint256 _skill) public isBusy {
        if (_getPlayerRole(msg.sender) != Role.Bowler)
            revert Game_Not_Authorised();
        require(_skill > 0 && _skill < 4, "Invalid selection");
        waiting_time[msg.sender] = block.timestamp + TIME_LOCK_IN_SEC;
        if (_skill == 1) {
            _practiceYocker();
        } else if (_skill == 2) {
            _practiceBouncer();
        } else if (_skill == 3) {
            _practiceLengthBall();
        }
    }

    event onDeposit(string _token, uint256 _quantity, address _from);
    event onWithdraw(string _token, uint256 _quantity, address _to);

    function deposit(uint256 _quantity) public {
        require(_quantity > 0, "quantity must be greater than 0");
        emit onDeposit("Ball", _quantity, msg.sender);
    }

    function withdraw(uint256 _quantity, address _address) public {
        require(_quantity > 0, "quantity must be greater than 0");
        emit onDeposit("Ball", _quantity, _address);
    }
}
