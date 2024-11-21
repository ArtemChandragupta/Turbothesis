from   scipy.interpolate import make_interp_spline
import matplotlib.pyplot as plt
import numpy             as np
import pandas            as pd

otn = 0.878

t = np.arange(0.11, 1.368, 0.01)
plt.plot(t, (0.935-0.777*t+0.503*t**2), '-')

xi = [otn, otn]
yi = [0.6,   0.85 ]
plt.plot(xi, yi, '--', label = r'$\dfrac{\Omega}{\varphi}=$' + f'{otn}')

plt.ylabel(r'$\left(\dfrac{\bar h_1}{\varphi}\right)_{\frac{b}{t}=1}$')
plt.xlabel(r'$\dfrac{\Omega}{\varphi}$')
plt.legend()
plt.grid(True)

plt.show()
