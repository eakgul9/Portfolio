import { deepEqual, throws } from "node:assert/strict";
import {
  change,
  stretched,
  say,
  powers,
  powersGenerator,
  makeCryptoFunctions,
  topTenScorers,
  pokemonInfo,
  Quaternion,
} from "../src/exercises.js";

describe("The change function", () => {
  it("works for 0", () => {
    deepEqual(change(0), [0, 0, 0, 0]);
  });
  it("throws on negative", () => {
    throws(() => change(-50), /RangeError/);
  });
  it("works for the usual cases", () => {
    deepEqual(change(1), [0, 0, 0, 1]);
    deepEqual(change(99), [3, 2, 0, 4]);
    deepEqual(change(42), [1, 1, 1, 2]);
  });
  it("works for fractions of cents", () => {
    deepEqual(change(33.375), [1, 0, 1, 3.375]);
  });
  it("can handle really big values", () => {
    deepEqual(change(100000000037), [4000000001, 1, 0, 2]);
    deepEqual(change(10000000000005), [400000000000, 0, 1, 0]);
  });
});

describe("The stretched function", () => {
  it("stretches okay", () => {
    deepEqual(stretched(""), "");
    deepEqual(stretched("dog house"), "dooggghhhhooooouuuuuussssssseeeeeeee");
    deepEqual(stretched("a        π§"), "aππ§§§");
    deepEqual(stretched("😄🤗 💀"), "😄🤗🤗💀💀💀");
  });
});

describe("The world-famous say function", () => {
  it("works when there are no words", () => {
    deepEqual(say(), "");
  });

  it("works when there are words", () => {
    deepEqual(say("hi")(), "hi");
    deepEqual(say("hi")("there")(), "hi there");
    deepEqual(
      say("hello")("my")("name")("is")("Colette")(),
      "hello my name is Colette"
    );
  });

  it("handles spaces and empty words", () => {
    deepEqual(say("h i")(), "h i");
    deepEqual(say("hi ")("   there")(), "hi     there");
    deepEqual(say("")("")("dog")("")("go")(), "  dog  go");
  });

  it("handles emojis", () => {
    deepEqual(say("😄🤗")("💀👊🏾")(), "😄🤗 💀👊🏾");
  });
});

describe("The powers function", () => {
  it("works as expected", () => {
    const a = [];
    powers(2, 1, (x) => a.push(x));
    deepEqual(a, [1]);
    powers(-3, 81, (x) => a.push(x));
    deepEqual(a, [1, 1, -3, 9, -27, 81, -243]);
  });
});

describe("The powers generator", () => {
  it("works as expected", () => {
    const g1 = powersGenerator(2, 1);
    deepEqual(g1.next(), { value: 1, done: false });
    deepEqual(g1.next(), { value: undefined, done: true });
    const g2 = powersGenerator(3, 100);
    deepEqual(g2.next(), { value: 1, done: false });
    deepEqual(g2.next(), { value: 3, done: false });
    deepEqual(g2.next(), { value: 9, done: false });
    deepEqual(g2.next(), { value: 27, done: false });
    deepEqual(g2.next(), { value: 81, done: false });
    deepEqual(g2.next(), { value: undefined, done: true });
    deepEqual([...powersGenerator(3, 27)], [1, 3, 9, 27]);
  });
});

describe("The crypto function generator", () => {
  it("works as expected", () => {
    const [e, d] = makeCryptoFunctions({
      forKey: "1jdiekcns783uejdhasdfhcewp90x1sm",
      using: "aes-256-cbc",
      withIV: "m3987dhcbxgs452w",
    });
    deepEqual(
      e("Where is the good stuff?"),
      "a9f51b9f63d4512456d2dcc19333b0e495b90d6846acf37363dc55f57fad4127"
    );
    deepEqual(
      d("a9f51b9f63d4512456d2dcc19333b0e495b90d6846acf37363dc55f57fad4127"),
      "Where is the good stuff?"
    );
  });
});

