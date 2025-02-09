// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Script, console} from "forge-std/Script.sol";

import {AtmAuctionFactory} from "../src/auction/AtmAuctionFactory.sol";
import {BondAuctionFactory} from "../src/auction/BondAuctionFactory.sol";
import {FundFactory} from "../src/FundFactory.sol";

contract FundScript is Script {
    FundFactory public fundFactory;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        address agentAddress = address(this);

        // Deploy AtmBondFactory
        AtmAuctionFactory atmAuctionFactory = new AtmAuctionFactory();

        // Deploy BondAuctionFactory
        BondAuctionFactory bondAuctionFactory = new BondAuctionFactory();

        // Deploy FundFactory
        uint256 seedPeriodDuration = 7 days;
        uint256 earlyWithdrawalPenaltyFee = 0;

        fundFactory = new FundFactory(
            agentAddress,
            seedPeriodDuration,
            earlyWithdrawalPenaltyFee,
            address(bondAuctionFactory),
            address(atmAuctionFactory)
        );

        // Grant roles
        bondAuctionFactory.grantRoles(address(fundFactory), bondAuctionFactory.ADMIN_ROLE());
        atmAuctionFactory.grantRoles(address(fundFactory), atmAuctionFactory.ADMIN_ROLE());

        bondAuctionFactory.renounceOwnership();
        atmAuctionFactory.renounceOwnership();

        // Create Fund
        address underlyingToken = address(1);
        address bondToken = address(2);
        address atmToken = address(3);

        fundFactory.createFund("Test Fund", "TEST", underlyingToken, bondToken, atmToken);

        vm.stopBroadcast();
    }
}
