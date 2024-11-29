# Turbothesis
![image](https://github.com/user-attachments/assets/1a168fcc-4c4e-4c24-924d-d1b6a2c6d2ac)



Документ написан на $\LaTeX$ с компилятором Xelatex и менеджером библиографии biber.

Расчеты проводились инструментами Python в среде Jupyter Lab, от чего я в будущем хотел бы отказаться, перейдя на Haskell, к модели вычислений и синтаксису которого я предрасположен.
Все переменные и расчеты в документе автоматизированны с помощью Jupyter, при изменении любых данных вводить всё заново не придётся.

Для работы с данными, выдаваемыми A2GTP в виде неструктурированного текста, я написал скрипт на языке командной оболочки nu, который позволяет достать оттуда нужные данные и записать их в CSV. Полученные файлы визуализируются с помощью matplotlib. Треугольник скоростей также построен с помощью matplotlib параметрически.

Предполагаемым способом обратной связи является github issues - с созданием issue на каждый вопрос. Так можно легко указать и отслеживать исправление ошибки и смотреть на конкретное изменение (commit), предполагающее исправление
