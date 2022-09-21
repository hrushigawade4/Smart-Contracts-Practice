

pragma solidity ^0.4.24;

//Safe Math Interface

contract SafeMath{
    
    function safeAdd(uint a, uint b) public pure returns(uint c){
        c = a + b;
        require(c >= a);
    }

    function safeSub(uint a, uint b) public pure returns(uint c){
        require(b <= a);
        c = a - b;
    }

    function safeMul(uint a, uint b) public pure returns(uint c){
        c = a * b;
        require(a == 0 || c / a == b);
    }

    function safeDiv(uint a, uint b) public pure returns(uint c){
        require(b > 0);
        c = a / b;
    }
}


//ERC Token Standard #20 Interface

contract ERC20Interface{
    function totalSupply() public constant returns (uint);
    function balanceOf(address tokenOwner) public constant returns (uint balance);
    function allowance(address tokenOwner, address spender) public constant returns(uint remaining);
    function transfer(address to, uint tokens) public returns (bool success);
    function approve(address spender, uint tokens) public returns(bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}


//Contract function to receive approval and execute function in one call


contract ApproveAndCallFallBack {
    function receiveApproval(address from, uint256 tokens, address token, bytes data) public; 
}

//Actual token contract

contract RUSHToken is ERC20Interface, SafeMath {
    string public symbol;
    string public name;
    uint8 public decimals;
    uint public _totalSupply;

    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;

    constructor() public {
        symbol = "RUSH";
        name = "RUSHI coin";
        decimals = 2;
        _totalSupply = 100000;
        balances[process.env.YOUR_METAMASK_WALLET_ADDRESS] = _totalSupply; //your metamask wallet address
        emit Transfer(address(0), process.env.YOUR_METAMASK_WALLET_ADDRESS, _totalSupply);
    }

    function totalSupply() public constant returns (uint) {
        return _totalSupply - balances[address(0)];
    }


    function balanceOf(address tokenOwner) public constant returns (uint balance) {
        return balances[tokenOwner];
    }

    function transfer(address to, uint tokens) public returns (bool success) {
        balances[msg.sender] = safeSub(balances[msg.sender], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        emit Transfer(msg.sender, to , tokens);
        return true;
    }

    function approve(address spender, uint tokens) public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }

    function transferFrom(address from, address to, uint tokens) public returns(bool success) {
        balances[from] = safeSub(balances[from], tokens);
        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        emit Transfer(from, to , tokens);
        return true; 
    }

    function allowance(address tokenOwner, address spender) public constant returns(uint remaining) {
        return allowed[tokenOwner][spender];
    }

    function approveAndCall(address spender, uint tokens, bytes data) public returns (bool sucecss){
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        ApproveAndCallFallBack(spender).receiveApproval(msg.sender, tokens, this, data);
        return true;
    }

    function () public payable {
        revert();
    }
}























































// Line 1: Declaring the solidity version

// Line 3-4: Calling the Safe Math interface to use math functions in our contract.

// Line 29-41: Calling the ERC-20 Interface to implement its functions.

// Line 44-48: A Contract function to receive approval and execute a function in one call.

// Line 52-56: Starting our QKCToken contract, creating a variable symbol of string type to hold our token’s symbol, a variable name of string type to hold our token’s name, variable decimals of unsigned integer type to hold the decimal value for the token division.

// Line 58-59: Creating two mapping functions that will grant users the ability to spend these tokens.

// Line 61-68: Initializing the constructor, setting symbol, name, decimals, and total supply value for our token. Declaring the total supply of the token to be equal to your wallet’s balance for this token.

// Line 70-72: Function totalSupply which will govern the total supply of our token.

// Line 74-76: Function balanceOf which will check the balance of a wallet address.

// Line 78-83: Function transfer which will execute the transfer of tokens from the total supply to users.

// Line 85-89: Function approve which will check if the total supply has the amount of token which needs to be allocated to a user.

// Line 91-97: Function transferFrom which will facilitate the transfer of token between users.

// Line 99-101: Function allowance which will check if a user has enough balance to perform the transfer to another user.

// Line 103-108: Function approveAndCall which executes the transactions of buying and spending of tokens.

// Line 110-112: Fallback function to prevent accounts from directly sending ETH to the contract, this prevents the users from spending gas on transactions in which they forget to mention the function name.

