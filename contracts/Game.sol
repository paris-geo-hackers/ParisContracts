// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

import "@uma/core/contracts/optimistic-oracle-v3/interfaces/OptimisticOracleV3Interface.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface IVerifier {
    function verifyProof(
        uint[2] memory a,
        uint[2][2] memory b,
        uint[2] memory c,
        uint[17] memory input
    ) external returns (bool);
}

contract Game is Ownable {

    OptimisticOracleV3Interface private immutable _oov3;
    uint64 public liveness;
    IERC20 public currency;
    bytes32 private constant defaultIdentifier = "ASSERT_TRUTH";
    mapping(uint256 => bytes32) private assertionIdByQuestId;

    IVerifier verifier;
    uint256 lastQuestId = 0;
    mapping(uint256 => Quest) questList ;

    constructor(IERC20 _currency, uint64 _liveness, address __oov3) {
        currency = _currency;
        liveness = _liveness;
        _oov3 = OptimisticOracleV3Interface(__oov3);
    }

    struct Quest{
        address creator;
        uint256 questId;
        string questName;
        address[] registeredPlayers;
        uint256 numberOfPlayers;
        string location;
        string zkCoordinates;
        uint256 questPrize;
        uint256 creatorFee;
        string questStatus;
        address winner;
        bool payoutCompleted;
    }

// ***************************************
// *    Modifiers                        *
// ***************************************

    modifier isOpen(uint256 _questId) {
        require(keccak256(abi.encodePacked(questList[_questId].questStatus)) == keccak256(abi.encodePacked("OPEN")));
        _;
    }

    modifier isStarted(uint256 _questId) {
        require(keccak256(abi.encodePacked(questList[_questId].questStatus)) == keccak256(abi.encodePacked("STARTED")));
        _;
    }
    
    modifier isClosed(uint256 _questId) {
        require(keccak256(abi.encodePacked(questList[_questId].questStatus)) == keccak256(abi.encodePacked("FINISHED")));
        _;
    }
    
    modifier isJoined(uint256 _questId) {
        // require(msg.sender == questList[_questId].winner);
        // TODO
        _;
    }

    modifier isWinner(uint256 _questId) {
        require(msg.sender == questList[_questId].winner);
        _;
    }


// ***************************************
// *    Quest functions                  *
// ***************************************

    function createQuest(string memory _questName, string memory _location, string memory _zkCoordinates, uint256 _numberOfPlayer, uint256 _questPrize, uint256 _creatorFee) public {
        lastQuestId = lastQuestId + 1;
        questList[lastQuestId] = Quest(msg.sender, lastQuestId, _questName, new address[](_numberOfPlayer), _numberOfPlayer, _location, _zkCoordinates, _questPrize, _creatorFee, "OPEN", address(0), false);
    }

    function joinQuest(uint256 _questId) external isOpen(_questId) {
        questList[_questId].registeredPlayers.push(msg.sender);
        if (questList[_questId].registeredPlayers.length == questList[_questId].numberOfPlayers) {
            questList[_questId].questStatus = "STARTED";
        }
    }

    function submitSolution(uint256 _questId, string calldata _solution) external isStarted(_questId) isJoined(_questId) {
        if (true){
            closeQuest(_questId, msg.sender);
            assertTruth(_solution, questList[_questId].questPrize, _questId);
        }
        else {
            // TODO implement punishment for wrong solution (timeout, max number of tries etc)
        }
    }

    function closeQuest(uint256 _questId, address _winner) private {
        require(currency.transfer(questList[_questId].creator, questList[_questId].creatorFee));
        questList[_questId].questStatus = "FINISHED";
        questList[_questId].winner = _winner;
    }

    function claimRewards(uint256 _questId) external isWinner(_questId) {
        if (getAssertionResult(_questId)) {
            if (!questList[_questId].payoutCompleted) {
                require(currency.transfer(questList[_questId].winner, questList[_questId].questPrize));
                questList[_questId].payoutCompleted == true;
            }
        }
        else {
            // settleAssertion(_questId);
        }

    }

// ***************************************
// *    UMA functions                    *
// ***************************************

    function assertTruth(
        string calldata _claim,
        uint256 _bondValue,
        uint256 _questId
    ) private {
        bytes32 assertionId = _oov3.assertTruth(
            abi.encodePacked(_claim),
            address(this), // asserter
            address(0), // callbackRecipient
            address(0), // escalationManager
            liveness,
            currency,
            _bondValue,
            defaultIdentifier,
            bytes32(0) // domainId
        );

        assertionIdByQuestId[_questId] = assertionId;
    }

    function settleAssertion(uint256 _questId) external {
        _oov3.settleAssertion(getAssertionIdByQuestId(_questId));
    }

    function getAssertionResult(
        uint256 _questId
    ) public view returns (bool) {
        return
            _oov3.getAssertionResult(getAssertionIdByQuestId(_questId));
    }

    function getAssertionIdByQuestId(
        uint256 _questId
    ) public view returns (bytes32) {
        return assertionIdByQuestId[_questId];
    }

}


