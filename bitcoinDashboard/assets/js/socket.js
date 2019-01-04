// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// To use Phoenix channels, the first step is to import Socket,
// and connect at the socket path in "lib/web/endpoint.ex".
//
// Pass the token on params as below. Or remove it
// from the params if you are not using authentication.
import {Socket} from "phoenix"
// import Chart from "chart.js"

let socket = new Socket("/socket", {params: {token: window.userToken}})

let channel = socket.channel("room:lobby", {})

var walletDiv = document.getElementById('wallet-list');


channel.on("geAllWallets", function (payload) { // listen to the 'shout' event
  walletDiv.style.display = "flex"
  viewWalletsDiv.style.display = "none"
  transactionWalletsDiv.style.display = "none"
  generatedTransactionDiv.style.display = "none"
  viewTransactionsDiv.style.display = "none"
  viewChartsDiv.style.display = "none"

  
  console.log(payload.wallets)
  
  if (payload.wallets.length > 0) {
      var innerDiv = document.createElement('div');
      innerDiv.innerHTML = '<h3 style="color: white;">Successfully created wallets. Click ViewWallets to view.</h3>'
      innerDiv.style.color = "FFF"
      innerDiv.style.margin = "20px 0";
      
      walletDiv.appendChild(innerDiv);
    }
  console.log("generate network")
});

var minedDiv = document.getElementById('mine-data');
channel.on("performMining", function (payload) { 
  console.log("performMining")
  minedDiv.innerHTML = "";
  walletDiv.style.display = "none"
  minedDiv.style.display = "flex"
  viewWalletsDiv.style.display = "none"
  transactionWalletsDiv.style.display = "none"
  generatedTransactionDiv.style.display = "none"
  viewTransactionsDiv.style.display = "none"
  viewChartsDiv.style.display = "none"


  if (payload.wallets) {
    walletNames = [];

    for (let index = 0; index < payload.wallets.length; index++) {
      var wallet = payload.wallets[index];
      var innerDiv = document.createElement('div');
      innerDiv.className="col-xl-4";
      innerDiv.style.margin = "20px 0";
      innerDiv.innerHTML = `
              <div class="card text-white bg-primary o-hidden h-100">
                <div class="card-body">
                  <div class="card-body-icon">
                    <i class="fas fa-fw fa-list"></i>
                  </div>
                  <div class="mr-5">Wallet Name:` + wallet.name + `</div>
                  <div class="mr-5">Public Key: <small> `+ wallet.publicKey +` </small></div>
                  <div class="mr-5">Wallet Balance: `+ wallet.walletBalance+` BTC</div>
                </div>
                <a class="card-footer text-white clearfix small z-1" href="#">
                  <span class="float-left">More</span>
                  <span class="float-right">
                    <i class="fas fa-angle-right"></i>
                  </span>
                </a>
              </div>
  `;
      
      minedDiv.appendChild(innerDiv);

      walletNames.push(wallet.name);
      sessionStorage.walletMined = walletNames
      
    }
  }   
});

var walletNames = [];
var minedWalletNames = [];
var bgColor = "";
var viewWalletsDiv = document.getElementById('view-wallet-data');
channel.on("viewWallets", function (payload) { 
  minedWalletNames = sessionStorage.walletMined.split(',')
  console.log("viewWallets")
  walletDiv.style.display = "none"
  minedDiv.style.display = "none"
  viewWalletsDiv.style.display = "flex"
  viewWalletsDiv.innerHTML = '';
  transactionWalletsDiv.style.display = "none"
  generatedTransactionDiv.style.display = "none"
  viewTransactionsDiv.style.display = "none"
  viewChartsDiv.style.display = "none"

  if (payload.wallets) {
    walletNames = [];

    for (let index = 0; index < payload.wallets.length; index++) {
      var wallet = payload.wallets[index];
      
      var name = wallet.name.toString()
      console.log(name)
      console.log(minedWalletNames)
      console.log(name in minedWalletNames)
      if (minedWalletNames.includes(name)) 
        bgColor = "bg-primary"
      else
        bgColor = "bg-warning"

      console.log()
      var innerDiv = document.createElement('div');
      innerDiv.className="col-xl-4";
      innerDiv.style.margin = "20px 0";
      innerDiv.innerHTML = `
              <div class="card text-white ` + bgColor + ` o-hidden h-100">
                <div class="card-body">
                  <div class="card-body-icon">
                    <i class="fas fa-fw fa-list"></i>
                  </div>
                  <div class="mr-5">Wallet Name:` + wallet.name + `</div>
                  <div class="mr-5">Public Key: <small> `+ wallet.publicKey +` </small></div>
                  <div class="mr-5">Wallet Balance: `+ wallet.walletBalance+` BTC</div>
                </div>
                <a class="card-footer text-white clearfix small z-1" href="#">
                  <span class="float-left">More</span>
                  <span class="float-right">
                    <i class="fas fa-angle-right"></i>
                  </span>
                </a>
              </div>
  `;
      
      viewWalletsDiv.appendChild(innerDiv);

      walletNames.push(wallet.name);
      
    }
  }   
});

