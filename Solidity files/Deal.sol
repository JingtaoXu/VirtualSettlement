////////////////////////////////////////////////////////////////////////////////
/// \file
/// \brief      Virtual Settlement
/// \author     Jingtao Xu, Ranga Baminiwatte
/// \version    0.1.0
/// \date       8.10.2020
/// \copyright  © Jingtao Xu 2021.
///             © Ranga Baminiwatte 2021.
///
////////////////////////////////////////////////////////////////////////////////

pragma solidity ^0.5.0;

import "Account.sol";

contract Deal
{
    address    Owner ;

    bytes32[]  Debug ;    

    bytes32  State ;    

    struct Payment
    {
      address  account_from ;
      address  account_to ;
      uint256  amount ;
      bytes32  state ;
      bytes32  confirmed ;
    } 

      mapping (bytes32 => Payment) Payments ;

    struct PaymentTrigger
    {
      bytes32  id ;
      bytes32  state ;
    } 

      PaymentTrigger[]  PaymentsTriggers ;


    struct PaymentsList
    {
      bytes32[]  ids ;
    } 
     
      mapping (bytes32 => PaymentsList) PaymentsTrigByStatus ;
   


    event DeliveryFile(uint256 version) ; 

    event ChangedState(bytes32 state) ; 
    event Paid(bytes32  id, address  account_from, address  account_to, uint256  amount) ; 

    constructor() public 
    {
            Owner=msg.sender ;
            State="NEW" ;
    }

//    function() payable {}
  
//=============== Self-Description Iface
//
// 0x55d93027
    function SD_Version() public pure returns (bytes32)
    {
       return("RBI 1.0") ;
    }

// 0x0d55e9f5
    function SD_Identify() public pure returns (bytes32)
    {
       return("RBRU.Deal.2021-01-15") ;
    }

// 0x3e7bd089
    function SD_Describe() public pure returns (string memory)
    {
       return("Business process control") ;
    }

//=============== Debug Iface
//
// 0x

    function GetDebug()  public view returns (bytes32[] memory retVal)
    {
       return(Debug) ;
    }

//=============== Application Iface
//
// 0x


// 0x
    function PutPayment(bytes32  id_, address  account_from_, address  account_to_,  uint256  amount_, bytes32  execute_state_) internal
    {
       bool  result ;

//   If you want disable payment correction add next operator
       if(Payments[id_].account_from!=address(0x00))  require(false) ;

            Payments[id_]=Payment({account_from : account_from_,
                                   account_to   : account_to_,
                                    amount      : amount_,
                                     state      : execute_state_,
                                  confirmed     : "N"
                                  });

            PaymentsTriggers.push(PaymentTrigger({id : id_, state : execute_state_})) ;

//         PaymentsTrigByStatus[execute_state_].ids.push(id_) ;

            (result,)=account_from_.call.gas(0x300000).value(0)(
                abi.encodeWithSignature("PutPayment(bytes32,address,address,uint256)",
                                           id_, account_from_, account_to_, amount_)  ) ;
        if(result==false) require(false) ;

    }

// 0x
    function GetState()  public view returns (bytes32 retVal)
    {
       return(State) ;
    }
    
   // Try to implement:
//1. The LoadPayments method for the implementation of transactions in the Deal contract (hint - loaded as an array bytes32 - the address and int256 are convert
//ed to bytes32) with saving payments in the context of the contract and calling the PutPayment method of the corresponding Account contract (li
//nk 1.1 in the figure).
//2. Transfer of payment confirmation from the Account contract to the Deal contract (link 2.2 in the figure).
//3. In the SetState method of the Deal contract, implement the execution of payments triggered by the status (link 3.2 in the figure).

    //loaded as an array bytes32
    function LoadPayments(bytes32[] memory Payments_)  public 
    {
        uint256  amount ;
        uint256  i ;

        
        for (i = 0; i < Payments_.length; i+=5) 
        {
              amount=uint256(int256(Payments_[i+3])) ;
            PutPayment(Payments_[i], address(bytes20(Payments_[i+1])), address(bytes20(Payments_[i+2])), amount, Payments_[i+4]) ;
        }
    }
    
    function ConfirmPayment(bytes32 _id) public
    {
        Payments[_id].confirmed="Y" ;
    }
    
    
    function SetState(bytes32  state_) public
    {
      uint  i ;
      bool  result ;

// Check payments for execution
// 1. Check executing state of payment
// 2. Check accept  of payment
// 3. Execute payment and check it's result

        for(i = 0 ; i < PaymentsTriggers.length ; i++) 
        {
            if (PaymentsTriggers[i].state == state_)
            {
                if(Payments[PaymentsTriggers[uint256(i)].id].confirmed == "Y")
                {
                    address curAccount = Payments[PaymentsTriggers[i].id].account_from  ;


            (result,)=curAccount.call.gas(0x300000).value(0)(
                abi.encodeWithSignature("ExecutePayment(bytes32)", PaymentsTriggers[i].id) ) ;
        if(result==false) require(false) ;

                 emit Paid (         PaymentsTriggers[i].id, 
                            Payments[PaymentsTriggers[i].id].account_from,
                            Payments[PaymentsTriggers[i].id].account_to,
                            Payments[PaymentsTriggers[i].id].amount        );
                }
            }
            
        }      


/*

     for(i=0 ;  i<PaymentsTrigByStatus[execute_state_].ids.length ; i++) 
     {
        bytes32  id=PaymentsTrigByStatus[execute_state_].ids[i] ;

                if(Payments[id].confirmed == "Y")
                {
                    ....
                }
     }
*/

        State = state_ ;

                 emit ChangedState(state_) ; 

    }
        
}
