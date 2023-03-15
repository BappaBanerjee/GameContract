//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

contract UserRegistration{
    //custom error 
    error userRegistration__already_a_player();//throw error if the user is already a user
    error Not_a_player();//throw error if sender if not a player

    //variables
    uint private userId = 1000;//count for the user ID's
    enum Role{//options for the role, the user can choose
        Batsman,
        Bowler
    }
    //data structure for the user
    struct Player{
        Role role;//batsman or bowler
        string username;//username of the user
        uint Id;//Id of the user
    }
    mapping(address=> Player) private playerDetails;
    mapping(address=> bool) private isPlayer;

    // all events declared here
    event userRegistered(Role role, string username, uint userId);
    event userUnregisterd(address userAddress);

    //all function starts from here 
    /*
        @dev function to register the user 
        @param role of the player and username of the player
        requirement :- 
            role should be a 0 for batsman and 1 for bowler 
            username can be string
        @event : emit the event userRegistered()
    */
    function _register(Role _role, string memory _username) internal{
        if(isPlayer[msg.sender]) revert userRegistration__already_a_player();
        playerDetails[msg.sender] = Player(
            _role,
            _username,
            userId
        );
        isPlayer[msg.sender] = true;
        ++userId;
        emit userRegistered(_role , _username , userId);
    }

    /*
        @dev function to unregister a user
        requirements :
            **should be a already a user
        @event : emit the event userUnregisterd()
    */
    function _unRegister() internal{
        if(!isPlayer[msg.sender]) revert Not_a_player();
        isPlayer[msg.sender] = false;
        delete playerDetails[msg.sender];
        emit userUnregisterd(msg.sender);
    }

    /**
        @dev return the details of the player if registered
    */
    function _getPlayerDetails() internal view returns(Player memory) {
        return playerDetails[msg.sender];
    }

    /*
        @dev return if the player is listed or not
        @param address of the user
    */
    function _isPlayer(address _address) public view returns(bool){
        return isPlayer[_address];
    }
    /*
        @dev returns the role of the player, mainly 0 for batsman and 1 for bowler
        @param address of the user
    */
    function _getPlayerRole(address _address) public view returns(Role){
        require(_isPlayer(_address) , "Not a player");
        return playerDetails[_address].role;
    }
}