# src/impute_missing_forest.py
# author: Qiao Wang
# date: 2023-12-23

import pandas as pd
import sklearn.neighbors._base
import sys
sys.modules['sklearn.neighbors.base'] = sklearn.neighbors._base
from missingpy import MissForest
import warnings
import logging

def missing_forest_impute(input_dta, output_dta, block_var):
    """
    Performs missing data imputation using MissForest on specified decile groups.

    Parameters:
    input_dta (str): Path to the input .dta file.
    output_dta (str): Path to save the output .dta file with imputed values.
    block_var (str): The column name used for dividing data into blocks.
    """
    # Set up logging and warning suppression
    logging.getLogger().setLevel(logging.WARNING)
    warnings.filterwarnings('ignore', message="No missing value located; returning original dataset.")
    warnings.filterwarnings('ignore', category=FutureWarning)

    # Load data
    df = pd.read_stata(input_dta)

    # Perform MissForest imputation
    for idx in df[block_var].unique():
        subset = df[df[block_var] == idx]  # Get the subset of the dataframe
        
        # Identify columns with all missing values
        cols_fully_missing = subset.columns[subset.isnull().all()]
        
        # Continue only if there's at least one column with some data
        if not subset.drop(columns=cols_fully_missing).empty:
            imputer = MissForest(max_iter=15, n_jobs=-1)
            # Impute only on columns that are not fully missing
            x_imp = imputer.fit_transform(subset.drop(columns=cols_fully_missing))
            
            # Update the dataframe with imputed values
            df.loc[df[block_var] == idx, subset.columns.difference(cols_fully_missing)] = x_imp
        else:
            print(f"No usable data for {block_var} = {idx}. Skipping...")
    
    # Save the imputed dataframe to a new .dta file
    df.to_stata(output_dta)

# Example usage:
# missing_forest_impute('../data/IBNET3a4py.dta', '../data/IBNET3-mf-imputed.dta', 's6_decile')
