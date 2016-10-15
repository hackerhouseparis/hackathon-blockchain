contract twoOfThree{
    address public a1; /* owners of the contract */
    address public a2;
    address public a3;
    
    function twoOfThree(address c1, address c2, address c3){
        a1=c1;
        a2=c2;
        a3=c3;
    }
    
    struct Transaction{
        address beneficiary;
        uint amount;
        bool v1; /* Validated by parties */
        bool v2;
        bool v3;
        bool done;
    }
    
    Transaction[] public transactions;
    uint public numberTransactions=0;
    
    modifier onlyOwners()
    {
        if (msg.sender!=a1 && msg.sender!=a2 && msg.sender!=a3)
            throw;
        _
    }
    
    function createTransaction(address beneficiary, uint amount) onlyOwners {
            
        numberTransactions = transactions.length++; /* Create a new transaction */
        Transaction t = transactions[numberTransactions];
        t.beneficiary=beneficiary;
        t.amount=amount;
        t.v1=false;
        t.v2=false;
        t.v3=false;
        t.done=false;
    }
    
    function validateTransaction(uint targetTransaction) onlyOwners {
        if (targetTransaction > numberTransactions)
            throw;
        
        Transaction t = transactions[targetTransaction];
        
        if (msg.sender == a1)
            t.v1=true;
        else if (msg.sender == a2)
            t.v2=true;
        else if (msg.sender == a3)
            t.v3=true;
    }
    
    function executeTransaction(uint targetTransaction) onlyOwners{
        if (targetTransaction > numberTransactions)
            throw;
            
        Transaction t = transactions[targetTransaction];
        
        uint numberValid=0;
        if (t.v1)
            numberValid++;
        if (t.v2)
            numberValid++;
        if (t.v3)
            numberValid++;
        
        if (numberValid < 2)
            throw;
        
        if (t.done)
            throw;
        
        t.done=true;
        if (!t.beneficiary.send(t.amount))
            throw;
        
        
    }
    
    function(){}
    
    
}


