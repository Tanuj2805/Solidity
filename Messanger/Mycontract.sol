// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract Mycontract
{

    string public msg = "Hello World"; 

    function showmsg() public 
    {
         msg = string(abi.encodePacked(msg, "hello9"));
    }

}