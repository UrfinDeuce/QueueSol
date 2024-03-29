// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

library QueueLib {
    struct Order {
        uint256 id;
        address user;
        address sell;
        uint256 amount;
        uint256 timeout;
    }

    struct Node {
        Order order;
        uint256 next;
        uint256 prev;
    }

    struct Queue {
        uint256 nextId;
        uint256 length;
        mapping(uint256 => Node) nodes;
    }

    function push(Queue storage self, Order calldata order_) internal {
        Node storage head = self.nodes[0];
        Node storage newNode = self.nodes[self.nextId];
        newNode.order = order_;
        newNode.order.id = self.nextId;

        newNode.prev = head.prev;
        newNode.next = 0;
        self.nodes[head.prev].next = self.nextId;
        head.prev = self.nextId;

        self.nextId++;
        self.length++;
    }

    function pop(Queue storage self) internal {
        require(self.length > 0, "Queue: queue is empty");

        uint256 toDeleteIndex = self.nodes[0].next;
        Node memory firstNode = self.nodes[toDeleteIndex];

        self.nodes[firstNode.next].prev = 0;
        self.nodes[0].next = firstNode.next;

        delete self.nodes[toDeleteIndex];

        self.length--;
    }

    function del(Queue storage self, uint256 index) internal {
        require(self.length > 0, "Queue: queue is empty");

        Node memory toDeleteNode = self.nodes[index];
        self.nodes[toDeleteNode.next].prev = toDeleteNode.prev;
        self.nodes[toDeleteNode.prev].next = toDeleteNode.next;

        delete self.nodes[index];

        self.length--;
    }

    function getFirst(Queue storage self) internal view returns (Order memory) {
        return self.nodes[self.nodes[0].next].order;
    }

    function getLast(Queue storage self) internal view returns (Order memory) {
        return self.nodes[self.nodes[0].prev].order;
    }

    function getByIndex(Queue storage self, uint256 index) internal view returns (Order memory) {
        return self.nodes[index].order;
    }

    function getLastId(Queue storage self) internal view returns (uint256) {
        return self.nextId - 1;
    }

    function getHead(Queue storage self) internal view returns (Node memory) {
        return self.nodes[0];
    }

    function getOrders(Queue storage self) internal view returns (Order[] memory orders) {
        orders = new Order[](self.length);
        uint256 nextNode = self.nodes[0].next;
        for (uint256 i = 0; i < self.length; i++) {
            orders[i] = self.nodes[nextNode].order;
            nextNode = self.nodes[nextNode].next;
        }
    }
}
