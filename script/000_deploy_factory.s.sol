// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {console2} from "forge-std/console2.sol";
import {Vm} from "forge-std/Vm.sol";

import {DeploymentUtils} from "@utils/DeploymentUtils.sol";
import {DeployerUtils} from "@utils/DeployerUtils.sol";

import {AtmAuctionFactory} from "../src/auction/AtmAuctionFactory.sol";
import {BondAuctionFactory} from "../src/auction/BondAuctionFactory.sol";
import {FundFactory} from "../src/FundFactory.sol";
import {BaseScript} from "./BaseScript.s.sol";

contract DeployFactoryScript is BaseScript {
    using DeployerUtils for Vm;
    using DeploymentUtils for Vm;

    FundFactory public fundFactory;

    function setUp() public {}

    function run() public {
        console2.log("Deploying FundFactory contract");
        deployer = vm.loadDeployerAddress();

        console2.log("Deployer Address");
        console2.logAddress(deployer);

        vm.startBroadcast(deployer);

        address agentAddress = 0x494B285459Ae0342da4A097be491DB26bab986a9;

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
