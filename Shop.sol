//SPDX-License-Identifier: MIT

pragma solidity >=0.6.0<0.9.0;

contract shop{

    mapping(string=>Item) public myShop;
    string public name;
    
    struct Item{
        uint256 price;
        uint256 units;
    }


    function setItem(string memory _name, uint256 _price,uint256 _units) external{
        myShop[_name].price=_price;
        myShop[_name].units=_units;
    }

    function addItem(string memory _name, Item memory _item) external{
        myShop[_name]=_item;        
    }

    function getItem(string memory _name) external view returns(uint256,uint256){
        return (myShop[_name].price,myShop[_name].units);
    }
}
