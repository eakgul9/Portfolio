from asyncio import streams
from typing import Tuple
from dataclasses import dataclass 
from cryptography.fernet import Fernet

def change(cents: int) -> tuple:
    if type(cents) == float:
        raise TypeError("No fractional amounts allowed.")
    if cents < 0:
        raise ValueError("amount cannot be negative")
    else:
        quarter_value: int = 25
        dime_value: int = 10
        nickel_value: int = 5
        quarters: int = cents // quarter_value
        remainder: int = cents % quarter_value
        dimes: int = remainder // dime_value
        remainder %= dime_value
        nickels: int = remainder // nickel_value
        pennies: int = remainder % nickel_value
        return (quarters, dimes, nickels, pennies)


def stretched(word: str) -> str: 
    trimmed_word: str = word.replace(" ", "").replace("\n", "").replace("\t", "")
    repeat: int = 0
    word_chars: list = [char*(repeat:= repeat + 1) for char in trimmed_word]
    return "".join(word_chars)

def powers(*, base: int, limit: int):
    value = 1
    while value <= limit:
        yield value
        value *= base

def say(input = None) -> str:
    if input == None:
        return ""
    else:
        def chain_next_word(next_input = None) -> str:
            if (next_input == None):
                return input
            else:
                return say(input + " " + next_input)
        return chain_next_word

def find_first_then_lower(predicate, word_list: list) -> str:    
    for word in word_list:
        if predicate(word):
            return word.lower()
    raise ValueError("No value satisfies the property")

def top_ten_scorers(input: dict) -> list:
    players = [[player[0], "{:.2f}".format(player[2]/player[1]), key] for key in input.keys() for player in input[key] if player[1] >= 15]
    top_ten = sorted(players, key = lambda player: player[1], reverse=True)
    return ["|".join(top_ten_player) for top_ten_player in top_ten[0:10]]

def crypto_functions() -> tuple:
    key = Fernet.generate_key()
    fernet_key = Fernet(key)
    def encode(message):
        encoded = fernet_key.encrypt(message)
        return encoded
    def decode(message):
        decoded = fernet_key.decrypt(message)
        return decoded
    return (encode,decode)

@dataclass(frozen = True)
class Quaternion: 
    a: int
    b: int
    c: int
    d: int

    @property
    def coefficients(self):
        return self.a,self.b,self.c,self.d

    def __add__(self,q2):
        return Quaternion(self.a + q2.a, self.b + q2.b, self.c + q2.c, self.d + q2.d)

    def __mul__(self,q2):
        curA = self.a * q2.a - self.b * q2.b - self.c * q2.c - self.d * q2.d
        curB = self.b * q2.a + self.a * q2.b + self.c * q2.d - self.d * q2.c
        curC = self.a * q2.c - self.b * q2.d + self.c * q2.a + self.d * q2.b
        curD = self.a * q2.d + self.b * q2.c - self.c * q2.b + self.d * q2.a
        return Quaternion(curA, curB, curC, curD)