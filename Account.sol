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


pragma solidity 0.6.0 ;
 
 
contract Account {

     address owner ;
     int256 balance ;
     enum StateType { unexpected, expected, unconfirmed, confirmed, rejected, paid }

    struct Payment {
      address  account_from ;    
      address  account_to ;
      int256  amount_max ;
      StateType payment_status ;
    }

    mapping (address => Payment) ConfirmedPayments ;
        //  Deal address   -> confirmed payment descriptions

    constructor() public
    {
        owner = tx.origin ;
    }

    function EnrollAccount(int  _money) public
    {
        if(msg.sender != tx.origin)  return ;
      
            balance += _money ;
    }

    function AcceptPayment(address _deal, address _account_to, int256  _money) public
    {
        if(msg.sender!=tx.origin)  return ;

            ConfirmedPayments[_deal].account_to = _account_to ;
            ConfirmedPayments[_deal].amount_max = _money ;
    }

    function PayTo(address  _account_to, int256  _money) public
    {
        if( ConfirmedPayments[msg.sender].account_to  == _account_to   && 
             ConfirmedPayments[msg.sender].amount_max  >= _money          ) 
         {
            balance -= _money ;

            address(_account_to).call.gas(0x300000).value(0)(abi.encodeWithSignature("AddMoney(int256)", _money)) ;
         }
    }

    function AddMoney(int256  _money) public
    {
            balance += _money ;
    }

}








