package main.distle;

import java.util.*;

public class EditDistanceUtils {
    
    /**
     * Returns the completed Edit Distance memoization structure, a 2D array
     * of ints representing the number of string manipulations required to minimally
     * turn each subproblem's string into the other.
     * 
     * @param s0 String to transform into other
     * @param s1 Target of transformation
     * @return Completed Memoization structure for editDistance(s0, s1)
     */
    public static int[][] getEditDistTable (String s0, String s1) {
        int [][] editDistTable = new int [s0.length() + 1] [s1.length() + 1];
        if(s0.equals(s1)) {
        	return editDistTable;
        }
        fillGutters(editDistTable);
        for (int r = 1; r < editDistTable.length; r++) {
        	for (int c = 1; c < editDistTable[r].length; c++) {
        		int recurrenceValue;
        		int insertion = editDistTable[r][c-1] + 1;
        		int deletion = editDistTable[r-1][c] + 1;
        		recurrenceValue = Math.min(insertion, deletion);
        		int replacement = editDistTable[r-1][c-1] + (s1.charAt(c-1) != (s0.charAt(r-1))? 1 : 0);
        		recurrenceValue = Math.min(recurrenceValue, replacement);
        		if (r >= 2 && c >= 2) {
        			boolean transpositionCondition = (s0.charAt(r-1) == s1.charAt(c-2) && s1.charAt(c-1) == s0.charAt(r-2));
        			if (transpositionCondition) {
        				int transposition = editDistTable[r-2][c-2] + 1;
            			recurrenceValue = Math.min(recurrenceValue, transposition);
        			}
        		}
        		editDistTable [r][c] = recurrenceValue;
        	}
        }
        return editDistTable;
    }
    
    /**
     * Returns one possible sequence of transformations that turns String s0
     * into s1. The list is in top-down order (i.e., starting from the largest
     * subproblem in the memoization structure) and consists of Strings representing
     * the String manipulations of:
     * <ol>
     *   <li>"R" = Replacement</li>
     *   <li>"T" = Transposition</li>
     *   <li>"I" = Insertion</li>
     *   <li>"D" = Deletion</li>
     * </ol>
     * In case of multiple minimal edit distance sequences, returns a list with
     * ties in manipulations broken by the order listed above (i.e., replacements
     * preferred over transpositions, which in turn are preferred over insertions, etc.)
     * @param s0 String transforming into other
     * @param s1 Target of transformation
     * @param table Precomputed memoization structure for edit distance between s0, s1
     * @return List that represents a top-down sequence of manipulations required to
     * turn s0 into s1, e.g., ["R", "R", "T", "I"] would be two replacements followed
     * by a transposition, then insertion.
     */
    public static List<String> getTransformationList (String s0, String s1, int[][] table) {
    	List<String> transformations = new ArrayList<String>();
    	if (s0.equals(s1)) {
    		return transformations;
    	}
    	return getTransformations(s0, s1, table, s0.length(), s1.length(), transformations);
    }
    
    /**
     * Returns the edit distance between the two given strings: an int
     * representing the number of String manipulations (Insertions, Deletions,
     * Replacements, and Transpositions) minimally required to turn one into
     * the other.
     * 
     * @param s0 String to transform into other
     * @param s1 Target of transformation
     * @return The minimal number of manipulations required to turn s0 into s1
     */
    public static int editDistance (String s0, String s1) {
        if (s0.equals(s1)) { return 0; }
        return getEditDistTable(s0, s1)[s0.length()][s1.length()];
    }
    
    /**
     * See {@link #getTransformationList(String s0, String s1, int[][] table)}.
     */
    public static List<String> getTransformationList (String s0, String s1) {
        return getTransformationList(s0, s1, getEditDistTable(s0, s1));
    }
    
    /**
     * A helper method that fills the gutters of a given memoization structure.
     * @param table the memoization structure 2D Array of ints
     */
    private static void fillGutters(int[][] table) {
    	for(int r = 0; r < table.length; r++) {
    		table[r][0] = r;
    	}
    	for(int c = 0; c < table[0].length; c++) {
    		table[0][c] = c;
    	}
    }
    
    /**
     * Returns the transformations list required to transform one string into another
     * when given the two strings, the memoization table, the current row and column and
     * the list of transformations collected so far.
     * 
     * @param s0 String to transform into other
     * @param s1 Target of transformation
     * @param table the memoization structure 2D Array of ints
     * @param row the current row of the table
     * @param column the current column of the table
     * @param list of transformations collected so far
     * @return the list of all transformations needed
     */
    private static List<String> getTransformations(String s0, String s1, int[][] table, int row, int column, List<String> transformations){
    	if (row == 0 && column == 0) {
    		return transformations;
    	}
    	else {
        	int recurrenceValue = table[row][column];
        	if (row >= 1 && column >= 1 && s0.charAt(row-1) == s1.charAt(column-1)) {
        		return getTransformations(s0, s1, table, row-1, column-1, transformations);
        	}
        	if (row >= 1 && column >= 1 && recurrenceValue > table[row-1][column-1]) {
            	transformations.add("R");
            	return getTransformations(s0, s1, table, row-1, column-1, transformations);
        	}
        	if (row >= 2 && column >= 2) {
        		boolean transpositionCondition = (s0.charAt(row-1) == s1.charAt(column-2) && s1.charAt(column-1) == s0.charAt(row-2));
        		if (transpositionCondition && recurrenceValue > table[row-2][column-2]) {
        			transformations.add("T");
        			return getTransformations(s0, s1, table, row-2, column-2, transformations);
        		}
        	}
        	if (column >= 1 && recurrenceValue > table[row][column-1]) {
        		transformations.add("I");
        		return getTransformations(s0, s1, table, row, column-1, transformations);
        	}
        	if (row >= 1 && recurrenceValue > table[row-1][column]) {
        		transformations.add("D");
        		return getTransformations(s0, s1, table, row-1, column, transformations);
        	}
    	}
    	return transformations;
    }
}
