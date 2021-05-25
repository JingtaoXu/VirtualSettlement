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


contract Deal {
    // status 
    enum StateType { unexpected, expected, unconfirmed, confirmed, rejected, paid }
    StateType public state;
    
    struct Payment {
        address InstancePayer;
        address InstanceBeneficiary;
        uint amount;
        StateType state;
    }
    
    Payment payment; 
    Payment[] public listOfExpectedPayments;
    function addPayment(address _payer, address _beneficiary, uint _money) public
    {
        listOfExpectedPayments.push(Payment(_payer, _beneficiary, _money, StateType.unexpected));
    }
}

// PASC - Payer's account Smart contract
contract PASC is Deal {
    // accounts of this payment;
    address payable public payer;
    address payable public beneficiary;
    

    modifier onlyPayer() {
        require(
            msg.sender == payer,
            "Only payer can call this."
        );
        _;
    }
    modifier inState(StateType _state) {
        require(
            state == _state,
            "Invalid state."
        );
        _;
    }
    
    event PaymentRequest();
    event PaymentConfirmed();
    
    function paymentRequest() 
        public 
        inState(StateType.unexpected) 
        payable
    {
        emit PaymentRequest();
        payer = msg.sender;
        state = StateType.expected;
    }
    
    function confirmToPay()
        public
        onlyPayer
        inState(StateType.expected)
        payable 
    {
        emit PaymentConfirmed();
        state = StateType.confirmed;
        payer.transfer(payment.amount);
        state = StateType.paid;
    }
}





