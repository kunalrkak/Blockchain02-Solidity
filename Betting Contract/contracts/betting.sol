pragma solidity 0.4.20;


contract Betting {
    /* Constructor function, where owner and outcomes are set */
    function Betting(uint[] _outcomes) public payable {
        owner = msg.sender;
        outcomeLength = 0;
        for (uint i = 0; i < _outcomes.length; i++) {
            outcomes[i] = _outcomes[i];
            outcomeLength ++;
        }
    }

    /* Fallback function */
    function() public payable {
        revert();
    }

    /* Standard state variables */
    address public owner;
    address public gamblerA;
    address public gamblerB;
    address public oracle;

    /* Structs are custom data structures with self-defined parameters */
    struct Bet {
        uint outcome;
        uint amount;
        bool initialized;
    }

    /* Keep track of every gambler's bet */
    mapping (address => Bet) bets;
    /* Keep track of every player's winnings (if any) */
    mapping (address => uint) winnings;
    /* Keep track of all outcomes (maps index to numerical outcome) */
    mapping (uint => uint) public outcomes;
    uint outcomeLength;

    /* Add any events you think are necessary */
    event BetMade(address gambler);
    event BetClosed();

    /* Uh Oh, what are these? */
    modifier ownerOnly() {if (msg.sender == owner) _;}
    modifier oracleOnly() {if (msg.sender == oracle) _;}
    modifier outcomeExists(uint outcome) {if (outcome < outcomeLength) _;}

    /* Owner chooses their trusted Oracle */
    function chooseOracle(address _oracle) public ownerOnly() returns (address) {
        oracle = _oracle;
    }
    
    // function getBet(address a) public returns (uint) {
    //     Bet b = bets[a];
    //     return b.outcome;
    // } 
    
    // function getBetAmt(address a) public returns (uint) {
    //     Bet b = bets[a];
    //     return b.amount;
    // } 

    /* Gamblers place their bets, preferably after calling checkOutcomes */
    function makeBet(uint _outcome) public payable returns (bool) {
        address sender = msg.sender;
        if (sender == owner || sender == oracle) {
            return false;
        }
        else if (gamblerA == 0) {
            gamblerA = sender;
        }
        else if (gamblerB == 0) {
            gamblerB = sender;
        }
        else {
            return false;
        }
        
        
        if (!bets[sender].initialized) {
            bets[sender].amount = msg.value;
            bets[sender].outcome = _outcome;
            bets[sender].initialized = true;
            BetMade(sender);
            return true;
        }
        else {
            return false;
        }
    }

    /* The oracle chooses which outcome wins */
    function makeDecision(uint _outcome) public oracleOnly() outcomeExists(_outcome) {
        BetClosed();
        uint aBet = bets[gamblerA].amount;
        uint bBet = bets[gamblerB].amount;
        if (bets[gamblerA].outcome == _outcome && bets[gamblerB].outcome == _outcome) {
            winnings[gamblerA] += aBet;
            winnings[gamblerB] += bBet;
        }
        else {
            uint total = aBet + bBet;
            if (bets[gamblerA].outcome == _outcome) {
                winnings[gamblerA] += total;
            }
            else if (bets[gamblerB].outcome == _outcome) {
                winnings[gamblerB] += total;
            }
            else {
                winnings[oracle] += total;
            }
        }
        
        contractReset();
    }

    /* Allow anyone to withdraw their winnings safely (if they have enough) */
    function withdraw(uint withdrawAmount) public returns (uint) {
        if (withdrawAmount <= winnings[msg.sender]) {
            winnings[msg.sender] -= withdrawAmount;
        }
        msg.sender.transfer(withdrawAmount);
    }
    
    /* Allow anyone to check the outcomes they can bet on */
    function checkOutcomes(uint outcome) public view returns (uint) {
        for (uint i = 0; i < outcomeLength; i++) {
            if (outcomes[i] == outcome) {
                return i;
            }
        }
    }
    
    /* Allow anyone to check if they won any bets */
    function checkWinnings() public view returns(uint) {
        return winnings[msg.sender];
    }

    /* Call delete() to reset certain state variables. Which ones? That's upto you to decide */
    function contractReset() public ownerOnly() {
        delete(gamblerA);
        delete(gamblerB);
        delete(oracle);
        delete(bets[gamblerA]);
        delete(bets[gamblerB]);
    }
}
