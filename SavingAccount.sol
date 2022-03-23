//SPDX-License-Identifier: MIT

pragma solidity >=0.6.0<0.9.0;

contract bank{
    address private owner;
    mapping(uint256=>uint256) idToAmount;
    uint256 id;
    uint256 time;

    constructor(){
        owner=msg.sender;
    }

    modifier onlyOwner{
        require(msg.sender == owner, "Not owner");
        _;
    }

    function addMoney() public payable{
        idToAmount[id]=msg.value;
        id++;
        if(time==0){
            time= block.timestamp + 12 weeks;
        }
    }

    function withdraw(uint256 _time) public payable onlyOwner{
        require(_time>time, "Wait");
        (bool sent,) = payable(msg.sender).call{value : address(this).balance}("");
        require(sent, "Not well sent");
    }

}

