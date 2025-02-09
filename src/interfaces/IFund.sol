// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

interface IFund {
    function decimals() external view returns (uint8);
    function mint(address _to, uint256 _amount) external;
}
