import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertArrayEquals;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import java.util.Optional;
import java.util.function.*;

public class ExercisesTest {

    @Test
    public void testChange() {
        assertThrows(IllegalArgumentException.class, () -> Exercises.change(-20));
        assertEquals(List.of(0, 0, 0, 0), Exercises.change(0));
        assertEquals(List.of(0, 0, 0, 1), Exercises.change(1));
        assertEquals(List.of(0, 1, 0, 3), Exercises.change(13));
        assertEquals(List.of(2, 0, 0, 0), Exercises.change(50));
        assertEquals(List.of(0, 0, 1, 0), Exercises.change(5));
        assertEquals(List.of(15, 2, 0, 2), Exercises.change(397));
        assertEquals(List.of(1, 1, 1, 2), Exercises.change(42));
        assertEquals(List.of(40000000, 1, 1, 2), Exercises.change(1000000017));
    }


    @Test
    public void testStretched() {
        assertEquals("", Exercises.stretched(""));
        assertEquals("", Exercises.stretched("  "));
        assertEquals("", Exercises.stretched("  \t\n  \t"));
        assertEquals("Hiihhhiiii", Exercises.stretched("  Hi  hi  "));
        assertEquals("😁😂😂😱😱😱", Exercises.stretched("😁😂😱"));
        assertEquals(
                "heelllllllooooowwwwwwooooooorrrrrrrrllllllllldddddddddd",
                Exercises.stretched("hello world"));
    }

    @Test
    public void testPowersWithConsumer() {
        var a = new ArrayList<Integer>();
        IntConsumer addToList = i -> a.add(i);
        Exercises.powers(2, 1, addToList);
        assertEquals(List.of(1), a);
        Exercises.powers(-3, 81, addToList);
        assertEquals(List.of(1, 1, -3, 9, -27, 81, -243), a);
    }
    
    @Test
    public void testPowersStream() {
        assertArrayEquals(
                new int[] { 1, 1, 1, 1, 1 },
                Exercises.powers(1).limit(5).toArray());
        assertArrayEquals(Exercises.powers(7).limit(10).toArray(),
                new int[] { 1, 7, 49, 343, 2401, 16807, 117649, 823543,
                        5764801,
                        40353607 });
        assertArrayEquals(Exercises.powers(-3).limit(5).toArray(),
                new int[] { 1, -3, 9, -27, 81 });
        assertArrayEquals(Exercises.powers(10).limit(4).toArray(),
                new int[] { 1, 10, 100, 1000 });
    }

    @Test
    public void testSay() {
        assertEquals("A", Exercises.say("A").ok());
        assertEquals("", Exercises.say());
        assertEquals("A B", Exercises.say("A").and("B").ok());
        assertEquals("🐤🦇 $🦊👏🏽 !",
                Exercises.say("🐤🦇").and("$🦊👏🏽").and("!").ok());
    }

    @Test
    public void testFindFirstAndLowerCase() {
        assertEquals(Optional.empty(),
                Exercises.findFirstThenLower(s -> s.length() > 10,
                        List.of()));
        assertEquals(Optional.empty(),
                Exercises.findFirstThenLower(s -> s.length() > 5,
                        List.of("hello", "world")));
        assertEquals(Optional.of("hello"),
                Exercises.findFirstThenLower(s -> s.startsWith("HELL"),
                        List.of("HELLO", "WORLD")));
        assertEquals(Optional.of("world!!"),
                Exercises.findFirstThenLower(s -> s.contains("d!"),
                        List.of("Hello", "World!!")));
    }

