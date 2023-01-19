from dataclasses import FrozenInstanceError
import re
import math
import pytest
from exercises import (
    change, stretched, powers, say, find_first_then_lower,
    top_ten_scorers, crypto_functions, Quaternion)


def test_change():
    assert change(0) == (0, 0, 0, 0)
    assert change(97) == (3, 2, 0, 2)
    assert change(8) == (0, 0, 1, 3)
    assert change(250) == (10, 0, 0, 0)
    assert change(144) == (5, 1, 1, 4)
    assert change(97) == (3, 2, 0, 2)
    assert change(100000000000) == (4000000000, 0, 0, 0)
    with pytest.raises(TypeError) as excinfo:
        # No fractional amounts allowed
        change(988.25)
    with pytest.raises(TypeError) as excinfo:
        # Do type check before negative check
        change(-988.25)
    with pytest.raises(ValueError) as excinfo:
        change(-50)
    assert str(excinfo.value) == 'amount cannot be negative'


def test_stretched():
    assert stretched('') == ''
    assert stretched('H e   l\t\tlo') == 'Heelllllllooooo'
    assert stretched('$#') == '$##'
    assert stretched('       ') == ''
    assert stretched('A = πr²') == 'A==πππrrrr²²²²²'
    assert stretched("  ") == ""
    assert stretched("  \t\n  \t") == ""
    assert stretched("  Hi  hi  ") == "Hiihhhiiii"
    assert stretched("😁😂😱") == "😁😂😂😱😱😱"
    assert stretched("hello world") == "heelllllllooooowwwwwwooooooorrrrrrrrllllllllldddddddddd"
    with pytest.raises(TypeError):
        # Test that the argument MUST be a positional argument
        stretched(s = '')


def test_powers():
    p = powers(base=2, limit=10)
    assert next(p) == 1
    assert next(p) == 2
    assert next(p) == 4
    assert next(p) == 8
    with pytest.raises(StopIteration):
        next(p)
    assert list(powers(base=2, limit=-5)) == []
    assert list(powers(base=7, limit=0)) == []
    assert list(powers(limit=1, base=3)) == [1]
    assert list(powers(base=2, limit=63)) == [1, 2, 4, 8, 16, 32]
    assert list(powers(base=2, limit=64)) == [1, 2, 4, 8, 16, 32, 64]
    with pytest.raises(TypeError):
        # Test that the arguments MUST be keyword arguments
        powers(2, 100)


def test_say():
    assert say() == ''
    assert say('hi')() == 'hi'
    assert say('hi')('there')() == 'hi there'
    assert say('hello')('my')('name')('is')(
        'Colette')() == 'hello my name is Colette'
    with pytest.raises(TypeError):
        # Test that the argument MUST be a positional argument
        say(s = '')


def test_find_first_then_lower_case():
    with pytest.raises(ValueError):
        find_first_then_lower(lambda s: len(s) > 10, [])
    with pytest.raises(ValueError):
        find_first_then_lower(lambda s: len(s) > 5, ["hello", "world"])
    assert find_first_then_lower(lambda s: s.startswith("HELL"), ["HELLO", "WORLD"]) == "hello"
    assert find_first_then_lower(lambda s: "d!" in s, ["Hello", "World!!"]) == "world!!"


def test_top_ten_scorers():
    assert top_ten_scorers({}) == []
    assert top_ten_scorers({'T1': [['A', 3, 300]]}) == []
    assert top_ten_scorers({'T1': [['A', 30, 300]]}) == ['A|10.00|T1']
    input = {
        'ATL': [
            ['Betnijah Laney', 16, 263],
            ['Courtney Williams', 14, 193]],
        'CHI': [
            ['Kahleah Copper', 17, 267],
            ['Allie Quigley', 17, 260],
            ['Courtney Vandersloot', 17, 225]],
        'CONN': [
            ['DeWanna Bonner', 16, 285],
            ['Alyssa Thomas', 16, 241]],
        'DAL': [
            ['Arike Ogunbowale', 16, 352],
            ['Satou Sabally', 12, 153]],
        'IND': [
            ['Kelsey Mitchell', 16, 280],
            ['Tiffany Mitchell', 13, 172],
            ['Candice Dupree', 16, 202]],
        'LA': [
            ['Nneka Ogwumike', 14, 172],
            ['Chelsea Gray', 16, 224],
            ['Candace Parker', 16, 211]],
        'LV': [
            ['A’ja Wilson', 15, 304],
            ['Dearica Hamby', 15, 188],
            ['Angel McCoughtry', 15, 220]],
        'MIN': [
            ['Napheesa Collier', 16, 262],
            ['Crystal Dangerfield', 16, 254]],
        'NY': [
            ['Layshia Clarendon', 15, 188]],
        'PHX': [
            ['Diana Taurasi', 13, 236],
            ['Brittney Griner', 12, 212],
            ['Skylar Diggins-Smith', 16, 261],
            ['Bria Hartley', 13, 190]],
        'SEA': [
            ['Breanna Stewart', 16, 317],
            ['Jewell Loyd', 16, 223]],
        'WSH': [
            ['Emma Meesseman', 13, 158],
            ['Ariel Atkins', 15, 212],
            ['Myisha Hines-Allen', 15, 236]]}
    expected = [
        "Arike Ogunbowale|22.00|DAL",
        "A’ja Wilson|20.27|LV",
        "Breanna Stewart|19.81|SEA",
        "DeWanna Bonner|17.81|CONN",
        "Kelsey Mitchell|17.50|IND",
        "Betnijah Laney|16.44|ATL",
        "Napheesa Collier|16.38|MIN",
        "Skylar Diggins-Smith|16.31|PHX",
        "Crystal Dangerfield|15.88|MIN",
        "Myisha Hines-Allen|15.73|WSH"
    ]
    assert top_ten_scorers(input) == expected


def test_crypto_functions():
    encode, decode = crypto_functions()
    for message in (b'', b'abc', bytes('😜😍😞🦾👀', 'utf-8')):
        assert(decode(encode(message))) == message


def test_quaternions():
    q1 = Quaternion(1, -2, 5, 0)
    q2 = Quaternion(3, 0, 5, -2)
    assert (q1 + q2).coefficients == (4, -2, 10, -2)
    assert (q1 * q2).coefficients == (-22, -16, 16, -12)
    with pytest.raises(FrozenInstanceError):
        # Test immutability
        q2.a = 100