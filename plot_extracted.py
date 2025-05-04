import numpy as np
import matplotlib.pyplot as plt
from matplotlib import colors

results = []

with open("./extracted_data.txt", "r") as f:
    for line in f:
        results.append(int(line))


somma = sum(results)
media = somma / len(results)

print(media)

x = np.asarray(results)

fig, ax = plt.subplots()


N, bins, patches = ax.hist(x, bins=64, linewidth=0.5, edgecolor="white", density=True)

# We'll color code by height, but you could use any scalar
fracs = N / N.max()

# we need to normalize the data to 0..1 for the full range of the colormap
norm = colors.Normalize(fracs.min(), fracs.max())

# Now, we'll loop through our objects and set the color of each accordingly
for thisfrac, thispatch in zip(fracs, patches):
    color = plt.cm.viridis(norm(thisfrac))
    thispatch.set_facecolor(color)

#ax.axline(media, media)

plt.axvline(x=media, color='red', linestyle='--', linewidth=2)

plt.axvline(x=2*media, color='red', linestyle='--', linewidth=2)


plt.show()