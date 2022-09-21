// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

//This is my first smart contract
// contract info - simple contract
// 1. Set the number
// 2. get the number
contract SimpleStorage {
    uint storedData;
    function set(uint x) public {
        storedData = x;
    }
    function get() public view returns (uint) {
        return storedData;
    }
}