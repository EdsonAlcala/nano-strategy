// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {FundFactory} from "../src/FundFactory.sol";

contract FundFactoryTest is Test {
    FundFactory public fundFactory;

    function setUp() public {
        fundFactory = new FundFactory(address(this), 100, 100, address(0), address(0));
    }

    function test_createFund() public {
        fundFactory.createFund("Test Fund", "TF", address(0), address(0), address(0));
    }
}
