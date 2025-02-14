// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {OwnableRoles} from "solady/src/auth/OwnableRoles.sol";
import "./interfaces/IBondAuctionFactory.sol";
import "./interfaces/IAtmAuctionFactory.sol";
import "./Fund.sol";

error FundAlreadyExists();

contract FundFactory is OwnableRoles {
    /// @dev The role for the admin, can start and cancel auctions
    uint8 public constant ADMIN_ROLE = 1;

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

    event FundCreated(
        address indexed fund,
        address indexed creator,
        string name,
        string symbol,
        address underlyingToken,
        address agentAddress,
        address bondAuction,
        address atmAuction,
        uint256 seedDuration,
        uint256 earlyWithdrawalPenaltyFee,
        uint256 minimumDeposit,
        uint256 maximumDeposit,
        uint256 depositCap
    );

    constructor(
        address _agentAddress,
        uint256 _seedPeriodDuration,
        uint256 _earlyWithdrawalPenaltyFee,
        address _bondAuctionFactory,
        address _atmAuctionFactory
    ) {
        _initializeOwner(msg.sender);
        agentAddress = _agentAddress;
        seedPeriodDuration = _seedPeriodDuration;
        earlyWithdrawalPenaltyFee = _earlyWithdrawalPenaltyFee;
        bondAuctionFactory = _bondAuctionFactory;
        atmAuctionFactory = _atmAuctionFactory;

        _grantRoles(agentAddress, ADMIN_ROLE);
    }

    function createFund(
        string memory _name,
        string memory _symbol,
        address _underlyingToken,
        address _bondToken,
        address _atmToken
    ) external onlyOwnerOrRoles(ADMIN_ROLE) {
        if (fundExists[_underlyingToken]) {
            revert FundAlreadyExists();
        }

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
                depositCap: depositCap
            })
        );

        address fundAddress = address(fund);

        address bondAuction =
            IBondAuctionFactory(bondAuctionFactory).createBondAuctionContractInstance(fundAddress, owner(), _bondToken);

        address atmAuction =
            IAtmAuctionFactory(atmAuctionFactory).createAtmAuctionContractInstance(fundAddress, owner(), _atmToken);

        fund.initializeAuctionAddresses(bondAuction, atmAuction);

        funds.push(fundAddress);
        fundExists[fundAddress] = true;
        fundsInformation[fundAddress].push(
            FundInformation({creator: msg.sender, name: _name, symbol: _symbol, underlyingToken: _underlyingToken})
        );

        emit FundCreated(
            fundAddress,
            msg.sender,
            _name,
            _symbol,
            _underlyingToken,
            agentAddress,
            bondAuction,
            atmAuction,
            seedPeriodDuration,
            earlyWithdrawalPenaltyFee,
            minimumDeposit,
            maximumDeposit,
            depositCap
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

    function setBondAuctionFactory(address _bondAuctionFactory) external onlyOwner {
        bondAuctionFactory = _bondAuctionFactory;
    }

    function setAtmAuctionFactory(address _atmAuctionFactory) external onlyOwner {
        atmAuctionFactory = _atmAuctionFactory;
    }

    /// -------------------------------------------------------------------------------------------------
    /// VIEW FUNCTIONS
    /// -------------------------------------------------------------------------------------------------

    function getFunds() external view returns (address[] memory) {
        return funds;
    }

    function getFundsInformation(address _fund) external view returns (FundInformation[] memory) {
        FundInformation[] memory _fundInformation = new FundInformation[](fundsInformation[_fund].length);

        for (uint256 i = 0; i < fundsInformation[_fund].length; i++) {
            _fundInformation[i] = fundsInformation[_fund][i];
        }

        return _fundInformation;
    }
}
