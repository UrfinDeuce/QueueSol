import { expect } from "chai";
import { ethers } from "hardhat";
import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { assertOrder } from "./utils/assertions";

describe("Queue unit tests", function () {
  async function deployFixture() {
    const [deployer, user, token] = await ethers.getSigners();

    const q = await ethers.deployContract("QueueLibTest");
    await q.waitForDeployment();
    return { q, user, token };
  }

  describe("Push", function () {
    it("Should push new node", async function () {
      const { q, user, token } = await loadFixture(deployFixture);

      const expected = [];
      for (let i = 1n; i <= 100n; i++) {
        const order = { id: 0n, user: user.address, sell: token.address, amount: i * 10n, timeout: 1000n };

        await q.push(order);

        order.id = i;
        expected.push(order);
      }

      const orders = await q.getOrders();
      for (let i = 0; i < orders.length; i++) {
        assertOrder(orders[i], expected[i]);
      }
    });
  });

  describe("Pop", function () {
    it("Should pop node", async function () {
      const { q, user, token } = await loadFixture(deployFixture);

      const expected = [];
      for (let i = 1n; i <= 100n; i++) {
        const order = { id: 0n, user: user.address, sell: token.address, amount: i * 10n, timeout: 1000n };

        await q.push(order);

        order.id = i;
        expected.push(order);
      }

      let orders = await q.getOrders();
      for (let i = 0; i < orders.length; i++) {
        assertOrder(orders[i], expected[i]);
      }

      await q.pop();

      orders = await q.getOrders();
      for (let i = 0; i < orders.length; i++) {
        assertOrder(orders[i], expected[i + 1]);
      }

      await q.pop();

      orders = await q.getOrders();
      for (let i = 0; i < orders.length; i++) {
        assertOrder(orders[i], expected[i + 2]);
      }
    });
  });

  describe("Delete by index", function () {
    it("Should delete node with given index", async function () {
      const { q, user, token } = await loadFixture(deployFixture);

      const expected = [];
      for (let i = 1n; i <= 100n; i++) {
        const order = { id: 0n, user: user.address, sell: token.address, amount: i * 10n, timeout: 1000n };

        await q.push(order);

        order.id = i;
        expected.push(order);
      }

      let orders = await q.getOrders();
      for (let i = 0; i < orders.length; i++) {
        assertOrder(orders[i], expected[i]);
      }

      await q.del(50);

      orders = await q.getOrders();
      let k = 0;
      for (let i = 0; i < orders.length; i++) {
        if (i === 49) {
          k++;
        }
        assertOrder(orders[i], expected[i + k]);
      }

      await q.del(70);

      k = 0;

      orders = await q.getOrders();
      for (let i = 0; i < orders.length; i++) {
        if (i === 49 || i === 68) {
          k++;
        }
        assertOrder(orders[i], expected[i + k]);
      }
    });
  });
});
