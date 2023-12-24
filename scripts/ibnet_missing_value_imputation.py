# scripts/ibnet_missing_data_imputation.py
# author: Qiao Wang
# date: 2023-12-23

import os
import sys
sys.path.append(os.path.join(os.path.dirname(__file__), '..'))

# Import your custom imputation functions
from src.visualize_missing_data import missing_data_visualize
from src.impute_missing_forest import missing_forest_impute
from src.impute_knn import knn_impute
from src.impute_mice import mice_impute

script_dir = os.path.dirname(__file__)
repo_root = os.path.join(script_dir, '..')

def main():
    # Define the file paths
    input_dta = os.path.join(repo_root, 'data', 'IBNET3a4py.dta')
    figures_output_file = os.path.join(repo_root, 'figures', 'missing_data_visualization.png')
    missforest_output_dta = os.path.join(repo_root, 'data', 'IBNET3-mf-imputed.dta')
    knn_output_dta = os.path.join(repo_root, 'data', 'IBNET3-knn-imputed.dta')
    mice_output_dta = os.path.join(repo_root, 'data', 'IBNET3-mice-imputed.dta')

    # Define the decile variable
    decile_var = 's6_decile'

    # Visualize Missing Values
    print("Missing values of orginal data...")
    missing_data_visualize(input_dta, figures_output_file)
    print("Missing value pattern figigure saved.")

    # Run MissForest Imputation
    print("Starting MissForest imputation...")
    missing_forest_impute(input_dta, missforest_output_dta, decile_var)
    print("MissForest imputation completed.")

    # Run KNN Imputation
    print("Starting KNN imputation...")
    knn_impute(input_dta, knn_output_dta, decile_var)
    print("KNN imputation completed.")

    # Run MICE Imputation
    print("Starting MICE imputation...")
    mice_impute(input_dta, mice_output_dta, decile_var)
    print("MICE imputation completed.")

if __name__ == '__main__':
    main()