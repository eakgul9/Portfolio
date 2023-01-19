#include <iostream>
#include <list>
#include <string>
#include <vector>
#include <array>
#include <valarray>
#include <iostream>

using namespace std;

double dot(valarray<double> a, valarray<double> b);

vector<int> stretched_nonzeros(vector<int> v);

void powers(int base, int limit, function<void(int)> consumer);

class IntStack {
  struct Node {
    int value;
    shared_ptr<Node> next;
  };
  shared_ptr<Node> top;
public:
  IntStack() {}
  IntStack(const IntStack&) = delete;
  IntStack& operator=(const IntStack&) = delete;
  int size();
  void push(int item);
  int pop();
};

struct Sayer {
  string words;
  string operator()();
  Sayer operator()(string word);
};
extern Sayer say;

vector<pair<string, int>> sorted_word_counts(list<string> words);

struct Quaternion {
  const double a;
  const double b;
  const double c;
  const double d;
  Quaternion(double a, double b, double c, double d);
  Quaternion& operator=(const Quaternion&) = delete;
  array<double, 4> coefficients();
  Quaternion operator+(const Quaternion& other);
  Quaternion operator-(const Quaternion& other);
  Quaternion operator*(const Quaternion& other);
  bool operator==(const Quaternion& other) const;
  static Quaternion ZERO;
  static Quaternion I;
  static Quaternion J;
  static Quaternion K;
  friend ostream& operator<<(ostream& o, Quaternion q);
};