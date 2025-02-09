// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {OwnableRoles} from "solady/src/auth/OwnableRoles.sol";
import "@openzeppelin/token/ERC20/ERC20.sol";
import "@openzeppelin/token/ERC20/IERC20.sol";

/// @dev The error for when a transfer is attempted but transfers are paused (minting is still allowed)
error TransferPaused();

/// @dev The error for when the seed period is invalid
error InvalidSeedPeriod();

contract Fund is OwnableRoles, ERC20 {
    /// @dev The role for the minter is able to mint unlimited tokens
    uint8 public constant MINTER_ROLE = 1;

    /// @dev The role of the pauser can pause transfers of tokens
    uint8 public constant PAUSER_ROLE = 2;

    /// @dev The role for the admin
    uint8 public constant ADMIN_ROLE = 3;

    /// @dev The underlying token of the fund
    IERC20 public immutable underlyingToken;

    /// @dev The duration of the seed period
    uint256 public immutable seedPeriodDuration;

    /// @dev The end time of the seed period
    uint256 public immutable seedPeriodEndTime;

    /// @dev The early withdrawal penalty fee is the fee for early withdrawal during the seed period
    uint256 public immutable earlyWithdrawalPenaltyFee;

    /// @dev The minimum deposit amount
    uint256 public immutable minimumDeposit;

    /// @dev The maximum deposit amount
    uint256 public immutable maximumDeposit;

    /// @dev The deposit cap
    uint256 public immutable depositCap;

    /// @dev The bond auction address
    address public bondAuction;

    /// @dev The atm auction address
    address public atmAuction;

    /// @dev The transfer pause status, minting is still allowed
    bool public isTransferPaused = true;

    event TransferPausedUpdated(bool isTransferPaused);

    struct FundCreationParameters {
        string name;
        string symbol;
        address agentAddress;
        address underlyingToken;
        uint256 seedDuration;
        uint256 earlyWithdrawalPenaltyFee;
        uint256 minimumDeposit;
        uint256 maximumDeposit;
        uint256 depositCap;
    }

    /// @dev The constructor for the Fund contract
    /// @param _parameters The parameters for the fund creation
    constructor(FundCreationParameters memory _parameters) ERC20(_parameters.name, _parameters.symbol) {
        /// @dev Initialize the owner of the fund
        _initializeOwner(_parameters.agentAddress);

        /// @dev Initialize the properties of the fund
        underlyingToken = IERC20(_parameters.underlyingToken);
        seedPeriodDuration = _parameters.seedDuration;
        seedPeriodEndTime = block.timestamp + seedPeriodDuration;
        earlyWithdrawalPenaltyFee = _parameters.earlyWithdrawalPenaltyFee;
        minimumDeposit = _parameters.minimumDeposit;
        maximumDeposit = _parameters.maximumDeposit;
        depositCap = _parameters.depositCap;

        _grantRoles(msg.sender, ADMIN_ROLE);
    }

    function initializeAuctionAddresses(address _bondAuction, address _atmAuction)
        external
        onlyOwnerOrRoles(ADMIN_ROLE)
    {
        bondAuction = _bondAuction;
        atmAuction = _atmAuction;

        _grantRoles(_atmAuction, MINTER_ROLE);
        _grantRoles(_bondAuction, MINTER_ROLE);
    }

    /// -------------------------------------------------------------------------------------------------
    /// DEPOSIT LOGIC
    /// -------------------------------------------------------------------------------------------------

    /// @dev The function to deposit tokens into the fund
    /// @param _amount The amount of tokens to deposit
    function deposit(uint256 _amount) external onlyOnSeedPeriod {
        underlyingToken.transferFrom(msg.sender, address(this), _amount);
        _mint(msg.sender, _amount);
    }

    /// @dev The function to withdraw tokens from the fund
    /// @dev Can only be called during the seed period and can contain a penalty
    /// @param _amount The amount of tokens to withdraw
    function withdraw(uint256 _amount) external onlyOnSeedPeriod {
        _burn(msg.sender, _amount);

        uint256 penalty = (_amount * earlyWithdrawalPenaltyFee) / 100;
        underlyingToken.transfer(msg.sender, _amount - penalty);
    }

    /// -------------------------------------------------------------------------------------------------
    /// REDEMPTIONS LOGIC
    /// -------------------------------------------------------------------------------------------------

    /// @dev The function to redeem tokens from the fund
    /// @dev To review the logic for the redemption
    /// @param _amount The amount of tokens to redeem
    function redeem(uint256 _amount) external onlyAfterSeedPeriod {
        _burn(msg.sender, _amount);

        underlyingToken.transfer(msg.sender, _amount);
    }

    /// -------------------------------------------------------------------------------------------------
    /// ADMIN FUNCTIONS
    /// -------------------------------------------------------------------------------------------------

    function setTransferPaused(bool _isTransferPaused) external onlyOwner {
        isTransferPaused = _isTransferPaused;

        emit TransferPausedUpdated(_isTransferPaused);
    }

    /// -------------------------------------------------------------------------------------------------
    /// INTERNAL FUNCTIONS
    /// -------------------------------------------------------------------------------------------------

    /// @dev The function to check if the seed period is active
    /// @return True if the seed period is active, false otherwise
    function _isSeedPeriodActive() internal view returns (bool) {
        return block.timestamp < seedPeriodEndTime;
    }

    /// @dev The function to transfer tokens
    /// @param _from The address of the sender
    /// @param _to The address of the recipient
    /// @param _value The amount of tokens to transfer
    function _update(address _from, address _to, uint256 _value) internal virtual override {
        if (isTransferPaused) {
            revert TransferPaused();
        }
        super._update(_from, _to, _value);
    }

    function mint(address _to, uint256 _amount) external onlyOwnerOrRoles(MINTER_ROLE) {
        _mint(_to, _amount);
    }

    /// -------------------------------------------------------------------------------------------------
    /// MODIFIERS
    /// -------------------------------------------------------------------------------------------------

    modifier onlyOnSeedPeriod() {
        if (!_isSeedPeriodActive()) {
            revert InvalidSeedPeriod();
        }
        _;
    }

    modifier onlyAfterSeedPeriod() {
        if (_isSeedPeriodActive()) {
            revert InvalidSeedPeriod();
        }
        _;
    }
}