//generate wallets for transaction
var transactionWalletsDiv = document.getElementById('generate-wallets-for-transaction');

  channel.on("generateWalletsForTransaction", function (payload) { // listen to the 'shout' event
    console.log(payload.wallets)
    
    if (payload.wallets.length > 0) {

      var fromWalletSelect = document.getElementById('fromWallet');
    
      for (let index = 0; index < payload.wallets.length; index++) {
        var wallet = payload.wallets[index];
        if (wallet.walletBalance > 0) {
          var option = document.createElement("option");
          option.text = wallet.name;
          option.value = wallet.publicKey;
          fromWalletSelect.add(option);
        }
      }

      var toWalletSelect = document.getElementById('toWallet');
      
      for (let index = 0; index < payload.wallets.length; index++) {
      var wallet = payload.wallets[index];
        var option = document.createElement("option");
        option.text = wallet.name;
        option.value = wallet.publicKey;
        toWalletSelect.add(option);
      }
      
      // transactionWalletsDiv.appendChild(toWalletSelect);
    }
});

// generate Transaction
var generatedTransactionDiv = document.getElementById('generated-transaction-data');
channel.on("generateTransaction", function (payload) { 
  minedWalletNames = sessionStorage.walletMined.split(',')
  console.log("generated  Transaction", payload)
  walletDiv.style.display = "none"
  minedDiv.style.display = "none"
  transactionWalletsDiv.style.display = "none"
  generatedTransactionDiv.style.display = "flex"
  viewTransactionsDiv.style.display = "none"
  viewChartsDiv.style.display = "none"

  // transactionWalletsDiv.innerHTML = '';
  
  if (payload.wallets && payload.wallets.length > 0) {
    generatedTransactionDiv.innerHTML = '';
    walletNames = [];

    for (let index = 0; index < payload.wallets.length; index++) {
      var wallet = payload.wallets[index];
      
      var name = wallet.name.toString()
      console.log(name)
      // console.log(minedWalletNames)
      // console.log(name in minedWalletNames)
      var innerDiv = document.createElement('div');
      innerDiv.className="col-xl-4";
      innerDiv.style.margin = "20px 0";
      innerDiv.innerHTML = `
              <div class="card text-white bg-success o-hidden h-100">
                <div class="card-body">
                  <div class="card-body-icon">
                    <i class="fas fa-fw fa-list"></i>
                  </div>
                  <div class="mr-5">Wallet Name:` + wallet.name + `</div>
                  <div class="mr-5">Public Key: <small> `+ wallet.publicKey +` </small></div>
                  <div class="mr-5">Wallet Balance: `+ wallet.walletBalance+` BTC</div>
                </div>
                <a class="card-footer text-white clearfix small z-1" href="#">
                  <span class="float-left">More</span>
                  <span class="float-right">
                    <i class="fas fa-angle-right"></i>
                  </span>
                </a>
              </div>
    `;
      
    generatedTransactionDiv.appendChild(innerDiv);
    generatedTransactionDiv.style.visibility = "flex";
      
    }
  }   
});


