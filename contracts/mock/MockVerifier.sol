// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

contract MockVerifier {

    /*
    * @returns Whether the proof is valid given the hardcoded verifying key
    *          above and the public inputs
    */
    function verifyProof(
        bytes memory proof,
        uint256[3] memory input
    ) public pure returns (bool) {
        return true;
    }
}