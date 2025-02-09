// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Constants} from "@constants/Constants.sol";

import {ConfigurationLocal} from "./Configuration.Local.sol";
import {ConfigurationEthereumMainnet} from "./ConfigurationEthereum.Mainnet.sol";
import {ConfigurationEthereumSepolia} from "./ConfigurationEthereum.Sepolia.sol";
import {ConfigurationModeMainnet} from "./ConfigurationMode.Mainnet.sol";
import {ConfigurationModeTestnet} from "./ConfigurationMode.Testnet.sol";
import {ConfigurationBaseMainnet} from "./ConfigurationBase.Mainnet.sol";
import {ConfigurationBaseSepolia} from "./ConfigurationBase.Sepolia.sol";

library Configuration {
    struct ConfigValues {
        address EXCHANGE_ROUTER_ADDRESS;
        address EXCHANGE_FACTORY_ADDRESS;
        uint16 TRADING_FEE;
        uint16 COMPLETION_FEE;
    }

    function load(uint64 _networkId) external pure returns (ConfigValues memory) {
        if (_networkId == Constants.ETHEREUM_MAINNET_NETWORK) {
            return ConfigurationEthereumMainnet.getConfig();
        }

        if (_networkId == Constants.ETHEREUM_SEPOLIA_NETWORK) {
            return ConfigurationEthereumSepolia.getConfig();
        }

        if (_networkId == Constants.MODE_MAINNET_NETWORK) {
            return ConfigurationModeMainnet.getConfig();
        }

        if (_networkId == Constants.MODE_TESTNET_NETWORK) {
            return ConfigurationModeTestnet.getConfig();
        }

        if (_networkId == Constants.BASE_MAINNET_NETWORK) {
            return ConfigurationBaseMainnet.getConfig();
        }

        if (_networkId == Constants.BASE_SEPOLIA_NETWORK) {
            return ConfigurationBaseSepolia.getConfig();
        }

        if (_networkId == Constants.LOCAL_NETWORK) {
            return ConfigurationLocal.getConfig();
        }

        revert("Configuration: network not supported");
    }
}
