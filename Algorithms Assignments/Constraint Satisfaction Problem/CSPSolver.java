package main.csp;

import java.time.LocalDate;
import java.util.*;

/**
 * CSP: Calendar Satisfaction Problem Solver
 * Provides a solution for scheduling some n meetings in a given
 * period of time and according to some unary and binary constraints
 * on the dates of each meeting.
 */
public class CSPSolver {

    // Backtracking CSP Solver
    // --------------------------------------------------------------------------------------------------------------
    
    /**
     * Public interface for the CSP solver in which the number of meetings,
     * range of allowable dates for each meeting, and constraints on meeting
     * times are specified.
     * @param nMeetings The number of meetings that must be scheduled, indexed from 0 to n-1
     * @param rangeStart The start date (inclusive) of the domains of each of the n meeting-variables
     * @param rangeEnd The end date (inclusive) of the domains of each of the n meeting-variables
     * @param constraints Date constraints on the meeting times (unary and binary for this assignment)
     * @return A list of dates that satisfies each of the constraints for each of the n meetings,
     *         indexed by the variable they satisfy, or null if no solution exists.
     */
    public static List<LocalDate> solve (int nMeetings, LocalDate rangeStart, LocalDate rangeEnd, Set<DateConstraint> constraints) {
    	List<MeetingDomain> varDomains = generateDomains(nMeetings, rangeStart, rangeEnd);
    	nodeConsistency(varDomains, constraints);
    	arcConsistency(varDomains, constraints);
    	return recursiveBacktracking(new ArrayList<LocalDate>(), nMeetings, varDomains, constraints);
    }
    
    /**
     * Recursive helper that backtracks through the domain to check which values fit the 
     * constraints and then returns the list of Local Dates that are consistent with that.
     * @param assignment the list of LocalDates that fit the constraints
     * @param nMeetings the number of meetings that need to be scheduled
     * @param dates the set of LocalDates available in the given domain
     * @param constraints the set of DateConstraints that the LocalDates must match
     * @return List of LocalDates that does not violate the constraints
     */
    private static List<LocalDate> recursiveBacktracking (List<LocalDate> assignment, int nMeetings, List<MeetingDomain> varDomains, Set<DateConstraint> constraints){
    	if (assignment.size() == nMeetings) {
    		return assignment;
    	}
    	for (MeetingDomain domain : varDomains) {
    		for (LocalDate date : domain.domainValues) {
        		assignment.add(date);
        		if (checkConstraint(constraints, assignment)) {
        			List<LocalDate> result = recursiveBacktracking(assignment, nMeetings, varDomains, constraints);
        			if(result != null) {
        				return result;
        			}
        		}
    		assignment.remove(assignment.size()-1);
    		}
    	}
    	return null;
    }
    
    /**
     * Checks if the constraints are satisfied by the given assignment,
     * returns true if it is satisfied, false otherwise.
     * @param assignment the list of LocalDates that fit the constraints
     * @param constraints the set of DateConstraints that the LocalDates must match
     * @return true if the constraint is satisfied, false if violated.
     */
    private static boolean checkConstraint (Set<DateConstraint> constraints, List<LocalDate> assignment) {
    	for (DateConstraint constraint : constraints) {
    		if (assignment.size()-1 < constraint.L_VAL) {
    			continue;
    		}
    		if (!isBinary(constraint)) {
    			UnaryDateConstraint unaryConstraint = (UnaryDateConstraint) constraint;
    			if (!unaryConstraint.isSatisfiedBy(assignment.get(unaryConstraint.L_VAL), unaryConstraint.R_VAL)) {
    				return false;
    			}
    		} else {
    			BinaryDateConstraint binaryConstraint = (BinaryDateConstraint) constraint;
    			if (assignment.size()-1 < binaryConstraint.R_VAL) {
    				continue;
    			}
    			if (!binaryConstraint.isSatisfiedBy(assignment.get(binaryConstraint.L_VAL), assignment.get(binaryConstraint.R_VAL))) {
    				return false;
    			}
    		}
    	}
    	return true;
    }
    
    /**
     * Checks if the given constraint is Binary.
     * @param constraint DateConstraint to check the arity of
     * @return true if the constraint is binary, false if unary.
     */
    private static boolean isBinary (DateConstraint constraint) {
    	if (constraint.arity() == 2) {
    		return true;
    	}
    	return false;
    }
    
    /**
     * Helper method to generate a list of MeetingDomains from a given range.
     * @param n Number of meeting variables
     * @param startRange Start date for the range of each variable's domain.
     * @param endRange End date for the range of each variable's domain.
     * @return the List of MeetingDomains.
     */
    private static List<MeetingDomain> generateDomains (int n, LocalDate startRange, LocalDate endRange) {
        List<MeetingDomain> domains = new ArrayList<>();
        while (n > 0) {
            domains.add(new MeetingDomain(startRange, endRange));
            n--;
        }
        return domains;
    }
    
    // Filtering Operations
    // --------------------------------------------------------------------------------------------------------------
    
    /**
     * Enforces node consistency for all variables' domains given in varDomains based on
     * the given constraints. Meetings' domains correspond to their index in the varDomains List.
     * @param varDomains List of MeetingDomains in which index i corresponds to D_i
     * @param constraints Set of DateConstraints specifying how the domains should be constrained.
     * [!] Note, these may be either unary or binary constraints, but this method should only process
     *     the *unary* constraints! 
     */
    public static void nodeConsistency (List<MeetingDomain> varDomains, Set<DateConstraint> constraints) {
        for (DateConstraint constraint : constraints) {
        	if (!isBinary(constraint)) {
        		UnaryDateConstraint unaryConstraint = (UnaryDateConstraint) constraint;
        		MeetingDomain copy = new MeetingDomain(varDomains.get(unaryConstraint.L_VAL));
        		for (LocalDate x : copy.domainValues) {
        			if (!unaryConstraint.isSatisfiedBy(x, unaryConstraint.R_VAL)) {
        				varDomains.get(unaryConstraint.L_VAL).domainValues.remove(x);
        			}
        		}
        	}
        }
    }
    
