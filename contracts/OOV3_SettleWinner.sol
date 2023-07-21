// SPDX-License-Identifier: AGPL-3.0-only

pragma solidity ^0.8.16;

import "@uma/core/contracts/optimistic-oracle-v3/interfaces/OptimisticOracleV3Interface.sol";

// ***************************************
// *    OOV3 Integration  *
// ***************************************

contract OOV3_SettleWinner {
    OptimisticOracleV3Interface private immutable _oov3;
    uint64 public defaultLiveness;
    IERC20 public defaultCurrency;
    bytes32 private constant _defaultIdentifier = "ASSERT_TRUTH";

    
mapping(bytes => bytes32) private _assertionIdByQuestId;

    /**
     * @notice Constructs the smart contract.
     * @param _currency the currency to use for assertions.
     * @param _liveness the liveness to use for assertions.
     * @param __oov3 the address of the OptimisticOracleV3 contract.
     */
    constructor(IERC20 _currency, uint64 _liveness, address __oov3) {
        defaultCurrency = _currency;
        defaultLiveness = _liveness;
        _oov3 = OptimisticOracleV3Interface(__oov3);
    }

    function assertTruth(
        bytes calldata _claim,
        uint256 _bondValue,
        bytes calldata _questId
    ) public {
        bytes32 assertionId = _oov3.assertTruth(
            _claim,
            address(this), // asserter
            address(0), // callbackRecipient
            address(0), // escalationManager
            defaultLiveness,
            defaultCurrency,
            _bondValue,
            _defaultIdentifier,
            bytes32(0) // domainId
        );

        _assertionIdByQuestId[_questId] = assertionId;
    }

    function settleAssertion(bytes calldata _questId) external {
        _oov3.settleAssertion(getAssertionIdByQuestPostId(_questId));
    }

    function getAssertionResult(
        bytes calldata _questId
    ) public view returns (bool) {
        return
            _oov3.getAssertionResult(getAssertionIdByQuestPostId(_questId));
    }

    function getAssertionIdByQuestPostId(
        bytes calldata _questId
    ) public view returns (bytes32) {
        return _assertionIdByQuestId[_questId];
    }

}