pragma solidity ^0.4.4;

contract SimpleStorage {
    uint storedData;
    
    function set (uint x) {
        storedData = x;
    }
    
    function get () constant returns (uint retVal) {
        return storedData;
    }
}
