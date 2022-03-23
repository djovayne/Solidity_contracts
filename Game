//SPDX-License-Identifier: MIT

pragma solidity >=0.6.0<0.9.0;

contract TakeAGuess{
    address public owner;
    string private mot;
    string public indice;
    mapping(address=>bool) public Played;
    address public gagnant;
    address[] public Players;

    constructor(){
        owner=msg.sender;
    }

    modifier onlyOwner{
        require(owner == msg.sender, "You're not the owner");
        _;
    }

    function setMot(string memory _mot, string memory _indice) public onlyOwner{
        mot=_mot;
        indice=_indice;
    }

    function play(string memory _mot) public{
        require(Played[msg.sender]==false,"Already played");
        Players.push(msg.sender);
        Played[msg.sender]=true;
        if(keccak256(abi.encodePacked(_mot)) == keccak256(abi.encodePacked(mot))){
            gagnant=msg.sender;
        }
    }

    function howManyPlayers() public view returns(uint256){
        return Players.length;
    }

    function reset(string memory _mot, string memory _indice) public onlyOwner{
        mot=_mot;
        indice=_indice;
        for(uint256 i=0 ;i<Players.length; i++){
            Played[Players[i]]=false;
        }
        delete Players;
        gagnant = address(0);
    }
}
