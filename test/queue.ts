import { expect } from "chai";
import { ethers } from "hardhat";
import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";

describe("Queue unit tests", function () {
  async function deployFixture() {
    const [deployer] = await ethers.getSigners();

    const q = await ethers.deployContract("Queue");
    await q.waitForDeployment();
    return { q };
  }

  describe("Push", function () {
    it("Should push new values", async function () {
      const { q } = await loadFixture(deployFixture);

      const expected: number[] = [];
      for (let i = 1; i <= 100; i++) {
        await q.push(i * 10);
        expected.push(i * 10);
      }
      const values = await q.getValues();
      expect(values).to.deep.equal(expected);

      //   console.log(values);
    });
  });

  describe("Pop", function () {
    it("Should pop value", async function () {
      const { q } = await loadFixture(deployFixture);

      for (let i = 1; i <= 10; i++) {
        await q.push(i * 10);
      }

      await q.pop();

      let values = await q.getValues();
      expect(values).to.deep.equal([20n, 30n, 40n, 50n, 60n, 70n, 80n, 90n, 100n]);

      console.log(values);

      await q.pop();

      values = await q.getValues();

      expect(values).to.deep.equal([30n, 40n, 50n, 60n, 70n, 80n, 90n, 100n]);

      console.log(values);
      await q.pop();

      values = await q.getValues();
      expect(values).to.deep.equal([40n, 50n, 60n, 70n, 80n, 90n, 100n]);

      console.log(values);
    });
  });
});
