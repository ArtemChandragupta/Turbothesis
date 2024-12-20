# Turbothesis
![image](https://github.com/user-attachments/assets/4dcdcf1c-ff15-4ea2-a590-1e10dfc21355)


[Документ](https://github.com/ArtemChandragupta/Turbothesis/blob/main/Turbothesis/main.pdf) написан на $\LaTeX$ в [Neovim](https://neovim.io/) + [VimTeX](https://github.com/lervag/vimtex) с компилятором [LuaTeX](https://www.luatex.org/) и менеджером библиографии [biber](https://biblatex-biber.sourceforge.net/).

Расчеты проводились инструментами Python в среде [Jupyter Lab](https://jupyter.org/), от чего я в будущем хотел бы отказаться, перейдя на Haskell, к модели вычислений и синтаксису которого я предрасположен.
Все переменные и расчеты в документе автоматизированны с помощью Jupyter, при изменении любых данных вводить всё заново не придётся - все числа в документе представлены в виде переменных.

Для работы с данными, выдаваемыми A2GTP в виде неструктурированного текста, я написал скрипт на языке командной оболочки [nu](https://www.nushell.sh/), который позволяет достать оттуда нужные данные и записать их в CSV. Полученные файлы визуализируются с помощью [matplotlib](https://matplotlib.org/). Треугольник скоростей также построен с помощью matplotlib параметрически.

Предполагаемым способом обратной связи является github issues - с созданием issue на каждый вопрос. Так можно легко указать и отслеживать исправление ошибки и смотреть на конкретное изменение (commit), предполагающее исправление

[Презентация](https://github.com/ArtemChandragupta/Turbothesis/blob/main/Presentation/Dmitriev_65Mvt.pdf) сделана по [неофициальному шаблону Политеха](https://github.com/polytechnic-templates/presentation-template).
