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
    uint256 public nextQuestId = 0;
    mapping(uint256 => Quest) questList ;

    constructor(IERC20 _currency, uint64 _liveness, address __oov3) {
        currency = _currency;
        liveness = _liveness;
        _oov3 = OptimisticOracleV3Interface(__oov3);
    }

    struct Quest {
        address creator;
        uint256 questId;
        string questName;
        string description;
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

    struct Coordinates {
        uint256 left;
        uint256 right;
        uint256 top;
        uint256 bottom;
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
        require(isPlayerIsJoined(_questId, msg.sender));
        _;
    }

    modifier isNotJoined(uint256 _questId) {
        require(!isPlayerIsJoined(_questId, msg.sender));
        _;
    }

    modifier isWinner(uint256 _questId) {
        require(msg.sender == questList[_questId].winner);
        _;
    }

    modifier isUmaVerified(uint256 _questId) {
        require(getAssertionResult(_questId));
        _;
    }


// ***************************************
// *    Quest functions                  *
// ***************************************

    function viewQuest(uint256 _questId) public view returns(address creator, string memory questName, string memory description, string memory location, address[] memory players, uint256 numberOfPlayers,
    uint256 questPrize, uint256 creatorFee, string memory questStatus, address winner, bool payoutCompleted) {
        creator = questList[_questId].creator;
        questName = questList[_questId].questName;
        description = questList[_questId].description;
        location = questList[_questId].location;
        players = questList[_questId].registeredPlayers;
        numberOfPlayers = questList[_questId].numberOfPlayers;
        questPrize = questList[_questId].questPrize;
        creatorFee = questList[_questId].creatorFee;
        questStatus = questList[_questId].questStatus;
        winner = questList[_questId].winner;
        payoutCompleted = questList[_questId].payoutCompleted;
    }

    function isPlayerIsJoined(uint256 _questId, address player) public view returns(bool) {
        for (uint i = 0; i < questList[_questId].registeredPlayers.length; i++) {
            if (questList[_questId].registeredPlayers[i] == player) {
                return true;
            }
        }
    }
    function getPlayerCost(uint256 _questId) public view returns(uint256) {
        return (questList[_questId].questPrize /  questList[_questId].numberOfPlayers);
    }

    function createQuest(string memory _questName, string memory description, string memory _location, string memory _zkCoordinates, uint256 _numberOfPlayer, uint256 _questPrize, uint256 _creatorFee) public {
        
        questList[nextQuestId] = Quest(msg.sender, nextQuestId, _questName, description, new address[](0), _numberOfPlayer, _location, _zkCoordinates, _questPrize, _creatorFee, "OPEN", address(0), false);
        nextQuestId = nextQuestId + 1;
    }

    function joinQuest(uint256 _questId) external isOpen(_questId) isNotJoined(_questId) {
        // require(currency.transferFrom(msg.sender, address(this), getPlayerCost(_questId)));
        currency.transferFrom(msg.sender, address(this), getPlayerCost(_questId));
        questList[_questId].registeredPlayers.push(msg.sender);
        if (questList[_questId].registeredPlayers.length == questList[_questId].numberOfPlayers) {
            questList[_questId].questStatus = "STARTED";
        }
    }

    function submitSolution(uint256 _questId, string calldata _solution, string calldata _proofPhotoUrl) external isStarted(_questId) isJoined(_questId) {
        // TODO: if statement verifies zkproof solution
        if (true){
            closeQuest(_questId, msg.sender);
            assertTruth(_solution, _proofPhotoUrl,  questList[_questId].questPrize, _questId);
        }
        else {
            // TODO implement punishment for wrong solution (timeout, max number of tries etc)
        }
    }

    function closeQuest(uint256 _questId, address _winner) public {
        // require(currency.transfer(questList[_questId].creator, questList[_questId].creatorFee));
        questList[_questId].questStatus = "FINISHED";
        questList[_questId].winner = _winner;
    }

    function claimRewards(uint256 _questId) external isWinner(_questId) isUmaVerified(_questId) {
        
        if (!questList[_questId].payoutCompleted) {
            require(currency.transfer(questList[_questId].winner, questList[_questId].questPrize));
            questList[_questId].payoutCompleted = true;
        }
    }

// ***************************************
// *    UMA functions                    *
// ***************************************

    function assertTruth(
        string calldata _claimLocation,
        string calldata _claimPhotoUrl,
        uint256 _bondValue,
        uint256 _questId
    ) public {
        bytes32 assertionId = _oov3.assertTruth(
            bytes(abi.encodePacked(_claimLocation, _claimPhotoUrl)),
            address(this), // asserter
            address(0), // callbackRecipient
            address(0), // escalationManager
            liveness,
            currency,
            0, //bond set to 0 
            bytes32(defaultIdentifier),
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

// ***************************************
// *    test functions functions                    *
// ***************************************

    function transferCoins(address receiver, uint256 amount) external {
        currency.transferFrom(msg.sender, receiver, amount);
        
    }


    // ========================================
    //     HELPER FUNCTIONS
    // ========================================

    function createFinalClaimAssembly(
        string memory claim,
        string memory photo
    ) private pure returns (bytes memory) {
        bytes memory claimBytes = bytes(claim);
        bytes memory photoBytes = bytes(photo);
        bytes memory mergedBytes = new bytes(claimBytes.length + claimBytes.length);

        assembly {
            let length1 := mload(claimBytes)
            let length2 := mload(photoBytes)
            let dest := add(mergedBytes, 32) // Skip over the length field of the dynamic array

            // Copy claim to mergedBytes
            for {
                let i := 0
            } lt(i, length1) {
                i := add(i, 32)
            } {
                mstore(add(dest, i), mload(add(claimBytes, add(32, i))))
            }

            // Copy photo to mergedBytes
            for {
                let i := 0
            } lt(i, length2) {
                i := add(i, 32)
            } {
                mstore(
                    add(dest, add(length1, i)),
                    mload(add(photoBytes, add(32, i)))
                )
            }

            mstore(mergedBytes, add(length1, length2))
        }

        return mergedBytes;
    }
}