// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import { QueueLib } from "./QueueLib.sol";

contract QueueLibTest {
    using QueueLib for QueueLib.Queue;

    QueueLib.Queue private queue;

    constructor() {
        queue.nextId = 1;
    }

    function push(QueueLib.Order calldata order_) external {
        queue.push(order_);
    }

    function pop() external {
        queue.pop();
    }

    function del(uint256 index) external {
        queue.del(index);
    }

    function getFirst() external view returns (QueueLib.Order memory) {
        return queue.getFirst();
    }

    function getLast() external view returns (QueueLib.Order memory) {
        return queue.getLast();
    }

    function getByIndex(uint256 index) external view returns (QueueLib.Order memory) {
        return queue.getByIndex(index);
    }

    function getLastId() internal view returns (uint256) {
        return queue.getLastId();
    }

    function getHead() external view returns (QueueLib.Node memory) {
        return queue.getHead();
    }

    function getOrders() external view returns (QueueLib.Order[] memory orders) {
        return queue.getOrders();
    }
}
