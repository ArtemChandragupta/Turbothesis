from   scipy.interpolate import make_interp_spline
import matplotlib        as mpl
import matplotlib.pyplot as plt
import numpy             as np
import pandas            as pd

fig, ax = plt.subplots()

J = 0.796

x = np.array([0.5, 0.551, 0.6  , 0.7  , 0.9 , 1, 1.279, 1.653, 1.886])
y = np.array([0.6, 0.654, 0.697, 0.788, 0.94, 1, 1.194, 1.447, 1.595])

X_Y_Spline = make_interp_spline(x, y)
X_ = np.linspace(x.min(), x.max(), 500)
Y_ = X_Y_Spline(X_)
ax.plot(X_, Y_)

yi = [J  , J    ]
xi = [0.5, 1.886]
ax.plot(xi, yi, '--', label = f'$J={J}$')
ax.set_box_aspect(1/2)

ax.set_ylabel(r'$J$'    )
ax.set_xlabel(r'$b / t$')
ax.legend(    )
ax.grid  (True)

plt.savefig('COMP-J.pgf', bbox_inches='tight', backend='pgf')
