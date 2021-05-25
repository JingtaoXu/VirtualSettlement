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
    
    mapping (address => uint) private balances;
    
    // accounts of this payment;
    address public payer;
    address public beneficiary;
    
    
    // status 
    enum StateType { unexpected, expected, unconfirmed, confirmed, rejected, paid }
    StateType public state;
    
    
    struct Payment {
        address public InstancePayer;
        address public InstanceBeneficiary;
        uint amount;
        StateType state;
    }
    
    Payment payment; 
    
    // modifiers
     modifier condition(bool _condition) {
        require(_condition);
        _;
    }

    modifier onlyPayer() {
        require(
            msg.sender == payer,
            "Only payer can call this."
        );
        _;
    }

    modifier onlyBeneficiary() {
        require(
            msg.sender == beneficiary,
            "Only beneficiary can call this."
        );
        _;
    }

    modifier inState(State _state) {
        require(
            state == _state,
            "Invalid state."
        );
        _;
    }
    
    event PaymentConfirmed();
    event PaymentRequest();
    
    function setPayment(uint _value) public 
    {
        payment = Payment(payer, beneficiary, _value, unexpected);
    }

    
    
    function PaymentRequest() 
        public 
        inState(State.unexpected) 
    {
        emit PaymentRequest();
        payer = msg.sender;
        state = StateType.expected;
    }

    
    function confirmToPay()
        public
        onlyPayer
        inState(State.expected)
    {
        emit PaymentConfirmed();
        state = StateType.confirmed;
        payer.transfer(value);
        State = StateType.paid;
    }
    
    
    
}

