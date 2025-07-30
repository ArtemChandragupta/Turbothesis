from   scipy.interpolate import make_interp_spline
import matplotlib.pyplot as plt
import numpy             as np
import pandas            as pd

otn = 0.878

t = np.arange(0.11, 1.368, 0.01)
plt.plot(t, (0.935-0.777*t+0.503*t**2), '-')

xi = [otn, otn]
yi = [0.6,   0.85 ]
plt.plot(xi, yi, '--', label = r'$\frac{\Omega}{\varphi}=$' + f'{otn}')

# ax.set_box_aspect(1/1.5)

plt.ylabel(r'$\left(\frac{\bar h_1}{\varphi}\right)_{\frac{b}{t}=1}$')
plt.xlabel(r'$\Omega / \varphi$')
plt.legend()
plt.grid(True)

plt.savefig('COMP-ome-approx.pgf', bbox_inches='tight', backend='pgf')
