// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "@openzeppelin/access/Ownable.sol";
import "./Fund.sol";
import "./interfaces/IBondAuctionFactory.sol";
import "./interfaces/IAtmAuctionFactory.sol";

error FundAlreadyExists();

contract FundFactory is Ownable {
    // Factory configuration
    uint256 public seedPeriodDuration;
    uint256 public earlyWithdrawalPenaltyFee;
    address public agentAddress;
    uint256 public minimumDeposit;
    uint256 public maximumDeposit;
    uint256 public depositCap;
    address public bondAuctionFactory;
    address public atmAuctionFactory;

    // Factory state
    address[] public funds;

    struct FundInformation {
        address creator;
        string name;
        string symbol;
        address underlyingToken;
    }

    mapping(address => FundInformation[]) public fundsInformation;
    mapping(address => bool) public fundExists;

    constructor(
        address _agentAddress,
        uint256 _seedPeriodDuration,
        uint256 _earlyWithdrawalPenaltyFee,
        address _bondAuctionFactory,
        address _atmAuctionFactory
    ) Ownable(msg.sender) {
        agentAddress = _agentAddress;
        seedPeriodDuration = _seedPeriodDuration;
        earlyWithdrawalPenaltyFee = _earlyWithdrawalPenaltyFee;
        bondAuctionFactory = _bondAuctionFactory;
        atmAuctionFactory = _atmAuctionFactory;
    }

    function createFund(string memory _name, string memory _symbol, address _underlyingToken) external onlyOwner {
        if (fundExists[_underlyingToken]) {
            revert FundAlreadyExists();
        }

        address bondAuction = IBondAuctionFactory(bondAuctionFactory).createBondAuctionContractInstance(
            address(this), msg.sender, _underlyingToken
        );

        address atmAuction = IAtmAuctionFactory(atmAuctionFactory).createAtmAuctionContractInstance(
            address(this), msg.sender, _underlyingToken
        );

        Fund fund = new Fund(
            Fund.FundCreationParameters({
                name: _name,
                symbol: _symbol,
                agentAddress: agentAddress,
                underlyingToken: _underlyingToken,
                seedDuration: seedPeriodDuration,
                earlyWithdrawalPenaltyFee: earlyWithdrawalPenaltyFee,
                minimumDeposit: minimumDeposit,
                maximumDeposit: maximumDeposit,
                depositCap: depositCap,
                bondAuction: bondAuction,
                atmAuction: atmAuction
            })
        );

        address fundAddress = address(fund);

        funds.push(fundAddress);
        fundExists[fundAddress] = true;
        fundsInformation[fundAddress].push(
            FundInformation({creator: msg.sender, name: _name, symbol: _symbol, underlyingToken: _underlyingToken})
        );
    }

    /// -------------------------------------------------------------------------------------------------
    /// ADMIN FUNCTIONS
    /// -------------------------------------------------------------------------------------------------

    function setAgentAddress(address _agentAddress) external onlyOwner {
        agentAddress = _agentAddress;
    }

    function setSeedPeriodDuration(uint256 _seedPeriodDuration) external onlyOwner {
        seedPeriodDuration = _seedPeriodDuration;
    }

    function setEarlyWithdrawalPenaltyFee(uint256 _earlyWithdrawalPenaltyFee) external onlyOwner {
        earlyWithdrawalPenaltyFee = _earlyWithdrawalPenaltyFee;
    }

    function setMinimumDeposit(uint256 _minimumDeposit) external onlyOwner {
        minimumDeposit = _minimumDeposit;
    }

    function setMaximumDeposit(uint256 _maximumDeposit) external onlyOwner {
        maximumDeposit = _maximumDeposit;
    }

    function setDepositCap(uint256 _depositCap) external onlyOwner {
        depositCap = _depositCap;
    }

    /// -------------------------------------------------------------------------------------------------
    /// VIEW FUNCTIONS
    /// -------------------------------------------------------------------------------------------------

    function getFunds() external view returns (address[] memory) {
        return funds;
    }
}
