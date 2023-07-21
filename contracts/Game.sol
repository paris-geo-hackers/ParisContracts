// SPDX-License-Identifier: MIT
pragma solidity 0.8.16;

import "solidity-string-utils/StringUtils.sol";
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

    IVerifier verifier;
    uint256 lastQuestId = 0;
    mapping(uint256 => Quest) questList ;

    struct Quest{
        uint256 questId;
        string questName;
        address[] registeredPlayers;
        uint256 numberOfPlayers;
        string location;
        uint256 questPrize;
        uint256 creatorFee;
        string questStatus;
    }

    // constructor(IVerifier _verifier) {
    //     verifier = _verifier;
    // }

    function createQuest(string memory _questName, string memory _location, uint256 _numberOfPlayer, uint256 _questPrize, uint256 _creatorFee) public {
        lastQuestId = lastQuestId + 1;
        questList[lastQuestId] = Quest(lastQuestId, _questName, new address[](_numberOfPlayer), _numberOfPlayer, _location, _questPrize, _creatorFee, "OPEN");
    }

    function joinQuest(uint256 _questId) external {
        questList[_questId];
        // if (keccak256(questList[_questId].questStatus) == keccak256("OPEN")){
        if (true) {
            questList[_questId].registeredPlayers.push(msg.sender);
            if (questList[_questId].registeredPlayers.length == questList[_questId].numberOfPlayers) {
                questList[_questId].questStatus = "STARTED";
            }
        }
        else {
            //TODO: not allowed
        }
    }

    function submitSolution(uint256 _questId, string memory _solution) external {
        if (true) {
            closeQuest(_questId);
        }
        else {

        }
    }

    function closeQuest(uint256 _questId) private {
        questList[_questId].questStatus = "FINISHED";
    }

}


