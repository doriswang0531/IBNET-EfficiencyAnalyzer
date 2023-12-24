# CHANGELOG 🌟

This document outlines the improvements and changes made to the project, where I meticulously reproduce Basab's analysis of the productivity and efficiency of water utilities using the International Benchmarking Network for Water and Sanitation Utilities (IBNET) dataset. This document 📝 serves as a comprehensive record of all the enhancements, modifications, and updates that have been integrated into our project over time, particularly after the publication of PER report. It includes detailed descriptions of additional data cleaning procedures 🧹, fixes for any bugs 🐛 encountered, expansions in our analytical scope 🔍, and enriched narratives 📖 to better elucidate our findings. The changelog aims to provide stakeholders with a transparent view of the project's evolution, ensuring that every step towards improvement and refinement is clearly documented and easy to follow.

paper 1: missing data imputation using ML for IBNET (only available dataset, motivations, two approaches & monetary value meaning) + descriptive analysis

paper 2: cost and productivty estimation and monetary hidden cost

---

## [Paper Draft Version 2022.09.24] - 2023-12-21 ~ 2023-12-25

### Narratives 📝

1. Structure of Datasets
   Original IBNET data: 5191 utilities, 1994 – 2020 (17 years), 141,426 obs.
   IBNET3.dta: after selecting eligible utilities with at least 7 data points available for water production or operating cost – 1,619 utilities, 22,666 obs. Don't run the PART 1 session of the do file 01_data_prepare, or you will a different IBNET3.dta from Basab's one. Just use the IBNET3.dta as the inital dataset to start the project. Don't start from IBNET1.dta.
2. Starting from IBNET3.dta, 1566 unique utilities, dropped 3 utilities with s6 missing across all years.
3. 

### Added 🆕

1. Added envrionment,yml (link here) file to solve python scripts' envrionmental issues:

   ```
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

   To fix this issue, refer to this [post](https://stackoverflow.com/questions/75633185/importerror-cannot-import-name-check-weights-from-sklearn-neighbors-base) on stackoverflow.
2. Created Python scripts (link here) for visualizing the pattern of missing values and imputation with missing forest, kNN and MICE algorithms for reproducible purpose
3. 

### Fixed 🛠️

1. Flagged out and fixed the inconsistent scales across years for some utilities
2. Updated the method for generating deciles: Instead of directly employing the 's6' variable, which represents the served population, we have refined our approach. Now, we first calculate the median value of the served population for each utility. Subsequently, we use these median values to generate deciles. This change aims to provide a more accurate and representative classification of utilities based on the population they serve
3. Dropped three utilities with missing s6 across all years
4. Instread of imputing missing values by subset/block created by year and s6_decile, which does not have enough number of data, used only s6_decile as subset to impute missing values based on missing forest, kNN and MICE algorithms.
5. 

### Cleaned 🧹

### Updated 🔄

### Enhancement🚀
