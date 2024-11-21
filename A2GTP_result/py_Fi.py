import matplotlib.pyplot as plt
import numpy             as np
import pandas            as pd

data1 = pd.read_csv('1.csv').loc[1:22,['ПИК','КПДЕ','НЕ','ФИ']].apply(lambda col:pd.to_numeric(col, errors='coerce'))
data2 = pd.read_csv('2.csv').loc[1:22,['ПИК','КПДЕ','НЕ','ФИ']].apply(lambda col:pd.to_numeric(col, errors='coerce'))
data3 = pd.read_csv('3.csv').loc[1:22,['ПИК','КПДЕ','НЕ','ФИ']].apply(lambda col:pd.to_numeric(col, errors='coerce'))
data4 = pd.read_csv('4.csv').loc[1:22,['ПИК','КПДЕ','НЕ','ФИ']].apply(lambda col:pd.to_numeric(col, errors='coerce'))
data5 = pd.read_csv('5.csv').loc[1:22,['ПИК','КПДЕ','НЕ','ФИ']].apply(lambda col:pd.to_numeric(col, errors='coerce'))

x1 = data1.loc[:,['ПИК']]
y1 = data1.loc[:,['ФИ' ]]
x2 = data2.loc[:,['ПИК']]
y2 = data2.loc[:,['ФИ' ]]
x3 = data3.loc[:,['ПИК']]
y3 = data3.loc[:,['ФИ' ]]
x4 = data4.loc[:,['ПИК']]
y4 = data4.loc[:,['ФИ' ]]
x5 = data5.loc[:,['ПИК']]
y5 = data5.loc[:,['ФИ' ]]

fig, ax = plt.subplots()

ax.plot(x1,y1,'o-', label = 'T1 = 1543K', markersize=4)
ax.plot(x2,y2,'^-', label = 'T1 = 1593K', markersize=4)
ax.plot(x3,y3,'s-', label = 'T1 = 1643K', markersize=4)
ax.plot(x4,y4,'^-', label = 'T1 = 1693K', markersize=4)
ax.plot(x5,y5,'o-', label = 'T1 = 1743K', markersize=4)

ax.set_box_aspect(1/1.5)

ax.set_xlabel(r'$\pi_k^*$')
ax.set_ylabel(r'$\varphi$')
ax.legend()

plt.grid(True)

plt.savefig('Fi.pgf', bbox_inches='tight', backend='pgf')