//blockchain
var viewBlockchainDiv = document.getElementById('view-blockchain-data');
channel.on("viewBlockchain", function (payload) { 
  // minedWalletNames = sessionStorage.walletMined.split(',')
  console.log("viewBlockchain")
  walletDiv.style.display = "none"
  minedDiv.style.display = "none"
  viewBlockchainDiv.style.display = "flex"
  viewBlockchainDiv.innerHTML = '';
  transactionWalletsDiv.style.display = "none"
  generatedTransactionDiv.style.display = "none"
  viewTransactionsDiv.style.display = "none"


  if (payload.blockchain) {
    console.log(payload.blockchain.length)

    for (let index = 0; index < payload.blockchain.length; index++) {
      var block = payload.blockchain[index];
      var a = new Date(block.blockTime);
      var months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
      var year = a.getFullYear();
      var month = months[a.getMonth()];
      var date = a.getDate();
      var hour = a.getHours();
      var min = a.getMinutes();
      var sec = a.getSeconds();
      var time = date + ' ' + month + ' ' + year + ' ' + hour + ':' + min + ':' + sec ;
      var index = block.blockIndex.toString()

      // {blockIndex: blockIndex, blockTime: blockTime, blockHash: blockHash, blockPrevHash: blockPrevHash, blockMerkleRoot: blockMerkleRoot}

      console.log(block)
      var innerDiv = document.createElement('div');
      innerDiv.className="col-xl-4";
      innerDiv.style.margin = "20px 0";
      innerDiv.innerHTML = `
              <div class="card text-white bg-danger h-100">
                <div class="card-body">
                  <div class="mr-5">Block Index:` + block.blockIndex + `</div>
                  <div class="mr-5">Block creation timestamp:` + time + `</div>
                  <div class="mr-5">Block hash:` + block.blockHash + `</div>
                  <div class="mr-5">Previous block hash: <small> `+ block.blockPrevHash +` </small></div>
                  <div class="mr-5">Merkle root: `+ block.blockMerkleRoot+`</div>
                </div>
                <a class="card-footer text-white clearfix small z-1" href="#">
                  <span class="float-left">More</span>
                  <span class="float-right">
                    <i class="fas fa-angle-right"></i>
                  </span>
                </a>
              </div>
  `;
      
      viewBlockchainDiv.appendChild(innerDiv);
      
    }
  }   
});


//transactions
var viewTransactionsDiv = document.getElementById('transactions-data');
channel.on("viewTransactions", function (payload) { 
  console.log("viewTransactions")
  walletDiv.style.display = "none"
  viewTransactionsDiv.style.display = "block"
  viewWalletsDiv.style.display = "none"
  transactionWalletsDiv.style.display = "none"
  generatedTransactionDiv.style.display = "none"
  viewChartsDiv.style.display = "none"


  if (payload.confirmedTransactions) {
    walletNames = [];
    $("#transactionTable").empty()

    for (let index = 0; index < payload.confirmedTransactions.length; index++) {
      var transaction = payload.confirmedTransactions[index];
      var a = new Date(transaction.timestamp);
      var months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
      var year = a.getFullYear();
      var month = months[a.getMonth()];
      var date = a.getDate();
      var hour = a.getHours();
      var min = a.getMinutes();
      var sec = a.getSeconds();
      var time = date + ' ' + month + ' ' + year + ' ' + hour + ':' + min + ':' + sec ;
      $("#transactionTable tbody").prepend(
        `
        <tr>
          <th scope="row">`+index+`</th>
          <td>`+transaction.hash+`</td>
          <td>`+time+`</td>
          <td>`+transaction.totalAmount+`</td>
        </tr>
        `
      );
      
      } 
    }else {
      $("#transactionTable").visibility = "none";
    }
    if (payload.unconfirmedTransactions) {
      walletNames = [];
      $("#unconfirmedTransactionTable tbody").empty()
      for (let index = 0; index < payload.unconfirmedTransactions.length; index++) {
        var transaction = payload.unconfirmedTransactions[index];
        var a = new Date(transaction.timestamp);
        var months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
        var year = a.getFullYear();
        var month = months[a.getMonth()];
        var date = a.getDate();
        var hour = a.getHours();
        var min = a.getMinutes();
        var sec = a.getSeconds();
        var time = date + ' ' + month + ' ' + year + ' ' + hour + ':' + min + ':' + sec ;

        $("#unconfirmedTransactionTable tbody").prepend(
          `
          <tr>
            <th scope="row">`+index+`</th>
            <td>`+transaction.hash+`</td>
            <td>`+time+`</td>
            <td>`+transaction.totalAmount+`</td>
          </tr>
          `
        );
        
      }
  }   
});

