pragma solidity ^0.8.0;

contract TodoList {
  uint public taskCount = 0;

  struct Task {
    uint id;
    string content;
    bool completed;
  }

  mapping(uint => Task) public tasks;

  constructor() {
    createTask("A new default task");
  }

  function createTask(string memory _content) public {
    taskCount++;

    uint taskId = taskCount;
    bool isCompleted = false;

    tasks[taskId] = Task(taskId, _content, isCompleted);
  }
}
