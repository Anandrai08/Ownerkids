// SPDX-License-Identifier: Unlicensed

pragma solidity ^0.8.7;
 
contract OwnerKid{
    address owner;

    event LogKidFundingReceived(address addr, uint amount, uint contractBalance);


constructor() {
owner = msg.sender;
    }

//  define Kid

struct Kid {
    address payable walletAddress;
    string firstname;
    string lastname;
    uint releaseTime;
    uint amount;
    bool canwithdraw;
}
Kid[] public kids;

modifier onlyOwner() {
    require(msg.sender == owner, "Only owner can add their kids");
    _;
}
// add kids to contract 
function addkids(address payable walletAddress, string memory firstname, string memory lastname, uint releaseTime, uint amount, bool canwithdraw) public onlyOwner{
kids.push(Kid(walletAddress, firstname, lastname, releaseTime, amount, canwithdraw));
}
function balanceOf() public view returns(uint){
    return address(this).balance;
}  
//deposit funds to contract, specifically to a kid's account
function deposit(address walletAddress) payable public {
    addToKidsBalance(walletAddress);

} 
function addToKidsBalance(address walletAddress) private {
    for(uint i=0; i < kids.length;i++){
    if(kids[i].walletAddress==walletAddress){
    kids[i].amount+=msg.value;
    emit LogKidFundingReceived(walletAddress, msg.value, balanceOf());
}
}
}
function getIndex(address walletAddress) view private returns(uint) {
    for(uint i =0; i < kids.length; i++){
    if(kids[i].walletAddress==walletAddress){
        return i;
    }
    }
    return  999;
}
//kid check if able to withdraw
function availableToWithdraw(address walletAddress) public returns(bool) {
    uint i=getIndex(walletAddress);
    require(block.timestamp>kids[i].releaseTime,"You can not withdraw yet");
    if(block.timestamp>kids[i].releaseTime){
        kids[i].canwithdraw= true;
        return true;
}
else
{
    return false;
}
}
// withdraw Money
function withdraw(address payable walletAddress) payable public {
    uint i = getIndex(walletAddress);
    require(msg.sender == kids[i].walletAddress, "you must be kid to withdraw");
    require(kids[i].canwithdraw== true, "you are not abble to withdraw this time");
    kids[i].walletAddress.transfer(kids[i].amount);
}
