//SPDX-License-Identifer : MIT

pragma solidity >=0.6.0<0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Whitelist is Ownable{
    enum addressStatus {Default, Blacklist,Whitelist}
    mapping(address=> addressStatus) public list;
    event Authorized(address _address); // Event
    event blackListed(address _address);
 
    function authorize(address _address) public onlyOwner{
       list[_address] = addressStatus.Whitelist;
       emit Authorized(_address); // Triggering event
   }

   function blackList(address _address) public onlyOwner{
       list[_address] = addressStatus.Blacklist;
       emit blackListed(_address); // Triggering event
   }

   function basic(address _address) public onlyOwner{
       list[_address] = addressStatus.Default;
   }

   function getStatus(address _address) external view returns(addressStatus){
       return list[_address];
   }


}
