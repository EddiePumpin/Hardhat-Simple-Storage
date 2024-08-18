//SPDX-License-Identifier : MIT
pragma solidity ^0.8.20;

import "./PriceConversion.sol";

contract FundMe{
    using PriceConverter for uint256; //  This is a feature in Solidity that allows you to attach library functions to a data type
    uint256 public minimumUSD = 10 * 1e18;

    address[] public funders; // [] is an array(list).
    mapping(address =>uint256) public addressToAmountFunded; //  It stores key-value pairs, where each key(address) is mapped to a single value(uint256). The state variable 'addressToAmountFunded' is a mapping

    address public owner;

    constructor(){ // this function get called once immediately this contract is deployed 
      owner = msg.sender; // = means "set to" while == means "to check is LHS and RHS are equivalent


      
    }

    function Fund() public payable {
        msg.value.getConversionRate(); // This line is also the same as msg.value.getConversionRate

        require(msg.value.getConversionRate() >= minimumUSD, "Insufficient Amount!"); // Initially, it was " require(msg.value >= minimumUSD, "Insufficient Amount");"
        funders.push(msg.sender); // msg.sender is a global key world. It is the address of whosoever call the Fund() function. This line of code means add the address(es) of the sender into the empty variable 'funders'
        addressToAmountFunded[msg.sender] = msg.value; //  this line records how much Ether a particular address has sent to the contract. It means msg.value should be stored in a map state variable that already has msg.sender in it

    }

     modifier onlyOwner() {
        require(msg.sender == owner, "sender is not owner");
        _; // Doing the rest of the code in the functions that have the variable 'onlyowner' but when the _; is the first line, it will do the rest of the code in the function first before the require
      }



    function withdraw() public onlyOwner payable { //Solidity will read the 'onlyOwner' modifier before it reads the what is inside the function.
      for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex = funderIndex + 1){ // funderIndex = funderIndex + 1 this can also be written as funderIndex++
      address funder = funders[funderIndex]; // This retrieves the address of the funder at the current index from the funders array.
      addressToAmountFunded[funder] = 0; //  This sets the amount funded by the current funder to zero in the addressToAmountFunded mapping.
      }

      // reset an array
      funders = new address[](0);

      //msg.sender = address
      //payable(msg.sender) = payable address

      //transfer-- It automatically reverts if the transaction fails
      //payable(msg.sender).transfer(address(this).balance); //the keyword 'this' is referring to this contract. This line transfer the balance to whoever who calls the withdraw function. Transfer-Balance-of this Contract Address-to-Msg.sender.

      //send -- It reverts if we have the require.
      //bool sendSuccess = payable(msg.sender).send(adress(this).balance);
      //require(sendSuccess, "Send failed!");

      //call
      (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}(""); // Since bytes objects are array, their return needs to be in memory.
      require(callSuccess, "Call failed!");


      
    }
}