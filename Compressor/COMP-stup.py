from   matplotlib        import rc
import matplotlib.pyplot as plt
import matplotlib        as mpl
import numpy             as np
import pandas            as pd

fig, ax = plt.subplots()

ax.plot([1, 7, 13, 15], [17.55, 31.0499, 31.0499, 27]                              )
ax.plot([0, 16       ], [17.55, 17.55               ],'r--',label = r'$h_1$'       )
ax.plot([0, 16       ], [31.0499, 31.0499           ],'g--',label = r'$h_{\mathrm{ср. ст.}}$')
ax.plot([0, 16       ], [27, 27                     ],'m--',label = r"$h_{\mathrm{п} }$")

ax.set_xlim(0, 16)
plt.xticks(np.arange(0 , 16, 1.0))
plt.yticks(np.arange(16, 32, 2.0))

ax.set_box_aspect(1/2)

ax.set_ylabel(r'$h, \mathrm{кДж} / \mathrm{кг}$')
ax.set_xlabel(r'$i$')
ax.legend()

plt.grid(True)

plt.savefig('COMP-stup.pgf', bbox_inches='tight', backend='pgf')
