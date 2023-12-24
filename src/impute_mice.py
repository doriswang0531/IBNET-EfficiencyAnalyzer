# src/impute_mice.py
# author: Qiao Wang
# date: 2023-12-23

import pandas as pd
from fancyimpute import IterativeImputer
import numpy as np

def mice_impute(input_dta, output_dta, block_var):
    """
    Performs missing data imputation using MICE on specified decile groups.

    Parameters:
    input_dta (str): Path to the input .dta file.
    output_dta (str): Path to save the output .dta file with imputed values.
    block_var (str): The column name used for dividing data into blocks.
    """
    # Load data
    df = pd.read_stata(input_dta)

    # Initialize MICE imputer
    mice_imputer = IterativeImputer(
        missing_values=np.nan, 
        sample_posterior=False, 
        max_iter=100, 
        tol=0.001, 
        random_state=0,
        n_nearest_features=30, 
        initial_strategy='mean'
    )

    # Perform MICE imputation for each unique value in the decile variable
    for idx in df[block_var].unique():
        # Get the subset of the DataFrame for the current index value
        subset = df[df[block_var] == idx]
        
        # Ensure the subset is not empty
        if not subset.empty:
            # Perform MICE imputation on the subset
            mice_imp = mice_imputer.fit_transform(subset)
            
            # Assign the imputed data back to the DataFrame
            df.loc[df[block_var] == idx, :] = mice_imp
        else:
            # Print a message or handle cases where the subset is empty
            print(f"No data found for {block_var} = {idx}")

    # Save the imputed dataframe to a new .dta file
    df.to_stata(output_dta)

# Example usage:
# mice_impute('../data/IBNET3a4py.dta', '../data/IBNET3-mice-imputed.dta', 's6_decile')
