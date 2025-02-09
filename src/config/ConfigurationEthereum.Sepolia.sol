// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Constants} from "@constants/Constants.sol";

import {Configuration} from "./Configuration.sol";

library ConfigurationEthereumSepolia {
    function getConfig() external pure returns (Configuration.ConfigValues memory) {
        revert("ConfigurationEthereumSepolia: not implemented");
    }
}
