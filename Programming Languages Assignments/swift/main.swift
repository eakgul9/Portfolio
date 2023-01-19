import Foundation

// First check ensures you defined your own struct NegativeAmountError.
// If you implement your solution correctly, you will get a warning 
// when you compile, that's ok!
assert(change(200) is Result<(Int, Int, Int, Int), NegativeAmountError>)
switch change(250) {
    case .success(let coins): assert(coins == (10, 0, 0, 0))
    case _: assert(false)
}
switch change(-50) {
    case .success(_): assert(false)
    case .failure(let error): assert(error is NegativeAmountError)
}
assert(try! change(0).get() == (0, 0, 0, 0))
assert(try! change(97).get() == (3, 2, 0, 2))
assert(try! change(8).get() == (0, 0, 1, 3))
assert(try! change(144).get() == (5, 1, 1, 4))
assert(try! change(97).get() == (3, 2, 0, 2))
assert(try! change(100000000000).get() == (4000000000, 0, 0, 0))
assert((try? change(-50).get()) == nil)

assert("".stretched == "")
assert("  ".stretched == "")
assert("  \t\n  \t".stretched == "")
assert("  Hi  hi  ".stretched == "Hiihhhiiii")
assert("😁😂😱".stretched == "😁😂😂😱😱😱")
assert("hello world".stretched ==
    "heelllllllooooowwwwwwooooooorrrrrrrrllllllllldddddddddd")
assert("😁👩🏽‍🎤🧑🏻‍🔧".stretched == "😁👩🏽‍🎤👩🏽‍🎤🧑🏻‍🔧🧑🏻‍🔧🧑🏻‍🔧")

assert([].mapThenUnique { Int($0) * $0 } == Set([]))
assert([2, 9, -9, 3].mapThenUnique { Int($0) * $0 } == Set([4, 9, 81]))
assert(["abc", "Hi", "AbC"].mapThenUnique { $0.lowercased() } == Set(["hi", "abc"]))
assert(["33", "21", "33"].mapThenUnique { Int($0) } == Set([21, 33]))

var scratch = [Int]()
powers(of: 2, through: 64) { scratch.append($0) }
assert(scratch == [1, 2, 4, 8, 16, 32, 64])
scratch.removeAll()
powers(of: 2, through: 63) { scratch.append($0) }
assert(scratch == [1, 2, 4, 8, 16, 32])
scratch.removeAll()
powers(of: -3, through: 300) { scratch.append($0) }
assert(scratch == [1, -3, 9, -27, 81, -243])

let h: Animal = Horse(name: "CJ")
assert(h.speak() == "CJ says neigh")
let c: Animal = Cow(name: "Bessie")
assert(c.speak() == "Bessie says moooo")
assert(Sheep(name: "Little Lamb").speak() == "Little Lamb says baaaa")

// Test that Animal really is a protocol with the default method
struct Rat: Animal {
    let name: String
    let sound = "squeak"
}
assert(Rat(name:"Oreo").speak() == "Oreo says squeak")

assert(say("A").phrase == "A")
assert(say("A").and("B").phrase == "A B")
assert(say("🐤🦇").and("$🦊👏🏽").and("!").phrase == "🐤🦇 $🦊👏🏽 !")
var greet = say("Hello").and("there")
assert(greet.and("nice").and("person").phrase == "Hello there nice person")
assert(greet.and("Swift").phrase == "Hello there Swift")

assert(twice({$0 * 2}, appliedTo: 5.0) == 20.0)
assert(twice({s in s + "ee"}, appliedTo: "b") == "beeee")

assert(uppercasedFirst(of: [], longerThan: 5) == nil)
assert(uppercasedFirst(of: ["🎃"], longerThan: 1) == nil)
assert(uppercasedFirst(of: ["a", "bcdef"], longerThan: 5) == nil)
assert(uppercasedFirst(of: ["a", "abcdef", "g"], longerThan: 5) == Optional.some("ABCDEF"))
assert(uppercasedFirst(of: ["ab", "abcf"], longerThan: 1) == Optional.some("AB"))

let q = Quaternion(a: 3.5, b: 2.25, c: -100, d: -1.25)
assert(q.a == 3.5)
assert(q.b == 2.25)
assert(q.c == -100.0)
assert(q.d == -1.25)
let q1 = Quaternion(a: 1, b: 3, c: 5, d: 2)
let q2 = Quaternion(a: -2, b: 2, c: 8, d: -1)
let q3 = Quaternion(a: -1, b: 5, c: 13, d: 1)
let q4 = Quaternion(a: -46, b: -25, c: 5, d: 9)
assert(q1 + q2 == q3)
assert(q3 - q2 == q1)
assert(q1 * q2 == q4)
assert(Quaternion.I * Quaternion.J == Quaternion.K)
assert(Quaternion.ZERO.coefficients == [0, 0, 0, 0])
assert(Quaternion.K.coefficients == [0, 0, 0, 1])
assert(Quaternion(a: 2, b: 1.5, c: 10, d: -8).coefficients ==
    [2.0, 1.5, 10.0, -8.0])
assert(String(describing: Quaternion.ZERO) ==
    "0.0+0.0i+0.0j+0.0k")
assert(String(describing: Quaternion(a: 0, b: -1, c:  0, d: 2.25)) ==
    "0.0-1.0i+0.0j+2.25k")
assert(String(describing: Quaternion.ZERO - Quaternion.K) ==
    "0.0+0.0i+0.0j-1.0k")
assert(String(describing: Quaternion(a: -20, b: -1.75, c: 13, d: -2.25)) ==
    "-20.0-1.75i+13.0j-2.25k")

print("All tests passed")