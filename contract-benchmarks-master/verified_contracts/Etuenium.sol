pragma solidity ^0.4.18;

contract Etuenium {

    uint256 public totalSupply = 200*10**27;
    string public name = "Etuenium";
    uint8 public decimals = 18;
    string public symbol = "eTNM";
    mapping (address => uint256) balances;
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    

    constructor() public {
        balances[0xd9575a15Cb1064A73e839676373c4A6e05284768] = totalSupply;
    }
    
    function() payable {
        revert();
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balances[msg.sender] >= _value);
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function balanceOf(address _owner) constant public returns (uint256 balance) {
        return balances[_owner];
    }

}