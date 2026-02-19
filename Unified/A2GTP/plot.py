import matplotlib.pyplot as plt
import pandas as pd

# Чтение и обработка данных
files = [f'{i}.csv' for i in range(1, 6)]
data  = [pd.read_csv(f).loc[1:22, ['ПИК','КПДЕ','НЕ','ФИ']].apply(lambda col: pd.to_numeric(col, errors='coerce')) for f in files]

# Параметры графиков
labels = [rf'$T_1 = {temp} \ K$' for temp in [1443, 1493, 1543, 1593, 1643]]
outputs = [
    ('ФИ'  , 'φ'  , 'Fi' ),
    ('НЕ'  , 'H_e', 'He' ),
    ('КПДЕ', 'η_e', 'KPD')
]

# Создаем диаграмму с тремя графиками
fig, axes = plt.subplots(3, 1, figsize=(8, 12))
for idx, (col, ylabel, name) in enumerate(outputs):
    ax = axes[idx]
    ax.grid(True)

    for i, d in enumerate(data):
        ax.plot(d['ПИК'], d[col], '^-', label=labels[i], markersize=4)

    ax.set_xlabel(r'$\pi_k^*$' )
    ax.set_ylabel(f'${ylabel}$')
    ax.legend(fontsize=10)

plt.savefig('plots.svg', bbox_inches='tight')
