// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Constants} from "@constants/Constants.sol";
import {Configuration} from "./Configuration.sol";

library ConfigurationLocal {
    function getConfig() external pure returns (Configuration.ConfigValues memory) {
        return Configuration.ConfigValues({
            EXCHANGE_ROUTER_ADDRESS: Constants.UNISWAP_ROUTER_SEPOLIA,
            EXCHANGE_FACTORY_ADDRESS: Constants.UNISWAP_FACTORY_SEPOLIA,
            TRADING_FEE: Constants.TRADING_FEE,
            COMPLETION_FEE: Constants.COMPLETION_FEE
        });
    }
}
