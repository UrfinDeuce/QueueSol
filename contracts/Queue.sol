// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

contract Queue {
    struct Node {
        uint256 val;
        uint256 next;
        uint256 prev;
    }

    uint256 private _nextId;
    uint256 private _length;

    mapping(uint256 => Node) private _nodes;

    constructor() {
        _nextId = 1;
    }

    function push(uint256 val) external {
        Node storage head = _nodes[0];
        Node storage newNode = _nodes[_nextId];
        newNode.val = val;

        newNode.prev = head.prev;
        newNode.next = 0;
        _nodes[head.prev].next = _nextId;
        head.prev = _nextId;

        _nextId++;
        _length++;
    }

    function pop() external {
        require(_length > 0, "Queue: queue is empty");

        Node storage head = _nodes[0];
        Node memory firstNode = _nodes[head.next];

        uint256 toDelete = head.next;

        _nodes[firstNode.next].prev = 0;
        head.next = firstNode.next;

        delete _nodes[toDelete];

        _length--;
    }

    function getFirst() external view returns (Node memory) {
        return _nodes[_nodes[0].next];
    }

    function getLast() external view returns (Node memory) {
        return _nodes[_nodes[0].prev];
    }

    function getHead() external view returns (Node memory) {
        return _nodes[0];
    }

    function getByIndex(uint256 index) external view returns (Node memory) {
        return _nodes[index];
    }

    function getValues() external view returns (uint256[] memory values) {
        values = new uint256[](_length);
        uint256 nextNode = _nodes[0].next;
        for (uint256 i = 0; i < _length; i++) {
            values[i] = _nodes[nextNode].val;
            nextNode = _nodes[nextNode].next;
        }
    }
}
