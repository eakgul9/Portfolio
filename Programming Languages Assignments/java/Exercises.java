import java.util.*;
import java.util.stream.*;
import java.util.function.Predicate;
import java.util.function.IntConsumer;

public class Exercises {
    private Exercises() {
        // Intentionally Empty
    }

    public static List<Integer> change(int cents) {
        if (cents < 0) {
            throw new IllegalArgumentException();
        }
        final int quarterValue = 25;
        final int dimeValue = 10;
        final int nickelValue = 5;
        var quarters = cents/quarterValue;
        var remainder = cents % quarterValue;
        var dimes = remainder / dimeValue;
        remainder %= dimeValue;
        var nickels = remainder / nickelValue;
        var pennies = remainder % nickelValue;
        return Collections.unmodifiableList(List.of(quarters, dimes, nickels, pennies));
    }
    
    public static String stretched (String word) {
        var trimmedWord = word.replaceAll("\\s", "");
        int[] codePoints = trimmedWord.codePoints().toArray();
        return IntStream.range(0, codePoints.length)
        .mapToObj(index -> Character.toString(codePoints[index])
        .repeat(index+1)).collect(Collectors.joining(""));
    }

   public static void powers(int base, int limit, IntConsumer consume) {
        for (int power = 1; power <= limit; power *= base) {
            consume.accept(power);
        }
    }

    public static IntStream powers(int base) {
        return IntStream.iterate(1, prevBase -> base*prevBase);
    }
    
    public static Optional<String> findFirstThenLower(Predicate<String> predicate, List<String> words){
        return words.stream().filter(predicate).findFirst().map(String::toLowerCase);
    }

    public static String say() {
        return "";
    }

    public static SayHelper say(String input) {
        return new SayHelper(input);
    }

    public record SayHelper(String input) {
        SayHelper and(String nextInput) {
            return new SayHelper(this.input + " " + nextInput);
        }

        String ok() {
            return input;
        }
    }

    public static List<String> topTenScorers(Map<String, List<String>> players) {
    return players.entrySet().stream().flatMap(entry -> entry.getValue().stream().map(player -> player.concat(","+entry.getKey())))
        .map(playerArray -> playerArray.split(","))
        .filter(gameCount -> Integer.parseInt(gameCount[1]) >= 15)
        .map(playerArray -> {
            var playerPPG = (Double.parseDouble(playerArray[2])/Double.parseDouble(playerArray[1]));
            return new PlayerStats(playerArray[0], playerPPG, playerArray[3]);
        })
        .sorted((player1, player2) -> player2.comparePPG(player1))
        .limit(10).map(PlayerStats::formatToString).toList();
    }

    private record PlayerStats(String name, double ppg, String teamName) {
        int comparePPG(PlayerStats player2) {
            return Double.compare(this.ppg, player2.ppg);
        }
        
        String formatToString() {
            return this.name + "|" + String.format("%.2f", this.ppg) + "|" + this.teamName;
        }
    }
}
