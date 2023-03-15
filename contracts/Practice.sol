//SPDX-License-Identifier:MIT

pragma solidity ^0.8.0;

contract Practice {
    //custom error
    error skillup_max_limit_reached(uint limit); //throw error if the max limit of the skill reached

    //variables
    uint private constant MAX_SKILL_POINT = 10; //max limit of the skills

    //data structure for the batting shots
    struct Shots {
        uint coverDrive;
        uint straightDrive;
        uint pull;
        uint squareCut;
    }
    //data structure for the bowlig skills
    struct Bowl {
        uint yocker;
        uint bouncer;
        uint lengthBall;
    }

    mapping(address => Shots) public BattingSkill;
    mapping(address => Bowl) public BowlingSkill;

    /*
        @dev function to check if the skill value reached the threshold value
        @param the value of the skill
        requiremt :
            if the value is greater than the maximum value (MAX_SKILL_POINT) then it will revert the execution of the function
    */
    function checkLimit(uint value) private pure {
        if (value >= MAX_SKILL_POINT) revert skillup_max_limit_reached(value);
    }

    //Batting shots
    /*
        @dev functions to level up individual batting shots skills by 1
    */
    function _practiceCoverDrive() internal {
        Shots memory skill = BattingSkill[msg.sender];
        checkLimit(skill.coverDrive);
        skill.coverDrive += 1;
        BattingSkill[msg.sender] = skill;
    }

    function _practiceStraightDrive() internal {
        Shots memory skill = BattingSkill[msg.sender];
        checkLimit(skill.straightDrive);
        skill.straightDrive += 1;
        BattingSkill[msg.sender] = skill;
    }

    function _practicePull() internal {
        Shots memory skill = BattingSkill[msg.sender];
        checkLimit(skill.pull);
        skill.pull += 1;
        BattingSkill[msg.sender] = skill;
    }

    function _practiceSquareCut() internal {
        Shots memory skill = BattingSkill[msg.sender];
        checkLimit(skill.squareCut);
        skill.squareCut += 1;
        BattingSkill[msg.sender] = skill;
    }

    //Bowler _practice
    /*
        @dev function to level up individual bowling skills by 1
    */
    function _practiceYocker() internal {
        Bowl memory skill = BowlingSkill[msg.sender];
        checkLimit(skill.yocker);
        skill.yocker += 1;
        BowlingSkill[msg.sender] = skill;
    }

    function _practiceBouncer() internal {
        Bowl memory skill = BowlingSkill[msg.sender];
        checkLimit(skill.bouncer);
        skill.bouncer += 1;
        BowlingSkill[msg.sender] = skill;
    }

    function _practiceLengthBall() internal {
        Bowl memory skill = BowlingSkill[msg.sender];
        checkLimit(skill.lengthBall);
        skill.lengthBall += 1;
        BowlingSkill[msg.sender] = skill;
    }
}
