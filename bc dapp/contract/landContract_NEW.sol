pragma solidity ^0.4.0;

contract MyLandContract
{
    struct Land 
    {
        address ownerAddress;
        string location;
        string name;
        string parent;
        string date;
        uint landID;
    }
    address public owner;   // government is owner of contract

    uint public totalLandsCounter; //Total number of people registered
    
    //setting owner as who ever deploys contract
    function MyLandContract() public
    {
        owner = msg.sender;
        totalLandsCounter = 0;
    }
    
    //registry event
    event Add(address _owner, uint _landID);
    
    //certificate transfer event
    event Transfer(address indexed _from, address indexed _to, uint _landID);
    
    modifier isOwner
    {
        require(msg.sender == owner);
        _;
    }
    
    //associating accounts with certificates
    mapping (address => Land[]) public __ownedLands; 
    

    //1. REGISTER
    //goverment registers people through this function
    function addLand(string _location, string _name, string _parent, string _date) public isOwner
    {
        totalLandsCounter = totalLandsCounter + 1;
        Land memory myLand = Land(
            {
                ownerAddress: msg.sender,
                location: _location,
                name: _name,
                parent: _parent,
                date: _date,
                landID: totalLandsCounter
            });
        __ownedLands[msg.sender].push(myLand);
        Add(msg.sender, totalLandsCounter);

    }
    
    
    //2. TRANSFER OWNERSHIP OF CERTIFICATE
    //goverment transfers created certificate to persons address 
    function transferLand(address _landBuyer, uint _landID) public isOwner returns (bool)
    {
        //checking account id
        for(uint i=0; i < (__ownedLands[msg.sender].length);i++)    
        {
            //making sure it matchs the account
            if (__ownedLands[msg.sender][i].landID == _landID)
            {
                //changing the owner address to the new account 
                Land memory myLand = Land(
                    {
                        ownerAddress:_landBuyer,
                        location: __ownedLands[msg.sender][i].location,
                        name: __ownedLands[msg.sender][i].name,
                        parent: __ownedLands[msg.sender][i].parent,
                        date: __ownedLands[msg.sender][i].date,
                        landID: _landID
                    });
                __ownedLands[_landBuyer].push(myLand);   
                
                //removing from goverments account
                delete __ownedLands[msg.sender][i];

                
                //inform 
                Transfer(msg.sender, _landBuyer, _landID);                
                
                return true;
            }
        }
        
        //if we still did not return, return false
        return false;
    }
    
    
    //3. GET CERTIFICATE DETAILS
    function getLand(address _landHolder, uint _index) public returns (string, string, string, string, address,uint)
    {
        return (__ownedLands[_landHolder][_index].location, 
                __ownedLands[_landHolder][_index].name,
                __ownedLands[_landHolder][_index].parent,
                __ownedLands[_landHolder][_index].date,
                __ownedLands[_landHolder][_index].ownerAddress,
                __ownedLands[_landHolder][_index].landID);
                
    }
    
    //4. How many certificates person has
    function getNoOfLands(address _landHolder) public returns (uint)
    {
        return __ownedLands[_landHolder].length;
    }


}