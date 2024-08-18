//pragma solidity ^0.8.20;

import "./AggregatorV3Interface.sol";

contract FundMe {
    uint256 public minimumUSD = 50;

    function Fund() public payable {
        require(
            getConversionRate(msg.value) >= minimumUSD,
            "Insufficient Amount"
        ); // Initially, it was " require(msg.value >= minimumUSD, "Insufficient Amount");"
    }

    function getPrice() public view returns (uint256) {
        //ABI
        //Address 0x694AA1769357215DE4FAC081bf1f309aDC325306
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );
        (, int256 price, , , ) = priceFeed.latestRoundData(); // ETH in terms of USD
        return uint256(price * 1e18);
    }

    function getVersion() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );
        return priceFeed.version();
    }

    function getConversionRate(
        uint256 ethAmount
    ) public view returns (uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18; // multiplication before division.
        return ethAmountInUsd;
    }
}
