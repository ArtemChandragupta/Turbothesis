import matplotlib.pyplot as plt
import numpy             as np
import pandas            as pd

data1 = pd.read_csv('1.csv').loc[1:22,['ПИК','КПДЕ','НЕ','ФИ']].apply(lambda col:pd.to_numeric(col, errors='coerce'))
data2 = pd.read_csv('2.csv').loc[1:22,['ПИК','КПДЕ','НЕ','ФИ']].apply(lambda col:pd.to_numeric(col, errors='coerce'))
data3 = pd.read_csv('3.csv').loc[1:22,['ПИК','КПДЕ','НЕ','ФИ']].apply(lambda col:pd.to_numeric(col, errors='coerce'))
data4 = pd.read_csv('4.csv').loc[1:22,['ПИК','КПДЕ','НЕ','ФИ']].apply(lambda col:pd.to_numeric(col, errors='coerce'))
data5 = pd.read_csv('5.csv').loc[1:22,['ПИК','КПДЕ','НЕ','ФИ']].apply(lambda col:pd.to_numeric(col, errors='coerce'))

x1 = data1.loc[:,['ПИК' ]]
y1 = data1.loc[:,['КПДЕ']]
x2 = data2.loc[:,['ПИК' ]]
y2 = data2.loc[:,['КПДЕ']]
x3 = data3.loc[:,['ПИК' ]]
y3 = data3.loc[:,['КПДЕ']]
x4 = data4.loc[:,['ПИК' ]]
y4 = data4.loc[:,['КПДЕ']]
x5 = data5.loc[:,['ПИК' ]]
y5 = data5.loc[:,['КПДЕ']]

fig, ax = plt.subplots()

ax.plot(x1,y1,'o-', label = r'$T_3^* = 1543 \ K$', markersize=4)
ax.plot(x2,y2,'^-', label = r'$T_3^* = 1593 \ K$', markersize=4)
ax.plot(x3,y3,'s-', label = r'$T_3^* = 1643 \ K$', markersize=4)
ax.plot(x4,y4,'^-', label = r'$T_3^* = 1693 \ K$', markersize=4)
ax.plot(x5,y5,'o-', label = r'$T_3^* = 1743 \ K$', markersize=4)

ax.set_box_aspect(1/1.5)

ax.set_xlabel(r'$\pi_k^*$',fontsize=14,loc='right'           ,labelpad=-13)
ax.set_ylabel(r'$\eta_e$' ,fontsize=14,loc='top'  ,rotation=0,labelpad=-20)
ax.legend()

plt.grid(True)

plt.savefig('KPD.pgf', bbox_inches='tight', backend='pgf')