    /**
     * Enforces arc consistency for all variables' domains given in varDomains based on
     * the given constraints. Meetings' domains correspond to their index in the varDomains List.
     * @param varDomains List of MeetingDomains in which index i corresponds to D_i
     * @param constraints Set of DateConstraints specifying how the domains should be constrained.
     * [!] Note, these may be either unary or binary constraints, but this method should only process
     *     the *binary* constraints using the AC-3 algorithm! 
     */
    public static void arcConsistency (List<MeetingDomain> varDomains, Set<DateConstraint> constraints) {
    	Set<Arc> arcQueue = new HashSet<>();
    	for (DateConstraint constraint : constraints) {
    		if (isBinary(constraint)) {
    			BinaryDateConstraint binaryConstraint = (BinaryDateConstraint) constraint;
    			arcQueue.add(new Arc(binaryConstraint.L_VAL, binaryConstraint.R_VAL, constraint));
    			arcQueue.add(new Arc(binaryConstraint.R_VAL, binaryConstraint.L_VAL, (DateConstraint) binaryConstraint.getReverse()));
    		}
    	}
    	while (!arcQueue.isEmpty()) {
    		Arc next = arcQueue.iterator().next();
    		arcQueue.remove(next);
    		if (removeInconsistent(next, varDomains)) {
    			addNeighbors(arcQueue, next, constraints);
    		}
    	}
    }
    
    /**
     * Creates and adds the neighbors of the given arc to the queue.
     * @param arcQueue the set of Arcs to add to
     * @param next the Arc whose neighbors we are getting
     * @param constraints the set of DateConstraints used to make the new Arcs
     */
    private static void addNeighbors (Set<Arc> arcQueue, Arc next, Set<DateConstraint> constraints) {
		for (DateConstraint constraint : constraints) {
			if (isBinary(constraint)) {
				BinaryDateConstraint binaryConstraint = (BinaryDateConstraint) constraint;
				if (next.TAIL == binaryConstraint.L_VAL) {
					arcQueue.add(new Arc(binaryConstraint.R_VAL, binaryConstraint.L_VAL, (DateConstraint) binaryConstraint.getReverse()));
				}
				if (next.TAIL == binaryConstraint.R_VAL) {
					arcQueue.add(new Arc(binaryConstraint.L_VAL, binaryConstraint.R_VAL, constraint));
				}
			}
		}
    }

    /**
     * Removes the inconsistent values from the given domains.
     * @param current Arc that we are checking
     * @param varDomains the list of MeetingDomains to remove values from
     * @return true if a value have been removed, false if not.
     */
    private static boolean removeInconsistent (Arc current, List<MeetingDomain> varDomains) {
    	boolean removed = false;
    	int failCounter = 0;
    	MeetingDomain copy = new MeetingDomain(varDomains.get(current.TAIL));
    	for (LocalDate x : copy.domainValues) {
    		for (LocalDate y : varDomains.get(current.HEAD).domainValues) {
    			if (!current.CONSTRAINT.isSatisfiedBy(x, y)) {
    				failCounter++;
    			}
    		}
    		if (failCounter == varDomains.get(current.HEAD).domainValues.size()) {
    			varDomains.get(current.TAIL).domainValues.remove(x);
    			removed = true;
    		}
    		failCounter = 0;
    	}
    	return removed;
    }
    
    /**
     * Private helper class organizing Arcs as defined by the AC-3 algorithm, useful for implementing the
     * arcConsistency method.
     * [!] You may modify this class however you'd like, its basis is just a suggestion that will indeed work.
     */
    private static class Arc {
        
        public final DateConstraint CONSTRAINT;
        public final int TAIL, HEAD;
        
        /**
         * Constructs a new Arc (tail -> head) where head and tail are the meeting indexes
         * corresponding with Meeting variables and their associated domains.
         * @param tail Meeting index of the tail
         * @param head Meeting index of the head
         * @param c Constraint represented by this Arc.
         * [!] WARNING: A DateConstraint's isSatisfiedBy method is parameterized as:
         * isSatisfiedBy (LocalDate leftDate, LocalDate rightDate), meaning L_VAL for the first
         * parameter and R_VAL for the second. Be careful with this when creating Arcs that reverse
         * direction. You may find the BinaryDateConstraint's getReverse method useful here.
         */
        public Arc (int tail, int head, DateConstraint c) {
            this.TAIL = tail;
            this.HEAD = head;
            this.CONSTRAINT = c;
        }
        
        @Override
        public boolean equals (Object other) {
            if (this == other) { return true; }
            if (this.getClass() != other.getClass()) { return false; }
            Arc otherArc = (Arc) other;
            return this.TAIL == otherArc.TAIL && this.HEAD == otherArc.HEAD && this.CONSTRAINT.equals(otherArc.CONSTRAINT);
        }
        
        @Override
        public int hashCode () {
            return Objects.hash(this.TAIL, this.HEAD, this.CONSTRAINT);
        }
        
        @Override
        public String toString () {
            return "(" + this.TAIL + " -> " + this.HEAD + ")";
        }
        
    }
    
}
