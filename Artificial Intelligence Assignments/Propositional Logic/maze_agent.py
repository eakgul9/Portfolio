import time
import random
import math
from queue import Queue
from constants import *
from maze_clause import *
from maze_knowledge_base import *

class MazeAgent:
    '''
    BlindBot MazeAgent meant to employ Propositional Logic,
    Planning, and Active Learning to navigate the Pitsweeper
    Problem. Have fun!
    '''
    
    def __init__ (self, env: "Environment", perception: dict) -> None:
        """
        Initializes the MazeAgent with any attributes it will need to
        navigate the maze.
        [!] Add as many attributes as you see fit!
        
        Parameters:
            env (Environment):
                The Environment in which the agent is operating; make sure
                to see the spec / Environment class for public methods that
                your agent will use to solve the maze!
            perception (dict):
                The starting perception of the agent, which is a
                small dictionary with keys:
                  - loc:  the location of the agent as a (c,r) tuple
                  - tile: the type of tile the agent is currently standing upon
        """
        self.env: "Environment" = env
        self.goal: tuple[int, int] = env.get_goal_loc()
        
        # The agent's maze can be manipulated as a tracking mechanic
        # for what it has learned; changes to this maze will be drawn
        # by the environment and is simply for visuals / debugging
        # [!] Feel free to change self.maze at will
        self.maze: list = env.get_agent_maze()
        
        # Standard set of attributes you'll want to maintain
        self.kb: "MazeKnowledgeBase" = MazeKnowledgeBase()
        self.possible_pits: set[tuple[int, int]] = set()
        self.safe_tiles: set[tuple[int, int]] = set()
        self.pit_tiles: set[tuple[int, int]] = set()
        
        # agent here, or any other record-keeping attributes you'd like
        self.explored_tiles: set[tuple[int, int]] = set()

        # Updating the KB to take into account the agent's starting position
        self.safe_tiles.add(self.goal)
        adjacent_tiles: set[tuple[int, int]] = self.env.get_cardinal_locs(self.goal, 1)
        if len(adjacent_tiles) == 1:
            self.safe_tiles.update(adjacent_tiles)
        self.kb.tell(MazeClause([(("P", loc), False) for loc in adjacent_tiles]))
        self.kb.tell(MazeClause([(("P", self.goal), False)]))
        self.think(perception)

    ##################################################################
    # Methods
    ##################################################################
    
    def think (self, perception: dict) -> tuple[int, int]:
        """
        The main workhorse method of how your agent will process new information
        and use that to make deductions and decisions. In gist, it should follow
        this outline of steps:
        1. Process the given perception, i.e., the new location it is in and the
           type of tile on which it's currently standing (e.g., a safe tile, or
           warning tile like "1" or "2")
        2. Update the knowledge base and record-keeping of where known pits and
           safe tiles are located, as well as locations of possible pits.
        3. Query the knowledge base to see if any locations that possibly contain
           pits can be deduced as safe or not.
        4. Use all of the above to prioritize the next location along the frontier
           to move to next.
        
        Parameters:
            perception (dict):
                A dictionary providing the agent's current location
                and current tile type being stood upon, of the format:
                {"loc": (x, y), "tile": tile_type}
        
        Returns:
            tuple[int, int]:
                The maze location along the frontier that your agent will try to
                move into next.
        """
        frontier = self.env.get_frontier_locs()
        current_location: tuple[int, int] = perception["loc"]
        tile_type: str = perception["tile"]
        adjacent_tiles: set[tuple[int, int]] = self.env.get_cardinal_locs(current_location, 1) - self.explored_tiles
        self.explored_tiles.add(current_location)

        if tile_type != Constants.PIT_BLOCK:
            self.safe_tiles.add(current_location)
            self.kb.simplify_self(self.pit_tiles, self.safe_tiles)
            self.kb.tell(MazeClause([(("P", (current_location)), False)]))
            if tile_type == Constants.SAFE_BLOCK:
                self._add_adjacent_tiles(adjacent_tiles, self.safe_tiles, False)  
            else: 
                self._inform_knowledge_base(tile_type, current_location)
        else: 
            self.pit_tiles.add(current_location)
            self.kb.simplify_self(self.pit_tiles, self.safe_tiles)
            self.kb.tell(MazeClause([(("P", (current_location)), True)]))
        
        for location in self.possible_pits:
            self.is_safe_tile(location)

        return self._get_closest_location(frontier, current_location)
        
    def is_safe_tile (self, loc: tuple[int, int]) -> Optional[bool]:
        """
        Determines whether or not the given maze location can be concluded as
        safe (i.e., not containing a pit), following the steps:
        1. Check to see if the location is already a known pit or safe tile,
           responding accordingly
        2. If not, performs the necessary queries on the knowledge base in an
           attempt to deduce its safety
        
        Parameters:
            loc (tuple[int, int]):
                The maze location in question
        
        Returns:
            One of three return values:
            1. True if the location is certainly safe (i.e., not pit)
            2. False if the location is certainly dangerous (i.e., pit)
            3. None if the safety of the location cannot be currently determined
        """
        if loc in self.safe_tiles:
            return True
        elif loc in self.pit_tiles:
            return False
        else:
            query: "MazeClause" = MazeClause([(("P", loc), True)])
            negated_query: "MazeClause" = MazeClause([(("P", loc), False)])
            if self.kb.ask(query):
                self.pit_tiles.add(loc)
                self.kb.simplify_self(self.pit_tiles, self.safe_tiles)
                self.kb.tell(query)
                return False
            elif self.kb.ask(negated_query):
                self.safe_tiles.add(loc)
                self.kb.simplify_self(self.pit_tiles, self.safe_tiles)
                self.kb.tell(negated_query)
                return True
            else: 
                self.possible_pits.add(loc) 
                return None
       
    def _inform_knowledge_base (self, tile_type: str, current_location: tuple[int, int]) -> None:
        """
        Informs the knowledgebase about warning tiles, given the agent's current
        location and the type of that tile.
        
        Parameters:
            tile_type (str):
                The type of the tile the agent is currently on.
            current_location (tuple[int, int]):
                The current location of the agent.
        """
        adjacent_tiles: set[tuple[int, int]] = self.env.get_cardinal_locs(current_location, 1) - self.safe_tiles
        all_adjacent_tiles: set[tuple[int, int]] = self.env.get_cardinal_locs(current_location, 1)
        combinations: list[tuple[tuple[int, int], tuple[int, int]]] = list(itertools.combinations(adjacent_tiles, 2))

        if len(self.safe_tiles & all_adjacent_tiles) + int(tile_type) == len(all_adjacent_tiles):
            all_adjacent_tiles -= self.safe_tiles
            for tile in adjacent_tiles:
                self.pit_tiles.add(tile)
                self.kb.tell(MazeClause([(("P", (tile)), True)]))
        elif tile_type == Constants.WRN_THREE_BLOCK:
            self._add_adjacent_tiles(adjacent_tiles, self.pit_tiles, True)
        elif tile_type == Constants.WRN_TWO_BLOCK:
            for location in combinations:
                wrn_two_clause: "MazeClause" = MazeClause ([(("P", (location[0])), True), (("P", (location[1])), True)])
                self.kb.tell(wrn_two_clause)
            self.possible_pits |= adjacent_tiles  
            self.kb.tell(MazeClause([(("P", (loc)), False) for loc in adjacent_tiles]))
        else:
            for location in combinations:
                wrn_one_clause: "MazeClause" = MazeClause ([(("P", (location[0])), False), (("P", (location[1])), False)])
                self.kb.tell(wrn_one_clause)
            self.kb.tell(MazeClause([(("P", (loc)), True) for loc in adjacent_tiles]))
            self.possible_pits |= adjacent_tiles
        self.kb.simplify_self(self.pit_tiles, self.safe_tiles)

    def _add_adjacent_tiles (self, adjacent_tiles: set[tuple[int, int]], set_to_add: set[tuple[int, int]], is_pit: bool) -> None:
        """
        Adds the adjacent tiles to the correct sets and informs the knowledgebase
        given the adjacent tiles, the set to add and if the tile is a pit or not.
        
        Parameters:
            adjacent_tiles (set[tuple[int, int]]):
                The adjacent tiles that we want to inform the knowledgebase about.
            set_to_add (set[tuple[int, int]]):
                The correct set to add the clauses about the given tiles.
            is_pit (bool):
                Whether these adjacent tiles are pits or not.
        """
        for location in adjacent_tiles:
            set_to_add.add(location)
            self.kb.simplify_self(self.pit_tiles, self.safe_tiles)
            self.kb.tell(MazeClause([(("P", (location)), is_pit)]))

    def _get_manhattan_distance (self, location: tuple[int, int], desired_tile: tuple[int, int]) -> int:
        """
        Gets the manhattan distance of a given location from a desired tile.
        
        Parameters:
            location (tuple[int, int]):
                The location from which the distance is measured.
            desired_tile (tuple[int, int]]):
                The desired location.
        Returns:
            int:
                The manhattan distance between the two tiles.
        """
        x_coordinate: int = abs(desired_tile[0] - location[0])
        y_coordinate: int = abs(desired_tile[1] - location[1])
        return x_coordinate + y_coordinate
    
    def _return_min (self, set_intersection: set[tuple[int, int]], current_location: tuple[int, int]) -> tuple[int, int]:
        """
        Returns the tile with the minimum manhattan distance value from a given set
        intersection using a current location.
        
        Parameters:
            set_intersection (set[tuple[int, int]]):
                The intersection of the frontier and another set to loop through.
            current_location (tuple[int, int]):
                The current location of the agent.
        Returns:
            tuple[int, int]:
                The tile with the minimum manhattan distance value
        """
        possible_moves: dict[tuple[int, int], int] = {}
        goal_tile: tuple[int, int] = self.env.get_goal_loc()

        for location in set_intersection:
                manhattan_distance_goal: int = self._get_manhattan_distance(location, goal_tile)
                manhattan_distance_current: int = self._get_manhattan_distance(location, current_location)
                possible_moves [location] = manhattan_distance_current +  manhattan_distance_goal
        return min(possible_moves, key = possible_moves.get)
    
    def _get_closest_location (self, frontier: set[tuple[int, int]], current_location: tuple[int, int]) -> tuple[int, int]:
        """
        Returns the closest and safest possible location to the goal and the agent 
        from the current location and frontier given.

        Parameters:
            frontier (set[tuple[int, int]]):
                The set of possible moves our agent can make.
            current_location (tuple[int, int]):
                The current location of the agent.
        Returns:
            tuple[int, int]:
                The closest and safest possible location to the goal
        """
        safe_tiles_frontier: set[tuple[int, int]] = frontier & self.safe_tiles
        possible_pits_frontier: set[tuple[int, int]] = frontier & self.possible_pits

        if safe_tiles_frontier:
            return self._return_min(safe_tiles_frontier, current_location) 
        else:
            return self._return_min(possible_pits_frontier, current_location)
# Declared here to avoid circular dependency
from environment import Environment

