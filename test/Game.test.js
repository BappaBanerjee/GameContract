const { assert, expect } = require("chai");
const { network, deployments, ethers } = require("hardhat")


//added just for testing
describe("User Registration", function () {
    let game
    let deployer
    let anotherAccount
    beforeEach(async () => {
        [deployer, anotherAccount] = await ethers.getSigners()
        await deployments.fixture(["Game"])
        game = await ethers.getContract("Game", deployer)
    })

    describe("registration", function () {
        it("register the user", async () => {
            await game.register(0, "userBappa");
            expect(await game._isPlayer(deployer.address)).to.equal(true);
            let player = await game._getPlayerDetails();
            expect(player.Id.toString()).to.equal("1000");
        });

        it("emit an event on register", async () => {
            expect(await game.register(0, "username")).to.emit("userRegistered").withArgs(
                0,
                "username",
                1000
            )
        })

        it("revert if existing user register", async () => {
            //register a user
            await game.register(0, "userBappa");
            expect(await game._isPlayer(deployer.address)).to.equal(true);

            //regegister a user
            await expect(game.register(0, "username")).to.be.revertedWith(
                `userRegistration__already_a_player`
            )
        })
    })

    describe("unregister", function () {
        it("unregister a user, if he is am existing user", async () => {
            await game.register(0, "userBappa");

            expect(await game.unRegister()).to.emit("userUnregisterd").withArgs(deployer.address);
            expect(await game._isPlayer(deployer.address)).to.equal(false);
            let player = await game._getPlayerDetails();
            expect(player.username).to.equal("");
        })

        it("revert if not an existing user", async () => {
            await expect(game.unRegister()).to.be.revertedWith(
                `Not_a_player`
            )
        })
    })

    describe("Practice Batting", function () {

        describe("if not a batsman", async () => {
            beforeEach(async () => {
                await game.register(1, "userBappa");
            })

            it("revert if the user is bowler", async () => {
                await expect(game.practiceShots(1)).to.revertedWith('Game_Not_Authorised');
            })
        })

        describe("if user is a barsman", async () => {
            beforeEach(async () => {
                await game.register(0, "userBappa");
            })
            it("revert if the shot selection is invalid", async () => {
                await expect(game.practiceShots(7)).to.revertedWith('Invalid selection');
            })

            it("increase the skill point of coverdrive of the user", async () => {
                await game.practiceShots(1);
                let player = await game.BattingSkill(deployer.address);
                expect(player.coverDrive.toString()).to.equal("1");
            })

            it("increase the skill point of straight drive of the user", async () => {
                await game.practiceShots(2);
                let player = await game.BattingSkill(deployer.address);
                expect(player.straightDrive.toString()).to.equal("1");
            })

            it("increase the skill point of pull shot of the user", async () => {
                await game.practiceShots(3);
                let player = await game.BattingSkill(deployer.address);
                expect(player.pull.toString()).to.equal("1");
            })

            it("increase the skill point of square cut of the user", async () => {
                await game.practiceShots(4);
                let player = await game.BattingSkill(deployer.address);
                expect(player.squareCut.toString()).to.equal("1");
            })
            /**
             * @dev when the user execute the function practiceshot, he should have to wait for a certain amount of time for performing any other task in the game...
             */
            it("revert if user perform task before timeout...", async () => {
                await game.practiceShots(4);
                let player = await game.BattingSkill(deployer.address);
                await expect(game.practiceShots(4)).to.revertedWith('Game__Is_Busy');
            })
        })
    })

    describe("Bowling practice", function () {
        describe("if the user is batter", async () => {
            beforeEach(async () => {
                await game.register(0, "userBappa");
            })

            it("revert if the user is bowler", async () => {
                await expect(game.practiceBowling(1)).to.revertedWith('Game_Not_Authorised');
            })
        })

        describe("if user is a bowler", async () => {
            beforeEach(async () => {
                await game.register(1, "userBappa");
            })
            it("revert if the shot selection is invalid", async () => {
                await expect(game.practiceBowling(7)).to.revertedWith('Invalid selection');
            })

            it("increase the skill point of yocker of the user", async () => {
                await game.practiceBowling(1);
                let player = await game.BowlingSkill(deployer.address);
                expect(player.yocker.toString()).to.equal("1");
            })

            it("increase the skill point of bouncer drive of the user", async () => {
                await game.practiceBowling(2);
                let player = await game.BowlingSkill(deployer.address);
                expect(player.bouncer.toString()).to.equal("1");
            })

            it("increase the skill point of lengthball of the user", async () => {
                await game.practiceBowling(3);
                let player = await game.BowlingSkill(deployer.address);
                expect(player.lengthBall.toString()).to.equal("1");
            })

            /**
             * @dev when the user execute the function practiceshot, he should have to wait for a certain amount of time for performing any other task in the game...
             */
            it("revert if user perform task before timeout...", async () => {
                await game.practiceBowling(1);
                let player = await game.BowlingSkill(deployer.address);
                await expect(game.practiceBowling(2)).to.revertedWith('Game__Is_Busy');
            })
        })
    })
})