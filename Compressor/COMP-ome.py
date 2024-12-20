from   scipy.interpolate import make_interp_spline
import matplotlib.pyplot as plt
import numpy             as np
import pandas            as pd

fig, ax = plt.subplots()

x = np.array([0.11, 0.214,0.25, 0.474,0.550,0.630,0.704,0.727, 0.756,0.792, 0.831,0.863,0.922,1.041,1.097,1.303,1.368])
y = np.array([0.847,0.794,0.778,0.691,0.667,0.646,0.634,0.631, 0.629,0.629, 0.632,0.635,0.646,0.675,0.693,0.779,0.809])

X_Y_Spline = make_interp_spline(x, y)
X_ = np.linspace(x.min(), x.max(), 500)
Y_ = X_Y_Spline(X_)
ax.plot(X_, Y_)

xi = [0.503, 0.503]
yi = [0.6,   0.85 ]
ax.plot(xi, yi, '--', label = r'$\Omega / \varphi=0.503$')

ax.set_ylabel(r'$h/\varphi$')
ax.set_xlabel(r'$\Omega/\varphi$')
plt.legend()
plt.grid(True)

plt.show()
