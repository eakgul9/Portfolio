#include <valarray>
#include <map>
#include <list>
#include <string>
#include <vector>
#include <algorithm>
#include "exercises.h"

using namespace std;

double dot(valarray<double> a, valarray<double> b) {
    return (a * b).sum();
}

vector<int> stretched_nonzeros(vector<int> v) {
    vector<int> filtered;
    v.erase(remove(begin(v), end(v), 0), end(v));
    for (auto index = 1; index <= v.size(); index++) {
        for (auto repeat = 0; repeat < index; repeat++) {
            filtered.push_back(v[index - 1]);
        }
    }
    return filtered;
}

void powers(int base, int limit, function<void(int)> consumer) {
    for (int power = 1; power <= limit; power *= base) {
        consumer(power);
    }
}

int IntStack::size() {
    int counter = 0;
    shared_ptr<Node> top_copy = top;
    while (top_copy != nullptr) {
        counter++;
        top_copy = top_copy->next;
    }
    return counter;
}

void IntStack::push(int item) {
    top = shared_ptr<Node>(new Node{item, top});
}

int IntStack::pop() {
    if (top == nullptr) {
        throw logic_error {"Your stack is empty."};
    }
    int popped_value = top->value;
    top = top->next;
    return popped_value;
}

string Sayer::operator()() {
    return words;
}

Sayer Sayer::operator()(string word) {
    if (words.empty()) {
        return Sayer{words + word};
    }
    return Sayer{ words + " " + word };
}
Sayer say;

vector<pair<string, int>> sorted_word_counts(list<string> words) {
    map<string, int> word_count;
    vector<pair<string, int>> word_pairs;
    for (string word : words) {
        word_count[word]++;
    }
    for (auto pair : word_count) {
        word_pairs.push_back(make_pair(pair.first, pair.second));
    }
    sort(word_pairs.begin(), word_pairs.end(), [](auto first_pair, auto second_pair) { 
        return first_pair.second > second_pair.second; 
    });
    return word_pairs;
}

Quaternion::Quaternion(double a, double b, double c, double d): a(a), b(b), c(c), d(d) {}

array<double, 4> Quaternion::coefficients() {
    return {a, b, c, d};
}

Quaternion Quaternion::operator+(const Quaternion& other) {
    return Quaternion{other.a + a, other.b + b, other.c + c, other.d + d};
}

Quaternion Quaternion::operator-(const Quaternion& other) {
    return Quaternion{a - other.a, b - other.b, c - other.c, d - other.d};
}

Quaternion Quaternion::operator*(const Quaternion& other) {
    return Quaternion{
        a * other.a - b * other.b - c * other.c - d * other.d,
        b * other.a + a * other.b + c * other.d - d * other.c,
        a * other.c - b * other.d + c * other.a + d * other.b,
        a * other.d + b * other.c - c * other.b + d * other.a};
}

bool Quaternion::operator==(const Quaternion& other) const {
    return a == other.a && b == other.b && c == other.c && d == other.d;
}

Quaternion Quaternion::ZERO = Quaternion{0, 0, 0, 0};
Quaternion Quaternion::I = Quaternion{0, 1, 0, 0};
Quaternion Quaternion::J = Quaternion{0, 0, 1, 0};
Quaternion Quaternion::K = Quaternion{0, 0, 0, 1};

ostream& operator<<(ostream& o, Quaternion q) {
    o << q.a;
    o << (q.b >= 0 ? "+" : "");
    o << q.b << "i";
    o << (q.c >= 0 ? "+" : "");
    o << q.c << "j";
    o << (q.d >= 0 ? "+" : "");
    o << q.d << "k";
    return o;
}