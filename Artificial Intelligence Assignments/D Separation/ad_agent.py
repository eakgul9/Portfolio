"""
ad_engine.py
Advertisement Selection Engine that employs a Decision Network
to Maximize Expected Utility associated with different Decision
variables in a stochastic reasoning environment.

Solution Amended from Legendary N2A Team
> Warning: not a great amendment: was just playing with some
  settings to get the new pgmpy library working
"""
import math
import itertools
import unittest
import numpy as np
import pandas as pd
from pgmpy.inference import VariableElimination
from pgmpy.models import BayesianNetwork
from typing import Any as any  # to pass mypy tests


class AdEngine:
    def __init__(
        self,
        data: "pd.DataFrame",
        structure: list[tuple[str, str]],
        dec_vars: list[str],
        util_map: dict[str, dict[int, int]],
    ):
        """
        Responsible for initializing the Decision Network of the
        AdEngine by taking in the dataset, structure of network,
        any decision variables, and a map of utilities

        Parameters:
            data (pd.DataFrame):
                Pandas data frame containing all data on which the decision
                network's chance-node parameters are to be learned
            structure (list[tuple[str, str]]):
                The Bayesian Network's structure, a list of tuples denoting
                the edge directions where each tuple is (parent, child)
            dec_vars (list[str]):
                list of string names of variables to be
                considered decision variables for the agent. Example:
                ["Ad1", "Ad2"]
            util_map (dict[str, dict[int, int]]):
                Discrete, tabular, utility map whose keys
                are variables in network that are parents of a utility node, and
                values are dictionaries mapping that variable's values to a utility
                score, for example:
                  {
                    "X": {0: 20, 1: -10}
                  }
                represents a utility node with single parent X whose value of 0
                has a utility score of 20, and value 1 has a utility score of -10
        """
        self.dataframe: "pd.DataFrame" = data
        self.model: "BayesianNetwork" = BayesianNetwork(structure)
        self.model.fit(data)
        self.decision_nodes: list[str] = dec_vars
        self.query_nodes: list[str] = list(util_map.keys() - set(self.decision_nodes))
        self.utility_map: dict[str, dict[int, int]] = util_map
        self.nodes = set(self.dataframe.columns)

    def meu(self, evidence: dict[str, int]) -> tuple[dict[str, int], float]:
        """
        Computes the Maximum Expected Utility (MEU) defined as the choice of
        decision variable values that maximize expected utility of any evaluated
        chance nodes given in the agent's utility map.

        Parameters:
            evidence (dict[str, int]):
                dict mapping network variables to their observed values,
                of the format: {"Obs1": val1, "Obs2": val2, ...}

        Returns:
            tuple[dict[str, int], float]:
                A 2-tuple of the format (a*, MEU) where:
                [0] is a dictionary mapping decision variables to their MEU states
                [1] is the MEU value (a float) of that decision combo
        """
        decision_values: dict[str, set] = {
            decision_node: set(self.dataframe[decision_node])
            for decision_node in self.decision_nodes
        }
        decision_combos: list[dict[str, any]] = [
            perm
            for values in itertools.product(*decision_values.values())
            for perm in [
                {
                    list(decision_values.keys())[index]: values[index]
                    for index in range(len(values))
                }
            ]
        ]
        expected_utils: dict[float, dict[str, int]] = {
            self._calculate_expected_utility(evidence, decision): decision
            for decision in decision_combos
        }
        # Grabbing the key-value pair whose key has the max value
        max_eu: tuple[float, dict[str, int]] = max(
            expected_utils.items(), key=lambda item: item[0]
        )
        return (max_eu[1], max_eu[0])

    def _calculate_expected_utility(
        self, evidence: dict[str, int], decision: dict[str, int]
    ) -> float:
        """
        Calculates the expected utility of a decision based on the given evidence and decision.

        Parameters:
            evidence (dict[str, int]):
                dict mapping network variables to their observed values,
                of the format: {"Obs1": val1, "Obs2": val2, ...}
            decision (dict[str, int]):
                dict mapping decision variables to their values

        Returns:
            float:
                A float representing the expected utility of taking the given decision
                based on the given evidence
        """
        inference: "VariableElimination" = VariableElimination(self.model)
        evidence_with_decision: dict[str, int] = {**evidence, **decision}
        expected_util: float = 0
        for variable in self.utility_map.keys():
            query: "pd.DataFrame" = inference.query(
                [variable], evidence=evidence_with_decision
            )
            cpt_vals: "pd.Series" = query.values
            states: dict[int, str] = query.state_names[variable]
            for index, state in enumerate(states):
                utility: int = self.utility_map[variable].get(state, 0)
                expected_util += cpt_vals[index] * utility
        return expected_util

    def vpi(self, potential_evidence: str, observed_evidence: dict[str, int]) -> float:
        """
        Given some observed demographic "evidence" about a potential
        consumer, returns the Value of Perfect Information (VPI)
        that would be received on the given "potential" evidence about
        that consumer.

        Parameters:
            potential_evidence (str):
                string representing the variable name of the variable
                under consideration for potentially being obtained
            observed_evidence (dict[str, int]):
                dict mapping network variables
                to their observed values, of the format:
                {"Obs1": val1, "Obs2": val2, ...}

        Returns:
            float:
                float value indicating the VPI(potential | observed)
        """
        domain_of_potential: set[int] = set(self.dataframe[potential_evidence])
        inference: "VariableElimination" = VariableElimination(self.model)
        meu_with_potential: float = 0.0

        for domain in domain_of_potential:
            query: "pd.Series" = inference.query(
                [potential_evidence], evidence=observed_evidence
            )
            probability: float = query.values[domain]
            evidence: dict[str, any] = {**observed_evidence, potential_evidence: domain}
            product: float = probability * self.meu(evidence)[1]
            meu_with_potential += product

        meu_of_observed: float = self.meu(observed_evidence)[1]
        vpi: float = meu_with_potential - meu_of_observed
        return vpi if vpi > 0 else 0

    def most_likely_consumer(self, evidence: dict[str, int]) -> dict[str, int]:
        """
        Given some known traits about a particular consumer, makes the best guess
        of the values of any remaining hidden variables and returns the completed
        data point as a dictionary of variables mapped to their most likely values.
        (Observed evidence will always have the same values in the output).

        Parameters:
            evidence (dict[str, int]):
                dict mapping network variables
                to their observed values, of the format:
                {"Obs1": val1, "Obs2": val2, ...}

        Returns:
            dict[str, int]:
                The most likely values of all variables given what's already
                known about the consumer.
        """
        inference: "VariableElimination" = VariableElimination(self.model)
        query: set[str] = self.nodes - set(self.decision_nodes) - set(evidence.keys())
        most_likely: dict[str, int] = inference.map_query(
            variables=query, evidence=evidence
        )
        most_likely.update(evidence)
        return most_likely
