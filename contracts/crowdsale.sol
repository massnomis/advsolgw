pragma solidity ^0.5.0;

import "puppercoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

// @TODO: Inherit the crowdsale contracts
contract PupperCoinSale is Crowdsale, MintedCrowdsale, CappedCrowdsale, TimedCrowdsale, RefundablePostDeliveryCrowdsale {

    constructor( 
        uint rate, // rate in TKNbits
        PupperCoin token, // token name
        address payable wallet, // company's fundraising wallet that holds ETH sent from users
        uint256 goal, // goal of the crowdsale
        uint256 openingTime, // testing: uint fakenow
        uint256 closingTime // testing: closingTime = fakenow + 2 minutes
        )
        
        Crowdsale(rate, wallet, token)
        MintedCrowdsale()
        CappedCrowdsale(goal)
        TimedCrowdsale(openingTime, closingTime) // testing: TimedCrowdsale(fakenow, fakenow + 2 minutes)
        RefundableCrowdsale(goal)
        
        // @TODO: Pass the constructor parameters to the crowdsale contracts.
        public
        
    {
        // constructor can stay empty
    }
}

contract PupperCoinSaleDeployer {

    address public token_sale_address;
    address public token_address;
    

    constructor(
        string memory name,
        string memory symbol,
        address payable wallet, // this address will recieve all Ether raised by the sale
        uint256 goal
        // testing: uint fakenow
    )
        public
    {
        
        PupperCoin token = new PupperCoin(name, symbol, 0);
        token_address = address(token);

        
        PupperCoinSale token_sale = new PupperCoinSale(1, token, wallet, goal, now, now + 24 weeks);  
        // testing: replace now with fakenow and replace 24 weeks with 5 minutes
        token_sale_address = address(token_sale);


        token.addMinter(token_sale_address);
        token.renounceMinter();
    }
}
