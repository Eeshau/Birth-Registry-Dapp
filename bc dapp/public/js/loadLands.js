//update land records from current selected account..
//loadLand();

$('#updateLandsButtonID').click(function()
{
    loadLand();
    return false;
});

//Wait for land list to load
$(document).arrive('input[type=radio][name=inlineRadioOptions]', function() {
    // 'this' refers to the newly created element
    //var $newElem = $(this);
    //console.log('New land updated in Display');
    //register for land selection
    $('input[type=radio][name=inlineRadioOptions]').on('change', function() 
    {
        var landID = $(this).val();
        updateStatus("\nLand ID selected: " + landID);
        $('#selectedLandID').text(landID); //update selected land for transfer op
    });
});




function loadLand()
{
    if (isOkToCall)    //we could update only if accounts accessible via metamask..
    {
        //clear display if already showing list
        $('#contentPanel').empty();

        //get the contract hook and call the function
        realEstateContractHook.getNoOfLands.call(ethWeb3.eth.defaultAccount,
            (error, noOfLandsOfCurrentAccount) =>
            {
                console.log("No of lands of Current Account: " + noOfLandsOfCurrentAccount);
                for (index=0; index<noOfLandsOfCurrentAccount;index++)
                {
                    realEstateContractHook.getLand.call(ethWeb3.eth.defaultAccount, index, 
                        (error, land) =>
                        {
                            if (land[4] != 0)
                            {
                                console.log("name: " + land[1]);
                                console.log("Location: " + land[0]);
                                console.log("Cost: " + land[3]);
                                console.log("parents: " + land[2]);
                                console.log("date: " + land[5]);
                                console.log("Owner: " + land[4]);  
                                console.log("Land ID: " + land[6] + ":"); 
                                updateListDisplay(land);  
                             
                            }
                        }
                    );
                }
                   
            }
        );        

    }    
    else
    {
        console.log("web3 init not ok. please ensure that before this operation");
    }
}


function updateListDisplay(land)
{
    var i = land[4];
    var location = land[0];
    var name = land[1];
    var parent = land[2];
    var date = land[6];
    var myLabel = $('<label class="form-check-label"></label>');
    var myInput = $('<input class="form-check-input" type="radio" name="inlineRadioOptions" id="inlineRadio' + i +'" value="' + i + '">');
    var myCard = $('<div class="card" id="inlineCard' + i + '" style="width:250px"><img src="https://s14.postimg.org/b7n0s9csh/land.jpg"><h5>Address: '+ i +'</h5><span> Full Name: '+ name +'</span><span>Date of Birth: '+ date +'</span><span>City, Country: '+ location +'</span><span> Guardian(s): '+ parent +'</span></div>');
    myInput.appendTo(myLabel);
    myCard.appendTo(myLabel);
    $('<br>').appendTo(myLabel);
    myLabel.appendTo('#contentPanel');
};