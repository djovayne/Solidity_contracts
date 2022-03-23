//SPDX-License-Identifier: MIT

pragma solidity >=0.6.0<0.9.0;

contract Grades{
    address public profBio = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    address public profMaths = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;
    address public profFr = 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db;
    Student[] public class;
    Student public studentTemp;
    bool executedMaths = false;
    bool executedBio = false;
    bool executedFr = false;

    struct Student{
        uint256 noteBio;
        uint256 noteMaths;
        uint256 noteFr;
    }

    function addBio(uint256 _noteBio) public{
        require(msg.sender==profBio,"You're not the bio teacher");
        studentTemp.noteBio = _noteBio;
        executedBio = true;
    }

    function addMaths(uint256 _noteMaths) public{
        require(msg.sender==profMaths,"You're not the maths teacher");
        studentTemp.noteMaths= _noteMaths;
        executedMaths = true;
    }

    function addFr(uint256 _noteFr) public{
        require(msg.sender==profFr,"You're not the fr teacher");
        studentTemp.noteFr = _noteFr;
        executedFr = true;
    }

    function addStudent() public{
        require(executedBio==true && executedMaths==true && executedFr==true,"All grades are not there");
        class.push(studentTemp);
        delete studentTemp;
        executedFr = false;
        executedBio = false;
        executedMaths = false;
    }

    function average() public view returns(uint256,uint256,uint256){
        uint256 bio;
        uint256 maths;
        uint256 fr;
        for(uint256 i=0; i<class.length;i++){
            bio+=class[i].noteBio;
            maths+=class[i].noteMaths; 
            fr+=class[i].noteFr;
        }
        return (bio/class.length,maths/class.length,fr/class.length);
    }

}
