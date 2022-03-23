//SPDX-License-Identifer : MIT

pragma solidity >=0.6.0<0.9.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol"; 

contract FundMe{
    address public owner;

    mapping(address => uint256) public addressToAmountFunded;

    //Le constructeur s'active dès que le contrat est déployé. Donc la personne qui send the deploy message, ie le msg.sender, est déclaré comme étant le owner du contract.
    constructor() public{
        owner = msg.sender;
    } 

    address[] public funders; 

    //Interface cChainLink qui va nous permettre d'avoir la conversion ETH -> USD
    AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);

    //On crée une fonction qui va envoyer de l'argent au présent contract. Il faut que la somme envoyée soit supérieur à 50$.
    //Les investisseurs sont ajoutés à une map qui précise quelle adresse a envoyé quel montant. 
    function fund() public payable{
        uint256 amount = getConversionRate(msg.value);
        require(amount>50*10*18, "Send more");
        addressToAmountFunded[msg.sender]+= msg.value;
        funders.push(msg.sender);
    }
 
    function getVersion() public view returns (uint256){
        return priceFeed.version();  
    }

    //Fonction qui nous donne le prix en USD d'un ETH.
    function getPrice() public view returns (uint256){
        (,int256 answer,,,) = priceFeed.latestRoundData();
        return uint256(answer*10**8);
    }

    //Fonction qui nous donne le montant de la participation d'un donnateur.
    function getConversionRate(uint256 ethAmount) public view returns(uint256){
        return (ethAmount*(10**8))/FundMe.getPrice();
    }

    /*Ce modifier permet de dire : si cette condition est vérifié, run le code qui est en position "_". Ici, "_" est en bas du require, donc run le code qui est en bas. 
    modifier onlyOwner{
        require(msg.sender == owner, "Not owner");
        _;
    }*/

    //Permet de récupérer tout l'argent qui est sur le contrat et de l'envoyer au propriétaire du contract, déclaré dans le constructeur, ie celui qui a déployé le contrat.
    function withdraw() payable public{
        require(msg.sender == owner, "Not owner");
        payable(msg.sender).transfer(address(this).balance);
        for (uint256 i = 0; i<funders.length; i++){
            addressToAmountFunded[funders[i]] = 0 ;
        }
        funders = new address[](0);
    }
}
