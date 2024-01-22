import numpy as np
import numpy.typing as npt
import pandas as pd
import copy
from sklearn import preprocessing  # type: ignore
from sklearn.impute import SimpleImputer  # type: ignore
from sklearn.linear_model import LogisticRegression  # type: ignore
from sklearn.metrics import classification_report  # type: ignore
from sklearn.preprocessing import KBinsDiscretizer, OneHotEncoder # type: ignore
from pandas import Index


class SalaryPredictor:
    """
    A Logistic Regression Classifier used to predict someone's salary (from LONG ago)
    based upon their demographic characteristics like education level, age, etc. This
    task is turned into a binary-classification task with two labels:
      y = 0: The individual made less than or equal to 50k
      y = 1: The individual made more than 50k

    [!] You are free to choose whatever attributes needed to implement the SalaryPredictor;
    unlike the ToxicityFilter, there are no constraints of what you must include here.
    """

    def __init__(self, X_train: pd.DataFrame, y_train: pd.DataFrame):
        """
        Creates a new SalaryPredictor trained on the given features from the
        preprocessed census data to predicted salary labels. Does so by:
        1. Preprocesses the training data
        2. Fits the Logistic Regression model to the transformed features
        3. Saves this model as an attribute for later use

        Parameters:
            X_train (pd.DataFrame):
                Pandas DataFrame consisting of the sample rows of attributes
                pertaining to each individual

            y_train (pd.DataFrame):
                Pandas DataFrame consisting of the sample rows of labels
                pertaining to each person's salary
        """
        features: np.ndarray = self.preprocess(X_train, True)
        self.lrbc: LogisticRegression = LogisticRegression(max_iter=5000)
        self.lrbc.fit(features, y_train)

    def preprocess(self, features: pd.DataFrame, training: bool = False) -> npt.NDArray:
        """
        Takes in the raw rows of individuals' characteristics to be used for
        salary classification and converts them into the numerical features that
        can be used both during training and classification by the LR model.

        Parameters:
            features [pd.DataFrame]:
                The data frame containing all inputs to be preprocessed where the
                rows are 1 per person to classify and the columns are their attributes
                that may require preprocessing, e.g., one-hot encoding the categorical
                attributes like education.

            training [bool]:
                Whether or not this preprocessing call is happening during training
                (i.e., in the SalaryPredictor's constructor) or during testing (i.e.,
                in the SalaryPredictor's classify method). If set to True, all preprocessing
                attributes like imputers and OneHotEncoders must be fit before transforming
                any features to numerical representations. If set to False, should NOT fit
                any preprocessors, and only use their transform methods.

        Returns:
            np.ndarray:
                Numpy Array composed of numerical features converted from the raw inputs.
        """
        features_copy: pd.DataFrame = copy.deepcopy(features)
        features_copy.replace(" ", "", inplace=True)
        features_copy.replace("?", np.nan, inplace=True)

        categorical_columns: Index[str] = features_copy.select_dtypes(
            include=["object"]
        ).columns
        numerical_columns: Index[str] = features_copy.select_dtypes(
            include=["number"]
        ).columns

        if training:
            self.imputer_numerical: SimpleImputer = SimpleImputer(
                missing_values=np.nan, strategy="mean"
            )
            self.imputer_categorical: SimpleImputer = SimpleImputer(
                missing_values=np.nan, strategy="most_frequent"
            )
            self.discretizer: KBinsDiscretizer = preprocessing.KBinsDiscretizer(
                n_bins=5, encode="ordinal", strategy="kmeans"
            )
            self.encoder: OneHotEncoder = preprocessing.OneHotEncoder(
                sparse_output=False, handle_unknown="ignore"
            )

            features_copy[numerical_columns] = self.imputer_numerical.fit_transform(
                features_copy[numerical_columns]
            )
            features_copy[categorical_columns] = self.imputer_categorical.fit_transform(
                features_copy[categorical_columns]
            )
            numerical_vectorized: np.ndarray = self.discretizer.fit_transform(
                features_copy[numerical_columns]
            )
            categorical_vectorized: np.ndarray = self.encoder.fit_transform(
                features_copy[categorical_columns]
            )
        else:
            features_copy[numerical_columns] = self.imputer_numerical.transform(
                features_copy[numerical_columns]
            )
            features_copy[categorical_columns] = self.imputer_categorical.transform(
                features_copy[categorical_columns]
            )
            numerical_vectorized = self.discretizer.transform(
                features_copy[numerical_columns]
            )
            categorical_vectorized = self.encoder.transform(
                features_copy[categorical_columns]
            )
        return pd.concat(
            [pd.DataFrame(numerical_vectorized), pd.DataFrame(categorical_vectorized)],
            axis=1,
        ).values

    def classify(self, X_test: pd.DataFrame) -> list[int]:
        """
        Takes as input a data frame containing input user demographics, uses the predictor's
        preprocessing to transform these into the ndarray of numerical features, and then
        returns a list of salary classifications, one for each individual.

        [!] Note: Should use the preprocess method with training parameter set to False!

        Parameters:
            X_test (list[str]):
                A data frame where each row is a new individual with characteristics like
                age, education, etc. that the salary predictor must assess.

        Returns:
            list[int]:
                A list of classifications, one for each individual, where the
                index of the output class corresponds to the index of input person.
                The ints represent the classes such that y=0: <=50k and y=1: >50k
        """
        return list(self.lrbc.predict(self.preprocess(X_test, False)))

    def test_model(
        self, X_test: "pd.DataFrame", y_test: "pd.DataFrame"
    ) -> tuple[str, dict]:
        """
        Takes the test-set as input (2 DataFrames consisting of test inputs
        and their associated labels), classifies each, and then prints
        the classification_report on the expected vs. given labels.

        Parameters:
            X_test [pd.DataFrame]:
                Pandas DataFrame consisting of the test rows of individuals

            y_test [pd.DataFrame]:
                Pandas DataFrame consisting of the test rows of labels pertaining
                to each individual

        Returns:
            tuple[str, dict]:
                Returns the classification report in two formats as a tuple:
                [0] = The classification report as a prettified string table
                [1] = The classification report in dictionary format
                In either format, contains information on the accuracy of the
                classifier on the test data.
        """
        prediction = self.classify(X_test)
        return (
            classification_report(y_test, prediction, output_dict=False),
            classification_report(y_test, prediction, output_dict=True),
        )
