//SPDX-License-Identifer : MIT

pragma solidity >=0.6.0<0.9.0;

contract Bank{
    function transfer(address payable _to) public payable{
        require(msg.value>0, "Send more");
        (bool sent, bytes memory data) = _to.call{value : msg.value}("");
        require(sent, "Transaction was not sent");
    }
    function getBalanace(address _addr) public view returns(uint256){
        return _addr.balance;
    }
}
