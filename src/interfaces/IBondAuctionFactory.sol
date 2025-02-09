// SPDX-License-Identifier: Apache 2.0
pragma solidity ^0.8.26;

interface IBondAuctionFactory {
    function createBondAuctionContractInstance(address _fund, address _owner, address _paymentToken)
        external
        returns (address);
}
