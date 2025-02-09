// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Fund} from "../src/Fund.sol";

contract FundTest is Test {
    Fund public fund;

    function setUp() public {
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
    }

    function test_Deposit() public {
        fund.deposit(100);
        assertEq(fund.balanceOf(address(this)), 100);
    }
}
