// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";

interface IVerifier {
    function verifyProof(
        uint[2] memory a,
        uint[2][2] memory b,
        uint[2] memory c,
        uint[17] memory input
    ) external returns (bool);
}

contract Quest is Ownable {

    struct WhitelistData{
        uint256 userId;
        address userAddr;
        bytes32 emailSuffix;
    }

    constructor(IVerifier _verifier) {
        verifier = _verifier;
    }

    function addToWhitelist(
        uint256 _userId,
        bytes32 _emailSuffix,
        uint[2] memory a,
        uint[2][2] memory b,
        uint[2] memory c,
        uint[17] memory input
    ) public {
        require(
            verifier.verifyProof(a,b,c,input),
            "Invalid proof"
        );
        WhitelistData memory newWhitelistData = WhitelistData({
            userId: _userId,
            userAddr: msg.sender,
            emailSuffix: _emailSuffix
        });
        whitelistedList[msg.sender] = newWhitelistData;
    }

    function verifyUser(address _white) public view returns(bool) {
        return whitelistedList[_white].userId > 0;
    }

}


