// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (token/ERC20/ERC20.sol)

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Suwidnyana is IERC20 {
    string public constant name = "Suwidnyana";
    string public constant symbol = "SWDN";
    uint8 public constant decimals = 18;

    event App(
        address indexed tokenOwner,
        address indexed spender,
        uint256 tokens
    );

    event Trf(address indexed from, address indexed to, uint256 tokens);

    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;

    uint256 totalSupply_ = 2000000 ether;

    using SafeMath for uint256;

    constructor() public {
        balances[msg.sender] = totalSupply_;
    }

    function totalSupply() public view override returns (uint256) {
        return totalSupply_;
    }

    function balanceOf(address tokenOwner)
        public
        view
        override
        returns (uint256)
    {
        return balances[tokenOwner];
    }

    function transfer(address receiver, uint256 numTokens)
        public
        override
        returns (bool)
    {
        require(numTokens <= balances[msg.sender]);
        balances[msg.sender] = balances[msg.sender].sub(numTokens);
        balances[receiver] = balances[receiver].add(numTokens);
        emit Trf(msg.sender, receiver, numTokens);
        return true;
    }

    function approve(address delegate, uint256 numTokens)
        public
        override
        returns (bool)
    {
        allowed[msg.sender][delegate] = numTokens;
        emit App(msg.sender, delegate, numTokens);
        return true;
    }

    function allowance(address owner, address delegate)
        public
        view
        override
        returns (uint256)
    {
        return allowed[owner][delegate];
    }

    function transferFrom(
        address owner,
        address buyer,
        uint256 numTokens
    ) public override returns (bool) {
        require(numTokens <= balances[owner]);
        require(numTokens <= allowed[owner][msg.sender]);

        balances[owner] = balances[owner].sub(numTokens);
        allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(numTokens);
        balances[buyer] = balances[buyer].add(numTokens);
        emit Trf(owner, buyer, numTokens);
        return true;
    }
}
