// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Fund} from "../src/Fund.sol";

contract FundScript is Script {
    Fund public fund;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        address bondAuction = address(0);
        address atmAuction = address(0);

        fund = new Fund(
            Fund.FundCreationParameters({
                name: "Test Fund",
                symbol: "TF",
                agentAddress: address(this),
                underlyingToken: address(0),
                seedDuration: 100,
                earlyWithdrawalPenaltyFee: 100,
                minimumDeposit: 100,
                maximumDeposit: 1000,
                depositCap: 1000,
                bondAuction: bondAuction,
                atmAuction: atmAuction
            })
        );
        vm.stopBroadcast();
    }
}
