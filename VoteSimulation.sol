//SPDX-License-Identifer : MIT

pragma solidity >=0.6.0<0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";

// Toutes les fonctions (sauf stringCompare), sont external car elles ne s'appellent pas entre elles
contract Voting is Ownable {
    uint private highestVoteCount;
    WorkflowStatus private workflowStatus;
    Proposal[] private proposals;
    mapping (address => Voter) private voters;
    mapping (uint => uint[]) private proposalsIdsVoteCounts;
    mapping (uint => Proposal[]) private proposalsVoteCounts;

    struct Voter {
        bool isRegistered;
        bool hasVoted;
        uint votedProposalId;
    }
    struct Proposal {
        string description;
        uint voteCount;
    }

    enum WorkflowStatus {
        RegisteringVoters,
        ProposalsRegistrationStarted,
        ProposalsRegistrationEnded,
        VotingSessionStarted,
        VotingSessionEnded,
        VotesTallied
    }

    event VoterRegistered(address voterAddress);
    event WorkflowStatusChange(WorkflowStatus previousStatus, WorkflowStatus newStatus);
    event ProposalRegistered(uint proposalId);
    event Voted (address voterAddress, uint proposalId);


    constructor() Ownable() {
        addVoter(msg.sender);
    }

   
    modifier onlyVoters() {
        require(voters[msg.sender].isRegistered, "Not registered as voter");
        _;
    }

   
    function compareString(string memory _str1, string memory _str2) internal pure returns (bool) {
        return (keccak256(abi.encodePacked((_str1))) == keccak256(abi.encodePacked((_str2))));
    }

  
    function getWorkflowstatus() external view returns (WorkflowStatus) {
        return workflowStatus;
    }

 
    function addProposal(string memory _description) external onlyVoters {
        require(workflowStatus == WorkflowStatus.ProposalsRegistrationStarted, "Workflow status cant allow to request proposals");
        require(!compareString(_description, ""), "Enter description");

        Proposal memory proposal;
        proposal.description = _description;
        proposals.push(proposal);

        emit ProposalRegistered(proposals.length - 1);
    }


    function getProposals() external view onlyVoters returns (Proposal[] memory)  {
        return proposals;
    }

   
    function getProposal(uint _proposalId) external view onlyVoters returns (Proposal memory) {
        require(_proposalId < proposals.length, "Proposal not found. Enter valid id.");
        return proposals[_proposalId];
    }

   
    function addVoter(address _voterAddress) public onlyOwner {
        require(workflowStatus == WorkflowStatus.RegisteringVoters, "Workflow status cant allow to add voters");
        require(voters[_voterAddress].isRegistered == false, "Voter already registered");

        voters[_voterAddress].isRegistered = true;

        emit VoterRegistered(_voterAddress);
    }


    function removeVoter(address _voterAddress) external onlyOwner {
        require(workflowStatus == WorkflowStatus.RegisteringVoters, "Workflow status cant allow to add voters");
        require(voters[_voterAddress].isRegistered, "Voter already NOT registered");

        voters[_voterAddress].isRegistered = false;

        emit VoterRegistered(_voterAddress);
    }

  
    function getVoter(address _voterAddress) external onlyVoters view returns (Voter memory) {
        return voters[_voterAddress];
    }

   
    function startRegisteringProposals() external onlyOwner {
        require(workflowStatus == WorkflowStatus.RegisteringVoters, "Workflow status cant allow to register proposals");

        workflowStatus = WorkflowStatus.ProposalsRegistrationStarted;

        emit WorkflowStatusChange(WorkflowStatus.RegisteringVoters, WorkflowStatus.ProposalsRegistrationStarted);
    }


    function stopRegisteringProposals() external onlyOwner {
        require(
            workflowStatus == WorkflowStatus.ProposalsRegistrationStarted,
            "Workflow status cant allow to stop registering proposals"
        );

        workflowStatus = WorkflowStatus.ProposalsRegistrationEnded;

        emit WorkflowStatusChange(WorkflowStatus.ProposalsRegistrationStarted, WorkflowStatus.ProposalsRegistrationEnded);
    }

 
    function startVotingSession() external onlyOwner {
        require(workflowStatus == WorkflowStatus.ProposalsRegistrationEnded, "Workflow status cant allow to start voting session");

        workflowStatus = WorkflowStatus.VotingSessionStarted;

        emit WorkflowStatusChange(WorkflowStatus.ProposalsRegistrationEnded, WorkflowStatus.VotingSessionStarted);
    }

   
    function vote(uint _proposalId) external onlyVoters {
        require(workflowStatus == WorkflowStatus.VotingSessionStarted, "Workflow status cant allow to vote");
        require(voters[msg.sender].hasVoted == false, "Already voted");
        require(_proposalId < proposals.length, "Proposal not found. Enter valid id.");

        voters[msg.sender].votedProposalId = _proposalId;
        voters[msg.sender].hasVoted = true;
        proposals[_proposalId].voteCount++;

        emit Voted(msg.sender, _proposalId);
    }

   
    function stopVotingSession() external onlyOwner {
        require(workflowStatus == WorkflowStatus.VotingSessionStarted, "Workflow status cant allow to stop the voting session");
        
        workflowStatus = WorkflowStatus.VotingSessionEnded;
        
        emit WorkflowStatusChange(WorkflowStatus.VotingSessionStarted, WorkflowStatus.VotingSessionEnded);
    }


    function tallyVotes() external onlyOwner {
        require(workflowStatus == WorkflowStatus.VotingSessionEnded, "Workflow status cant allow to tally votes");

        for (uint i = 0; i < proposals.length; i++) {
            Proposal memory proposal = proposals[i];
            proposalsVoteCounts[proposal.voteCount].push(proposal);
            proposalsIdsVoteCounts[proposal.voteCount].push(i);

            if (highestVoteCount < proposal.voteCount) {
                highestVoteCount = proposal.voteCount;
            }
        }
        workflowStatus = WorkflowStatus.VotesTallied;

        emit WorkflowStatusChange(WorkflowStatus.VotingSessionEnded, WorkflowStatus.VotesTallied);
    }

    function getHighestVoteCount() external view returns (uint) {
        require(workflowStatus == WorkflowStatus.VotesTallied, "Workflow status cant allow to see highest vote count");
        return highestVoteCount;
    }

   
    function getWinningProposalIds() external view returns (uint[] memory) {
        require(workflowStatus == WorkflowStatus.VotesTallied, "Workflow status cant allow to see the winners proposal ids");
        return proposalsIdsVoteCounts[highestVoteCount];
    }

    
    function getWinners() external view returns (Proposal[] memory) {
        require(workflowStatus == WorkflowStatus.VotesTallied, "Workflow status cant allow to see the winners proposals");
        return proposalsVoteCounts[highestVoteCount];
    }
}

// Fin du voting process
