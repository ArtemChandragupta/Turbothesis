from   scipy.interpolate import make_interp_spline
import matplotlib.pyplot as plt
import numpy             as np
import pandas            as pd


t = np.arange(0.11, 1.368, 0.01)
plt.plot(t, (0.935-0.777*t+0.503*t**2), '-')

xi = [0.484, 0.484]
yi = [0.6,   0.85 ]
plt.plot(xi, yi, '--', label = r'$\Omega/\varphi=0.484$')

plt.ylabel(r'$h/\varphi$')
plt.xlabel(r'$\Omega/\varphi$')
plt.legend()
plt.grid(True)

plt.show()
