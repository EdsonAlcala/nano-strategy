// SPDX-License-Identifier: Apache 2.0
pragma solidity ^0.8.26;

import {SafeTransferLib} from "solady/src/utils/SafeTransferLib.sol";
import {DutchAuction} from "./DutchAuction.sol";
import {IFund} from "../interfaces/IFund.sol";

contract AtmAuction is DutchAuction {
    /// @dev The constructor for the AtmAuction contract, initializes the DutchAuction contract
    /// @param _fund The address of the fund
    /// @param _owner The address of the owner
    /// @param _paymentToken The address of the payment token
    constructor(address _fund, address _owner, address _paymentToken) DutchAuction(_fund, _owner, _paymentToken) {}

    /// @dev An internal override of the _fill function from DutchAuction, transfers the paymentToken to the owner() and mints the EthStrategy tokens to the filler
    /// @param amountOut The amount of EthStrategy tokens to be sold
    /// @param amountIn The amount of payment tokens to be paid by the filler
    function _fill(uint128 amountOut, uint128 amountIn, uint64, uint64) internal override {
        SafeTransferLib.safeTransferFrom(paymentToken, msg.sender, owner(), amountIn);
        IFund(fund).mint(msg.sender, amountOut);
    }
}
