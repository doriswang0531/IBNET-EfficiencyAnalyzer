# CHANGELOG 🌟

This document outlines the improvements and changes made to the project, where I meticulously reproduce Basab's analysis of the productivity and efficiency of water utilities using the International Benchmarking Network for Water and Sanitation Utilities (IBNET) dataset. This document 📝 serves as a comprehensive record of all the enhancements, modifications, and updates that have been integrated into our project over time, particularly after the publication of PER report. It includes detailed descriptions of additional data cleaning procedures 🧹, fixes for any bugs 🐛 encountered, expansions in our analytical scope 🔍, and enriched narratives 📖 to better elucidate our findings. The changelog aims to provide stakeholders with a transparent view of the project's evolution, ensuring that every step towards improvement and refinement is clearly documented and easy to follow.

paper 1: missing data imputation using ML for IBNET (only available dataset, motivations, two approaches & monetary value meaning) + descriptive analysis

paper 2: cost and productivty estimation and monetary hidden cost

---

## [Paper Draft Version 2022.09.24] - Update 2023-12

### Narratives 📝

1. Structure of Datasets
   Original IBNET data: 5191 utilities, 1994 – 2020 (17 years), 141,426 obs.
   IBNET3.dta: after selecting eligible utilities with at least 7 data points available for water production or operating cost – 1,619 utilities, 22,666 obs. Don't run the PART 1 session of the do file 01_data_prepare, or you will a different IBNET3.dta from Basab's one. Just use the IBNET3.dta as the inital dataset to start the project. Don't start from IBNET1.dta.
2. Starting from IBNET3.dta, 1566 unique utilities, dropped 3 utilities with s6 missing across all years.

### Enhancement🚀

1. **Environment Configuration**: An `environment.yml` file was added to address environmental issues encountered with Python scripts. This addition addresses import errors from dependencies, such as `missingpy`, specifically issues related to importing `_check_weights` from `sklearn.neighbors._base`
2. ```
    ----> 1 import missingpy

    File c:\Users\doris\miniconda3\envs\573\Lib\site-packages\missingpy\__init__.py:1
    ----> 1 from .knnimpute import KNNImputer
        2 from .missforest import MissForest
        4 __all__ = ['KNNImputer', 'MissForest']

    File c:\Users\doris\miniconda3\envs\573\Lib\site-packages\missingpy\knnimpute.py:13
        11 from sklearn.utils.validation import check_is_fitted
        12 from sklearn.utils.validation import FLOAT_DTYPES
    ---> 13 from sklearn.neighbors.base import _check_weights
        14 from sklearn.neighbors.base import _get_weights
        16 from .pairwise_external import pairwise_distances

    ImportError: cannot import name '_check_weights' from 'sklearn.neighbors._base' (c:\Users\doris\miniconda3\envs\573\Lib\site-packages\sklearn\neighbors\_base.py)
   ```

   Users experiencing similar issues can refer to a comprehensive solution on [StackOverflow](https://stackoverflow.com/questions/75633185/importerror-cannot-import-name-check-weights-from-sklearn-neighbors-base).
3. **Python Scripts for Data Analysis**: New Python scripts were introduced for visualizing missing data patterns and performing imputation. The scripts utilize Missing Forest, kNN, and MICE algorithms to ensure a reproducible process for handling missing values.e

### Fixed 🛠️

1. **Inconsistent Scales Across Years**: Identified and corrected inconsistencies in scales across different years for certain utilities. This fix ensures data consistency and accuracy in longitudinal analyses.
2. **Decile Generation Method**: Updated the methodology for generating utility deciles. Previously direct usage of the 's6' variable (served population) might have led to inaccuracies. Now, the median served population for each utility is calculated first, and these medians are used to generate deciles. This enhancement improves the precision of utility classification based on population served.
3. **Utilities with Consistently Missing Data**: Removed three utilities with consistently missing 's6' values across all years to maintain data integrity and analysis validity.
4. **Improved Missing Value Imputation Strategy**: Optimized the imputation strategy for missing values. Instead of creating subsets/blocks by both year and 's6_decile', which often led to insufficient data for imputation, the process now solely utilizes 's6_decile' for creating subsets. This change is applied across Missing Forest, kNN, and MICE algorithms, enhancing the robustness and accuracy of imputations.

### Added 🆕

### Cleaned 🧹

### Updated 🔄

### Enhancement🚀
