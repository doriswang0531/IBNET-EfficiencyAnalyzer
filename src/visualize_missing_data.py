# src/visualize_missing_data.py
# author: Qiao Wang
# date: 2023-12-23

import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt

def missing_data_visualize(input_file, output_file):
    """
    Visualizes the missing data pattern of the provided .dta file and saves the figure.

    Parameters:
    input_file (str): Path to the input .dta file.
    output_file (str): Path to save the output figure.
    """
    # Load data
    df = pd.read_stata(input_file)
    
    # Set up the palette and style
    palette = sns.color_palette("tab10")
    sns.set(style="whitegrid") 
    
    # Create the missing data plot
    g = sns.displot(
        data=df.isnull().melt(value_name='missing'),
        y='variable',
        hue='missing',
        multiple='fill',
        palette=palette,
        height=6,
        aspect=0.8
    )
    
    # Add a vertical line at 0.4 threshold
    plt.axvline(0.4, color='r', ls='--')
    
    # Improve layout
    plt.tight_layout()
    
    # Save the plot
    plt.savefig(output_file)

    # Close the plot
    plt.close()

# Example Usage:
# missing_data_visualize('../data/IBNET3a4py.dta', '../figures/missing_data_visualization.png')
