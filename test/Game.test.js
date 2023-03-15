const { assert, expect } = require("chai");
const { network, deployments, ethers } = require("hardhat")

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
        it("should register the user", async () => {
            await game.register(0, "userBappa");
            expect(await game._isPlayer(deployer.address)).to.equal(true);
        })
    })
})