/* License: Do What The Fuck You Want Public License http://www.wtfpl.net/about/ */

contract continuity{
    address public owner;
    uint256 public lastPing;
    uint256 public timeBeforeRelease; // Time to release after last ping
    uint256 constant maxTime=2**250;
    
    struct Beneficiary{
        address addr; // Beneficiary address
        uint256 timeAfterRelease; // Time after the release time
    }
    
    Beneficiary[] public beneficiaries;
    uint public numberBeneficiaries=0;
    
    modifier onlyOwner() {
        if (msg.sender!=owner)
            throw;
        _
        lastPing=now; // Always ping when the owner interacts with the contract;
    }
    
    function continuity(uint256 r) {
        owner=msg.sender;
        changeTimeBeforeRelease(r);
    }
    
    function ping() onlyOwner() {} // Does nothing except updating lastPing
    
    function changeTimeBeforeRelease(uint256 r) onlyOwner{
        checkReasonableValue(r); // Incoherent values are forbidden to avoid overflow
        timeBeforeRelease=r;

    }
    
    function withdraw(uint amount) onlyOwner {
        // With amount wei to the owner
        if (!owner.send(amount))
            throw;
    }
    
    
    function checkReasonableValue(uint256 v) private {
        if (v>maxTime)
            throw;
    }
    
    function addBeneficiary(address addr,uint256 timeAfterRelease) onlyOwner {
        checkReasonableValue(timeAfterRelease); // Incoherent values are forbidden to avoid overflow
        numberBeneficiaries=beneficiaries.length++;
        Beneficiary b = beneficiaries[numberBeneficiaries];
        b.addr=addr;
        b.timeAfterRelease=timeAfterRelease;
    }
    
    function changeTimeAfterRelease(uint beneficiaryID, uint256 timeAfterRelease) onlyOwner {
        checkReasonableValue(timeAfterRelease);
        if (beneficiaryID>numberBeneficiaries)
            throw; // Beneficiary does not exist
        
        beneficiaries[beneficiaryID].timeAfterRelease=timeAfterRelease;
    }
    
    function removeBeneficiary(uint beneficiaryID) onlyOwner {
        if (beneficiaryID>numberBeneficiaries)
            throw; // Beneficiary does not exist

        beneficiaries[beneficiaryID].timeAfterRelease=maxTime; // Put the time at the maxTime (which will never be reached)
    }
    
    function claim(uint beneficiaryID,uint amount) {
        if (beneficiaryID>numberBeneficiaries)
            throw; // Beneficiary does not exist
        if (beneficiaries[beneficiaryID].addr!=msg.sender)
            throw; // The beneficiary is not the good one
        if (lastPing+timeBeforeRelease+beneficiaries[beneficiaryID].timeAfterRelease > now)
            throw; // Funds can't be released yet
        
        if (!msg.sender.send(amount))
            throw;
    }
    

    function () {} // Accept funds transferts
    
    

}

