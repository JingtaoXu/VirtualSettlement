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


pragma solidity ^0.5.0 ;
 
 
import "Deal.sol" ;

contract Account
{
    address    Owner ;
     int256    Balance ;

   bytes32[]  Debug ;    

    struct Payment
    {
      bytes32  id ;
      address  account_to ;
      uint256  amount ;
      bytes32  accepted ;
    } 

    struct Deal
    {
      mapping (bytes32 => Payment) Payments ;
      bytes32                      Used ;
    }

    mapping (address => Deal) Deals ;
    
    //unique payment
    //mapping (bytes32 => mapping(bytes32 => Payment)) Paymentss ;
    
    event  AcceptPayment(bytes32  id, address  deal, address  account_from, address  account_to, uint256  amount) ;

    constructor() public payable
    {
            Owner = msg.sender ;
            Balance = 10000;
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
       return("RBRU.Account.2021-01-27") ;
    }

// 0x3e7bd089
    function SD_Describe() public pure returns (string memory)
    {
       return("Account control") ;
    }

// 
    function check_balance() public view returns (int256)
    {
        return(Balance) ; 
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
// 0xf9e50ac9
    function PutPayment(bytes32  id_, address  account_from_, address  account_to_,  uint256  amount_) public
    {
        if( address(this)!=account_from_)  require(false) ;

            Deals[msg.sender]=Deal({ Used : "Y"} ) ;

            Deals[msg.sender].Payments[id_]=Payment({     id     : id_, 
                                                     account_to  : account_to_,
                                                      amount     : amount_,
                                                    accepted     : "N"
                                                   });

        emit AcceptPayment(id_, msg.sender, address(this), account_to_, amount_) ;
    }

//
// 0x
    function PaymentAccepted(address  deal_, bytes32  id_) public  
    {
      bool  result ;

       if( msg.sender!=Owner)  require(false) ;

        Deals[deal_].Payments[id_].accepted = "Y" ;

            (result,)=deal_.call.gas(0x300000).value(0)(
                abi.encodeWithSignature("ConfirmPayment(bytes32)", id_)  ) ;
        if(result==false) require(false) ;
    }


// 0xda763e14
    function GetPayment(address deal_, bytes32  id_)  public view returns (address, uint256, bytes32 retVal)
    {
       return(Deals[deal_].Payments[id_].account_to, 
              Deals[deal_].Payments[id_].amount, 
              Deals[deal_].Payments[id_].accepted) ;
    }
    
    
// income function
    function Income(uint256 amount) public 
    {
//      if ( some condition ) require(false) ;

        Balance += int256(amount) ;
    }

// execute payment     
    function ExecutePayment( bytes32 id_ )  public returns (bool retval)
    {
        bool  result ;

        if (Deals[msg.sender].Payments[id_].accepted != "Y") require(false) ;
       
        Account beneficiaryAcc = Account(Deals[msg.sender].Payments[id_].account_to) ; 
       
//           beneficiaryAcc.Income(Deals[msg.sender].Payments[id_].amount) ;
        (result,)=address(beneficiaryAcc).call.gas(0x300000).value(0)(abi.encodeWithSignature("Income(unit256)", Deals[msg.sender].Payments[id_].amount)) ;
        if(result==false) require(false) ;

        Balance -= int256(Deals[msg.sender].Payments[id_].amount) ; 
       
       return result;
    }
    
}








