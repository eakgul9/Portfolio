#include <cassert>
#include <sstream>
#include "exercises.h"

int main() {
  valarray<double> a = {3, 3, 1};
  valarray<double> b = {8, 3, -2};
  valarray<double> c = {1, -1, 10, 3};
  assert(dot(a, b) == 31);
  assert(dot(a, c) == 10);
  assert(dot(b, b) == 77);

  assert(stretched_nonzeros(vector<int>()) == vector<int>());
  assert(stretched_nonzeros(vector{0, 0, 0}) == vector<int>());
  assert(stretched_nonzeros(vector {100}) == (vector {100}));
  assert(stretched_nonzeros(vector {0, 0, 3, 5, 0, 2}) == (vector {3, 5, 5, 2, 2, 2}));

  vector<int> scratch;
  powers(2, 64, [&](int power){scratch.push_back(power);});
  assert(scratch == (vector {1, 2, 4, 8, 16, 32, 64}));
  scratch.clear();
  powers(2, 63, [&](int power){scratch.push_back(power);});
  assert(scratch == (vector {1, 2, 4, 8, 16, 32}));
  scratch.clear();
  powers(-3, 300, [&](int power){scratch.push_back(power);});
  assert(scratch == (vector {1, -3, 9, -27, 81, -243}));

  IntStack s;
  assert(s.size() == 0);
  s.push(13);
  s.push(1);
  s.push(8);
  assert(s.size() == 3);
  assert(s.pop() == 8);
  assert(s.size() == 2);
  assert(s.pop() == 1);
  assert(s.pop() == 13);
  assert(s.size() == 0);
  try {
    s.pop();
    assert(false);
  } catch (logic_error e) {
    assert(true);
  }

  assert(say("A")() == "A");
  assert(say("A")("B")() == "A B");
  assert(say("🐤🦇")("$🦊👏🏽")("!")() == "🐤🦇 $🦊👏🏽 !");
  auto greet = say("Hello")("there");
  assert(greet("nice")("person")() == "Hello there nice person");
  assert(greet("C++")() == "Hello there C++");

  vector<pair<list<string>, vector<pair<string, int>>>> fixture = {
    {{}, {}},
    {{"one"}, {{"one", 1}}},
    {{"a", "b", "b", "b"}, {{"b", 3}, {"a", 1}}}};
  for (auto [words, counts] : fixture) {
    assert(sorted_word_counts(words) == counts);
  }

  Quaternion q(3.5, 2.25, -100, -1.25);
  assert(q.a == 3.5);
  assert(q.b == 2.25);
  assert(q.c == -100.0);
  assert(q.d == -1.25);
  Quaternion q1 = Quaternion(1, 3, 5, 2);
  Quaternion q2 = Quaternion(-2, 2, 8, -1);
  Quaternion q3 = Quaternion(-1, 5, 13, 1);
  Quaternion q4 = Quaternion(-46, -25, 5, 9);
  assert(q1 + q2 == q3);
  assert(q3 - q2 == q1);
  assert(q1 * q2 == q4);
  assert(Quaternion::I * Quaternion::J == Quaternion::K);
  array<double, 4> zeros = { 0, 0, 0, 0 };
  assert(Quaternion::ZERO.coefficients() == zeros);
  array<double, 4> k_coefficients = { 0, 0, 0, 1 };
  assert(Quaternion::K.coefficients() == k_coefficients);
  array<double, 4> arbitrary_coefficients = { 2.0, 1.5, 10.0, -8.0 };
  assert(Quaternion(2, 1.5, 10, -8).coefficients() == arbitrary_coefficients);
  ostringstream stream;
  stream << Quaternion::ZERO;
  assert(stream.str() == "0+0i+0j+0k");
  stream = ostringstream();
  stream << Quaternion(0, -1,  0, 2.25);
  assert(stream.str() == "0-1i+0j+2.25k");
  stream = ostringstream();
  stream << Quaternion::ZERO - Quaternion::K;
  assert(stream.str() == "0+0i+0j-1k");
  stream = ostringstream();
  stream << Quaternion(-20, -1.75, 13, -2.25);
  assert(stream.str() == "-20-1.75i+13j-2.25k");

  cout << "All tests passed\n";
}