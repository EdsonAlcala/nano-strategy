// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

library Constants {
    uint64 public constant ETHEREUM_MAINNET_NETWORK = 1;
    uint64 public constant ETHEREUM_SEPOLIA_NETWORK = 11155111;
    uint64 public constant BASE_MAINNET_NETWORK = 8453;
    uint64 public constant BASE_SEPOLIA_NETWORK = 84532;
    uint64 public constant MODE_MAINNET_NETWORK = 34443;
    uint64 public constant MODE_TESTNET_NETWORK = 919;
    uint64 public constant LOCAL_NETWORK = 31337;
    uint64 public constant LOCAL_TEST_NETWORK = 3137;
    string public constant FUND_FACTORY = "FundFactory";
    address public constant UNISWAP_ROUTER_SEPOLIA = 0x425141165d3DE9FEC831896C016617a52363b687;
    address public constant UNISWAP_FACTORY_SEPOLIA = 0xB7f907f7A9eBC822a80BD25E224be42Ce0A698A0;
    address public constant UNISWAP_ROUTER_MAINNET = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address public constant UNISWAP_FACTORY_MAINNET = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
    address public constant DEAD_ADDRESS = 0x000000000000000000000000000000000000dEaD;
    uint16 public constant COMPLETION_FEE = 400;
    uint16 public constant TRADING_FEE = 100;
}
