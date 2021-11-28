# A todo list on Ethereum

> Reference: [Build Your First Blockchain App Using Ethereum Smart Contracts and Solidity](https://www.youtube.com/watch?v=coQ5dg8wM2o)

## 1. Installation

Install [Ganache](https://www.trufflesuite.com/ganache). It's a personal blockchain, simulating an Ethereum network on your computer, running on `http://127.0.0.1:7545`. It comes with a simulated wallet with several accounts, each having 100 ETH.

Install the Truffle framework using `npm install -g truffle`. It allows you to deploy Ethereum smart contracts written with Solidity.

Install the [Metamask](https://chrome.google.com/webstore/detail/metamask/nkbihfbeogaeaoehlefnkodbefgpgknn?hl=en) extension on Google Chrome. It allows web applications to communicate with networks and interact with smart contracts, such on the real Ethereum network or a simulated blockchain.

## 2. Set up project

Initialise the project.

```bash
git init
npm init
truffle init
```

Create `truffle-config.js`.

```js
module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545, // Standard Ethereum port is 8545. Personal blockchain runs on 7545.
      network_id: "*" // Match any network
    }
  },
  compilers: {
    solc: {
      version: "0.8.10", // Fetch default truffle's version
      settings: {
        optimizer: {
          enabled: true,
          runs: 200
        },
        evmVersion: "byzantium"
      }
    }
  }
};
```

## 3. Write a smart contract

Add `TodoList.col` into the `contracts` folder.

```solidity
// Declare the version of Solidity to use before beginning a smart contract.
pragma solidity ^0.8.0;

// Begin a new contract
contract TodoList {
  // In a contract, you may hold a state in the blockchain.
  uint public taskCount = 0; // uint means an unsigned number (no negative values)

  // The blockchain can store many items.
  // Define the data structure of each item.
  struct Task {
    uint id;
    string content;
    bool completed;
  }

  // Define a map (like a linked list) of items.
  // It allows you to add and retrieve items.
  mapping(uint => Task) public tasks;

  // Define a constructor. It runs upon deployment to the blockchain.
  constructor() {
    createTask("A new default task");
  }

  // Define a function that will allow you to update the state and the map of items.
  function createTask(string memory _content) public {
    taskCount++; // Increase the count of tasks

    uint taskId = taskCount; // Use the new count of tasks to be the taskId
    bool isCompleted = false; // By default, a new task is not completed

    tasks[taskId] = Task(taskId, _content, isCompleted); // Add a new task
  }
}
```

## 4. Write a migration

A migration updates the state in the blockchain. Add `2_deploy_contracts.js` into the `migrations` folder. Each migration is numbered so that Truffle knows the order of deployments to run.

```javascript
// Create an artifact from the contract
const TodoList = artifacts.require("./TodoList.sol");

module.exports = function (deployer) {
  deployer.deploy(TodoList);
};
```

## 5. Compile and deploy

```bash
truffle compile
truffle migrate
```

Note that each deployment will incur a bit of ETH gas fee. You can see this list of transactions in Ganache.

## 6. Check the items in the blockchain

```bash
truffle console

todoList = await TodoList.deployed()

todoList.address
>> '0x8b7F8be2438564Ae4597590834959419a2cCB2f8' # the smart contract address

task = await todoList.tasks(1) # first item in tasks
task.id.toNumber()
>> 1
task.content
>> 'A new default task'
task.completed
>> false

taskCount = await todoList.taskCount()
taskCount.toNumber() # number of tasks as kept in the state
>> 1

```
