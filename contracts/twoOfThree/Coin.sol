pragma solidity ^0.4.4;

contract Coin {
    adress public minter;
    mapping (address => uint) public balances;
    
    event Sent (address from, address to, uint amount);
    
    // constructor
    function Coin () {
        minter = msg.sender;
    }
    
    funtion mint (address receiver, uint amount) {
        if (msg.sender != minter) return;
        balances[receiver] += amount;
    }
    
    function send (address receiver, uint amount) {
        if balances[msg.sender] < amount) return;
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        Sent(msg.sender, receiver,amount);
    }
}
