
#Tests unitaires de Voting.sol

##Unit tests

27 tests validés

###Etape 1 : Test du "Voters registration" (4 tests)
- should add a voter
- should not add a voter if you are not the admin
- should not add a voter he is already registered
- should not add a voter if the workflow status is not set at RegisteringVoters


###Etape 2 : Test du "Proposals registration" (3 tests)
- should add a proposal
- should not add a proposal if it is not a voter
- should not add a proposal if the workflow status is not set at RegisteringVoters


###Etape 3 : Test du "Voting session" (4 tests)
- should set a vote
- should not set a vote if it is not a voter
- should not set a vote if the workflow status is not set at VotingSessionStarted
- should not set a vote if the voter has already voted

###Etape 4 : Test du "Tally votes" (1 tests)
- should tally votes and get the winner(s)


###Etape finale : Test de la partie "Admin workflow validation" (15 tests)
- should start the proposals registering
- should not start the proposals registering if it is not the admin
- should not start the proposals registering if the workflow status is not set at RegisteringVoters
- should end the proposals registering
- should not end the proposals registering if it is not the admin
- should not end the proposals registering if the workflow status is not set at ProposalsRegistrationStarted
- should start the voting session
- should not start the voting session if it is not the admin
- should not start the voting session if the workflow status is not set at ProposalsRegistrationEnded
- should end the voting session
- should not end the voting session if it is not the admin
- should not end the voting session if the workflow status is not set at VotingSessionStarted
- should tally votes
- should not tally votes if it is not the admin
- should not tally votes if the workflow status is not set at VotingSessionEnded
