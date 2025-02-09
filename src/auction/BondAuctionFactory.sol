// SPDX-License-Identifier: Apache 2.0
pragma solidity ^0.8.26;

import {BondAuction} from "./BondAuction.sol";

error BondAuctionAlreadyExists();

contract BondAuctionFactory {
    address[] public auctionInstances;

    mapping(address => address) public fundToAuctionInstance;

    mapping(address => bool) public fundToAuctionInstanceExists;

    /// @notice Creates a new BondAuction contract instance
    /// @param _fund The address of the fund
    /// @param _owner The address of the owner
    /// @param _paymentToken The address of the payment token
    /// @return The new BondAuction contract instance
    /// @dev This should be called once per fund or when the fund is created.
    function createBondAuctionContractInstance(address _fund, address _owner, address _paymentToken)
        external
        returns (BondAuction)
    {
        if (fundToAuctionInstanceExists[_fund]) {
            revert BondAuctionAlreadyExists();
        }

        BondAuction auction = new BondAuction(_fund, _owner, _paymentToken);
        auctionInstances.push(address(auction));
        fundToAuctionInstance[_fund] = address(auction);
        fundToAuctionInstanceExists[_fund] = true;
        return auction;
    }

    /// @notice Returns all auction instances
    /// @return The list of auction instances
    function getAuctionInstances() external view returns (address[] memory) {
        return auctionInstances;
    }

    /// @notice Returns the auction instance for a given fund
    /// @param _fund The address of the fund
    /// @return The auction instance
    function getAuctionInstanceForFund(address _fund) external view returns (address) {
        return fundToAuctionInstance[_fund];
    }
}
