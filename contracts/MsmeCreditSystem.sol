pragma solidity ^0.4.24;

contract CreditingSystem {

    address owner;
    uint256 balance;
    uint256 loanAmount;
    uint256 creditScore;
    uint256 interestRate;
    uint256 payablePerMonth;
    uint256 payableIntereset;
    uint256 totalPayable;
    uint256 yearss;
    bool isLoanExist;

    constructor() public{
        owner = msg.sender;
        balance = 0;
        loanAmount;
        totalPayable;
        yearss;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized.");
        _;
    }

    function loanMoney(uint256 _loanAmount, uint256 _yearss) onlyOwner public returns (bool){
        if (_yearss == 1) {
            interestRate = 10;
            yearss = _yearss;
            payablePerMonth = _loanAmount/12;
            payableIntereset = payablePerMonth/interestRate;
            totalPayable = payablePerMonth + payableIntereset;

        } else if (_yearss == 2) {
            interestRate = 15;
            payablePerMonth = _loanAmount/24;
            payableIntereset = payablePerMonth/interestRate;
            totalPayable = payablePerMonth + payableIntereset;
        } else {
            revert();
        }

        // loanAmount = totalpay;
        // return (totalPayable, _loanAmount);
        return true;
    }

    function viewCalculatedLoans () onlyOwner public view returns (uint256, uint256) {
        // string yearsss = string(yearss) + "year/s";
        return (totalPayable, yearss);
    }

    function confirmLoan() onlyOwner public returns (bool) {
        if(balance > 0) {
            return false;
        } else {
            if (yearss == 1) {
                balance = totalPayable*12;
                return true;
            }else if(yearss == 2) {
                balance = totalPayable*24;
                return true;
            }
        }
    }

    function payLoan(uint256 _payLoan) onlyOwner public returns (bool){
        // if (balance > 0 && balance > _payLoan && balance == _payLoan) {
        //     balance -= _payLoan;
        //     return true;
        // } else {
        //     return false;
        // }
        // added comment for sample commit
        balance -= _payLoan;
        return true;
    }

    function viewBalance () onlyOwner public view returns (uint256) {
        return balance;
    }

    // view credit score na function

}
