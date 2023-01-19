// Problem 1
func change(_ cents: Int) -> Result<(Int, Int, Int, Int), NegativeAmountError>  {
  if cents < 0 {
    return .failure(.negative)
  }
  let (quarterValue, dimeValue, nickelValue) = (25, 10, 5)
  var dimes: Int
  var nickels: Int
  var pennies: Int
  var quarters: Int
  var coinsLeft: Int
  (quarters, coinsLeft) = cents.quotientAndRemainder(dividingBy: quarterValue)
  (dimes, coinsLeft) = coinsLeft.quotientAndRemainder(dividingBy: dimeValue)
  (nickels, pennies) = coinsLeft.quotientAndRemainder(dividingBy: nickelValue)
  return .success((quarters,dimes,nickels,pennies))
}

enum NegativeAmountError: Error {
  case negative
}

// Problem 2
extension String {
  var stretched: String { 
    get {
      var word = self
      word.removeAll(where: {["\t", "\n", " "].contains($0)})
      var counter: Int = 1
      var stretchedWord: String = ""
      for character in word {
        let repeated = String(repeating: character, count: counter)
        stretchedWord += repeated
        counter += 1
      }
      return stretchedWord
    }
  }
}

// Problem 3
extension Array {
  func mapThenUnique<T> (closure: (Element) -> T) -> Set<T> {
    return Set(self.map(closure))
  }
}

// Problem 4
func powers(of base: Int, through limit: Int, _ consumer: (Int) -> Void) -> Void {
  var currentPower = 1
  while currentPower <= limit {
    consumer(currentPower)
    currentPower *= base
  }
}

// Problem 5
protocol Animal {
  var name: String {get}
  var sound: String {get}
}

extension Animal {
  func speak() -> String {
    return "\(self.name) says \(self.sound)"
  }
}

struct Cow: Animal {
  let name: String
  let sound = "moooo"
}

struct Horse: Animal {
  let name: String
  let sound = "neigh"
  let gallop = "galloping woohoo"
}

struct Sheep: Animal {
  let name: String
  let sound = "baaaa"
}

// Problem 6
func say(_ input: String) -> Sayanator {
  return Sayanator(input: input)
}

struct Sayanator {
  var input: String
  
  func and(_ nextInput: String) -> Sayanator {
    return Sayanator(input: self.input + " " + nextInput)
  }
  
  var phrase: String {
    get {return input}
  }
}

// Problem 7
func twice<T>(_ f: (T) -> T, appliedTo x: T) -> T {
  return f(f(x))
}

// Problem 8
func uppercasedFirst(of input: [String], longerThan: Int) -> String? {
  return input.first(where: {$0.count > longerThan})?.uppercased()
}

// Problem 9
struct Quaternion: CustomStringConvertible {
  // Properties
  let a: Float
  let b: Float
  let c: Float
  let d: Float
  var description: String {
    return "\(a)+\(b)i+\(c)j+\(d)k".replacingOccurrences(of: "+-", with: "-")
  }
  var coefficients: Array<Float> {
    return[a,b,c,d]
  }
  static let ZERO: Quaternion = Quaternion(a: 0, b:0, c:0, d:0)
  static let I: Quaternion = Quaternion(a: 0, b:1, c:0, d:0)
  static let J: Quaternion = Quaternion(a: 0, b:0, c:1, d:0)
  static let K: Quaternion = Quaternion(a: 0, b:0, c:0, d:1)
}
func + (left: Quaternion, right: Quaternion) -> Quaternion {
    return Quaternion(a: left.a + right.a, b: left.b + right.b, c: left.c + right.c, d: left.d + right.d)
}
func - (left: Quaternion, right: Quaternion) -> Quaternion {
    return Quaternion(a: left.a - right.a, b: left.b - right.b, c: left.c - right.c, d: left.d - right.d)
}
func * (left: Quaternion, right: Quaternion) -> Quaternion {
  let curA = left.a * right.a - left.b * right.b - left.c * right.c - left.d * right.d
  let curB = left.b * right.a + left.a * right.b + left.c * right.d - left.d * right.c
  let curC = left.a * right.c - left.b * right.d + left.c * right.a + left.d * right.b
  let curD = left.a * right.d + left.b * right.c - left.c * right.b + left.d * right.a
  return Quaternion(a: curA, b: curB, c: curC, d: curD)
}
func == (left: Quaternion, right: Quaternion) -> Bool {
  return left.a == right.a && left.b == right.b && left.c == right.c && left.d == right.d
}
