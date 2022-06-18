// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.11;
contract Wallet{
    address[] public approvers;
    uint public quorum;
    struct Transfer {
        uint id;
        uint amount;
        address payable to;
        uint approvals;
        bool sent;
    }
    Transfer[]public transfers;
    mapping(address => mapping(uint => bool)) public approvals;
constructor(address[] memory _approvers, uint _querum){
    approvers = _approvers;
    quorum = _querum;
}
// For Get list of the Approvers....
function getApprovers() external view returns(address[] memory){
    return approvers;
}
// /Get List of the Transfer
function getTransfers() external view returns(Transfer[] memory){
    return transfers;
}
function createTransfer(uint amount, address payable to) external onlyApprover(){
    transfers.push(Transfer(
      transfers.length,
      amount,
      to,
      0,
      false
    )
    );
}
// Approve Transferr
function approveTransfers(uint id) external onlyApprover(){
    require(transfers[id].sent == false, "Transfer has already been sent");
    require(approvals[msg.sender][id] == false, "Can not approve transfer Twice");
    approvals[msg.sender][id] = true;
    transfers[id].approvals++;
    if(transfers[id].approvals >= quorum){
        transfers[id].sent = true;
        address payable to = transfers[id].to;
        uint amount = transfers[id].amount;
        to.transfer(amount);
    }
}
 receive() external payable{}
 modifier onlyApprover(){
     bool allowed = false;
     for(uint i=0; i < approvers.length; i++){
         if(approvers[i] == msg.sender){
         allowed = true;
         }
     }
 require(allowed == true, 'only approver allowed');
 _;
}
}