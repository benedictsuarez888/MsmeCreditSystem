App = {
  web3Provider: null,
  contracts: {},

  init: function() {
    return App.initWeb3();
  },

  // init: async function() {
  //   // Load pets.
  //   $.getJSON('../pets.json', function(data) {
  //     var petsRow = $('#petsRow');
  //     var petTemplate = $('#petTemplate');
  //
  //     for (i = 0; i < data.length; i ++) {
  //       petTemplate.find('.panel-title').text(data[i].name);
  //       petTemplate.find('img').attr('src', data[i].picture);
  //       petTemplate.find('.pet-breed').text(data[i].breed);
  //       petTemplate.find('.pet-age').text(data[i].age);
  //       petTemplate.find('.pet-location').text(data[i].location);
  //       petTemplate.find('.btn-adopt').attr('data-id', data[i].id);
  //
  //       petsRow.append(petTemplate.html());
  //     }
  //   });
  //
  //   return await App.initWeb3();
  // },

  initWeb3: async function() {
    // Modern dapp browsers...
  if (window.ethereum) {
    App.web3Provider = window.ethereum;
    try {
      // Request account access
      await window.ethereum.enable();
    } catch (error) {
      // User denied account access...
      console.error("User denied account access")
    }
  }
  // Legacy dapp browsers...
  else if (window.web3) {
    App.web3Provider = window.web3.currentProvider;
  }
  // If no injected web3 instance is detected, fall back to Ganache
  else {
    App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
  }
  web3 = new Web3(App.web3Provider);

    return App.initContract();
  },

  initContract: function() {
    $.getJSON('CreditingSystem.json', function(data) {
    // Get the necessary contract artifact file and instantiate it with truffle-contract
    var CreditArtifact = data;
    App.contracts.CreditingSystem = TruffleContract(CreditArtifact);

    // Set the provider for our contract
    App.contracts.CreditingSystem.setProvider(App.web3Provider);

    // Use our contract to retrieve and mark the adopted pets
    return App.getCalculatedLoan();
  });

    return App.bindEvents();
  },

  bindEvents: function() {
    $(document).on('click', '#calculateButton', App.handleCalculation);
  },

  handleCalculation: function(event) {
    event.preventDefault();

      var loan_amount = parseInt($('#loan_amount').val());
      var loan_years = parseInt($('#loan_years').val());

      console.log('Calculate' + loan_amount + ' and ' + loan_years);

      var creditingSystemInstance;

      web3.eth.getAccounts(function(error, accounts) {
        if(error) {
          console.log(error);
        }

        var account = accounts[0];

        App.contracts.CreditingSystem.deployed().then(function(instance) {
          creditingSystemInstance = instance;

          return creditingSystemInstance.loanMoney(loan_amount, loan_years);
        }).then(function(result) {
          alert('Calculation Successful!');
          return App.getCalculatedLoan();
        }).catch(function(err) {
          console.log(err.message);
        });
      });
  },

  // getBalance: function() {
  //   console.log('Getting balances...');
  //
  //   var creditingSystemInstance;
  //
  //   web3.eth.getAccounts(function(error, accounts) {
  //     if(error) {
  //       console.log(error);
  //     }
  //
  //     var account = accounts[0];
  //
  //     App.contracts.CreditingSystem.deployed().then(function(instance) {
  //       creditingSystemInstance = instance;
  //
  //       return creditingSystemInstance.getBalance(account);
  //     })
  //   })
  // }



  getCalculatedLoan: function() {
    console.log("Getting the computed loan...");

    var creditingSystemInstance;

    web3.eth.getAccounts(function(error, accounts){
      if (error) {
        console.log(error);
      }

      var account = accounts[0];

      App.contracts.CreditingSystem.deployed().then(function(instance) {
        creditingSystemInstance = instance;

        return creditingSystemInstance.viewCalculatedLoan(account);
      }).then(function(result) {
        principal = result[0];
        interest_rate = result[1];
        total_loan = result[2];
        total_emi = result[3];

        $('principal').value(principal);
        $('interest_rate').value(interest_rate);
        $('total_loan').value(total_loan);
        $('total_emi').value(total_emi);
      }).catch(function(err) {
        console.log(err.message);
      });
    });

    // App.contracts.CreditingSystem.deployed().then(function(instance) {
    //   calculateLoanInstance = instance;
    //
    //   return calculateLoanInstance.viewCalculatedLoan.call();
    // }).then(function(loanAmount, interestCalc, futureBalCalc, totalPayableCalc) {
    //   for (i = 0; i < loanAmount.legth; i++) {
    //
    //   }
    // })
  },

  // markAdopted: function(adopters, account) {
  //   var adoptionInstance;
  //
  //   App.contracts.Adoption.deployed().then(function(instance) {
  //     adoptionInstance = instance;
  //
  //     return adoptionInstance.getAdopters.call();
  //   }).then(function(adopters) {
  //     for (i = 0; i < adopters.length; i++) {
  //       if (adopters[i] !== '0x0000000000000000000000000000000000000000') {
  //         $('.panel-pet').eq(i).find('button').text('Success').attr('disabled', true);
  //       }
  //     }
  //   }).catch(function(err) {
  //     console.log(err.message);
  //   });
  // },

  handleAdopt: function(event) {
    event.preventDefault();

    var petId = parseInt($(event.target).data('id'));

    var adoptionInstance;

    web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }

      var account = accounts[0];

      App.contracts.Adoption.deployed().then(function(instance) {
        adoptionInstance = instance;

        // Execute adopt as a transaction by sending account
        return adoptionInstance.adopt(petId, {from: account});
      }).then(function(result) {
        return App.markAdopted();
      }).catch(function(err) {
        console.log(err.message);
      });
    });
  }

};

$(function() {
  $(window).load(function() {
    App.init();
  });
});
