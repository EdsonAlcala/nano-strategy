// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Constants} from "@constants/Constants.sol";

import {Configuration} from "./Configuration.sol";

library ConfigurationBaseMainnet {
    function getConfig() external pure returns (Configuration.ConfigValues memory) {
        revert("ConfigurationBaseMainnet: not implemented");
    }
}
