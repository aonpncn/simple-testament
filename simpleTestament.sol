// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Testament {

address _manager;
mapping(address=>address) _heir;
mapping(address=>uint) _balance;

event Create(address indexed owner, address indexed heir, uint amount);
event Report(address indexed owner, address indexed heir, uint amount);


constructor(){
    _manager = msg.sender;
}

//owner create testament
function create(address heir)public payable{
    // must transfer money > 0
    require(msg.value>0,"Please Enter Money Greater then 0");
    // can only create a testament once.
    require(_balance[msg.sender]<=0,"Already Testament Exists");

    _heir[msg.sender] = heir;
    _balance[msg.sender] = msg.value;

    emit Create(msg.sender, heir, msg.value);
}


// to view the testament
function getTestament(address owner) public view returns(address heir,uint amount){
    return (_heir[owner],_balance[owner]);
}


// heritage
function reportOfDeath(address owner) public{
    // check, is a manager or not
    require(msg.sender ==_manager,"Unauthorized");
    // check if the owner has created a testament before
    require(_balance[owner]>0,"No Testament");
    
    emit Report(owner,_heir[owner],_balance[owner]);
    
    // transfer _balance[owner] to _heir[owner]
    payable(_heir[owner]).transfer(_balance[owner]);

    // the transfer is complete, the data must be reset
    _balance[owner] = 0;
    _heir[owner] = address(0);
}

}