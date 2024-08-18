//importing task
const { task } = require("hardhat/config") // The hardhat/config has the hardhat in it.

task("block-number", "Prints the current block number").setAction(
    // task(name, description)
    // const blockTask = async function() => {}
    // async function blockTask() {}
    async (taskArgs, hre) => {
        // => is known as javascript error function
        const blockNumber = await hre.ethers.provider.getBlockNumber()
        console.log(`Current block number: ${blockNumber}`)
    },
)

module.exports = {}
