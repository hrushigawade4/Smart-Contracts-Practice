// SPDX-License-Identifier: MIT

pragma solidity >= 0.5.0 <0.9.0;
// 0. only manager can request or make payment but it should not participate 
// 1. send eth to CrowdFunding and be a contributor
// 2. create request for project  i.e Make request and use this amount for doing some great work or project 
// 3. vote for the created request project
// 4. make payment for request if fulfill the criteria
// 5. Refund if some mishappening

contract CrowdFunding{

    mapping(address => uint) public contributors;
    // mapp the address of contributors who is contributing by send eth to contract
    address public manager;
    uint public minContribution;
    uint public deadLine;
    uint public raisedAmount;
    uint public noOfContributors;
    uint public target;

    struct Request {
        string description; // details of request
        address payable recipient; 
        uint value; // how much he wants the funds for request
        bool completed; //status of request e.g false then it is processing and if true when completed
        uint noOfVoters; 
        mapping(address => bool) voters;
        // mapp the address of contributors who have voted e.g if voted then true and not voted then false
    }

    mapping(uint => Request) public requests;
    uint public numRequests;
    

    constructor(uint _target, uint _deadline) {
        target = _target;
        deadLine = block.timestamp + _deadline;
        manager = msg.sender;
        minContribution = 1000000000000000000; // 1 ETH =  1000000000000000000 WEI
    }

    modifier onlyManager() {
        require(msg.sender==manager, "Only manager can call this function");
        _;
    }


    function sendEth() public payable {
        require(deadLine > block.timestamp , "Deadline Has passed");
        require(msg.value >= minContribution, "Min Contribution is not met(min 100 wei");

        if(contributors[msg.sender] == 0){
            noOfContributors ++;
        }
        raisedAmount += msg.value;
        contributors[msg.sender] += msg.value;
        // mapp e.g contributor[0x0002131.......] contribute 1Eth ..........msg.sender => msg.value
    }

    function contractBalance () public view returns(uint256) {
        return address(this).balance;
    }

    function createRequests(string memory _description, address payable _recipient, uint _value) public onlyManager {
        Request storage newRequest = requests[numRequests];
        numRequests++;
        newRequest.description = _description;
        newRequest.recipient = _recipient;
        newRequest.value = _value;
        newRequest.completed = false;
        newRequest.noOfVoters=0;
    }

    function voteRequest(uint _requestNo) public {
        require(contributors[msg.sender]>0, "You must be a contributor");
        Request storage thisRequest=requests[_requestNo];
        require(thisRequest.voters[msg.sender]==false, "You have already voted");
        thisRequest.voters[msg.sender]=true;
        thisRequest.noOfVoters++;
    }

    function makePayment(uint _requestNo) public onlyManager {
        require(raisedAmount>=target);
        Request storage thisRequest = requests[_requestNo];
        require(thisRequest.completed==false, "The request has been completed");
        require(thisRequest.noOfVoters > noOfContributors/2, "Majority does not support for this request");
        thisRequest.recipient.transfer(thisRequest.value);
        thisRequest.completed=true;
    }

    function refund() public {
        require(block.timestamp > deadLine && raisedAmount < target, "Not eligible for refund");
        require(contributors[msg.sender] > 0, "Not eligible for refund");
        address payable user = payable(msg.sender);
        user.transfer(contributors[msg.sender]);
        contributors[msg.sender] = 0;

    }
    





}