// Charts
var viewChartsDiv = document.getElementById('view-charts-data');
channel.on("viewCharts", function (payload) { 
  // minedWalletNames = sessionStorage.walletMined.split(',')
  console.log("viewCharts")
  walletDiv.style.display = "none"
  minedDiv.style.display = "none"
  viewChartsDiv.style.display = "none"
  transactionWalletsDiv.style.display = "none"
  generatedTransactionDiv.style.display = "none"
  viewTransactionsDiv.style.display = "none"
  viewChartsDiv.style.display = "block"

  $.getJSON('https://api.coindesk.com/v1/bpi/historical/close.json?start=2013-09-01&end=2018-09-05', function(json) {
      //data is the JSON string
      console.log(json)
      json = json.bpi
      var data = []
      var labels = []

      var data = [];
      for (var d in json) {
          console.log(d, json[d]);
          // data.push({
          //     x : new Date(d),
          //     y : json[d]
          // })
          data.push(json[d])
          labels.push(d)
      }
      console.log(data, labels)
      // var dataset = {
      //     label : "c",
      //     backgroundColor : "rgba(0,0,255,0.5)",
      //     borderColor : 'green',
      //     fill : false,
      //     data : data
      // };

      var ctx = document.getElementById('line-chart').getContext('2d');
      var myChart = new Chart(ctx, {
        type: 'line',
        data: {
          labels: labels,
          datasets: [{
            label: 'BTC',
            data: data,
            backgroundColor: "rgba(153,255,51,0.4)"
          }]
        }
      });
      // for (let i = 0; i < data.bpi.length; i++) {
      //   const element = data.bpi[i];
      //   labels.push()
      // }
      
  });

  if (payload.wallets) {
    console.log(payload.wallets.length)
    var data = []
    var labels = []
    for (let index = 0; index < payload.wallets.length; index++) {
      var wallet = payload.wallets[index];
      data.push(wallet.walletBalance)
      labels.push(index+1)
    }
    console.log(data)

    // Bar chart
    var ctx = document.getElementById("bar-chart").getContext('2d');
    var myChart = new Chart(ctx, {
    type: 'bar',
    data: {
      labels: labels,
      datasets: [{
        label: 'BTC',
        data: data,
        backgroundColor: "rgba(153,255,51,0.4)"
      }]
    },
    options: {scales: {
      xAxes: [{
        gridLines: {
          display: false,
          color: "black"
        },
        scaleLabel: {
          display: true,
          labelString: "Wallet Names",
          fontColor: "black"
        }
      }],
      yAxes: [{
        gridLines: {
          color: "black",
          borderDash: [2, 5],
        },
        scaleLabel: {
          display: true,
          labelString: "Balance (in BTC)",
          fontColor: "black"
        }
      }]
    }}
    });
  }   
  
});




  
channel.join(); // join the channel.
  

console.log("inside aqpp.js")
document.getElementById("createWalletButton").addEventListener("click", function(){
    console.log("Clicked!!")
    channel.push('geAllWallets', { // send the message to the server on "shout" channel
        wallets: []
      });
});

document.getElementById("mineButton").addEventListener("click", function(){
  console.log("mine Clicked!!")
  channel.push('performMining', { // send the message to the server on "shout" channel
      wallets: []
    });
});

document.getElementById("viewWalletButton").addEventListener("click", function(){
  console.log("viewWalletButton Clicked!!")
  channel.push('viewWallets', { // send the message to the server on "shout" channel
      wallets: []
    });
});


document.getElementById("generateWalletsForTransaction").addEventListener("click", function(){
  console.log("generateWalletsForTransaction Clicked!!")
  transactionWalletsDiv.style.display = "flex"
  viewWalletsDiv.style.display = "none"
  walletDiv.style.display = "none"
  minedDiv.style.display = "none"
  generatedTransactionDiv.style.display = "none"
  viewTransactionsDiv.style.display = "none"

  var fromWalletSelect = document.getElementById('fromWallet');
  var length = fromWalletSelect.options.length;
  for (let i = 0; i < length; i++) {
    fromWalletSelect.remove(i);
  }

  var toWalletSelect = document.getElementById('toWallet');
  var length = toWalletSelect.options.length;
  for (let i = 0; i < length; i++) {
    toWalletSelect.remove(i);
  }
  channel.push('generateWalletsForTransaction', { // send the message to the server on "shout" channel
      wallets: []
    });
});

document.getElementById("generateTransactionButton").addEventListener("click", function(){
  console.log("generateTransactionButton Clicked!!")
  var fromWallet = document.getElementById("fromWallet") 
  var toWallet = document.getElementById("toWallet") 
  var amount = document.getElementById("transactionAmount")
  channel.push('generateTransaction', { // send the message to the server on "shout" channel
    fromWallet: fromWallet.value, toWallet: toWallet.value, amount: amount.value
    });

});

document.getElementById("viewBlockchain").addEventListener("click", function(){
  console.log("viewBlockchain Clicked!!")
  channel.push('viewBlockchain', { // send the message to the server on "shout" channel
    });
});

document.getElementById("viewTransactions").addEventListener("click", function(){
  console.log("viewTransactions Clicked!!")
  channel.push('viewTransactions', { // send the message to the server on "shout" channel
    });
});

document.getElementById("viewCharts").addEventListener("click", function(){
  console.log("viewCharts Clicked!!")
  channel.push('viewCharts', { // send the message to the server on "shout" channel
    });
});

sessionStorage.setItem("walletMined", '')


export default socket