import { expect } from "chai";
import { QueueLib } from "../../typechain-types/QueueLibTest";

export function assertOrder(actual: QueueLib.OrderStructOutput, expected: QueueLib.OrderStruct) {
  expect(actual.id).to.equal(expected.id);
  expect(actual.user).to.equal(expected.user);
  expect(actual.sell).to.equal(expected.sell);
  expect(actual.amount).to.equal(expected.amount);
  expect(actual.timeout).to.equal(expected.timeout);
}