    @Test
    public void testTopTenScorers() {
        assertEquals(List.of(), Exercises.topTenScorers(Map.of()));

        assertEquals(List.of("A|10.00|T1"),
                Exercises.topTenScorers(
                        Map.of("T1", List.of("A,30,300"))));

        var stats = new HashMap<String, List<String>>();
        stats.put("ATL", List.of(
                "Betnijah Laney,16,263", "Courtney Williams,14,193"));
        stats.put("CHI", List.of(
                "Kahleah Copper,17,267", "Allie Quigley,17,260",
                "Courtney Vandersloot,17,225"));
        stats.put("CONN", List.of(
                "DeWanna Bonner,16,285", "Alyssa Thomas,16,241"));
        stats.put("DAL", List.of(
                "Arike Ogunbowale,16,352", "Satou Sabally,12,153"));
        stats.put("IND", List.of(
                "Kelsey Mitchell,16,280", "Tiffany Mitchell,13,172",
                "Candice Dupree,16,202"));
        stats.put("LA", List.of(
                "Nneka Ogwumike,14,172", "Chelsea Gray,16,224",
                "Candace Parker,16,211"));
        stats.put("LV", List.of(
                "A’ja Wilson,15,304", "Dearica Hamby,15,188",
                "Angel McCoughtry,15,220"));
        stats.put("MIN", List.of(
                "Napheesa Collier,16,262", "Crystal Dangerfield,16,254"));
        stats.put("NY", List.of(
                "Layshia Clarendon,15,18"));
        stats.put("PHX", List.of(
                "Diana Taurasi,13,236", "Brittney Griner,12,212",
                "Skylar Diggins-Smith,16,261",
                "Bria Hartley,13,190"));
        stats.put("SEA", List.of(
                "Breanna Stewart,16,317", "Jewell Loyd,16,223"));
        stats.put("WSH", List.of(
                "Emma Meesseman,13,158", "Ariel Atkins,15,212",
                "Myisha Hines-Allen,15,236"));

        assertEquals(
                List.of(
                        "Arike Ogunbowale|22.00|DAL",
                        "A’ja Wilson|20.27|LV",
                        "Breanna Stewart|19.81|SEA",
                        "DeWanna Bonner|17.81|CONN",
                        "Kelsey Mitchell|17.50|IND",
                        "Betnijah Laney|16.44|ATL",
                        "Napheesa Collier|16.38|MIN",
                        "Skylar Diggins-Smith|16.31|PHX",
                        "Crystal Dangerfield|15.88|MIN",
                        "Myisha Hines-Allen|15.73|WSH"),
                Exercises.topTenScorers(stats));
    }

    @Test
    public void testQuaternionConstructorErrors() {
        // That that NaNs are detected in each argument
        assertThrows(IllegalArgumentException.class,
                () -> new Quaternion(Double.NaN, 0, 0, 0));
        assertThrows(IllegalArgumentException.class,
                () -> new Quaternion(0, Double.NaN, 0, 0));
        assertThrows(IllegalArgumentException.class,
                () -> new Quaternion(0, 0, Double.NaN, 0));
        assertThrows(IllegalArgumentException.class,
                () -> new Quaternion(0, 0, 0, Double.NaN));
    }

    @Test
    public void testQuaternionAccessors() {
        // Java records give us these for free
        var q = new Quaternion(3.5, 2.25, -100, -1.25);
        assertEquals(3.5, q.a());
        assertEquals(2.25, q.b());
        assertEquals(-100.0, q.c());
        assertEquals(-1.25, q.d());
    }

    @Test
    public void testQuaternionArithmetic() {
        var q1 = new Quaternion(1, 3, 5, 2);
        var q2 = new Quaternion(-2, 2, 8, -1);
        var q3 = new Quaternion(-1, 5, 13, 1);
        var q4 = new Quaternion(-46, -25, 5, 9);
        assertEquals(q3, q1.plus(q2));
        assertEquals(q1, q3.minus(q2));
        assertEquals(q4, q1.times(q2));
        assertEquals(Quaternion.K, Quaternion.I.times(Quaternion.J));
    }

    @Test
    public void testQuaternionCoefficients() {
        assertEquals(List.of(0.0, 0.0, 0.0, 0.0),
                new Quaternion(0, 0, 0, 0).coefficients());
        assertEquals(List.of(2.0, 1.5, 10.0, -8.0),
                new Quaternion(2, 1.5, 10, -8).coefficients());
    }

    @Test
    public void testQuaternionToString() {
        assertEquals("Quaternion[a=0.0, b=0.0, c=0.0, d=0.0]",
                new Quaternion(0, 0, 0, 0).toString());
        assertEquals("Quaternion[a=0.0, b=-1.0, c=0.0, d=2.25]",
                new Quaternion(0, -1, 0, 2.25).toString());
        assertEquals("Quaternion[a=0.0, b=0.0, c=0.0, d=-1.0]",
                Quaternion.ZERO.minus(Quaternion.K).toString());
    }
}