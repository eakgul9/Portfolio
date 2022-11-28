package main.t3;

import java.util.*;

/**
 * Artificial Intelligence responsible for playing the game of T3!
 * Implements the alpha-beta-pruning mini-max search algorithm
 */
public class T3Player {
    
    /**
     * Workhorse of an AI T3Player's choice mechanics that, given a game state,
     * makes the optimal choice from that state as defined by the mechanics of the
     * game of Tic-Tac-Total. Note: In the event that multiple moves have
     * equivalently maximal minimax scores, ties are broken by move col, then row,
     * then move number in ascending order (see spec and unit tests for more info).
     * The agent will also always take an immediately winning move over a delayed
     * one (e.g., 2 moves in the future).
     * 
     * @param state
     *            The state from which the T3Player is making a move decision.
     * @return The T3Player's optimal action.
     */
    public T3Action choose (T3State state) {
    	double compare = 0;
    	T3Action bestMinimax = null;
    	for (Map.Entry<T3Action, T3State> transition : state.getTransitions().entrySet()) {
    		if (transition.getValue().isWin()) {
    			return transition.getKey();
    		}
    		double minimax = alphabeta(transition.getValue(), Integer.MIN_VALUE, Integer.MAX_VALUE, false);
    		if (minimax > compare) {
    			compare = minimax;
    			bestMinimax = transition.getKey();
    		}
    	}
    	return bestMinimax;
    }
    
    /**
     * A function that updates the alpha beta values of each T3State and returns the minimax
     * scores associated with them.
     * @param state
     *            The state from which the T3Player is making a move decision.
     * @param alpha
     * 			  A double representing the worst our agent can do.
     * @param beta
     * 			  A double representing the best our agent can do.
     * @param turn
     * 			  A boolean representing who's turn it is, whether it is even or odds.
     * @return The minimax score of a given state.
     */
    public static double alphabeta(T3State state, double alpha, double beta, boolean turn) {
    	if (state.isWin() || state.isTie()) {
    		return utilityScore(state, turn);
    	}
    	if (turn) {
    		double minimax = Integer.MIN_VALUE;
    		for (Map.Entry<T3Action, T3State> transition : state.getTransitions().entrySet()) {
    			minimax = Math.max(minimax, alphabeta(transition.getValue(), alpha, beta, false));
    			alpha = Math.max(alpha, minimax);
    			if (beta <= alpha) {
    				break;
    			}
    		}
    		return minimax;
    	} else {
    		double minimax = Integer.MAX_VALUE;
    		for (Map.Entry<T3Action, T3State> transition : state.getTransitions().entrySet()) {
    			minimax = Math.min(minimax, alphabeta(transition.getValue(), alpha, beta, true));
    			beta = Math.min(beta, minimax);
    			if (beta <= alpha) {
    				break;
    			}
    		}
    		return minimax;
    	}
    }
    
    /**
     * A helper method that returns the utility score associated with the given state and
     * player turn.
     * @param state
     *            The state from which the T3Player is making a move decision.
     * @param turn
     * 			  A boolean representing who's turn it is, whether it is even or odds.
     * @return the utility score.
     */
    public static double utilityScore(T3State state, boolean turn) {
	  if (state.isWin() && !turn) {
		  return 1;
	  }
	  if (state.isTie()) {
		  return 0.5;
	  }
	  return 0;
  }
}

