import matplotlib.pyplot as plt
import pandas as pd

df = pd.read_csv("../../data/10_us_economic_data.csv")
df.plot(y='JobsAdded')
plt.show()

