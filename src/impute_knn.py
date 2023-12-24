# src/impute_knn.py
# author: Qiao Wang
# date: 2023-12-23

import pandas as pd
from sklearn.impute import KNNImputer

def knn_impute(input_dta, output_dta, block_var):
    """
    Performs missing data imputation using K-Nearest Neighbors on specified decile groups.

    Parameters:
    input_dta (str): Path to the input .dta file.
    output_dta (str): Path to save the output .dta file with imputed values.
    block_var (str): The column name used for dividing data into blocks.
    """
    # Load data
    df = pd.read_stata(input_dta)

    # Initialize the KNN Imputer
    imputer = KNNImputer(n_neighbors=5)

    # Perform KNN imputation for each unique value in the decile variable
    for idx in df[block_var].unique():
        # Subsetting the dataframe for the current decile
        idx_rows = df[df[block_var] == idx].index
        
        # Ensure the subset is not empty
        if not idx_rows.empty:
            # Impute using only the rows from the current decile
            knn_imp = imputer.fit_transform(df.loc[idx_rows, :])
            
            # Ensure the output shape matches and update the dataframe
            if len(idx_rows) == knn_imp.shape[0]:
                df.loc[idx_rows, :] = knn_imp
            else:
                print(f"Shape mismatch error for {block_var} = {idx}")
        else:
            print(f"No data for {block_var} = {idx}. Skipping...")

    # Save the imputed dataframe to a new .dta file
    df.to_stata(output_dta)

# Example usage:
# knn_impute('../data/IBNET3a4py.dta', '../data/IBNET3-knn-imputed.dta', 's6_decile')
