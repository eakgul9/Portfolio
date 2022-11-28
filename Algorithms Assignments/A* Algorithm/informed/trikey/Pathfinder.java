package main.pathfinder.informed.trikey;

import java.util.*;

/**
 * Eylul Akgul
 */

/**
 * Maze Pathfinding algorithm that implements a basic, uninformed, breadth-first
 * tree search.
 */
public class Pathfinder {

    /**
     * Given a MazeProblem, which specifies the actions and transitions available in
     * the search, returns a solution to the problem as a sequence of actions that
     * leads from the initial state to the collection of all three key pieces.
     * 
     * @param problem A MazeProblem that specifies the maze, actions, transitions.
     * @return A List of Strings representing actions that solve the problem of the
     *         format: ["R", "R", "L", ...]    
     */
    public static List<String> solve(MazeProblem problem) {
    	PriorityQueue<SearchTreeNode> frontier = new PriorityQueue<>();
    	HashSet<SearchTreeNode> graveyard = new HashSet<>();
    	Set<MazeState> goals = problem.getKeyStates();
    	frontier.add(new SearchTreeNode(problem.getInitial(), "initial", null, 0, 0, new HashSet<MazeState>()));
    	//Performing A star graph search.
    	while (!frontier.isEmpty()) {
    		SearchTreeNode expanding = frontier.poll();
    		graveyard.add(expanding);
    		if (goals.contains(expanding.state)) {
    			expanding.keysCollected.add(expanding.state);
    		}
    		if (expanding.keysCollected.size() == problem.getKeyStates().size()) {
    			return getPath(expanding);
    		}
    		Map<String, MazeState> transitions = problem.getTransitions(expanding.state);
    		for (Map.Entry<String, MazeState> transition : transitions.entrySet()) {
    			SearchTreeNode currentChild = new SearchTreeNode(transition.getValue(), transition.getKey(), expanding, getPastCost(expanding, problem), getTotalCost(expanding, problem, goals),  new HashSet<MazeState>(expanding.keysCollected));
    			if(!graveyard.contains(currentChild)) {
    				frontier.add(currentChild);
    			}
    		}
    	}
    	return null;
    }
    
    /**
     * A function that calculates the manhattan distance from key states.
     * 
     * @param current, the current node that we are expanding.
     * @param problem, the maze problem that is given.
     * @param goals, set of maze states that consist of all key states.
     * @return min, integer that signifies the closest key from our current position.
     */
    private static int getHeuristic(SearchTreeNode current, MazeProblem problem, Set<MazeState> goals) {
    	List<Integer> distances = new ArrayList<>(); 
    	int columnDifference = 0;
    	int rowDifference = 0;
    	int distance = 0;
    	for (MazeState goal : goals) {
    		int column = current.state.col();
    		int row = current.state.row();
    		int keyColumn= goal.col();
    		int keyRow= goal.row();
    		columnDifference = Math.abs(keyColumn - column);
    		rowDifference = Math.abs(keyRow - row);
    		distance = columnDifference + rowDifference;
    		distances.add(distance);
    	}
    	int min = distances.get(0);
    	for (int i = 1; i < distances.size(); i++) {
    		if (min > distances.get(i))
    			min = distances.get(i);
    	}
    	return min;
    }
    
    /**
     * A function that calculates the past cost of the current node.
     * 
     * @param current, the current node that we are expanding.
     * @param problem, the maze problem that is given.
     * @return the cost of the current node's state plus its past cost.
     */
    private static int getPastCost(SearchTreeNode current, MazeProblem problem) {
    	return problem.getCost(current.state) + current.pastCost;
    }
    
    /**
     * A function that calculates the total cost of the current node.
     * 
     * @param current, the current node that we are expanding.
     * @param problem, the maze problem that is given.
     * @param goals, a set of MazeStates consisting of key states.
     * @return the sum of the node's pastCost and heuristic, the total cost.
     */
    private static int getTotalCost(SearchTreeNode current, MazeProblem problem, Set<MazeState> goals) {
    	int heuristic = getHeuristic(current, problem, goals);
    	return current.totalCost = current.pastCost + heuristic;
    }
    
    /**
     * Given a leaf node in the search tree (a goal), returns a solution by traversing
     * up the search tree, collecting actions along the way, until reaching the root
     * 
     * @param last SearchTreeNode to start the upward traversal at (a goal node)
     * @return LinkedList sequence of actions; solution of format ["U", "R", "U", ...]
     */
    private static LinkedList<String> getPath (SearchTreeNode last) {
        LinkedList<String> result = new LinkedList<>();
        for (SearchTreeNode current = last; current.parent != null; current = current.parent) {
            result.addFirst(current.action);
        }
        return result;
    }   

    /**
     * SearchTreeNode private static nested class that is used in the Search
     * algorithm to construct the Search tree.
     * [!] You may do whatever you want with this class -- in fact, you'll need 
     * to add a lot for a successful and efficient solution!
     */
    private static class SearchTreeNode implements Comparable <SearchTreeNode> {
        MazeState state;
        String action;
        SearchTreeNode parent;
        int pastCost;
        int totalCost;
        Set <MazeState> keysCollected;   

        /**
         * Constructs a new SearchTreeNode to be used in the Search Tree.
         * 
         * @param state  The MazeState (row, col) that this node represents.
         * @param action The action that *led to* this state / node.
         * @param parent Reference to parent SearchTreeNode in the Search Tree.
         */
        SearchTreeNode(MazeState state, String action, SearchTreeNode parent, int pastCost, int totalCost, Set <MazeState> keysCollected) {
            this.state = state;
            this.action = action;
            this.parent = parent;
            this.pastCost = pastCost;
            this.totalCost = totalCost;
            this.keysCollected = keysCollected;
        }
        
        /**
         * A function that compares SearchTreeNodes based on their totalCost.
         * 
         * @param other the node that we are comparing to.
         * @return integer that signifies the priority of the node.
         */
        public int compareTo (SearchTreeNode other) {
        	return this.totalCost - other.totalCost;
        }
        
        /**
         * Overrides the hash code.
         */
        @Override
        public int hashCode() {
            return Objects.hash(this.state);
        }
        
        /**
         * Overrides equals method to take states and keysCollected fields into account.
         */
        @Override
        public boolean equals(Object other) {   
        	SearchTreeNode otherNode = (SearchTreeNode) other;
        	if (this.getClass().equals(otherNode.getClass())) {
        		if(this.state.equals(otherNode.state) && this.keysCollected.equals(otherNode.keysCollected)) {
        			return true;
        		}
            }
        	return false;
        }
    }
}
