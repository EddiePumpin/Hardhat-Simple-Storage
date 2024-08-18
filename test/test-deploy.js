//Hardhat works with mocha frame work which is the javascript based framework for running test

const { ethers } = require("hardhat") // Import ethers from hardhat
const { expect, assert } = require("chai")

//The keyword 'describe' takes two paramaters: a string and a function. function () {} or () => {} is a anonymous function

describe("SimpleStorage", function () {
    // This beforeEach function will tell what to do before each our its
    // let simpleStorageFactory
    // let simpleStorage
    let simpleStorageFactory, simpleStorage
    beforeEach(async function () {
        // the async function will tell the testing framework what to do before each test
        simpleStorageFactory = await ethers.getContractFactory("SimpleStorage")
        simpleStorage = await simpleStorageFactory.deploy()
    })
    // this is where we actually direct the code before running our test
    it("Should start with a favourite number of 0", async function () {
        const currentValue = await simpleStorage.retrieve()
        const expectedValue = "0"

        assert.equal(currentValue.toString(), expectedValue) // This means i'm asserting that currentValue = expectedValue. Or that the receive to return 0
        // expect(currentValue.toString()).to.equal(expectedValue)
    })
    it("Should update when we call store", async function () {
        // The 'it.only' keyword allows to run only this test
        const expectedValue = "7"
        const transactionResponse = await simpleStorage.store(expectedValue)
        await transactionResponse.wait(1)

        const currentValue = await simpleStorage.retrieve()
        assert.equal(currentValue.toString(), expectedValue)
        it("Should addPerson to an array when called", async function () {})
    })
})
