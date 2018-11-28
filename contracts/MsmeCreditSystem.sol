pragma solidity ^0.4.24;

contract CreditingSystem {

    address owner;
    mapping (address => uint256) public balance;
    // mapping (address => uint256) loanAmount;
    mapping (address => uint256) public creditScore;
    mapping (address => uint256) interestRate;
    mapping (address => uint256) payablePerMonth;
    mapping (address => uint256) payableIntereset;
    mapping (address => uint256) public totalPayable;
    mapping (address => uint256) yearss;
    mapping (address => bool) public isCurrentLoanExist;
    mapping (address => bool) public isFirstTimeLoaner;

    // for calculator variables
    uint256 interestRateCalc;
    uint256 yearssCalc;
    uint256 payablePerMonthCalc;
    uint256 payableInteresetCalc;
    uint256 totalPayableCalc;


    constructor() public {
        owner = msg.sender;
        balance;
        // loanAmount;
        totalPayable;
        yearss;
        creditScore;
    }

    // modifier onlyOwner() {
    //     require(msg.sender == owner, "Not authorized.");
    //     _;
    // }

    // This function will serve as the calculator for loaning money
    // where the user will be inputting the amount loan and years to pay.
    function loanMoney(uint256 _loanAmount, uint256 _yearss) public returns (bool){
        if (_yearss == 1) {
            interestRateCalc = 10;
            yearssCalc = _yearss;
            payablePerMonthCalc = _loanAmount/12;
            payableInteresetCalc = payablePerMonthCalc/interestRateCalc;
            totalPayableCalc= payablePerMonthCalc + payableInteresetCalc;
            return true;

        } else if (_yearss == 2) {
            interestRateCalc = 15;
            payablePerMonthCalc = _loanAmount/24;
            payableInteresetCalc = payablePerMonthCalc/interestRateCalc;
            totalPayableCalc = payablePerMonthCalc + payableInteresetCalc;
            return true;
        } else {
            return false;
            revert();
        }
    }

    // This function will view the result from the loanMoney function.
    function viewCalculatedLoan () public view returns (uint256, uint256) {
        return (totalPayableCalc, yearssCalc);
    }

    // This function will confirm a loan if the customer was already satisfied with the result of the viewCalculatedLoans function
    function confirmLoan() public returns (bool) {
        require(isCurrentLoanExist[msg.sender] == false , "You still have a loan that is currently existing.");
        if (isFirstTimeLoaner[msg.sender] == false) {
            if (yearssCalc == 1) {
                yearss[msg.sender] = yearssCalc;
                totalPayable[msg.sender] = totalPayableCalc;
                balance[msg.sender] = totalPayableCalc*12;
                isCurrentLoanExist[msg.sender] = true;
                creditScore[msg.sender] = 100;
                return true;
            }else if(yearssCalc == 2) {
                yearss[msg.sender] = yearssCalc;
                totalPayable[msg.sender] = totalPayableCalc;
                balance[msg.sender] = totalPayableCalc*24;
                isCurrentLoanExist[msg.sender] = true;
                creditScore[msg.sender] = 100;
                return true;
            } else {
                revert();
                return false;
            }
        } else if (isFirstTimeLoaner[msg.sender] == true) {
            if (yearssCalc == 1) {
                yearss[msg.sender] = yearssCalc;
                totalPayable[msg.sender] = totalPayableCalc;
                balance[msg.sender] = totalPayableCalc*12;
                isCurrentLoanExist[msg.sender] = true;
                isFirstTimeLoaner[msg.sender] = false;
                return true;
            }else if(yearssCalc == 2) {
                yearss[msg.sender] = yearssCalc;
                totalPayable[msg.sender] = totalPayableCalc;
                balance[msg.sender] = totalPayableCalc*24;
                isCurrentLoanExist[msg.sender] = true;
                isFirstTimeLoaner[msg.sender] = false;
                return true;
            }else {
                revert();
                return false;
            }
        }
    }
        // if(isFirstTimeLoaner[msg.sender] == true) {
        //     if (isCurrentLoanExist[msg.sender] == false) {
        //         if (yearss[msg.sender] == 1) {
        //             balance[msg.sender] = totalPayable[msg.sender]*12;
        //             isCurrentLoanExist[msg.sender] = true;
        //             creditScore[msg.sender] = 80;
        //             return true;
        //         }else if(yearss[msg.sender] == 2) {
        //             balance[msg.sender] = totalPayable[msg.sender]*24;
        //             isCurrentLoanExist[msg.sender] = true;
        //             creditScore[msg.sender] = 80;
        //             return true;
        //         } else {
        //             revert();
        //             return false;
        //         }
        //     } else {
        //         if (isCurrentLoanExist[msg.sender] == false) {
        //             if (yearss[msg.sender] == 1) {
        //                 balance[msg.sender] = totalPayable[msg.sender]*12;
        //                 isCurrentLoanExist[msg.sender] = true;
        //                 return true;
        //             }else if(yearss[msg.sender] == 2) {
        //                 balance[msg.sender] = totalPayable[msg.sender]*24;
        //                 isCurrentLoanExist[msg.sender] = true;
        //                 return true;
        //             }else {
        //                 revert();
        //                 return false;
        //             }
        //         }
        //     }
        // }

    // This function will get the monthly payment from the customer
    function payLoan(uint256 _payLoan) public returns (bool){

        require(balance[msg.sender] > 0 && isCurrentLoanExist[msg.sender] == true, "Loan doesn't exist.");
        if (balance[msg.sender] == _payLoan || balance[msg.sender] > _payLoan) {
            if (_payLoan >= totalPayable[msg.sender]){
                if(creditScore[msg.sender] == 100) {
                    creditScore[msg.sender] += 0;
                }else if (creditScore[msg.sender] < 100) {
                    creditScore[msg.sender] += 1;
                }
            }else if(_payLoan  == 0) {
                creditScore[msg.sender] -= 2;
            } else if(_payLoan <= totalPayable[msg.sender]) {
                creditScore[msg.sender] -= 1;
            }
            if (balance[msg.sender] > 0) {
                balance[msg.sender] -= _payLoan;
                return true;
            } else if (balance[msg.sender] == 0) {
                isCurrentLoanExist[msg.sender] = false;
                interestRate[msg.sender] = 0;
                totalPayable[msg.sender] = 0;
                payablePerMonth[msg.sender] = 0;
                payableIntereset[msg.sender] = 0;
                yearss[msg.sender] = 0;
                return true;
            }
        } else if (balance[msg.sender] < _payLoan){
            revert();
            return false;
        }

        // if(balance[msg.sender] > 0 && isCurrentLoanExist[msg.sender] == true) {
        //     if (balance[msg.sender] == _payLoan || balance[msg.sender] > _payLoan) {
        //         if (_payLoan >= totalPayable[msg.sender]){
        //             if(creditScore[msg.sender] == 100) {
        //                 creditScore[msg.sender] += 0;
        //             }else if (creditScore[msg.sender] < 100) {
        //                 creditScore[msg.sender] += 1;
        //             }
        //         }else if(_payLoan <= totalPayable[msg.sender]) {
        //             creditScore[msg.sender] -= 1;
        //         } else if(_payLoan == 0) {
        //             creditScore[msg.sender] -= 2;
        //         }
        //         balance[msg.sender] -= _payLoan;
        //         return true;
        //     } else if (balance[msg.sender] < _payLoan){
        //         revert();
        //         return false;
        //     }
        // } else if (balance[msg.sender] == 0 && isCurrentLoanExist[msg.sender] == false) {
        //     revert();
        //     return false;
        // }

    }

    // This function will view the current balance of the customer
    function viewBalance() public view returns (uint256) {
        return balance[msg.sender];
    }

    // This function will view the credit score of the customer
    function viewCreditScore() public view returns (uint256) {
        return creditScore[msg.sender];
    }

}