describe("The topTenScorers function", () => {
  it("handles an empty object", () => {
    deepEqual(topTenScorers({}), []);
  });
  it("handles a small data set", () => {
    let input = { T1: [["A", 3, 300]] };
    let expected = [];
    deepEqual(topTenScorers(input), expected);
    input = { T1: [["A", 30, 300]] };
    expected = [{ name: "A", ppg: 10, team: "T1" }];
    deepEqual(topTenScorers(input), expected);
  });
  it("handles a larger data set", () => {
    let input = {
      ATL: [
        ["Betnijah Laney", 16, 263],
        ["Courtney Williams", 14, 193],
      ],
      CHI: [
        ["Kahleah Copper", 17, 267],
        ["Allie Quigley", 17, 260],
        ["Courtney Vandersloot", 17, 225],
      ],
      CONN: [
        ["DeWanna Bonner", 16, 285],
        ["Alyssa Thomas", 16, 241],
      ],
      DAL: [
        ["Arike Ogunbowale", 16, 352],
        ["Satou Sabally", 12, 153],
      ],
      IND: [
        ["Kelsey Mitchell", 16, 280],
        ["Tiffany Mitchell", 13, 172],
        ["Candice Dupree", 16, 202],
      ],
      LA: [
        ["Nneka Ogwumike", 14, 172],
        ["Chelsea Gray", 16, 224],
        ["Candace Parker", 16, 211],
      ],
      LV: [
        ["A’ja Wilson", 15, 304],
        ["Dearica Hamby", 15, 188],
        ["Angel McCoughtry", 15, 220],
      ],
      MIN: [
        ["Napheesa Collier", 16, 262],
        ["Crystal Dangerfield", 16, 254],
      ],
      NY: [["Layshia Clarendon", 15, 188]],
      PHX: [
        ["Diana Taurasi", 13, 236],
        ["Brittney Griner", 12, 212],
        ["Skylar Diggins-Smith", 16, 261],
        ["Bria Hartley", 13, 190],
      ],
      SEA: [
        ["Breanna Stewart", 16, 317],
        ["Jewell Loyd", 16, 223],
      ],
      WSH: [
        ["Emma Meesseman", 13, 158],
        ["Ariel Atkins", 15, 212],
        ["Myisha Hines-Allen", 15, 236],
      ],
    };
    let expected = [
      { name: "Arike Ogunbowale", ppg: 22, team: "DAL" },
      { name: "A’ja Wilson", ppg: 20.266666666666666, team: "LV" },
      { name: "Breanna Stewart", ppg: 19.8125, team: "SEA" },
      { name: "DeWanna Bonner", ppg: 17.8125, team: "CONN" },
      { name: "Kelsey Mitchell", ppg: 17.5, team: "IND" },
      { name: "Betnijah Laney", ppg: 16.4375, team: "ATL" },
      { name: "Napheesa Collier", ppg: 16.375, team: "MIN" },
      { name: "Skylar Diggins-Smith", ppg: 16.3125, team: "PHX" },
      { name: "Crystal Dangerfield", ppg: 15.875, team: "MIN" },
      { name: "Myisha Hines-Allen", ppg: 15.733333333333333, team: "WSH" },
    ];
    deepEqual(topTenScorers(input), expected);
  });
});

describe("The Pokemon API client", () => {
  it("works for snorlax", async () => {
    const data = await pokemonInfo("snorlax");
    deepEqual(data, { id: 143, name: "snorlax", weight: 4600 });
  });
  it("works for pikachu", async () => {
    const data = await pokemonInfo("pikachu");
    deepEqual(data, { id: 25, name: "pikachu", weight: 60 });
  });
});

describe("The Quaternion class", () => {
  it("can echo coefficients", () => {
    deepEqual(new Quaternion(8, 5, -3, 1).coefficients(), [8, 5, -3, 1]);
    deepEqual(new Quaternion(0, 0, 0, 0).coefficients(), [0, 0, 0, 0]);
  });
  it("adds correctly", () => {
    const q1 = new Quaternion(13, 21, -5, -21);
    const q2 = new Quaternion(2, -1, -55, 2.5);
    deepEqual(q1.plus(q2).coefficients(), [15, 20, -60, -18.5]);
  });
  it("multiples correctly", () => {
    const q1 = new Quaternion(3, -5, 1, -8);
    const q2 = new Quaternion(2, -13, -2, 3);
    deepEqual(q1.times(q2).coefficients(), [-33, -62, 115, 16]);
  });
});
