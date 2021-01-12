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

pragma solidity ^0.6.0;

import "Account.sol";

contract Deal {
    Account payer = new Account();
    Account beneficiary = new Account();
    int256 amountOfMoney;
    
    enum StateType { unconfirmed, confirmed, rejected, paid }
    StateType public state; // current status 
    
    
     modifier inState(StateType _state) {
        require(
            state == _state,
            "Invalid state."
        );
        _;
    }
    
    function toComfirm(address _add_beneficiary) public
    {
        // payer = Account(tx.origin);
        payer.acceptPayment( msg.sender, _add_beneficiary, amountOfMoney);
        state = StateType.confirmed;
    }

    function pay(Account _payer, Account _beneficiary, int256 _amountOfMoney) public 
    {
        _payer.payTo(_beneficiary.owner, _amountOfMoney);
        _beneficiary.addMoney(_amountOfMoney);
    }
    
}