//import
const { ethers, run, network } = require("hardhat") //.The LHS means ethers, run and network are coming from hardhat. Also, run allows us to run any hardhat task while network allows us to get network configuration information

//async main
async function main() {
    const SimpleStorageFactory =
        await ethers.getContractFactory("SimpleStorage")
    console.log("Deploying contract...")
    const simpleStorage = await SimpleStorageFactory.deploy()
    await simpleStorage.deployed() // This is to make sure that it waits to get deploy
    console.log(`Deployed contract to: ${simpleStorage.address}`) //String interpolation
    // console.log(network.config)
    //4 == 4 -> true
    //4 == "4" -> true
    //4 === "4" -> false
    if (network.config.chainId === 11155111 && process.env.ETHERSCAN_API_KEY) {
        //This means if "network.config.chainId" is 11155111 and the other part exist then go ahead and verify. **the part:process.env.ETHERSCAN_API_KEY exist (which is not conditional). In javascript if the part exist, it will be considered as true but if it doesn't exist it will be considered as false.  . && means
        console.log("Waiting for block txes...")
        await simpleStorage.deployTransaction.wait(6) // Meaning wait for 6 blocks before verifying the contract
        await verify(simpleStorage.address, []) //[] means the constructor argument
    }

    const currentValue = await simpleStorage.retrieve()
    console.log(`Current value is: ${currentValue}`)

    //Update the current value
    const transactionResponse = await simpleStorage.store(7)
    await transactionResponse.wait(1)
    const updatedValue = await simpleStorage.retrieve()
    console.log(`Updated value is: ${updatedValue}`)
}

//this function verify the contract on explorer.
async function verify(contractAddress, args) {
    // this line is also the same as const verify = async (contractAddress, args) => {
    // This won't work on local network such as hardhat.
    console.log("Verifying contractA...")
    try {
        await run("verify:verify", {
            address: contractAddress,
            constructorArguments: args,
        })
    } catch (e) {
        if (e.message.toLowerCase().includes("already verified")) {
            console.log("Already verified!")
        } else {
            console.log(e)
        }
    }
}

//main
main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        process.exit(1)
    })
