import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt

df = pd.read_stata('../data/IBNET3a4py.dta')
df.head(14).T

df = pd.read_stata('../data/IBNET3a4py.dta')
df.head(14).T

palette = sns.color_palette("tab10")
sns.set(style="whitegrid") 

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

# Improve layout and show the plot
#plt.tight_layout()
plt.show()
