from   matplotlib.pyplot import figure
import matplotlib.pyplot as plt
import numpy             as np
import pandas            as pd

data1 = pd.read_csv('1.csv').loc[1:22,['ПИК','КПДЕ','НЕ','ФИ']].apply(lambda col:pd.to_numeric(col, errors='coerce'))
data2 = pd.read_csv('2.csv').loc[1:22,['ПИК','КПДЕ','НЕ','ФИ']].apply(lambda col:pd.to_numeric(col, errors='coerce'))
data3 = pd.read_csv('3.csv').loc[1:22,['ПИК','КПДЕ','НЕ','ФИ']].apply(lambda col:pd.to_numeric(col, errors='coerce'))
data4 = pd.read_csv('4.csv').loc[1:22,['ПИК','КПДЕ','НЕ','ФИ']].apply(lambda col:pd.to_numeric(col, errors='coerce'))
data5 = pd.read_csv('5.csv').loc[1:22,['ПИК','КПДЕ','НЕ','ФИ']].apply(lambda col:pd.to_numeric(col, errors='coerce'))

x1 = data1.loc[:,['ПИК' ]]
f1 = data1.loc[:,['ФИ'  ]]
h1 = data1.loc[:,['НЕ'  ]]
k1 = data1.loc[:,['КПДЕ']]

x2 = data2.loc[:,['ПИК' ]]
f2 = data2.loc[:,['ФИ'  ]]
h2 = data2.loc[:,['НЕ'  ]]
k2 = data2.loc[:,['КПДЕ']]

x3 = data3.loc[:,['ПИК' ]]
f3 = data3.loc[:,['ФИ'  ]]
h3 = data3.loc[:,['НЕ'  ]]
k3 = data3.loc[:,['КПДЕ']]

x4 = data4.loc[:,['ПИК' ]]
f4 = data4.loc[:,['ФИ'  ]]
h4 = data4.loc[:,['НЕ'  ]]
k4 = data4.loc[:,['КПДЕ']]

x5 = data5.loc[:,['ПИК' ]]
f5 = data5.loc[:,['ФИ'  ]]
h5 = data5.loc[:,['НЕ'  ]]
k5 = data5.loc[:,['КПДЕ']]

fig, (ax1, ax2, ax3) = plt.subplots(1, 3,figsize=(14,5))
ax1.grid(True)
ax2.grid(True)
ax3.grid(True)

ax1.plot(x1,f1,'o-', label = r'$T_3^* = 1543 \ K$', markersize=2)
ax1.plot(x2,f2,'o-', label = r'$T_3^* = 1593 \ K$', markersize=2)
ax1.plot(x3,f3,'o-', label = r'$T_3^* = 1643 \ K$', markersize=2)
ax1.plot(x4,f4,'o-', label = r'$T_3^* = 1693 \ K$', markersize=2)
ax1.plot(x5,f5,'o-', label = r'$T_3^* = 1743 \ K$', markersize=2)

ax2.plot(x1,h1,'o-', label = r'$T_3^* = 1543 \ K$', markersize=2)
ax2.plot(x2,h2,'o-', label = r'$T_3^* = 1593 \ K$', markersize=2)
ax2.plot(x3,h3,'o-', label = r'$T_3^* = 1643 \ K$', markersize=2)
ax2.plot(x4,h4,'o-', label = r'$T_3^* = 1693 \ K$', markersize=2)
ax2.plot(x5,h5,'o-', label = r'$T_3^* = 1743 \ K$', markersize=2)

ax3.plot(x1,k1,'o-', label = r'$T_3^* = 1543 \ K$', markersize=2)
ax3.plot(x2,k2,'o-', label = r'$T_3^* = 1593 \ K$', markersize=2)
ax3.plot(x3,k3,'o-', label = r'$T_3^* = 1643 \ K$', markersize=2)
ax3.plot(x4,k4,'o-', label = r'$T_3^* = 1693 \ K$', markersize=2)
ax3.plot(x5,k5,'o-', label = r'$T_3^* = 1743 \ K$', markersize=2)

ax1.set_box_aspect(9/8)
ax1.set_xlabel(r'$\pi_k^*$', loc='right', fontsize=20)
ax1.set_ylabel(r'$\varphi$', loc='top'  , fontsize=20,rotation=0,labelpad=-15)
ax1.legend()
ax1.set_ylim(0.23, 0.69999)
ax1.set_xlim(0   , 43     )

ax1.plot([16,16], [0    ,0.539], 'k--', linewidth = '1')
ax1.plot([0 ,16], [0.539,0.539], 'k--', linewidth = '1')
ax1.set_xticks([0, 10, 16, 20, 30, 40])
ax1.set_yticks([0.3, 0.4, 0.5, 0.539, 0.6])

ax2.set_box_aspect(9/8)
ax2.set_xlabel(r'$\pi_k^*$', loc='right', fontsize=20)
ax2.set_ylabel(r'$H_e$'    , loc='top'  , fontsize=20,rotation=0,labelpad=-20)
ax2.legend()
ax2.set_ylim(251, 540)
ax2.set_xlim(0  , 43 )

ax2.plot([16,16], [0    ,490.3], 'k--', linewidth = '1')
ax2.plot([0 ,16], [490.3,490.3], 'k--', linewidth = '1')
ax2.set_xticks([0, 10, 16, 20, 30, 40])
ax2.set_yticks([300, 350, 400, 450, 490.3, 500])

ax3.set_box_aspect(9/8)
ax3.set_xlabel(r'$\pi_k^*$', loc='right', fontsize=20)
ax3.set_ylabel(r'$\eta_e$' , loc='top'  , fontsize=20,rotation=0,labelpad=-20)
ax3.legend()
ax3.set_ylim(0.21, 0.44)
ax3.set_xlim(0   , 43  )

ax3.plot([16,16], [0    ,0.387], 'k--', linewidth = '1')
ax3.plot([0 ,16], [0.387,0.387], 'k--', linewidth = '1')
ax3.set_xticks([0, 10, 16, 20, 30, 40])
ax3.set_yticks([0.25, 0.3, 0.35, 0.387, 0.4])

fig.tight_layout()
plt.savefig('A2GTP.pgf', bbox_inches='tight', backend='pgf')
