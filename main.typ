#import "template.typ": *
#import "vars.typ": *

#show: conf

#let page_number = context counter(page).final().at(0)
#let img_number = context query(figure.where(kind: image)).len()
#let tab_number = context query(figure.where(kind: table)).len()
#let ref_number = context {
  let citations = query(cite)
  citations.map(it => it.key).dedup().len()
}

#counter(page).update(4)

#text[
  #set page(numbering: none)
  #centred-heading("Реферат")
  #page_number страниц, #img_number рисунков, #tab_number таблиц, #ref_number источников, 2 приложения.

  #upper[
    Ключевые слова: газотурбинная установка, осевой компрессор, камера сгорания, турбина, рабочая лопатка, сопловая лопатка, прототип ГТЭ-65, диффузор, профиль, диск, ротор, лопатка.
  ]

  Тема выпускной квалификационной работы: "Газотурбинная установка мощностью #zMW[65]".

  Целью данной работы является проектирование газотурбинной установки мощностью #zMW[65] на основе прототипа ГТЭ-65.

  Задачи, решенные в ходе выполнения работы:
  + Расчет тепловой схемы, на основании результатов которого выбирается степень повышения давления в компрессоре и температура на входе в турбину;
  + Приближенный расчет компрессора;
  + Приближенный расчет камеры сгорания для получения её экологических характеристик;
  +  расчет турбины по среднему диаметру;
  + Расчет закрутки потока для последней ступени турбины;
  + Построение профилей и трехмерных моделей сопловой и рабочей лопаток последней ступени турбины, а также трехмерной модели диска рабочего колеса;
  + Расчет на прочность рабочего колеса последней ступени турбины;
  + Расчет на вибронадежность вала ротора и рабочего колеса последней ступени турбины;
  + Выбор и описание конструкции газотурбинной установки;
  + Анализ влияния радиального зазора в последней ступени турбины на КПД системы "последняя ступень-диффузор".

  #centred-heading("Abstract")
  #page_number pages, #img_number figures, #tab_number tables, #ref_number references, 2 appendices.

  #upper[
  Keywords: gas turbine unit, axial compressor, combustion chamber, turbine, rotor blade, nozzle vane, GTE-65 prototype, diffuser, airfoil, disk, rotor, blade.
  ]

  Topic of the graduation thesis: "Gas turbine unit with a capacity of 65 MW".

  The aim of this work is the design of a gas turbine unit with a capacity of 65 MW based on the GTE-65 prototype.

  Tasks completed during the work:
  + Calculation of the thermal cycle, based on the results of which the compressor pressure ratio and the turbine inlet temperature are selected;
  + Preliminary calculation of the compressor;
  + Preliminary calculation of the combustion chamber to obtain its emission characteristics;
  + Mean-line calculation of the turbine (calculation at the mean diameter);
  + Calculation of the flow swirl for the last turbine stage;
  + Generation of airfoils and 3D models of the nozzle vane and rotor blade of the last turbine stage, as well as a 3D model of the rotor disk;
  + Strength calculation of the rotor wheel of the last turbine stage;
  + Vibration reliability analysis of the rotor shaft and the rotor wheel of the last turbine stage;
  + Selection and description of the gas turbine unit design;
  + Analysis of the effect of the radial clearance in the last turbine stage on the efficiency of the "last stage-diffuser" system.
]

#outline(title: [*СОДЕРЖАНИЕ*])

#centred-heading("Обозначения и сокращения")

В работе использованы следующие обозначения и сокращения:

ГТУ --- газотурбинная установка;

ПГУ --- парогазовая установка;

КС --- камера сгорания;

КВОУ --- комплексное воздухоочистное устройство;

КПД --- коэффициент полезного действия;

РК --- рабочее колесо;

РЛ --- рабочая лопатка;

СА --- сопловой аппарат;

СЛ --- сопловая лопатка.

#centred-heading("Введение")

В современной энергетике газотурбинные установки (ГТУ) играют важную роль, обеспечивая надежное и эффективное производство электроэнергии. ГТУ обладают рядом преимуществ, таких как высокая мощность, быстрый запуск, возможность работы в различных климатических условиях и относительно низкие эксплуатационные затраты. Эти установки широко используются в качестве основных и резервных источников энергии, а также для балансировки энергосистем, особенно в условиях роста доли возобновляемых источников энергии.

Одной из наиболее перспективных разработок в области газотурбинных установок является ГТЭ-65 --- газовая турбина мощностью #zMW[65], разработанная российскими инженерами. ГТЭ-65 представляет собой современную турбину, которая сочетает в себе высокую эффективность, надежность и экологичность. На данный момент ГТЭ-65 находится на стадии активной разработки и тестирования, что делает её перспективной для внедрения в энергетические системы различных регионов.

Целью данной курсовой работы является проектирование газотурбинной установки мощностью 65 МВт на основе ГТЭ-65. В рамках работы будут рассмотрены основные технические характеристики ГТЭ-65, проанализированы её преимущества и недостатки, а также предложены пути оптимизации и улучшения конструкции для достижения заявленной мощности.

Актуальность данной работы обусловлена растущей потребностью в надежных и эффективных источниках энергии. В условиях глобального энергетического перехода и увеличения доли возобновляемых источников энергии, газотурбинные установки, такие как ГТЭ-65, становятся важным элементом энергетической инфраструктуры. Они обеспечивают стабильность энергосистем, позволяют быстро реагировать на изменения спроса и покрывать пиковые нагрузки. Кроме того, разработка и внедрение отечественных технологий в области ГТУ способствует укреплению энергетической независимости и повышению конкурентоспособности национальной энергетики.

Таким образом, создание газовой турбины мощностью #zMW[65] на основе ГТЭ-65 является важной задачей, решение которой позволит удовлетворить потребности современной энергетики и обеспечить устойчивое развитие энергетической инфраструктуры.

= Основные принципы работы ГТУ

== Общий принцип работы ГТУ

Газотурбинная установка --- это устройство, преобразующее тепловую энергию сгорания топлива в механическую энергию вращения вала. Принцип работы ГТУ основан на термодинамическом цикле Брайтона, изображенном на @Cycle-GTU.

#figure(
  {
    lq.diagram(
      height: 8.5cm, ylabel: $T$, xlabel: $S$,
      xaxis: (format-ticks: none), yaxis: (format-ticks: none),
      cycle: (black,),

      let y1 = 1,
      let y2 = 2,
      let y3 = 5.5,
      let y4 = 3,
    
      let cc1 = 1 / calc.ln(y3/y2),
      let cc2 = 1 / calc.ln(y4/y1),
      let lx = lq.linspace(1, 2),
      let lx2 = lq.linspace(2, 2.1),

      lq.place(1,y1,align: right+top,   block(inset:2pt)[$1$]),
      lq.place(1,y2,align: right+bottom,block(inset:2pt)[$2$]),
      lq.place(2,y3,align: left+bottom, block(inset:2pt)[$3$]),
      lq.place(2,y4,align: left+top,    block(inset:2pt)[$4$]),

      lq.plot(stroke:1.5pt, (1,1), (y1,y2) ),
      lq.plot(stroke:1.5pt, (2,2), (y3,y4) ),
      lq.plot(stroke:1.5pt, mark:none,
        lx, lx.map(x => y2 * calc.exp( (x - 1)/cc1 ))
      ),
      lq.plot(stroke:1.5pt, mark:none,
        lx, lx.map(x => y1 * calc.exp( (x - 1)/cc2 ))
      ),

      // Реальные линии      
      lq.plot(stroke:(dash: "dashed"), mark:none,
        lx2, lx2.map(x => y1 * calc.exp( (x - 1)/cc2 ))
      ),
      lq.plot(stroke: (dash:"dashed"), (lx.at(0),lx.at(3)), (
        y1 * calc.exp( (lx.at(0) - 1)/cc2 ),
        y2 * calc.exp( (lx.at(3) - 1)/cc1 ) )
      ),
      lq.plot(stroke: (dash:"dashed"), (lx.at(49),lx2.at(49)), (
        y2 * calc.exp( (lx.at(49)  - 1)/cc1 ),
        y1 * calc.exp( (lx2.at(49) - 1)/cc2 ) )
      ),

      lq.place(lx.at(3), y2 * calc.exp( (lx.at(3) - 1)/cc1 ),align: right+bottom,    block(inset:2pt)[$2'$] ),
      lq.place(lx2.at(49), y1 * calc.exp( (lx2.at(49) - 1)/cc2 ),align: left+top,    block(inset:2pt)[$4'$] ),

    )
    
    text(hyphenate: false, size:12pt)[\
      1-2 --- адиабатное сжатие в компрессоре, 2-3 --- изобарный подвод теплоты в камере сгорания, 3-4 --- адиабатное расширение продуктов сгорания на лопатках газовой турбины, 4-1 --- изобарный отвод теплоты от продуктов сгорания в атмосферу

      Точками $2'$ и $4'$ показаны точки реального процесса
    ]
  },
  caption: [Цикл одновальной ГТУ простого типа в T-S-диаграмме]
) <Cycle-GTU>

Сплошной линией показан идеальный цикл, он состоит из двух адиабатных процессов (сжатие в компрессоре и расширение в турбине) и двух изобарных (сжигание топлива в камере сгорания и расширение в выходном тракте). В реальном цикле Брайтона, который проходит по пунктирным линиям, все процессы являются политропными в связи с трением. Рабочим телом является воздух и продукты сгорания топлива --- газовоздушная смесь. Процесс преобразования энергии можно проследить по пути движения рабочего тела через основные элементы установки, изображенные на тепловой схеме на @Scheme-GTU @PERV.

#figure(
  {
    cetz.canvas({
      import cetz.draw: *

      // Компрессор и турбина
      line(name: "comp", (0, 0), (rel:(0,4)), (rel:(5,-1)), (rel:(0,-2)), close:true )
      line(name: "turb", (8, 0.75), (rel:(0,2.5)), (rel:(3,0.75)), (rel:(0,-4)), close:true )

      // Генератор
      circle(name: "gen", (-3,2), radius: 0.75)
      content("gen", text(30pt, sym.dash.wave))
      line(name:"genbash", "gen.north", (rel:(0,1)))
      content("genbash.40%", text(size: 20pt, sym.bar), angle:-60deg)
      content("genbash.60%", text(size: 20pt, sym.bar), angle:-60deg)
      content("genbash.80%", text(size: 20pt, sym.bar), angle:-60deg)

      // КС
      polygon((6.5,4),4, angle: 45deg, radius: 1, name: "cam")
      circle("cam", radius: 1/calc.sqrt(2))
      arc("cam", radius: 1/calc.sqrt(2),start: 45deg, delta: 90deg,mode: "PIE", anchor: "origin")
      arc("cam", radius: 1/calc.sqrt(2),start: -135deg, delta: 90deg,mode: "PIE", anchor: "origin")

      line(name: "d1", "comp", "gen"        )
      line(name: "d2", "turb", "comp"       )
      line(name: "d3", "turb", (rel:(3 ,0)) )

      line(name: "cam1", "comp.10", ((), "|-", "cam"), "cam", mark:(end:"stealth", fill: black))
      line(name: "cam2", "turb.2.5", ((), "|-", "cam"), "cam", mark:(start:"stealth", fill: black))
      line(name: "compline", "comp.0", (rel:(0, -1)), mark:(start:"stealth", fill: black))
      line(name: "turbline", "turb.9.5", (rel:(0, -1)), mark:(end:"stealth", fill: black))

      line(name:"fuel", "cam", (rel:(0, 1.5)), mark:(start:"stealth", fill: black))
      content("fuel.end",  [Топливо], anchor: "south", padding: 0.2)
      content("cam.south", [КС],      anchor: "north", padding: 0.2)

      content("gen.south", [Генератор], anchor:"north", padding:0.2)
      content("comp.centroid", [К ])
      content("turb.centroid", [ГТ])

      circle("d1", radius: 0.06, fill:black)
      content("d1", text(size:20pt," ["), anchor:"west",angle: 90deg)
      content("d1", text(size:20pt," ["), anchor:"west",angle:-90deg)
      content("d3", text(size:20pt," ["), anchor:"west",angle: 90deg)
      content("d3", text(size:20pt," ["), anchor:"west",angle:-90deg)

      // Расходы
      let gmark = (end:"stealth",fill:black,pos:50%,shorten-to:none)
      let gw(name) = cetz.decorations.wave(
        line(name, (rel:(20deg,1))), mark:(end:"stealth",fill:black),
        amplitude: .15, start: 1%, stop: 70%, segments: 2
      )

      line(name: "g1", "comp.70%", mark: gmark,
        (rel:(y: -0.7)), (rel:(x:3.5)), (rel:(y:0.7))
      )
      line(name: "g2", "comp.74%", mark: gmark,
        (rel:(y: -1  )), (rel:(x:4.7)), (rel:(y:1  ))
      )
      line(name: "g3", "comp.78%", mark: gmark,
        (rel:(y: -1.3)), (rel:(x:5.9)), (rel:(y:1.3))
      )
      line(name: "g4", "comp.82%", mark: gmark,
        (rel:(y: -1.6)), (rel:(x:7.1)), (rel:(y:1.6))
      )

      gw("g1.end"); gw("g2.end"); gw("g3.end"); gw("g4.end")

      content("g1.start", $G_4" "$, anchor: "south", padding:0.1)
      content("g2.start", $G_3" "$, anchor: "south", padding:0.1)
      content("g3.start", $G_2" "$, anchor: "south", padding:0.1)
      content("g4.start", $G_1" "$, anchor: "south", padding:0.1)

      // Номера
      content("compline", $1$, padding:0.2, anchor:"east")
      content("cam1.70%", $2$, padding:0.2, anchor:"east")
      content("cam2.50%", $3$, padding:0.2, anchor:"west")
      content("turbline", $4$, padding:0.2, anchor:"west")
    })
    text(size: 12pt)[
      К --- компрессор, КС --- камера сгорания, ГТ --- газовая турбина

      $G_1$, $G_2$, $G_3$, $G_4$ --- отборы воздуха из компрессора на охлаждение

      Цифровые обозначения соответствуют точкам цикла Брайтона
    ]
  },
  caption: [Тепловая схема проектируемой ГТУ]  
) <Scheme-GTU>

Атмосферный воздух входит в установку через комплексное воздухоочистительное устройство, обеспечивающее необходимое качество воздуха. Оттуда очищенный воздух попадает в многоступенчатый компрессор осевого типа, лопатки на вращающемся роторе которого сообщают воздуху кинетическую энергию, которая преобразуется лопатками статора компрессора в потенциальную энергию давления рабочего тела. На выходе из компрессора воздух оказывается сжатым до давления в 15 раз выше атмосферного и имеет повышенную температуру (до $#zdc[500]$).

Затем сжатый воздух поступает в камеру сгорания, в которой его часть в размере около $30-40%$ смешивается с топливом и сгорает при постоянном давлении, после чего оставшаяся часть смешивается с образовавшимся потоком раскалённых газов на выходе из зоны горения для охлаждения продуктов сгорания до температуры, которую могут выдержать лопатки турбины.

После выхода из камеры сгорания высокотемпературная газовоздушная смесь устремляется в многоступенчатую газовую турбину. В сопловых и рабочих лопатках турбины потенциальная энергия давления и тепла потока газовоздушной смеси переводится в кинетическую энергию, которая сообщается ротору ГТУ через рабочие лопатки на роторе турбины.

Таким образом, тепловая энергия сгорания топлива была переведена в механическую энергию вращения вала. Мощность, развиваемая при этом турбиной, преимущественно расходуется на два процесса:
+ Около $60%$ мощности идёт на привод компрессора;
+ Остальная часть мощности является полезной и идёт на привод генератора.

Отработанные газы, покидающие турбину, все ещё имеют высокую температуру порядка $450 - #zdc[600]$. В простейшем цикле они выбрасываются в атмосферу, однако в современной практике распространено применение парогазовых установок, использующие выходящие из газовой турбины газы для привода паровой турбины. В такой установке выхлопные газы направляются в утилизационный теплообменник, в котором происходит разогрев воды и генерация пара. Такая комбинированная установка имеет значительно более высокий КПД, чем традиционные ГТУ и ПТУ.

== Краткая характеристика проектируемой установки <Chapter-Char>

Проектируемая установка представляет из себя стационарную энергетическую ГТУ номинальной мощностью #zMW[65], предназначенную для использования как самостоятельно, так и в составе парогазовых блоков. Прототипом установки является ГТЭ-65 производства российской компании "Силовые Машины". Сведения о технических характеристиках прототипа приведены в @GTU-table.

#figure(
  block(stroke:black, table(
    columns: (auto, auto), row-gutter: (1.7pt, auto),
    table.header(
      [Название характеристики],[Значение характеристики]
    ),
    [Номинальная мощность, #zMW()]             , $67.7$,
    [КПД, %]                                   , $36.0$,
    [Скорость вращения выходного вала, #zrpm()], $5441$,
    [Применяемое топливо]                      , [газовое/дизельное],
    [Межремонтный ресурс, ЭЧ]                  , $33000$,
    [Температура газа на выходе, #zdc()]       , $562$,
    [Расход газа на выходе, #zkg-s()]          , $197.5$,
    [Габариты $(L dot B dot H)$, #zm()], $18.1 dot 12.5 dot 7.5$,
    [Масса турбогруппы, #zT()]                 , $62$,
  )),
  caption: [Технические характеристики прототипа]
) <GTU-table>

В проектируемой установке используется 16-ступенчатый компрессор, обеспечивающий степень сжатия 15.6 и 4-ступенчатая турбина. Между ними находится камера сгорания, исполняемая по трубчато-кольцевому типу. Проточная часть заканчивается выходным диффузором. Ротор двухопорный, закреплён на опорном подшипнике и опорно-упорном подшипнике. Для охлаждения лопаток турбины реализован отбор воздуха с одиннадцатой и четырнадцатой ступеней компрессора, который подводится к лопаткам с помощью коаксиальных валов.

== Сценарии применения проектируемой установки

Как описывалось в @Chapter-Char, проектируемая установка может применяться как самостоятельно, так и в составе парогазовых блоков.  Если при использовании установки в составе ПГУ происходит максимизация КПД, то при использовании ГТУ отдельно повышается манёвренность, что положительно сказывается на возможностях регулирования, повышая качество и надёжность электрической сети.

Российская элементная база позволяет использовать установку в программах импортозамещения. Так как установка может работать не только на газовом, но и на дизельном топливе, она может использоваться в зонах, в которых есть опасность перебоев поставки газа, а также повысить устойчивость энергосистемы при авариях на хозяйстве электростанции.

Малоэмиссионная камера сгорания с выбросами $"NO"_x$, не превышающими #zmg-nm3[50], позволяет использовать установку в населённых центрах и природных территориях, предъявляющих особые требования к чистоте выхлопных газов.

= Выбор оптимальных параметров цикла

== Вариантный расчет параметров ГТУ

С помощью программы A2GTP проведен расчет параметров рабочего процесса в характерных сечениях проточной части и основных характеристик ГТУ при различных значениях степени повышения давления $pi_к^*$ и температуры газа перед турбиной $T_3^*$, по результатам которого построены графики $H_e, eta_e, phi=f(pi_К^*, T_3^*)$. В расчете использованы следующие исходные данные:

+ Полезная мощность $N = #zW(RawTAN) $;
+ Температура газа перед турбиной $T_3^* = #zK(RawTATs3)$;
+ Параметры наружного воздуха $P_н = #zPa(RawTAPₙ)$, $T_н = #zK(RawTATₙ)$;
+ Топливо --- природный газ;
+ Частота вращения вала ГТУ $n = #zrpm(RawTAn)$.

== Результаты расчета

Графики на рисунках @ne[], @phi[] и @He[] отражают результаты расчета. Полные результаты расчета смотреть в Приложении Б.

#let csv_data = (
  csv("A2GTP/1.csv").slice(2),
  csv("A2GTP/2.csv").slice(2),
  csv("A2GTP/3.csv").slice(2),
  csv("A2GTP/4.csv").slice(2),
  csv("A2GTP/5.csv").slice(2)
)

#let pik = for line in csv_data.at(0) { (float(line.at(0)),) }

#let KPD = for page in csv_data {
  (for line in page { (float(line.at(1)),) },)
}
#let He = for page in csv_data {
  (for line in page { (float(line.at(2)),) },)
}
#let Phi = for page in csv_data {
  (for line in page { (float(line.at(3)),) },)
}

#let palette = lq.color.map.plasma
#let a2gtpmap = (
  (color: palette.at(0), mark: "o"),
  (color: palette.at(2), mark: "^"),
  (color: palette.at(4), mark: "s"),
  (color: palette.at(6), mark: "v"),
  (color: palette.at(8), mark: "d"),
)

#figure(
  lq.diagram(
    height:9cm, legend: (position: bottom),
    ylabel: $eta_e$, xlabel: $pi_k^*$, cycle: a2gtpmap,
    ..for i in range(csv_data.len()) {
      let Tt = 1443 + 50 * i
      (lq.plot(pik,KPD.at(i), stroke:1.5pt, mark-size: 5pt, smooth:true, label:$T_3^* = #zK(Tt) $),)
    }
  ),
  caption: [Зависимость эффективного КПД ГТУ от степени повышения давления в компрессоре при различных значениях температуры]
) <ne>

#undo-line()

#figure(
  lq.diagram(
    height:10cm, legend: (position: bottom),
    ylabel: $H_e$, xlabel: $pi_k^*$, cycle: a2gtpmap,
    ..for i in range(csv_data.len()) {
      let Tt = 1443 + 50 * i
      (lq.plot(pik,He.at(i), stroke:1.5pt, mark-size: 5pt, smooth:true, label:$T_3^* = #zK(Tt)$),)
    }
  ),
  caption: [Зависимость эффективной удельной работы ГТУ от степени повышения давления в компрессоре при различных значениях температуры]
) <phi>

#undo-line()

#figure(
  lq.diagram(
    height:9cm, ylabel: $phi$, xlabel: $pi_k^*$, cycle: a2gtpmap,
    ..for i in range(csv_data.len()) {
      let Tt = 1443 + 50 * i
      (lq.plot(pik,Phi.at(i), stroke:1.5pt, mark-size: 5pt, smooth:true, label:$T_3^* = #zK(Tt)$),)
    }
  ),
  caption: [Зависимость коэффициента полезной работы ГТУ от степени повышения давления в компрессоре при различных значениях температуры]
) <He>

#undo-line()

== Определение оптимальных значений параметров цикла <opt-cycle>

Максимальный КПД установки достигается при максимальной температуре газа перед турбиной – #zK(RawATs0). Жаростойкость материала лопаток турбины позволяет выдерживать такую температуру, поэтому в качестве входной температуры на турбину выбрана именно эта температура. Экстремум графика зависимости эффективного КПД ГТУ от степени повышения давления в компрессоре наблюдается при $pi_к^* = 24 $ и $eta_e = 0.360 $. Выбор такой степени сжатия не оправдан, т. к. при нём слишком низкие значения эффективной удельной работы и коэффициента полезной работы. Экстремум графика зависимости эффективной удельной работы ГТУ от степени повышения давления в компрессоре наблюдается при $pi_к^* = Aπsₖ $, значение эффективного КПД ГТУ при этом $eta_e = 0.346 $. Коэффициент полезной работы ГТУ с увеличением степени повышения давления $pi_к^*$ монотонно уменьшается, однако уменьшение $pi_к^*$ с целью его увеличения нецелесообразно, поскольку величина коэффициента полезной работы ГТУ увеличивается незначительно, при этом снижается величина эффективного внутреннего КПД и эффективной удельной работы.

Таким образом, для дальнейших расчетов принимаем:

$T_3^* = #zK(RawATs0)$, $pi_k^* = Aπsₖ$.

= Приближенный расчет компрессора

При приближенном расчете осевого компрессора, производимом по методике Ю. С. Подобуева @COMP основными расчетными сечениями являются сечение 1-1 на входе в первую ступень, сечение 2-2 на выходе из последней ступени (@COMP-lop[рис.]), а также сечение К-К на выходе из компрессора. Определим параметры $P$ и $T$ в этих двух сечениях:

#figure(
  image("assets/compressor/COMP-lopatki2.png", width: 80%),
  caption: [Схема первой и последней ступеней компрессора]
) <COMP-lop>

Давление воздуха в сечении 1-1:
$ P_1^* = sigma_"вх"^* dot P_н = COσsᵢₙ dot TAPₙ = #zPa(RawCPs1), $

#noind где $sigma_"вх"^*$ --- коэффициент уменьшения полного давления во входной части \
#hide[где $sigma_"вх"^*$ ---] компрессора (принимаем $sigma_"вых"^*=COσsᵢₙ$).

Температура в сечении 1-1:
$ T_1^* = T_н = #zK(RawCTs1) ; $

Давление воздуха в сечении К-К:
$ P_к^* = P_н dot pi_к^* = TAPₙ dot Aπsₖ = #zPa(RawCPsₖ), $

#noind где $pi_k^*$ --- степень повышения давления компрессора (из @opt-cycle[раздела] $pi_k^*=Aπsₖ$).

Давление в сечении 2-2:
$ P_2^* = P_к^* / sigma_"вых"^* = CPsₖ / COσsₒᵤₜ = #zPa(RawCPs2), $

#noind где $sigma_"вых"^*$ --- коэффициент уменьшения полного давления в выходной части \
#hide[где $sigma_"вых"^*$ ---] компрессора (принимаем $sigma_"вых"^*=COσsₒᵤₜ$).

#pagebreak()
Значение плотностей:
$ rho_1 = P^*_1 / (R_в dot T_1^*) = CPs1 / (CORₙ dot CTs1) = #zkg-m3( RawCρ1), $

#noind примем КПД компрессора $eta_"ад"^* = 0.88$, тогда:
$ rho_2 = rho_1 (P_2^* / P_1^*)^(1/n) = Cρ1 (CPs2 / CPs1)^(1/Cnₖ) = #zkg-m3(RawCρ2), $

#noind где $n$ --- показатель политропы определяется из равенства:

$
  k_в / (k_в-1) dot eta_"ад"^* = n/(n-1) \
  // COkₙ / (COkₙ - 1) dot COηₐ = n/(n-1) => n = Cnₖ;
$

Примем величины осевой составляющей абсолютных скоростей в сечениях 1-1 и 2-2 соответственно $C_(z_1) = #zm-s(RawCOcᶻ1)$ и $C_(z_2) = #zm-s(RawCOcᶻ2)$. Втулочное отношение выберем $nu_1 = frac(D_"вт"_1, D_"н"_1, style: "horizontal") = COν1 $. Расход воздуха $G_"в" = #zkg-s(RawAGₙ) $.

Из уравнения расхода первой ступени выразим значение наружного диаметра на входе в компрессор:
$ G_в &= rho_1 dot pi/4 dot (D^2_н_1 - D^2_"вт"_1) dot C_z_1 = rho_1 dot pi/4 dot ( 1 - nu_1^2) dot D^2_н_1 dot C_z_1, $

#noind откуда,
$ D_Н_1 = sqrt( (4 G_в)/(rho_1 dot pi dot (1-nu_1^2) dot C_z_1) ) = sqrt( (4 dot AGₙ) / (Cρ1 dot pi dot (1-COν1^2) dot COcᶻ1 ) ) = #zm(RawCD1) ; $

Диаметр втулки первой ступени:
$ D_"вт"_1 = nu_1 dot D_Н_1 = COν1 dot CD1 = #zm(RawCDᵥₜ1) ; $

Средний диаметр первой ступени:
$ D_"ср"_1 = (D_Н_1 + D_"вт"_1)/2 = (CD1 + CDᵥₜ1)/2 = #zm(RawCDₘ1) ; $

Длина рабочей лопатки первой ступени:
$ l_1 = (D_н_1 - D_"вт"_1)/2 = (CD1 - CDᵥₜ1)/2 = #zm(RawCl1) ; $

Размеры проходного сечения 2-2:
$ F_2 = G_в / (C_z_2 dot rho_2) = AGₙ / (COcᶻ2 dot Cρ2) = #zm2(RawCF2) ; $

Принимаем в проточной части $D_"ср" = "const" $, тогда:
$ nu_2 = (pi dot D_"ср"^2 - F_2) / (pi dot D_"ср"^2 + F_2) = (pi dot CDₘ1^2 - CF2)/(pi dot CDₘ1^2 + CF2) = Cν2; $

Длина рабочей лопатки последней ступени:
$ l_2 = (1-nu_2) sqrt(F_2/(pi (1 - nu_2^2))) = (1-Cν2) sqrt(CF2/(pi (1 - Cν2^2))) = #zm(RawCl2) ; $

Для обеспечения требуемой частоты вращения необходимо задать окружную скорость на наружном диаметре первой ступени $u_н_1 = #zm-s(RawCuₙ1) $, тогда:

$ n = (60 dot u_н_1) / (pi dot D_н_1) = (60 dot Cuₙ1) / (pi dot CD1) = #zrpm(RawTAn). $

Таким образом, для соединения вала турбоагрегата с валом генератора необходимо использовать редуктор, понижающий обороты до #zrpm[3000], передаточное отношение которого равняется $Z = frac(3000, TAn, style: "horizontal") $.

Адиабатический напор по полным параметрам в проточной части компрессора:

$ H^*_"ад. пр. ч." &= k_в/(k_в-1) dot R_в dot T_1^* dot [ (P_2^* / P_1^*)^((k_в-1)/k_в)-1] = \ &= COkₙ/(COkₙ-1) dot CORₙ dot CTs1 dot [ (CPs2/CPs1)^( (COkₙ-1)/COkₙ ) - 1] = #zJ-kg(RawCHsₐ) ; $

Приближенная величина теоретического напора или удельная работа, затрачиваемая на сжатие 1 кг воздуха:
$ H_к^* = H^*_"ад. пр. ч." / eta^*_"ад" = CHsₐ / COηsₐ = #zJ-kg(RawCHsₖ) ; $

Выберем средний теоретический напор $h_"ср" = #zJ-kg(RawCOhₘ) $.

Число ступеней компрессора:
$ i = ceil( H_к^* / h_"ср") = ceil(CHsₖ / COhₘ) = Ci; $

Теоретический напор в первой ступени:
$ h_1 = (0.6 dots 0.7) dot h_"ср" = COk1 dot COhₘ = #zJ-kg(RawCh1) ; $

Теоретический напор в средних ступенях:
$ h_"ср. ст." = (1.1 dots 1.2) dot h_"ср" = Ckₘ dot COhₘ = #zJ-kg(RawCh2) ; $

Теоретический напор в последней ступени:
$ h_п = (0.95 dots 1) dot h_"ср" = 1 dot COhₘ = #zJ-kg(RawCOhₘ) ; $

Считая рост напора в ступенях от и его падение в ступенях линейным, изобразим распределение напора на @Ras:

#figure(
  {
    show: lq.cond-set(lq.grid.with(kind: "x"), stroke:none)
    lq.diagram(
      legend: (position: left + horizon, dy: 0.5em),
      height: 8cm, xlim: (0.1,16.9), ylim: (1.5e4,2.8e4),
      xlabel: $i$, ylabel: $h, #zJ-kg()$,
      xaxis: (tick-distance:1, subticks:none),

      let h1 = RawCh1,
      let h2 = RawCh2,
      let hm = RawCOhₘ,

      lq.bar(
        (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16),
        (
          h1,
          (h1 + (h2 - h1)*1/7),
          (h1 + (h2 - h1)*2/7),
          (h1 + (h2 - h1)*3/7),
          (h1 + (h2 - h1)*4/7),
          (h1 + (h2 - h1)*5/7),
          (h1 + (h2 - h1)*6/7),
          h2, h2, h2, h2, h2, h2, h2,
          (h2 + hm)/2, hm
        ), fill: aqua,
      ),

      lq.plot( (-1,17),(h2,h2), label: $h_"ср.ст."$, mark: none,
        stroke:(dash:(10pt, 4pt), thickness:1.5pt, paint:olive)
      ),
      lq.plot( (-1,17),(hm,hm), label: $h_"ср"$, mark: none,
        stroke:(dash:(10pt, 4pt), thickness:1.5pt, paint:red)
      ),
      lq.plot( (-1,17),(h1,h1), label: $h_1$, mark: none,
        stroke:(dash:(10pt, 4pt), thickness:1.5pt, paint: fuchsia)
      ),
    )
  },
  caption: [Распределение теоретического напора по ступеням компрессора]
) <Ras>

В результате распределения напоров соблюдается условие:

$ sum h_i = H_k^* = #zJ-kg(RawCHsₖ). $

Уточняем величину окружной скорости на среднем диаметре первой ступени:
$ u_"ср"_1 = (pi dot D_"ср"_1 dot n)/60 = (pi dot CDₘ1 dot TAn)/60 = #zm-s(RawCuₘ1) ; $

Производим расчет первой ступени по среднему диаметру:

Коэффициент расхода на среднем диаметре:
$ phi = C_z_1 / u_"ср"_1 = COcᶻ1 / Cuₘ1 = CΦ1; $

Коэффициент теоретического напора:
$ dash(h)_1 = h_1/u^2_"ср"_1 = Ch1 / Cuₘ1^2 = Ch̄1; $

Отношение найденных коэффициентов:
$ dash(h)_1 / phi = Ch̄1 / CΦ1 = Cotn; $

Зададим степень реактивности $Omega = COΩ $ и найдем:
$ Omega / phi = COΩ / CΦ1 = Cotm; $

По графику на @otn находим $(dash(h)_1/phi)_(b/t=1) = CP0ᵍ;$

#figure(
  {
    show lq.selector(lq.legend): set grid(row-gutter: 8pt)
    lq.diagram(
      legend: (inset:10pt), height: 9cm,
      xlabel: $Omega"/"phi$, ylabel: $(dash(h)_1"/"phi)_(b/t=1)$,

      let lx = lq.linspace(0.11, 1.368),

      lq.plot(mark: none, stroke: 2pt,
        lx, lx.map(lx => 0.935 - 0.777*lx + 0.503 * lx * lx)
      ),
      
      lq.line(stroke: (paint: lq.color.map.petroff10.at(1), dash:(10pt, 4pt), thickness: 1.5pt), (RawCotm,100%), (RawCotm, RawCP0ᵍ), label: $Omega"/"phi = Cotm$
      ),
      lq.line(stroke: (paint: lq.color.map.petroff10.at(2), dash:(10pt, 4pt), thickness: 1.5pt), (RawCotm,RawCP0ᵍ), (0%,RawCP0ᵍ), label: $(dash(h)_1 "/" phi)_(b/t=1)=CJ$
      ),
    )
  },
  caption: [График зависимости $(dash(h)_1/phi)_(b/t=1)$ от $Omega/phi$]
) <otn>

Коэффициент $J$:
$ J = ((dash(h)_1 / phi))  / (dash(h)_1/phi)_(b/t=1) = Cotn / CP0ᵍ = CJ; $

Пользуясь графиком на @J определяем $b/t = 1/Ctb -> t/b = Ctb.$

При постоянной вдоль радиуса хорде относительный шаг у втулки первой ступени:
$ (t/b)_"вт" = t/b dot D_"вт"_1 / D_"ср"_1 = Ctb dot CDᵥₜ1/CDₘ1 = Ctbem. $

#figure(
  lq.diagram(
    height: 8cm, ylim: (0.6, 1.7), xlim:(0.4,2),
    xlabel: $b"/"t$, ylabel: $J$, legend: (position: right + bottom),

    lq.plot(mark: none, stroke: 2pt, smooth: true,
      (0.5, 0.551, 0.6  , 0.7  , 0.9 , 1, 1.279, 1.653, 1.886),
      (0.6, 0.654, 0.697, 0.788, 0.94, 1, 1.194, 1.447, 1.595),
    ),
    lq.line(stroke: (paint: lq.color.map.petroff10.at(1), dash: (10pt, 4pt), thickness: 1.5pt), (1/RawCtb, RawCJ),(0%, RawCJ), label: $J = CJ$
    ),
    lq.line(stroke: (paint: lq.color.map.petroff10.at(2), dash: (10pt, 4pt), thickness: 1.5pt), (1/RawCtb, 100%),(1/RawCtb,RawCJ), label: $b"/"t = #calc.round(digits: 4,1/RawCtb)$
    )
  ),
  caption: [График зависимости коэффициента $J$ от густоты решетки]
) <J>

Окружные скорости на входе и на выходе из рабочего колеса принимаем одинаковыми, т. е. $u_"ср"_1 = u_"ср"_2 = u = #zm-s(RawCu) $.

Проекция абсолютной скорости на окружное направление входной скорости на входе в рабочее колесо:
$ C_u_1 = u(1-Omega) - h_1/(2u) = Cu dot (1-COΩ) - Ch1 / (2 dot Cu) = #zm-s(RawCcᵤ1) ; $

На выходе из рабочего колеса:
$ C_u_2 = u(1-Omega) + h_1/(2u) = Cu dot (1-COΩ) + Ch1 / (2 dot Cu) = #zm-s(RawCcᵤ2) ; $

Абсолютная скорость на входе в рабочее колесо:
$ C_1 = sqrt(C^2_z_1 + C^2_u_1) = sqrt( COcᶻ1^2 + COcᶻ2^2 ) = #zm-s(RawCc1) ; $

Угол наклона вектора абсолютной скорости на входе в рабочее колесо:
$ a_1 = "arcctg" (C_u_1/C_z_1) = "arctg" ( Ccᵤ1/COcᶻ1 ) = Cα1 degree; $

Температура воздуха перед рабочим колесом:
$ T_1 = T_1^* - C_1^2 / (2 dot k_в/(k_в-1) dot R_в) = CTs1 - Cc1^2 / (2 dot COkₙ/(COkₙ-1) dot CORₙ) = #zK(RawCT1) ; $

Проекция относительной скорости $W$ на окружное направление входной скорости на входе в рабочее колесо:
$ W_u_1 = C_u_1 - u = Ccᵤ1 - Cu = #zm-s(RawCwᵤ1) ; $

Относительная скорость на входе в колесо:
$ W_1 = sqrt(C^2_z_1 + W^2_u_1) = sqrt(COcᶻ1^2 + (Cwᵤ1)^2) = #zm-s(RawCw1) ; $

Число Маха по относительной скорости на входе в рабочее колесо первой ступени:
$ M_W_1 = W_1 / sqrt(k_в dot R_в dot T_1) = Cw1 / sqrt(COkₙ dot CORₙ dot CT1) = CMʷ1; $

Наклон входной относительной скорости при отсчете от отрицательного направления оси $u$ характеризуется углом $beta$:
$ beta_1 = "arcctg" (W_u_1/C_z_1) = "arcctg" (Cwᵤ1 / COcᶻ1) = Cβ1 degree; $

Уменьшение осевой составляющей скорости в одной ступени:
$ Delta C_z = (C_z_1 - C_z_2)/i = ( COcᶻ1 - COcᶻ2 )/Ci = #zm-s(RawCΔcᶻ) ; $

Осевая составляющая скорости на выходе из рабочего колеса первой ступени:
$ C_z_2 = C_z_1 - (Delta C_z)/2 = COcᶻ1 - CΔcᶻ / 2 = #zm-s(RawCCcᶻ2) ; $

Абсолютная скорость на выходе из рабочего колеса:
$ C_2 = sqrt(C^2_z_2 + C^2_u_2) = sqrt( CCcᶻ2^2 + Ccᵤ2^2 ) = #zm-s(RawCc2) ; $

Угол наклона вектора для построения треугольников скоростей:
$ a_2 = "arcctg" (C_u_2/C_z_2) = "arctg" ( Ccᵤ2 / CCcᶻ2 ) = Cα2 degree; $

Проекция относительной скорости $W$ на окружное направление входной скорости на выходе из рабочего колеса:
$ W_u_2 = C_u_2 - u = Ccᵤ2 - Cu = #zm-s(RawCwᵤ2) ; $

Относительная скорость на выходе из колеса:
$ W_2 = sqrt(C^2_z_2 + W^2_u_2) = sqrt(COcᶻ2^2 + (Cwᵤ2)^2) = #zm-s(RawCw2) ; $

Наклон выходной относительной скорости:
$ beta_2 = "arctg" (W_u_2/C_z_2) = "arctg" (Cwᵤ2/COcᶻ2) = Cβ2 degree; $

Угол поворота в решетке рабочего колеса:
$ epsilon = beta_2 - beta_1 = Cβ2 degree - Cβ1 degree = Cϵ degree; $

Коэффициент расхода на внешнем диаметре:
$ phi_н = C_z_1 / u_н_1 = COcᶻ1 / Cuₙ1 = CΦₙ; $

Проверка числа Маха по средней относительной скорости на внешнем диаметре первой ступени:
$ M_W_с = u_н_1 dot sqrt(1+phi_н^2)/sqrt(k_в dot R_в dot T_1^*) = Cuₙ1 dot sqrt(1 + CΦₙ^2) / sqrt(COkₙ dot CORₙ dot CTs1) = CMʷₘ; $

Сверхзвуковое число $M_W_c$ свидетельствует о необходимости профилирования лопаточного аппарата первой ступени турбины по закону $Omega = "const"$ вдоль радиуса.

На @compressor-triangle приведён построенный по полученным данным треугольник скоростей:

#figure(
  text(size: 12pt, cetz.canvas(length:0.05cm, {
    import cetz.draw: *
    set-style(
      mark: (transform-shape: false, fill: black),
      stroke: (cap: "round")
    )
    // Variables
    let cz1 = -RawCOcᶻ1
    let cz2 = -RawCCcᶻ2
    let cu1 = -RawCcᵤ1
    let cu2 = -RawCcᵤ2
    let cu  =  RawCu
    let a1  =  RawCα1 * 1deg
    let a2  =  RawCα2 * 1deg
    let b1  =  RawCβ1 * 1deg
    let b2  =  RawCβ2 * 1deg
    let start = calc.max( calc.abs(cu1), calc.abs(cu2) )
    
    // Оси
    line((start,0),(-start,0), mark:(end: "stealth"), name: "axisu")
    content("axisu.end", $U$, padding: 5, anchor: "north-west" )
    line((0,0),(0,cz1), mark:(end: "stealth"), name: "axisz")
    content("axisz.end", $z$, padding: 5, anchor: "south-west" )

    // Треугольник 1
    line(name:"C1", (0,0),(cu1  ,cz1), mark:(end:"stealth", fill:red), stroke:(paint:red, thickness: 2pt))
    line(name:"W1", (0,0),(cu1 + cu, cz1), mark:(end:"stealth", fill:red), stroke:(paint:red, thickness: 2pt))
    line(name:"U1", "W1.end","C1.end", mark:(end: "stealth", fill:red),stroke:(paint:red, thickness: 2pt))

    // Треугольник 2
    line(name:"C2", (0,0),(cu2, cz2), mark:(end:"stealth", fill:blue), stroke:(paint:blue, thickness: 2pt))
    line(name:"W2", (0,0),(cu2 + cu, cz2), mark:(end:"stealth", fill:blue), stroke:(paint:blue, thickness: 2pt))
    line(name:"U2","W2.end","C2.end", mark:(end: "stealth", fill:blue),stroke:(paint:blue, thickness: 2pt))

    // линии для U1 и U2
    line(name:"U1s","U1.start", (rel:(0,-20)))
    line(name:"U1e","U1.end",   (rel:(0,-20)))
    line(name:"U_1", "U1s.16", "U1e.16", mark:(symbol: "stealth"))
    line(name:"U2s","U2.start", (rel:(0,-40)))
    line(name:"U2e","U2.end",   (rel:(0,-40)))
    line(name:"U_2", "U2s.36", "U2e.36", mark:(symbol: "stealth"))

    // Подписи
    content("C1.70%", angle:  a1, box(fill:white, inset:3pt, $C_1 = #zm-s(RawCc1) $))
    content("W1.70%", angle: -b1, box(fill:white, inset:3pt, $W_1 = #zm-s(RawCw1) $))
    content("C2.70%", angle:  a2, box(fill:white, inset:3pt, $C_2 = #zm-s(RawCc2) $))
    content("W2.70%", angle: -b2, box(fill:white, inset:3pt, $W_2 = #zm-s(RawCw2) $))
    content("U_1", box(fill:white, inset:3pt, $U_1 = #zm-s(RawCu)$))
    content("U_2", box(fill:white, inset:3pt, $U_2 = #zm-s(RawCu) $))
    content("axisz.90", angle: 90deg, box(fill:white, inset:3pt, $C_z_1 = #zm-s(RawCOcᶻ1)$), anchor: "south")
    content("axisz.90", angle:-90deg, box(fill:white, inset:3pt, $C_z_2 = #zm-s(RawCCcᶻ2) $), anchor: "south")

    // Дуги
    arc(name:"a2", (0,0), start: 180deg, delta:  a2, radius:80, anchor:"origin", mark:(symbol:"stealth"))
    arc(name:"b2", (0,0), start: 0deg  , delta: -b2, radius:45, anchor:"origin", mark:(symbol:"stealth"))
    arc(name:"a1", (0,0), start:-180deg, delta: +a1, radius:45, anchor:"origin", mark:(symbol:"stealth"))
    arc(name:"b1", (0,0), start:   0deg, delta: -b1, radius:80, anchor:"origin", mark:(symbol:"stealth"))

    // Подписи дуг
    content("a1.50%", angle:  a1/2, box(fill:white, inset:3pt, $alpha_1  = Cα1 degree$) )
    content("b1.33%", angle: -b1/3, box(fill:white, inset:3pt, $beta_1^* = Cβ1 degree$) )
    content("a2.33%", angle:  a2/3, box(fill:white, inset:3pt, $alpha_2  = Cα2 degree$) )
    content("b2.50%", angle: -b2/2, box(fill:white, inset:3pt, $beta_2^* = Cβ2 degree$) )
  })),
  caption: text(14pt)[Треугольник скоростей на среднем диаметре первой ступени компрессора]
) <compressor-triangle>

= Расчет камеры сгорания

Камера сгорания проектируемой установки является противоточной и исполняется по трубчато-кольцевому типу. Расчет был выполнен по методике В. А. Рассохина @COMBUSTOR. Общий вид КС прототипа представлен на @Calc-KS.

#figure(
  image("assets/bob/KS-65.jpg", width: 80%),
  caption: [Общий вид камеры сгорания прототипа]
) <Calc-KS>

== Исходные данные для расчета камеры сгорания

+ Коэффициент избытка воздуха $alpha = Bα$;
+ Теоретическое удельное количество воздуха $L_0 = BL0$;
+ Диаметр канала на входе в КС $D_"вх" = #zm(RawBDᵢₙ)$;
+ Высота канала на входе в КС $h_"к" = #zm(RawBhᵢₙ)$;
+ Диаметр канала на выходе из КС $D_"вых" = #zm(RawBDₒᵤₜ)$;
+ Площадь сечения выхода из КС $F_"вых" = #zm2(RawBFₒᵤₜ)$;
+ Высота канала в выходном сечении КС $h_"вых" = #zm(RawBhₒᵤₜ)$;
+ Площадь отверстий на выходе из завихрителей $mu dash(F_"охл") = #zm2(RawBμF̄3)$;
+ Интенсивность закрутки воздушного потока $dash(W) = BW̄$;
+ Относительный расход воздуха на охлаждение $delta_(sum "отб") = Bδₛᵤₘ$;
+ Центральный угол выхода безотрывного диффузора $alpha_d = Bαd degree$;
+ Параметры варьирования:
  $ X_1 = F_ж/F_"вых" = BX1; X_2 = lambda_"ож" = BX2; X_3 = L_"гс"/h_"ср" = BX3; X_4 = F_"кк"/F_"к" = BX4. $

== Расчет геометрических размеров камеры сгорания

Площадь миделевого сечения пламенной трубы:
$ F_ж = F_"вых" dot X_1 = BFₒᵤₜ dot BX1 = #zm2(RawBFₘ) ;  $

Суммарная эффективная площадь всех отверстий в пламенной трубе:
$ sum mu F_"ож" &= (16 dot G_n dot sqrt(T_k))/(P_k dot (1 - 0.83 dot X_2^2)^2.5 dot X_2) = \ &= ( 16 dot AGₙ dot sqrt(BTₖ))/(CPsₖ dot (1 - 0.83 dot BX2^2)^2.5 dot BX2) = #zm2(RawBμFₒₘ) ; $

Поступающие через дожигающие отверстия струи воздуха должны обеспечить равномерное смешивание с продуктами горения в объёме жаровой трубы.

Средний диаметр жаровой трубы:
$ D_"ж.тр.ср" = (D_к + D_"вых")/2 = (BDᵢₙ + BDₒᵤₜ)/2 = #zm(RawBDᵐₜᵤ) ; $

Высота жаровой трубы в миделевом сечении:
$ h_ж = F_ж / (pi D_"ж.тр.ср.") = BFₘ / (pi BDᵐₜᵤ) = #zm(RawBhᵐₜᵤ) ; $

Диаметр наружной обечайки жаровой трубы:
$ D_"ж.тр.н." = D_"ж.тр.ср." + h_ж = BDᵐₜᵤ + Bhᵐₜᵤ = #zm(RawBDᵗᵒᵖₜᵤ) ; $

Диаметр внутренней обечайки жаровой трубы:
$ D_"ж.тр.вн." = D_"ж.тр.ср." - h_ж = BDᵐₜᵤ - Bhᵐₜᵤ = #zm(RawBDᵇᵒᵗₜᵤ) ; $

Средняя высота между миделевым и выходным сечениями:
$ h_"ср" = (h_ж + h_"вых")/2 = (Bhᵐₜᵤ + Bhₒᵤₜ)/2 = #zm(RawBhᵐₘ) ; $

Длина газосборника:
$ L_"гс" = X_3 dot h_"ср" = BX3 dot Bhᵐₘ = #zm(RawBLᵧ) ; $

Площадь кольцевых каналов:
$ F_"кк" = X_4 dot F_к = BX4 dot BFₘ = #zm2(RawBFₖₖ) ; $

Диаметр наружного корпуса камеры сгорания:
$ D_"кс.н." = sqrt(D_"ж.тр.н"^2 + 2/pi F_"кк") = sqrt(BDᵗᵒᵖₜᵤ^2 + 2/pi dot BFₖₖ ) = #zm(RawBDᵇᵒᵗ) ; $

Диаметр внутреннего корпуса камеры сгорания:
$ D_"кс.вн." = sqrt(D_"ж.тр.вн"^2 - 2/pi F_"кк") = sqrt(BDᵇᵒᵗₜᵤ^2 - 2/pi dot BFₖₖ) = #zm(RawBDᵗᵒᵖ) ; $

Длина зоны горения:
$ L_"зг" = 0.8 h_ж = 0.8 dot Bhᵐₜᵤ = #zm(RawBLᵦₐ) ; $

Длина жаровой трубы:
$ L_ж = L_"зг" + L_"гс" = BLᵦₐ + BLᵧ = #zm(RawBLₜᵤ) ; $

Степень расширения малого "безотрывного" диффузора:
$ n_"д1" = 5 alpha_d^(-0.38) = 5 dot Bαd^(-0.38) = Bnᵈ1;  $

Высота канала на выходе из малого "безотрывного" диффузора:
$ h_"д1" = n_"д1" dot h_к = Bnᵈ1 dot Bhᵢₙ = #zm(RawBhᵈ1) ; $

Длина малого "безотрывного" диффузора:
$ L_"д1" = (h_"д1" - h_к)/2 = (Bhᵈ1 - Bhᵢₙ)/2 = #zm(RawBLᵈ1) ; $

Расстояние от выхода из малого "безотрывного" диффузора до торцов топливных форсунок:
$ Delta = 2.5 h_к = 2.5 Bhᵢₙ = #zm(RawBΔ) ; $

Длина камеры сгорания:
$ L_"кс" = L_ж + Delta + L_"д1" = BLₜᵤ + BΔ + BLᵈ1 = #zm(RawBLᶜᵒᵐᵇ) ; $

Число форсунок:
$ N_ф = ceil(3 dot 100 dot F_ж) = ceil(3 dot 100 dot BFₘ) = BNᶠ; $

Число форсунок, подключаемых на запуске:
$ N_ф^"зап" = ceil(1.5 dot 100 dot F_ж) = ceil(1.5 dot 100 dot BFₘ) = BNᶠ1; $

Объём пламенной трубы:
$ V_ж = 0.8 dot F_ж dot L_ж = 0.8 dot BFₘ dot BLₜᵤ = #zm3(RawBVₜᵤ) ; $

Площадь боковой поверхности жаровой трубы:
$ S' = (D_"ж.тр.вн" + D_"ж.тр.н") dot pi dot L_ж = (BDᵗᵒᵖₜᵤ + BDᵇᵒᵗₜᵤ) dot pi dot BLₜᵤ = #zm2(RawBSˡ), $
$ K_S = 0.542 dot S' + 0.687 = 0.542 dot BSˡ + 0.687 = BKₛ, $
$ S_ж = K_S dot S' = BKₛ dot BSˡ = #zm2(RawBSₜᵤ) ; $

#pagebreak()
Объём зоны горения:
$ V_"зг" = F_ж dot L_"зг" = BFₘ dot BLᵦₐ = #zm3(RawBVᵦₐ) ; $

Проверка функциональных ограничений:
$ (0.23 (1 - F_к / F_"кк") dot pi dot D_к [(h_"д1" + h_"к")L_"д1" + Delta (D_"кс.н." - D_"кс.вн.")] h_к^0.38 ) / (2 F_к (L_"д1" + Delta)^1.38) = Bk1 < 0.6; $
$ 5 <= F_ж / (sum mu F_"ож") = Bk2 <= 7, $
$ F_"кк" / (sum mu F_"ож") = Bk3 >= 1.9, $
$ dash(t)_ф = (pi dot D_"ж.тр.ср") / (N_ф dot h_ж) = Btf <=1,  $
$ T_w = T_к &+ 30.6/(1 + 0.8 alpha dot L_0) dot [ -0.11 (S_ж/V_ж)^2 + 19.3 (S_ж/V_ж) ] = BTω <= #zK(1310) ; $

Камера сгорания прошла по всем функциональным ограничениям.

== Расчет коэффициентов сопротивления и потерь в камере сгорания

Расчет полноты сгорания:
$ eta &= 1 - 10^(-3) dot (E I_"HC" + 0.232 dot E I_"CO") = \ &= 1 - 10^(-3) dot (BEIHC + 0.232 dot BEICO) = Bη; $

Коэффициент окружной неравномерности поля температуры газа на выходе из КС:
$
  Theta_max &= 1.2 ( [0.0144 (F_ж/(sum mu F_"ож"))^2 - 0.178 (F_ж/(sum mu F_"ож")) + 1] dot exp(0.377 h_"ср" / L_"гс") ) / ( (F_ж / F_"вых")^1.11 (1 - 1.19 dot exp( - F_"кк" / (sum mu F_"ож") )) ) = \
  &= 1.2 ( [0.0144 (BFₘ/BμFₒₘ)^2 - 0.178 (BFₘ/BμFₒₘ) + 1] dot exp(0.377 Bhᵐₘ / BLᵧ) ) / ( (BFₘ / BFₒᵤₜ)^1.11 (1 - 1.19 dot exp( - BFₖₖ / BμFₒₘ )) ) =
  BΘₘₐₓ;
$

Коэффициент радиальной неравномерности поля температуры газа:
$ Theta_"r max" = 0.275 Theta_max = 0.275 dot BΘₘₐₓ = BΘʳₘₐₓ; $

#pagebreak()
Коэффициент гидравлического сопротивления жаровой трубы:
$ xi_0 = 0.974 dot (1 + 0.008 (F_ж/(sum mu F_"ож"))) / (1 - 0.68 exp(- F_"кк"/(sum mu F_"ож"))) = 0.974 dot (1 + 0.008 dot BFₘ / BμFₒₘ) / (1-0.68 exp(- BFₖₖ / BμFₒₘ)) = Bξ0; $

Суммарный коэффициент гидравлического сопротивления КС:
$ xi_д = (1 - F_к / (1.1 F_"кк"))^2 = (1 - BFᵢₙ / (1.1 dot BFₖₖ))^2 = Bξd; $
$
  xi_"кс"
  &= xi_д + xi_0 (F_"кк"/(sum mu F_"ож"))^2 (F_к/F_"кс")^2 (1- delta_(sum "отб"))^2 = \
  &= Bξd + Bξ0 dot (BFₖₖ / BμFₒₘ)^2 (BFᵢₙ / BFₖₖ)^2 (1 - Bδₛᵤₘ)^2 = Bξₖₛ; 
$

Коэффициент скорости на входе в КС:
$ lambda_к = 1.6 dot (G_в dot T_к^0.5) / (P_к dot 10^5 dot F_к) = 16 dot (AGₙ dot BTₖ^2)/(CPsₖ dot BFᵢₙ) = Bλₖ; $

Коэффициент потерь полного давления в КС:
$ delta_"кс" &= 1 - 0.583 dot xi_"кс" (1 - 0.167 dot lambda_к^2) dot lambda_к^2 = \ &= 1 - 0.583 dot Bξₖₛ dot (1- 0.167 dot Bλₖ^2) dot Bλₖ^2 = Bδₖₛ; $

== Расчет эмиссии загрязняющих веществ

Важным параметром современной камеры сгорания энергетической ГТУ является её экологичность --- ГТУ с высокоэкологичной камерой сгорания можно эксплуатировать в городской застройке. Оновными загрязняющими веществами для ГТУ являются:
+ Оксиды азота;
+ Оксиды углерода;
+ Несгоревшие углеводороды;
+ Бензапирен;

Особую опасность для человека представляет бензапирен, так как он имеет высокую канцерогенную активность.

#pagebreak()
Индекс эмиссии оксидов азота:
$
  E I_(N O_x)
  &= 710.63 dot P_к^1.5 dot V_"зг"/G_в dot T_г/T_к dot exp(T_к/288) dot \
  &dot (1 - 0.181 F_ж / (sum mu F_"ож") + 0.0124[F_ж/(sum mu F_"ож")]^2) exp(-0.08 dash(W) - 0.492 mu dash(F)_3) dot \
  &dot (1 + 0.277 exp[ - N_ф / F_ж dot 10^(-2) ]) = \
  &= 710.63 dot (CPsₖ/ 10^6)^1.5 dot BVᵦₐ / AGₙ dot ATs0/BTₖ dot exp(BTₖ/288) dot \
  &dot (1 - 0.181 BFₘ / BμFₒₘ + 0.0124[BFₘ/BμFₒₘ]^2) exp(-0.08 dot BW̄ - 0.492 dot BμF̄3) dot \
  &dot (1 + 0.277 exp[ - BNᶠ / BFₘ dot 10^(-2) ]) = #zg-kg(RawBEINOX) ;
$

Индекс эмиссии оксидов углерода:
$
  E I_"CO"
  =& 191.78 dot P_к^(-1.8) dot G_в/V_ж dot T_г^(-1) dot exp(-T_к/288) dot (K_к)_"жт"^"HC" = \
  =& 191.78 dot (CPsₖ/10^6)^(-1.8) dot AGₙ/BVₜᵤ dot ATs0^(-1) dot exp(-BTₖ/288) dot BKₖCO = \
  =& #zg-kg(RawBEICO) ;
$

$
  (K_к)_"жт"^"CO"
  &= exp(1.1 dot 10^(-5) [N_ф/F_ж]^2 - 1.02 dot 10^(-2) dot N_ф/F_ж) dot (1 + 8.11 mu dash(F)_3 ) dot \
  &dot (1 + 0.118 F_ж/(sum mu F_"ож")) dot (1 - 1.09 dash(W) + 0.463 dash(W)^2) dot \
  &dot (1 + 2.105 dot d_э / D_э - 1.59 dot [d_э/D_э]^2) dot (0.924 + 0.132 (mu F_"охл")/(sum mu F_"ож")) = \
  &= exp(1.1 dot 10^(-5) [BNᶠ/BFₘ]^2 - 1.02 dot 10^(-2) dot BNᶠ/BFₘ) dot (1 + 8.11 BμF̄3 ) dot \
  &dot (1 + 0.118 BFₘ/BμFₒₘ) dot (1 - 1.09 BW̄ + 0.463 BW̄^2) dot \
  &dot (1 + 2.105 dot Bde - 1.59 dot Bde^2) dot (0.924 + 0.132 dot BμF̄3/BμFₒₘ) = BKₖCO;
$

#pagebreak()
Индекс эмиссии несгоревших углеводородов:
$
  E I_"HC"
  &= 43.35 P_к^(-1.8) dot G_в/V_ж T_г^(-1) exp(-T_к/288) dot (K_к)_"жт"^"HC" = \
  &= 43.35 (CPsₖ / 10^6)^(-1.8) dot AGₙ/BVₜᵤ ATs0^(-1) exp(-BTₖ/288) dot BKₖHC = \
  &= #zg-kg(RawBEIHC) ;
$

$
  (K_к)_"жт"^"HC"
  &= exp(4 dot 10^(-6) [N_ф/F_ж]^2 - 2.85 dot 10^(-3) dot N_ф/F_ж) dot \
  &dot (1- 8.8 mu dash(F)_3 + 24.45 (mu dash(F)_3)^2) dot (1 + 0.108 F_ж/(sum mu F_"ож")) dot \
  &dot (1 - 0.901 dash(W) + 0.295 dash(W)^2) dot (1 + 7.51 dot d_э / D_э - 6.77 dot [d_э/D_э]^2) dot \
  &dot (0.925 + 0.279 (mu F_"охл")/(sum mu F_"ож")) = \
  
  &= exp(4 dot 10^(-6) [BNᶠ/BFₘ]^2 - 2.85 dot 10^(-3) dot BNᶠ/BFₘ) dot \
  &dot (1- 8.8 dot BμF̄3 + 24.45 dot BμF̄3^2) dot (1 + 0.108 BFₘ/BμFₒₘ) dot \
  &dot (1 - 0.901 dot BW̄ + 0.295 dot BW̄^2) dot (1 + 7.51 dot Bde - 6.77 dot Bde^2) dot \
  &dot (0.925 + 0.279 BμF̄3/BμFₒₘ) = BKₖHC ;
$

Индекс эмиссии бензапирена:
$ E I_"БП" = 2.51 dot 10^(-5) E I_"HC" = 2.51 dot 10^(-5) dot BEIHC = #zg-kg(RawBEIBP) ; $

Расчет массовой концентрации загрязняющих веществ:

$ [N O_x] = (E I_(N O_x) dot 1.25 dot 10^3)/(2.05 dot (1 + alpha L_0)) = (BEINOX dot 1.25 dot 10^3)/(2.05 dot (1 + Bα dot BL0)) = #zppm(RawBMNOX) ; $

$ [C O] = (E I_(C O) dot 1.25 dot 10^3)/(1.25 dot (1 + alpha L_0)) = (BEICO dot 1.25 dot 10^3)/(1.25 dot (1 + Bα dot BL0)) = #zppm(RawBMCO) ; $

$ [H C] = (E I_(H C) dot 1.25 dot 10^3)/(0.715 dot (1 + alpha L_0)) = (BEIHC dot 1.25 dot 10^3)/(0.715 dot (1 + Bα dot BL0)) = #zppm(RawBMHC) ; $

= Предварительный расчет турбины <chapter-turb>

Целью предварительного расчёта турбины является определение характерного напорного параметра и параметров на выходе из турбины.

Удельная изобарная теплоёмкость газа: 
$ C_p = R dot (k/(k-1)) = CORᵧ dot ( COkᵧ / (COkᵧ -1) ) = #zJ-kgK(RawCOCpᵧ) ; $

Удельная внутренняя мощность турбины:
$ H_(u T) = N dot alpha_N / G = TAN dot COkₙₜ / AGᵧ = #zJ-kg(RawTHᵤₜ) ; $

Температурный перепад на турбину по параметрам торможения:
$ Delta t_T = H_(u T) / C_p = THᵤₜ / COCpᵧ = #zK(RawTΔTsₜ) ; $

Температура торможения за турбиной:
$ T^*_(2 T) = T^*_0 - Delta t_T = ATs0 - TΔTsₜ = #zK(RawTTs2ₜ) ; $

Критическая скорость потока газа за турбиной:
$ alpha_"кр" = sqrt( (2 k)/(k+1) ) dot R dot T^*_(2 T) = sqrt( (2 dot COkᵧ) / (COkᵧ + 1) ) dot CORᵧ dot TTs2ₜ = #zm-s(RawTaᵏʳ2) ; $

Скорость потока газа за турбиной:
$ c_(2 T) = alpha_"кр" dot lambda = Taᵏʳ2 dot COY = #zm-s(RawTc2ₜ) ; $

Адиабатный перепад энтальпий на турбину:
$ H_"ад" = H_(u T) + c_(2 T)^2/2 = THᵤₜ + Tc2ₜ^2/2 = #zJ-kg(RawTHₐₜ) ; $

Изоэнтропийный перепад энтальпий на турбину:
$ H_(0 T) = H_"ад" / eta_"ад" = THₐₜ / COηₐₜ = #zJ-kg(RawTH0ₜ) ; $

Температура в потоке за турбиной при изоэнтропийном процессе расширения:
$ T_(2 t T) = T_0^* - H_(0 T)/C_p = ATs0 - TH0ₜ/COCpᵧ = #zK(RawTTs2ₜₜ) ; $

Давление в потоке за турбиной:
$ p_(2 T) = p_0^* (T_(2 t T)/T_0^*)^(k/(k-1)) = TPs0 (TTs2ₜₜ / ATs0)^(COkᵧ / (COkᵧ-1)) = #zPa(RawTP2ₜ) ; $

#pagebreak()
Температура в потоке за турбиной:
$ T_(2 T) = T^*_(2 T) - c_(2 T)^2/2 = TTs2ₜ - Tc2ₜ^2/2 = #zK(RawTT2T) ; $

Плотность в потоке за турбиной:
$ rho_(2 T) = p_(2 T) / (T_(2 T) dot R) = TP2ₜ / (TT2T dot CORᵧ) = #zkg-m3(RawTρ2ₜ) ; $

Площадь живого сечения на выходе из рабочего колеса последней ступени:
$ F_(2 T) = G/(rho_(2 T) dot c_(2 T) dot sin(alpha_(2 T))) = AGᵧ / (Tρ2ₜ dot Tc2ₜ dot sin COå degree ) = #zm2(RawTF2ₜ) ; $

//$ sigma_p = 0.89 dot 10^(-5) dot n^2 dot F_(2 T) = $

Окружная скорость потока на выходе из турбины по среднему диаметру:
$ u_2 = pi d_"ср" n/60 = pi dot RawTAγ dot TAn / 60 = #zm-s(RawTu2) ; $

Высота лопаток последней ступени:
$ l_2 = F_(2 T) / (pi d_"ср") = TF2ₜ / (pi dot Td2ₘ) = #zm(RawTl2) ; $

Коэффициент веерности последней ступени:
$ C_u = d_"ср"/l_2 = Td2ₘ / Tl2 = Tkₘ ; $

Характерный напорный параметр:
$ Y = u_2 dot sqrt(m / (2 H_(0 T) ) ) = Tu2 dot sqrt( COm / (2 dot TH0ₜ) ) = COY,  $

#noind что соответствует рекомендованным значениям $(0,5...0,6)$.

= Профилирование меридианных обводов проточной части

Зная полученную длину рабочей лопатки и средний диаметр последней ступени турбины, основываясь на прототипе постоим проточную часть с постоянным корневым диаметром (@Mer[рисунок]). Основываясь на соотношениях между сторонами лопаток и промежутками между ними, а также установив угол раскрытия $gamma = TAγ degree$, из эскиза были получены меридиональные контуры и высоты всех лопаток.

#figure(
  image("assets/plots/geometry.svg"),
  caption: [Продольный разрез проектируемой проточной части],
) <Mer>

В @geometry указаны полученные высоты сопловых и рабочих лопаток.

#figure(
  table(
    columns: (auto, auto, auto, auto, auto),
    align: center,
    [Номер ступени], [1],[2],[3],[4],
    [Сопловая лопатка, $l_1$, м], $P1l1$, $P2l1$, $P3l1$, $P4l1$,
    [Рабочая  лопатка, $l_2$, м], $P1l2$, $P2l2$, $P3l2$, $P4l2$,
  ),
  caption: [Высоты лопаток],
) <geometry>

= Расчет турбины по среднему диаметру

Целью расчета турбины по среднему диаметру является получение термодинамических и аэродинамических параметров потока газа на среднем диаметре каждой ступени турбины.

Для учёта потерь на неизоэнтропийность вводятся параметры $#sym.Phi = frac(c_1,c_(1t), style: "horizontal")$ и $#sym.Psi = frac(w_2, w_(2t), style: "horizontal")$, значение каждого из которых назначается в промежутке от $0.94$ до $0.98$. От этих параметров зависят, в том числе, мощность турбины и угол выхода потока из последней ступени при неизменном расходе. Для минимизации потерь энергии с выходной скоростью угол выхода потока из последней ступени $alpha_2^*$ должен быть как можно ближе к $90 degree$. Для каждого значения параметров $#sym.Phi$ и $#sym.Psi$ существует лишь одно значение расхода $G_"opt"$, обеспечивающее угол $alpha_2^* = 90 degree$, что показано на @AnglePlot.

#figure(
  lq.diagram(
    margin: 0%, height: 6cm, ylim: (75, 110),
    xlabel: $G, "кг/c"$, ylabel: $alpha_2$,

    lq.plot(mark-size: 0pt, stroke: 2pt, smooth: true, color: blue,
    (RawTGᵧ -20, RawTGᵧ, RawTGᵧ +20), (106, 90, 81) ),

    lq.line( (RawTGᵧ, 100%), (RawTGᵧ, 90), stroke: (thickness: 1pt, dash: "dashed") ),
    lq.line( (0%, 90), (RawTGᵧ,90), stroke: (thickness: 1pt, dash: "dashed") ),

    lq.scatter( (RawTGᵧ,RawTGᵧ), (90,0), size: 12pt, color: blue, label: $G_"опт" = TGᵧ(#sym.Phi = P1Φ, #sym.Psi = P1Ψ)$),
  ),
  caption: [График зависимости угла потока газа на выходе из среднего сечения последней ступени турбины от расхода газа для определённых значений параметров $#sym.Phi$ и $#sym.Psi$]
) <AnglePlot>

Таким образом, для соответствия расчета турбины по среднему диаметру вариантному расчету с использованием A2GTP необходимо провести варьирование этого расчета по параметрам $#sym.Phi$ и $#sym.Psi$, чтобы найти и назначить такие их значения, при которых достигаются мощность и расход газа $G_"opt"$, равные полученным в @chapter-turb. Результат варьирования показан на @Gopt в виде поля распределения $G_"opt" (#sym.Phi, #sym.Psi)$, на котором показаны линии целевой мощности и расхода. Видно, что обеспечение необходимых мощности и расхода происходит только в одной точке при параметрах $#sym.Phi = P1Φ $, $#sym.Psi = P1Ψ $.

#figure(
  {
    image("assets/plots/G.svg")
    text(12pt)[Розовой линией показан целевой расход, желтой линией показана целевая мощность]
  },
  caption: [Зависимость оптимального расхода газа через турбину от параметров $#sym.Phi$ и $#sym.Psi$],
) <Gopt>

В @S показаны результаты расчета по среднему диаметру.

#let tbl_S = table(
  columns: (auto, auto, auto, auto, auto, auto),
  align: horizon, row-gutter: (1.7pt, auto),
  table.header([Величина и формула], [Ед.из.], [Ступень 1], [Ступень 2], [Ступень 3], [Ступень 4]),
  $ p_0^* = p^*_(2(i-1)) $, [Па],
    S1ps0,S2ps0,S3ps0,S4ps0,
  $ T_0^* = T^*_(2(i-1)) $, [К],
    S1Ts0,S2Ts0,S3Ts0,S4Ts0,
  $ H_0 = H_(0 t)/ m $, [Дж/кг],
    S1H0,S2H0,S3H0,S4H0,
  $ T_(2 t t) = T_0^* - H_0 / C_p $, [К],
    S1T2tt,S2T2tt,S3T2tt,S4T2tt,
  $ p_2 = p_0^* dot (T_(1 t t)/T_0^*)^(k/(k-1)) $, [Па],
    S1p2,S2p2,S3p2,S4p2,
  $ c_(1 t) = sqrt(2 (1- rho_(t "ср") ) dot H_0) $, [м/с],
    S1c1t,S2c1t,S3c1t,S4c1t,
  $ c_1 = #sym.Phi c_(1 t) $, [м/с],
    S1c1,S2c1,S3c1,S4c1,
  $ T_(1 t) = T_0^* - c_(1 t)^2 / (2 C_p) $, [К],
    S1T1t,S2T1t,S3T1t,S4T1t,
  $ p_1 = p_0^* dot (T_(1 t)/T_0^*)^(k/(k-1)) $, [Па],
    S1p1,S2p1,S3p1,S4p1,
  $ T_1 = T_0^* - c_1^2 / (2 C_p) $, [К],
    S1T1,S2T1,S3T1,S4T1,
  $ rho_1 = p_1 / (R dot T_1) $, [кг/$м^3$],
    S1ρ1,S2ρ1,S3ρ1,S4ρ1,
  $ F_(1 r) = (G dot R dot T_1) / (p_1 dot c_1) $,$м^2$,
    S1F1r,S2F1r,S3F1r,S4F1r,
  $ F_1 = pi dot d_(1 "ср") dot l_1 $,$м^2$,
    S1F1,S2F1,S3F1,S4F1,
  $ alpha_1 = arcsin(F_(1 r)/F_1) $, [град],
    S1α1,S2α1,S3α1,S4α1,
  $ c_(1 u) = c_1 dot cos(alpha_1) $, [м/с],
    S1c1u,S2c1u,S3c1u,S4c1u,
  $ c_(1 z) = c_1 dot sin(alpha_1) $, [м/с],
    S1c1z,S2c1z,S3c1z,S4c1z,
  $ u_1 = pi dot d_(1 c) dot n/60 $, [м/с],
    S1u1,S2u1,S3u1,S4u1,
  $ u_2 = pi dot d_(2 c) dot n/60 $, [м/с],
    S1u2,S2u2,S3u2,S4u2,
  $ w_(1 u) = c_(1 u) - u_1 $, [м/с],
    S1w1u,S2w1u,S3w1u,S4w1u,
  $ w_1 =sqrt(c_(1 z)^2 + w_(1 u)^2) $, [м/с],
    S1w1,S2w1,S3w1,S4w1,
  $ beta_1 = arctan(c_(1 z)/w_(1 u)) $, [град],
    S1β1,S2β1,S3β1,S4β1,
  $ T^*_w_1 = T_1 + w_1^2 / (2 C_p) $, [К],
    S1Tsw1,S2Tsw1,S3Tsw1,S4Tsw1,
  $ p^*_w_1 = p_1 dot (T^*_w_1 / T_1)^(k/(k-1)) $, [Па],
    S1psw1,S2psw1,S3psw1,S4psw1,
  $ T^*_w_2 = T^*_w_1 - (u_1^2 - u_2^2)/(2 C_p) $, [К],
    S1Tsw2,S2Tsw2,S3Tsw2,S4Tsw2,
  $ p^*_(w_2 t) = p^*_w_1 dot (T^*_w_2/T^*_w_1)^(k/(k-1)) $, [Па],
    S1psw2t,S2psw2t,S3psw2t,S4psw2t,
  $ H^*_2 = C_p dot T^*_w_2 dot (1 - (p_2 / p^*_(w_2 t))^((k-1)/k) ) $, [Дж/кг],
    S1Hs2,S2Hs2,S3Hs2,S4Hs2,
  $ w_(2 t) = sqrt(2 H^*_2) $, [м/с],
    S1w2t,S2w2t,S3w2t,S4w2t,
  $ w_2 = Psi w_(2 t) $, [м/с],
    S1w2,S2w2,S3w2,S4w2,
  $ T_2 = T^*_w_1 - w_2^2 / (2 C_p) $, [К],
    S1T2,S2T2,S3T2,S4T2,
  $ F_(2 r) = (G dot R dot T_2) / (p_2 dot w_2) $,$м^2$,
    S1F2r,S2F2r,S3F2r,S4F2r,
  $ F_2 = pi dot d_(2 "ср") dot l_2 $,$м^2$,
    S1F2,S2F2,S3F2,S4F2,
  $ beta_2^* = arcsin( F_(2 r)/F_2) $, [град],
    S1βs2,S2βs2,S3βs2,S4βs2,
  $ w_(2 u) = w_2 dot cos(beta_2^*) $, [м/с],
    S1w2u,S2w2u,S3w2u,S4w2u,
  $ c_(2 z) = w_(2 z) = u_2 dot sin(beta_2^*) $, [м/с],
    S1c2z,S2c2z,S3c2z,S4c2z,
  $ c_(2 u) = u_2 dot cos(beta_2^*) $, [м/с],
    S1c2u,S2c2u,S3c2u,S4c2u,
  $ alpha_2^* = -arctan(c_(2 z)/c_(2 u)) $, [град],
    S1αs2,S2αs2,S3αs2,S4αs2,
  $ c_2 = sqrt(c_(2 z)^2 + c_(2 u)^2) $, [м/с],
    S1c2,S2c2,S3c2,S4c2,
  $ T^*_2 = T_2 + c_2^2 / (2 C_p) $, [К],
    S1Ts2,S2Ts2,S3Ts2,S4Ts2,
  $ p_2^* = p_2 dot (T_2^* / T_2)^((k-1)/k) $, [Па],
    S1ps2,S2ps2,S3ps2,S4ps2,
  $ M_c_1 = c_1 / sqrt(k dot R dot T_1) $, [],
    S1Mc1,S2Mc1,S3Mc1,S4Mc1,
  $ M_w_2 = w_2 / sqrt(k dot R dot T_2) $, [],
    S1Mw2,S2Mw2,S3Mw2,S4Mw2,
  $ T^*_(2 t t) = T_(2 t t) dot (p_2^* / p_2)^((k-1)/k) $, [К],
    S1Ts2tt,S2Ts2tt,S3Ts2tt,S4Ts2tt,
  $ eta_u = (T^*_0 - T^*_2) / (T^*_0 - T_(2 t t)) $, [],
    S1ηᵤ,S2ηᵤ,S3ηᵤ,S4ηᵤ,
  $ eta_u^* = (T^*_0 - T^*_2) / (T^*_0 - T^*_(2 t t)) $, [],
    S1ηsᵤ,S2ηsᵤ,S3ηsᵤ,S4ηsᵤ,
)

#figure(
  kind: table,
  caption: [Расчет параметров по среднему диаметру],
  table-multi-page(
    continue-header-label: [Продолжение таблицы @S[]],
    tbl_S,
  ),
) <S>

= Расчет закрутки потока последней ступени <Par-rot>

Расчет закрутки потока производится по обратному закону:
$ r^n dot tan(alpha) = b; $

#noind где $r$ --- радиус сечения;\ #hide[где] $alpha$ --- угол потока;\ #hide[где] $n, b$ --- константы.

Применение этого закона обеспечивает высокую эффективность выходного диффузора, поскольку повышение давления у периферии "отжимает" поток газа от стенок диффузора, противодействуя центробежной силе, что приводит к более равномерному распределению потока в радиальном направлении. Градиент давления, обеспеченный этим законом закрутки в результате расчета, показан на @p-groth[рисунке].

#figure(
  lq.diagram(
    height: 6cm, xaxis: (tick-distance: 1, subticks: none),
    xlabel: $i$, ylabel: $p_2, "Па"$,

    lq.plot(stroke: 2pt, mark-size: 8pt, smooth: true, (1,2,3,4,5),
      (RawR1p2, RawR2p2, RawR3p2, RawR4p2, RawR5p2),
    ),
  ),
  caption: [Градиент давления по сечениям за последней ступенью турбины]
) <p-groth>

На @rho-groth показано распределение кинематической и термодинамической степени реактивности по сечениям за последней ступенью турбины, обеспеченное обратным законом закрутки в результате расчета. Видно, что рост обеих степеней реактивности близок к линейному.

#figure(
  lq.diagram(
    height: 6cm, xaxis: (tick-distance: 1, subticks: none),
    xlabel: $i$, ylabel: $rho$, legend: (position:bottom + right),

    lq.plot(stroke: 2pt, mark-size: 8pt, smooth: true, (1,2,3,4,5),
      (RawR1ρK, RawR2ρK, RawR3ρK, RawR4ρK, RawR5ρK), label: $rho_K$
    ),
    lq.plot(stroke: 2pt, mark-size: 8pt, smooth: true, (1,2,3,4,5),
      (RawR1ρT, RawR2ρT, RawR3ρT, RawR4ρT, RawR5ρT), label: $rho_T$
    ),
  ),
  caption: [Распределение кинематической и термодинамической степени реактивности по сечениям за последней ступенью турбины]
) <rho-groth>

В рассматриваемом расчете происходит варьирование по четырем параметрам:
+ Угол потока в абсолютном движении на периферии: $ 13 degree < alpha_1 < alpha_(1 "ср");$
+ Угол потока в относительном движении на периферии: $15 degree < beta_2^* < 65 degree; $
+ Параметр, определяющий отрицательный градиент осевой составляющей вектора скорости: $-0.5 < F < 0 $ ;
+ Кинематическая степень реактивности в корневом сечении: $rho_к (r'_2). $

Для поиска оптимальных значений этих параметров при ряде выбранных значений $alpha_1$ и $beta_2^*$ было проведено варьирование по параметрам $F$ и $rho_к$, в результате которого было построено поле распределения значений отклонения от линейного роста давлений на выходе из ступени $p_2$,  и разницы суммарной кинематической степени реактивности и суммарной полиномиальной степени реактивности $Delta rho$ при допустимых значениях параметров. Критерием допустимости является монотонный рост давлений $p_2$ от корня к периферии и значения $Delta rho < 0.1$, что позволяет не тратить вычислительные ресурсы на заведомо неподходящие комбинации параметров. Полученные поля изображены на @var.

Критерием оптимального значения является наименьшее отклонение роста давлений $p_2$ от линейного, выраженное в минимизации параметра $sigma$. Оптимальное значение показано на @var красной точкой.

#figure(
  image("assets/plots/var.svg", width: 100%),
  caption: [Поле распределения значений $sigma$ и $Delta$ при допустимых значениях параметров],
) <var>

Значения констант для расчета закрутки потока на входной кромке:

$ n_1 
  = (ln ( tg(alpha_(1 "пер"))/ tg(alpha_(1 "ср")) ) )/ ln(r_(1 "ср") / r_(1 "пер"))
  = (ln ( tg(R5α1 degree)/tg(R3α1 degree) ))/ ln(R3r/R5r) = SIn1;
$

$ b_1 = r_(1 "пер")^(n_1) dot tg(alpha_(1 "пер")) = R5r ^ SIn1 dot tg( R5α1 degree ) = SIb1. $

Значения констант для расчета закрутки потока на выходной кромке:

$ n_2 = (ln tg(beta_(2 "пер")^*)/ tg(beta_(2 "ср")^*) )/ ln(r_(2 "пер") / r_(2 "ср")) = (ln ( tg(R5βs2 degree )/ tg(R3βs2 degree) ) )/ ln( R5r/R3r ) = SIn2; $

$ b_2 = r_(2 "ср")^(n_2) dot tg(beta_(2 "ср")^*) = R3r^SIn2 dot tg(S4βs2 degree) = SIb2. $

Коэффициенты для определения осевой составляющей скорости в абсолютном движении на выходе из соплового аппарата:

$ A = (F dot c_(1 z "ср"))/(r_(1 "пер")-r_(1 "ср")) = (SIF dot R3c1z ) / ( 0.5 dot P4l1 ) = SIA; $

$ B = c_(1 z "ср") - (F dot c_(1 z "ср"))/(r_(1 "пер")-r_(1 "ср")) dot r_(1 "ср") = R3c1z - (SIF dot R3c1z)/( 0.5 dot P4l1) dot R3r = SIB; $

Для среднего сечения параметры берутся из расчета по среднему диаметру, для остальных сечений для расчёта применяются формулы, представленные в @R[таблице].

Окружная составляющая скорости в относительном движении на корневом диаметре на выходе из рабочего колеса:

$ 
  w'_(2 u) 
  &= - (u'_1 w'_(1 u) + 2 u'_1^2 rho'_к )/ u'_2 
  = - (R1u1 dot R1w1u + 2 dot R1u1^2 dot R1ρK ) / R1u2
  = #zm-s(RawR1w2u);
$

Результаты расчета закрутки на последней ступени по обратному закону для пяти сечений представлены в @R[таблице].

#let tbl_R = table(
  columns: (auto, auto, auto, auto, auto, auto, auto),
  align: horizon, row-gutter: (1.7pt, auto),
  table.header([Величина и формула], [Ед.из.], [Сечение 1], [Сечение 2], [Сечение 3], [Сечение 4], [Сечение 5]),
  $ r_1 $,   [м]   ,
    R1r1  , R2r1  , R3r  , R4r1  , R5r1  ,
  $ r_2 $,   [м]   ,
    R1r  , R2r  , R3r  , R4r  , R5r  ,
  $ γ $, [град],
    R1γ  , R2γ  , R3γ  , R4γ  , R5γ  ,
  $ alpha_1 = arctan(b_1/r_1^n_1) $, [град],
    R1α1 , R2α1 , R3α1 , R4α1 , R5α1 ,
  $ c_(1 z) = r_1 dot A + B $,[м/с],
    R1c1u, R2c1u, R3c1u, R4c1u, R5c1u,
  $ c_(1 u) = c_(1 z) / tan(alpha_1) $,[м/с],
    R1c1z, R2c1z, R3c1z, R4c1z, R5c1z,
  $ c_(1 r) = c_(1 z) dot tan(gamma) $, [м/с],
    R1c1r, R2c1r, R3c1r, R4c1r, R5c1r,
  $ c_1 = sqrt(c_(1 z)^2 + c_(1 u)^2 + c_(1 r)^2) $,  [м/с],
    R1c1 , R2c1 , R3c1 , R4c1 , R5c1 ,
  $ u_1 = 2 pi r_1 dot n/60 $,[м/с],
    R1u1 , R2u1 , R3u1 , R4u1 , R5u1 ,
  $ u_2 = 2 pi r_2 dot n/60 $,[м/с],
    R1u2 , R2u2 , R3u2 , R4u2 , R5u2 ,
  $ w_(1 u) = c_(1 u) - u_1 $, [м/с],
    R1w1u, R2w1u, R3w1u, R4w1u, R5w1u,
  $ beta_1 = arctan(c_(1 z)/(w_(1 u))) $, [град],
    R1β1 , R2β1 , R3β1 , R4β1 , R5β1 ,
  $ w_1 = sqrt(w_(1 u)^2 + c_(1 r)^2 + c_(1 z)^2) $, [м/с],
    R1w1 , R2w1 , R3w1 , R4w1 , R5w1 ,
  $ w_(2 u) = w_(2 u)^(i= 1) + ((w_(2u)^(i =3) - w_(2u)^(i =1)) (i-1))/2 $, [м/с],
    R1w2u, R2w2u, R3w2u, R4w2u, R5w2u,
  $ c_(2 u) = w_(2 u) + u_2 $, [м/с],
    R1c2u, R2c2u, R3c2u, R4c2u, R5c2u,
  $ c_(2 z) = -w_(2 u) dot tan(beta_2^*) $, [м/с],
    R1c2z, R2c2z, R3c2z, R4c2z, R5c2z,
  $ c_(2 r) =  c_(2 z) dot tan(gamma ) $,[м/с],
    R1c2r, R2c2r, R3c2r, R4c2r, R5c2r,
  $ c_2 = sqrt(c_(2 z)^2 + c_(2 u)^2 + c_(2 r)^2) $, [м/с],
    R1c2 , R2c2 , R3c2 , R4c2 , R5c2 ,
  $ alpha_2^* = -arctan(c_(2z) / c_(2u)) $, [град],
    R1αs2, R2αs2, R3αs2, R4αs2, R5αs2,
  $ beta_2^* = arctan(b_2 / r_2^n_2) $, [град],
    R1βs2, R2βs2, R3βs2, R4βs2, R5βs2,
  $ w_2 = c_(2 z) / sin(beta_2^*) $, [м/с],
    R1w2, R2w2, R3w2, R4w2, R5w2,
  $ T_1 = T_0^* - c_1^2 / (2 C_p) $,$ degree C$,
    R1T1, R2T1, R3T1, R4T1, R5T1,
  $ p_1 = p_0^* &dot chi^1 dot \ &dot (1 - c_1^2 / (k/(k-1) dot 2 R dot T_0^*) )^(k/(k-1)) $, [Па],
    R1p1, R2p1, R3p1, R4p1, R5p1,
  $ rho_1 = p_1 / (R dot T_1) $, [кг/$м^3$],
    R1ρ1, R2ρ1, R3ρ1, R4ρ1, R5ρ1,
  $ T^*_w_1 = T_1 + w_1^2 / (2 C_p) $,$ degree C$,
    R1Tsw1, R2Tsw1, R3Tsw1, R4Tsw1, R5Tsw1,
  $ T_2 = T^*_w_1 - w_2^2 / (2 C_p) $,$degree C$,
    R1T2, R2T2, R3T2, R4T2, R5T2,
  $ p_2 = p^*_0 &dot chi^1 dot chi^2 dot \ &dot (1 - (c_1^2 + w_2^2 - w_1^2)/( k/(k-1) dot 2 R dot T^*_0 ) )^(k/(k-1)) $, [Па],
    R1p2, R2p2, R3p2, R4p2, R5p2,
  $ rho_2 = p_2 / (T_2 dot R) $, [кг/$м^3$],
    R1ρ2, R2ρ2, R3ρ2, R4ρ2, R5ρ2,
  $ rho_T = ( (p_1/p_0^*)^((k-1)/k) - (p_2/p_0^*)^((k-1)/k) ) / (1 - (p_2 / p_0^*)^((k-1)/k)) $, [],
    R1ρT, R2ρT, R3ρT, R4ρT, R5ρT,
  $ H_p = (w_2^2 - w_1^2)/2 + (u_1^2 - u_2^2)/2 $, [Дж],
    R1Hₚ, R2Hₚ, R3Hₚ, R4Hₚ, R5Hₚ,
  $ H_u = (c_1^2 - c_2^2)/2 + (w_2^2 - w_1^2)/2 + (u_1^2 - u_2^2)/2 $, [Дж],
    R1Hᵤ, R2Hᵤ, R3Hᵤ, R4Hᵤ, R5Hᵤ,
  $ rho_K = H_p / H_u $, [],
    R1ρK, R2ρK, R3ρK, R4ρK, R5ρK,
  $ ρ_"kп" = a (r-r_1)^2 + b (r-r_1) + c $, [],
    R1ρKp, R2ρKp, R3ρKp, R4ρKp, R5ρKp,
  $ Delta ρ_k = ρ_"kп" - rho_K  $, [],
    R1Δρ, R2Δρ,  R3Δρ, R4Δρ, R5Δρ,
)

#figure(
  kind: table,
  caption: [Расчет закрутки потока для последней ступени турбины],
  table-multi-page(
    continue-header-label: [Продолжение таблицы @R[]],
    tbl_R,
  ),
) <R>

= Построение моделей рабочей и сопловой лопатки

Основываясь на углах из @R[таблицы], строятся треугольники скоростей и профили для 5 сечений рабочей и сопловой лопатки последней ступени турбины. Построение профилей проводится по средней линии и использует кубический сплайн в форме Эрмита для описания средней линии, спинки и корытца. Такой подход позволяет автоматизировать процесс, что выгодно отличает его от метода окружностей, а также упрощает компьютерную обработку и анализ полученных профилей.

Применение именно этой кривой обусловлено тем, что для её построения необходимы координаты и касательный угол в начальной ($x_1, y_1, alpha_1$) и конечной ($x_2, y_2, alpha_2$) точках --- то есть все данные о геометрии, полученные в ходе расчета в @Par-rot. Построение проводится с помощью введения дополнительного параметра относительной координаты $t(x)$ и описывается следующей системой уравнений:
$
  cases(
    h &= (x_2 - x_1),
    t(x) &= frac((x - x_1), h, style:"horizontal"),
    p(t) &= y_1 dot (1 + 2t) (1-t)^2 + y_2 dot t^2 (3-2t) +,
    &+ h dot [tg(alpha_1) t (1-t)^2 + tg(alpha_2) t^2 (t-1) ]
  )
$ <hermite>

Помимо этого, сплайн в форме Эрмита может быть переведён в сплайн в форме Безье и обеспечивает гладкость (непрерывность первой производной) в точках соприкосновения с секторами окружностей входной и выходной кромок @SplineBook.

Для демонстрации конфузорности профилей для каждой точки корытца были подобраны ближайшие точки спинки соседнего профиля, по этим данным построено поле распределения расстояния между профилями вдоль канала. Расстояния в этом поле показаны с помощью перцептивно равномерной цветовой шкалы viridis @Viridis, которая позволяет однозначно сопоставить цвет со значением, в том числе при печати на черно-белом принтере.

// На рисунках @Tri-1[]-@blade-last[] показаны треугольники скоростей и профили соответствующих сечений рабочих лопаток.

// #figure(
//   text(size: 10pt, cetz.canvas(length:0.016cm, {
//     import cetz.draw: *
//     set-style(
//       mark: (transform-shape: false, fill: black),
//       stroke: (cap: "round")
//     )
//     // Variables
//     let c1z = -RawR1c1z
//     let c2z = -RawR1c2z
//     let c1u = -RawR1c1u
//     let c2u = -RawR1c2u
//     let u1  =  RawR1u1
//     let u2  =  RawR1u2
//     let a1  =  RawR1α1
//     let a2  =  RawR1αs2
//     let b1  =  RawR1β1
//     let b2  =  RawR1βs2
//     let c1  = calc.round( RawR1c1 )
//     let c2  = calc.round( RawR1c2 )
//     let w1  = calc.round( RawR1w1 )
//     let w2  = calc.round( RawR1w2 )
    
//     // Оси
//     line((c2u+u2, 0), (c1u, 0), mark:(end: "stealth"), name: "axisu")
//     content("axisu.end", $U$, padding: 20, anchor: "north-west" )
//     line((0,0),(0,c2z - 30), mark:(end: "stealth"), name: "axisz")
//     content("axisz.end", $z$, padding: 5, anchor: "south-west" )

//     // Треугольник 1
//     line(name:"C1", (0,0),(c1u  ,c1z), mark:(end:"stealth", fill:red), stroke:(paint:red, thickness: 2pt))
//     line(name:"W1", (0,0),(c1u + u1, c1z), mark:(end:"stealth", fill:red), stroke:(paint:red, thickness: 2pt))
//     line(name:"U1", "W1.end","C1.end", mark:(end: "stealth", fill:red),stroke:(paint:red, thickness: 2pt))

//     // Треугольник 2
//     line(name:"C2", (0,0),(c2u, c2z), mark:(end:"stealth", fill:blue), stroke:(paint:blue, thickness: 2pt))
//     line(name:"W2", (0,0),(c2u + u2, c2z), mark:(end:"stealth", fill:blue), stroke:(paint:blue, thickness: 2pt))
//     line(name:"U2","W2.end","C2.end", mark:(end: "stealth", fill:blue),stroke:(paint:blue, thickness: 2pt))

//     // линии для U1 и U2
//     line(name:"U1s","U1.start", (rel:(0,-30)))
//     line(name:"U1e","U1.end",   (rel:(0,-30)))
//     line(name:"U_1", "U1s.80%", "U1e.80%", mark:(symbol: "stealth"))
//     line(name:"U2s","U2.start", (rel:(0,-30)))
//     line(name:"U2e","U2.end",   (rel:(0,-30)))
//     line(name:"U_2", "U2s.80%", "U2e.80%", mark:(symbol: "stealth"))

//     // Подписи скоростей
//     content("C1.70%", angle:  a1 * 1deg, box(fill:white, inset:3pt, $C_1 = c1 $))
//     content("W1.70%", angle:  b1 * 1deg, box(fill:white, inset:3pt, $W_1 = w1 $))
//     content("C2.70%", angle: -a2 * 1deg, box(fill:white, inset:3pt, $C_2 = c2 $))
//     content("W2.70%", angle: -b2 * 1deg, box(fill:white, inset:3pt, $W_2 = w2 $))
//     content("U_1", box(fill:white, inset:3pt, $U_1 = #calc.round(u1) $))
//     content("U_2", box(fill:white, inset:3pt, $U_2 = #calc.round(u2) $))

//     // Осевые скорости
//     line(name:"z1", (0,c1z),(c1u + u1,c1z), stroke: (dash: "dashed"))
//     line(name:"z2", (0,c2z),(c2u     ,c2z), stroke: (dash: "dashed"))
//     content("z1", box(fill:white, inset:3pt, $C_z_1 = #calc.round(-c1z) $), anchor: "south")
//     content("z2.0", angle:-90deg, box(inset:3pt, $C_z_2 = #calc.round(-c2z) $), anchor: "south-east")

//     // Дуги
//     arc(name:"a2", (0,0), start:0deg, delta: -a2*1deg, radius:c2/2.3, anchor:"origin", mark:(symbol:"stealth"))
//     arc(name:"b2", (0,0), start:0deg, delta: -b2*1deg, radius:w2/2, anchor:"origin", mark:(symbol:"stealth"))
//     arc(name:"a1", (0,0), start:-180deg, delta: a1*1deg, radius:c1/2, anchor:"origin", mark:(symbol:"stealth"))
//     arc(name:"b1", (0,0), start:180deg, delta: b1*1deg, radius:w1/2, anchor:"origin", mark:(symbol:"stealth"))

//     // Подписи дуг
//     content("a1.50%", angle: a1/2*1deg, box(fill:white, inset:3pt, $alpha_1 = #calc.round(a1) degree$) )
//     content("b1.33%", angle: b1/3*1deg, box(fill:white, inset:3pt, $beta_1 = #calc.round(b1) degree$) )
//     content("a2.33%", angle: -a2/3*1deg, box(fill:white, inset:3pt, $alpha_2^* = #calc.round(a2) degree$) )
//     content("b2.50%", angle: -b2/2*1deg, box(fill:white, inset:3pt, $beta_2^* = #calc.round(b2) degree$) )
//   })),
//   caption: [Треугольники скоростей в корневом сечении РЛ]
// ) <Tri-1>

// #undo-line()

// #figure(
//   image("assets/profiles/2/profile_combined1.svg"),
//   caption: [Профиль РЛ в корневом сечении и демонстрация его конфузорности]
// )

// #figure(
//   text(size: 10pt, cetz.canvas(length:0.016cm, {
//     import cetz.draw: *
//     set-style(
//       mark: (transform-shape: false, fill: black),
//       stroke: (cap: "round")
//     )
//     // Variables
//     let c1z = -RawR2c1z
//     let c2z = -RawR2c2z
//     let c1u = -RawR2c1u
//     let c2u = -RawR2c2u
//     let u1  =  RawR2u1
//     let u2  =  RawR2u2
//     let a1  =  RawR2α1
//     let a2  =  RawR2αs2
//     let b1  =  RawR2β1
//     let b2  =  RawR2βs2
//     let c1  = calc.round( RawR2c1 )
//     let c2  = calc.round( RawR2c2 )
//     let w1  = calc.round( RawR2w1 )
//     let w2  = calc.round( RawR2w2 )
    
//     // Оси
//     line((c2u+u2, 0), (c1u, 0), mark:(end: "stealth"), name: "axisu")
//     content("axisu.end", $U$, padding: 20, anchor: "north-west" )
//     line((0,0),(0,c2z - 30), mark:(end: "stealth"), name: "axisz")
//     content("axisz.end", $z$, padding: 5, anchor: "south-west" )

//     // Треугольник 1
//     line(name:"C1", (0,0),(c1u  ,c1z), mark:(end:"stealth", fill:red), stroke:(paint:red, thickness: 2pt))
//     line(name:"W1", (0,0),(c1u + u1, c1z), mark:(end:"stealth", fill:red), stroke:(paint:red, thickness: 2pt))
//     line(name:"U1", "W1.end","C1.end", mark:(end: "stealth", fill:red),stroke:(paint:red, thickness: 2pt))

//     // Треугольник 2
//     line(name:"C2", (0,0),(c2u, c2z), mark:(end:"stealth", fill:blue), stroke:(paint:blue, thickness: 2pt))
//     line(name:"W2", (0,0),(c2u + u2, c2z), mark:(end:"stealth", fill:blue), stroke:(paint:blue, thickness: 2pt))
//     line(name:"U2","W2.end","C2.end", mark:(end: "stealth", fill:blue),stroke:(paint:blue, thickness: 2pt))

//     // линии для U1 и U2
//     line(name:"U1s","U1.start", (rel:(0,-30)))
//     line(name:"U1e","U1.end",   (rel:(0,-30)))
//     line(name:"U_1", "U1s.80%", "U1e.80%", mark:(symbol: "stealth"))
//     line(name:"U2s","U2.start", (rel:(0,-30)))
//     line(name:"U2e","U2.end",   (rel:(0,-30)))
//     line(name:"U_2", "U2s.80%", "U2e.80%", mark:(symbol: "stealth"))

//     // Подписи скоростей
//     content("C1.70%", angle:  a1 * 1deg, box(fill:white, inset:3pt, $C_1 = c1$))
//     content("W1.70%", angle:  b1 * 1deg, box(fill:white, inset:3pt, $W_1 = w1$))
//     content("C2.70%", angle: -a2 * 1deg, box(fill:white, inset:3pt, $C_2 = c2$))
//     content("W2.70%", angle: -b2 * 1deg, box(fill:white, inset:3pt, $W_2 = w2$))
//     content("U_1", box(fill:white, inset:3pt, $U_1 = #calc.round(u1)$))
//     content("U_2", box(fill:white, inset:3pt, $U_2 = #calc.round(u2)$))

//     // Осевые скорости
//     line(name:"z1", (0,c1z),(c1u + u1,c1z), stroke: (dash: "dashed"))
//     line(name:"z2", (0,c2z),(c2u     ,c2z), stroke: (dash: "dashed"))
//     content("z1", box(inset:3pt, $C_z_1 = #calc.round(-c1z)$), anchor: "south")
//     content("z2.0", angle:-90deg, box(inset:2pt, $C_z_2 = #calc.round(-c2z)$), anchor: "south-east")

//     // Дуги
//     arc(name:"a2", (0,0), start:0deg, delta: -a2*1deg, radius:c2/2.3, anchor:"origin", mark:(symbol:"stealth"))
//     arc(name:"b2", (0,0), start:0deg, delta: -b2*1deg, radius:w2/2, anchor:"origin", mark:(symbol:"stealth"))
//     arc(name:"a1", (0,0), start:-180deg, delta: a1*1deg, radius:c1/2, anchor:"origin", mark:(symbol:"stealth"))
//     arc(name:"b1", (0,0), start:180deg, delta: b1*1deg, radius:w1/2, anchor:"origin", mark:(symbol:"stealth"))

//     // Подписи дуг
//     content("a1.50%", angle: a1/2*1deg, box(fill:white, inset:3pt, $alpha_1 = #calc.round(a1) degree$) )
//     content("b1.65%", angle: b1*0.65*1deg, box(fill:white, inset:3pt, $beta_1 = #calc.round(b1) degree$) )
//     content("a2.65%", angle: -a2*0.65*1deg, box(fill:white, inset:3pt, $alpha_2^* = #calc.round(a2) degree$) )
//     content("b2.50%", angle: -b2/2*1deg, box(fill:white, inset:3pt, $beta_2^* = #calc.round(b2) degree$) )
//   })),
//   caption: [Треугольники скоростей на средне-корневом сечении РЛ]
// ) <Tri-2>

// #undo-line()

// #figure(
//   image("assets/profiles/2/profile_combined2.svg"),
//   caption: [Профиль РЛ в средне-корневом сечении и демонстрация его конфузорности]
// )

// #figure(
//   text(size: 10pt, cetz.canvas(length:0.017cm, {
//     import cetz.draw: *
//     set-style(
//       mark: (transform-shape: false, fill: black),
//       stroke: (cap: "round")
//     )
//     // Variables
//     let c1z = -RawR3c1z
//     let c2z = -RawR3c2z
//     let c1u = -RawR3c1u
//     let c2u = -RawR3c2u
//     let u1  =  RawR3u1
//     let u2  =  RawR3u2
//     let a1  =  RawR3α1
//     let a2  =  RawR3αs2
//     let b1  =  RawR3β1
//     let b2  =  RawR3βs2
//     let c1  = calc.round( RawR2c1 )
//     let c2  = calc.round( RawR2c2 )
//     let w1  = calc.round( RawR2w1 )
//     let w2  = calc.round( RawR2w2 )
    
//     // Оси
//     line((c2u+u2, 0), (c1u, 0), mark:(end: "stealth"), name: "axisu")
//     content("axisu.end", $U$, padding: 20, anchor: "north-west" )
//     line((0,0),(0,c2z - 30), mark:(end: "stealth"), name: "axisz")
//     content("axisz.end", $z$, padding: 5, anchor: "south-west" )

//     // Треугольник 1
//     line(name:"C1", (0,0),(c1u  ,c1z), mark:(end:"stealth", fill:red), stroke:(paint:red, thickness: 2pt))
//     line(name:"W1", (0,0),(c1u + u1, c1z), mark:(end:"stealth", fill:red), stroke:(paint:red, thickness: 2pt))
//     line(name:"U1", "W1.end","C1.end", mark:(end: "stealth", fill:red),stroke:(paint:red, thickness: 2pt))

//     // Треугольник 2
//     line(name:"C2", (0,0),(c2u, c2z), mark:(end:"stealth", fill:blue), stroke:(paint:blue, thickness: 2pt))
//     line(name:"W2", (0,0),(c2u + u2, c2z), mark:(end:"stealth", fill:blue), stroke:(paint:blue, thickness: 2pt))
//     line(name:"U2","W2.end","C2.end", mark:(end: "stealth", fill:blue),stroke:(paint:blue, thickness: 2pt))

//     // линии для U1 и U2
//     line(name:"U1s","U1.start", (rel:(0,-30)))
//     line(name:"U1e","U1.end",   (rel:(0,-30)))
//     line(name:"U_1", "U1s.80%", "U1e.80%", mark:(symbol: "stealth"))
//     line(name:"U2s","U2.start", (rel:(0,-30)))
//     line(name:"U2e","U2.end",   (rel:(0,-30)))
//     line(name:"U_2", "U2s.80%", "U2e.80%", mark:(symbol: "stealth"))

//     // Подписи скоростей
//     content("C1.70%", angle:  a1 * 1deg, box(fill:white, inset:3pt, $C_1 = c1$))
//     content("W1.65%", angle:  b1 * 1deg, box(fill:white, inset:3pt, $W_1 = w1$))
//     content("C2.65%", angle: -a2 * 1deg, box(fill:white, inset:3pt, $C_2 = c2$))
//     content("W2.70%", angle: -b2 * 1deg, box(fill:white, inset:3pt, $W_2 = w2$))
//     content("U_1", box(fill:white, inset:3pt, $U_1 = #calc.round(u1)$))
//     content("U_2", box(fill:white, inset:3pt, $U_2 = #calc.round(u2)$))

//     // Осевые скорости
//     line(name:"z1", (0,c1z),(c1u + u1,c1z), stroke: (dash: "dashed"))
//     content("z1.end", box(inset:3pt, $C_z_1 = #calc.round(-c1z)$), anchor: "south-east")
//     content("U2.end", box(inset:5pt, $C_z_2 = #calc.round(-c2z)$), anchor: "south-west")

//     // Дуги
//     arc(name:"a2", (0,0), start:0deg, delta: -a2*1deg, radius:c2/2.8, anchor:"origin", mark:(symbol:"stealth"))
//     arc(name:"b2", (0,0), start:0deg, delta: -b2*1deg, radius:w2/2, anchor:"origin", mark:(symbol:"stealth"))
//     arc(name:"a1", (0,0), start:-180deg, delta: a1*1deg, radius:c1/2, anchor:"origin", mark:(symbol:"stealth"))
//     arc(name:"b1", (0,0), start:180deg, delta: b1*1deg, radius:w1/3.4, anchor:"origin", mark:(symbol:"stealth"))

//     // Подписи дуг
//     content("a1.50%", angle: a1/2*1deg, box(fill:white, inset:3pt, $alpha_1 = #calc.round(a1) degree$) )
//     content("b1.65%", angle: b1*0.6*1deg, box(fill:white, inset:3pt, $beta_1 = #calc.round(b1) degree$) )
//     content("a2.65%", angle: -a2*0.65*1deg, box(fill:white, inset:3pt, $alpha_2^* = #calc.round(a2) degree$) )
//     content("b2.50%", angle: -b2/2*1deg, box(fill:white, inset:3pt, $beta_2^* = #calc.round(b2) degree$) )
//   })),
//   caption: [Треугольники скоростей в среднем сечении РЛ]
// ) <Tri-3>

// #undo-line()

// #figure(
//   image("assets/profiles/2/profile_combined3.svg"),
//   caption: [Профиль РЛ в среднем сечении и демонстрация его конфузорности]
// )

// #figure(
//   text(size: 10pt, cetz.canvas(length:0.02cm, {
//     import cetz.draw: *
//     set-style(
//       mark: (transform-shape: false, fill: black),
//       stroke: (cap: "round")
//     )
//     // Variables
//     let c1z = -RawR4c1z
//     let c2z = -RawR4c2z
//     let c1u = -RawR4c1u
//     let c2u = -RawR4c2u
//     let u1  =  RawR4u1
//     let u2  =  RawR4u2
//     let a1  =  RawR4α1
//     let a2  =  RawR4αs2
//     let b1  =  RawR4β1
//     let b2  =  RawR4βs2
//     let c1  = calc.round( RawR4c1 )
//     let c2  = calc.round( RawR4c2 )
//     let w1  = calc.round( RawR4w1 )
//     let w2  = calc.round( RawR4w2 )
    
//     // Оси
//     line((c2u+u2, 0), (c1u, 0), mark:(end: "stealth"), name: "axisu")
//     content("axisu.end", $U$, padding: 20, anchor: "north-west" )
//     line((0,0),(0,c2z - 50), mark:(end: "stealth"), name: "axisz")
//     content("axisz.end", $z$, padding: 5, anchor: "south-west" )

//     // Треугольник 1
//     line(name:"C1", (0,0),(c1u  ,c1z), mark:(end:"stealth", fill:red), stroke:(paint:red, thickness: 2pt))
//     line(name:"W1", (0,0),(c1u + u1, c1z), mark:(end:"stealth", fill:red), stroke:(paint:red, thickness: 2pt))
//     line(name:"U1", "W1.end","C1.end", mark:(end: "stealth", fill:red),stroke:(paint:red, thickness: 2pt))

//     // Треугольник 2
//     line(name:"C2", (0,0),(c2u, c2z), mark:(end:"stealth", fill:blue), stroke:(paint:blue, thickness: 2pt))
//     line(name:"W2", (0,0),(c2u + u2, c2z), mark:(end:"stealth", fill:blue), stroke:(paint:blue, thickness: 2pt))
//     line(name:"U2","W2.end","C2.end", mark:(end: "stealth", fill:blue),stroke:(paint:blue, thickness: 2pt))

//     // линии для U1 и U2
//     line(name:"U1s","U1.start", (rel:(0,-30)))
//     line(name:"U1e","U1.end",   (rel:(0,-30)))
//     line(name:"U_1", "U1s.80%", "U1e.80%", mark:(symbol: "stealth"))
//     line(name:"U2s","U2.start", (rel:(0,-30)))
//     line(name:"U2e","U2.end",   (rel:(0,-30)))
//     line(name:"U_2", "U2s.80%", "U2e.80%", mark:(symbol: "stealth"))

//     // Дуги
//     arc(name:"a2", (0,0), start:0deg, delta: -a2*1deg, radius:c2/2.1, anchor:"origin", mark:(symbol:"stealth"))
//     arc(name:"b2", (0,0), start:0deg, delta: -b2*1deg, radius:w2/2, anchor:"origin", mark:(symbol:"stealth"))
//     arc(name:"a1", (0,0), start:-180deg, delta: a1*1deg, radius:c1/2, anchor:"origin", mark:(symbol:"stealth"))
//     arc(name:"b1", (0,0), start:-180deg, delta: b1*1deg, radius:w1/2.8, anchor:"origin", mark:(symbol:"stealth"))

//     // Подписи скоростей
//     content("C1.70%", angle:  a1 * 1deg, box(fill:white, inset:3pt, $C_1 = c1 $))
//     content("W1.64%", angle: 180deg + b1 * 1deg, move(box(fill:white, inset:3pt, $W_1 = w1 $),dy:-2pt))
//     content("C2.70%", angle: 180deg - a2 * 1deg, box(fill:white, inset:3pt, $C_2 = c2 $))
//     content("W2.70%", angle: -b2 * 1deg, box(fill:white, inset:3pt, $W_2 = w2 $))
//     content("U_1", box(fill:white, inset:3pt, $U_1 = #calc.round(u1) $))
//     content("U_2", box(fill:white, inset:3pt, $U_2 = #calc.round(u2) $))

//     // Осевые скорости
//     content("U1.0", box(inset:3pt, $C_z_1 = #calc.round(-c1z) $), anchor: "west")
//     content("U2.end", box(inset:3pt, $C_z_2 = #calc.round(-c2z) $), anchor: "east")

//     // Подписи дуг
//     content("a1.50%", angle: a1/2*1deg, box(fill:white, inset:3pt, $alpha_1 = #calc.round(a1) degree$) )
//     content("b1.50%", angle: b1/2*1deg, move(box(fill:white, inset:3pt, $beta_1 = #calc.round(b1) degree $), dx:-3pt) )
//     content("a2.50%", angle: -a2/2*1deg, box(fill:white, inset:3pt, $alpha_2^* = #calc.round(a2) degree$) )
//     content("b2.50%", angle: -b2/2*1deg, box(fill:white, inset:3pt, $beta_2^* = #calc.round(b2) degree$) )    
//   })),
//   caption: [Треугольники скоростей в средне-периферийном сечении РЛ]
// ) <Tri-4>

// #figure(
//   image("assets/profiles/2/profile_combined4.svg"),
//   caption: [Профиль РЛ в средне-периферийном сечении и демонстрация его конфузорности]
// )

// #undo-line()

// #figure(
//   text(size: 10pt, cetz.canvas(length:0.022cm, {
//     import cetz.draw: *
//     set-style(
//       mark: (transform-shape: false, fill: black),
//       stroke: (cap: "round")
//     )
//     // Variables
//     let c1z = -RawR5c1z
//     let c2z = -RawR5c2z
//     let c1u = -RawR5c1u
//     let c2u = -RawR5c2u
//     let u1  =  RawR5u1
//     let u2  =  RawR5u2
//     let a1  =  RawR5α1
//     let a2  =  RawR5αs2
//     let b1  =  RawR5β1
//     let b2  =  RawR5βs2
//     let c1  = calc.round( RawR5c1 )
//     let c2  = calc.round( RawR5c2 )
//     let w1  = calc.round( RawR5w1 )
//     let w2  = calc.round( RawR5w2 )
    
//     // Оси
//     line((c2u+u2, 0), (c1u, 0), mark:(end: "stealth"), name: "axisu")
//     content("axisu.end", $U$, padding: 20, anchor: "north-west" )
//     line((0,0),(0,c2z - 50), mark:(end: "stealth"), name: "axisz")
//     content("axisz.end", $z$, padding: 5, anchor: "south-west" )

//     // Треугольник 1
//     line(name:"C1", (0,0),(c1u  ,c1z), mark:(end:"stealth", fill:red), stroke:(paint:red, thickness: 2pt))
//     line(name:"W1", (0,0),(c1u + u1, c1z), mark:(end:"stealth", fill:red), stroke:(paint:red, thickness: 2pt))
//     line(name:"U1", "W1.end","C1.end", mark:(end: "stealth", fill:red),stroke:(paint:red, thickness: 2pt))

//     // Треугольник 2
//     line(name:"C2", (0,0),(c2u, c2z), mark:(end:"stealth", fill:blue), stroke:(paint:blue, thickness: 2pt))
//     line(name:"W2", (0,0),(c2u + u2, c2z), mark:(end:"stealth", fill:blue), stroke:(paint:blue, thickness: 2pt))
//     line(name:"U2","W2.end","C2.end", mark:(end: "stealth", fill:blue),stroke:(paint:blue, thickness: 2pt))

//     // линии для U1 и U2
//     line(name:"U1s","U1.start", (rel:(0,-30)))
//     line(name:"U1e","U1.end",   (rel:(0,-30)))
//     line(name:"U_1", "U1s.80%", "U1e.80%", mark:(symbol: "stealth"))
//     line(name:"U2s","U2.start", (rel:(0,-30)))
//     line(name:"U2e","U2.end",   (rel:(0,-30)))
//     line(name:"U_2", "U2s.80%", "U2e.80%", mark:(symbol: "stealth"))

//     // Дуги
//     arc(name:"a2", (0,0), start:0deg, delta: -a2*1deg, radius:c2/2.1, anchor:"origin", mark:(symbol:"stealth"))
//     arc(name:"b2", (0,0), start:0deg, delta: -b2*1deg, radius:w2/2, anchor:"origin", mark:(symbol:"stealth"))
//     arc(name:"a1", (0,0), start:-180deg, delta: a1*1deg, radius:c1/2, anchor:"origin", mark:(symbol:"stealth"))
//     arc(name:"b1", (0,0), start:-180deg, delta: b1*1deg, radius:w1/2.6, anchor:"origin", mark:(symbol:"stealth"))

//     // Подписи скоростей
//     content("C1.70%", angle:  a1 * 1deg, box(fill:white, inset:3pt, $C_1 = c1 $))
//     content("W1.65%", angle: 180deg + b1 * 1deg, box(fill:white, inset:3pt, $W_1 = w1 $))
//     content("C2.70%", angle: 180deg - a2 * 1deg, box(fill:white, inset:3pt, $C_2 = c2 $))
//     content("W2.70%", angle: -b2 * 1deg, box(fill:white, inset:3pt, $W_2 = w2 $))
//     content("U_1.80%", box(fill:white, inset:3pt, $U_1 = #calc.round(u1) $))
//     content("U_2.mid", box(fill:white, inset:3pt, $U_2 = #calc.round(u2) $))

//     // Осевые скорости
//     content("U1.0", box(inset:3pt, $C_z_1 = #calc.round(-c1z) $), anchor: "west")
//     content("U2.end", box(inset:3pt, $C_z_2 = #calc.round(-c2z) $), anchor: "east")
    
//     // Подписи дуг
//     content("a1.50%", angle: a1/2*1deg, box(fill:white, inset:3pt, $alpha_1 = #calc.round(a1) degree$) )
//     content("b1.30%", angle: b1*0.3*1deg, move(box(fill:white, inset:3pt, $beta_1 = #calc.round(b1) degree $), dx:-1pt ) )
//     content("a2.14%", angle: -a2*0.14*1deg, box(fill:white, inset:3pt, $alpha_2^* = #calc.round(a2) degree$) )
//     content("b2.50%", angle: -b2/2*1deg, box(fill:white, inset:3pt, $beta_2^* = #calc.round(b2) degree$) )    
//   })),
//   caption: [Треугольники скоростей в периферийном сечении РЛ]
// ) <Tri-5>

// #undo-line()

// #figure(
//   image("assets/profiles/2/profile_combined5.svg"),
//   caption: [Профиль РЛ в периферийном сечении и демонстрация его конфузорности]
// ) <blade-last>

// #pagebreak()

// На рисунках @Tris-1[]-@blade-s-last[] изображены треугольники скоростей и профили соответсвующих сечений сопловых лопаток.

// #figure(
//   text(size: 10pt, cetz.canvas(length:0.02cm, {
//     import cetz.draw: *
//     set-style(
//       mark: (transform-shape: false, fill: black),
//       stroke: (cap: "round")
//     )
//     // Variables
//     let c1z = -RawS3c2z; let c2z = -RawR1c1z
//     let c1u = -RawS3c2u; let c2u = -RawR1c1u
//     let a1  =  RawS3αs2; let a2  =  RawR1α1
//     let c2  = calc.round(RawR1c1); let c1  = calc.round(RawS3c2)
    
//     // Треугольник 1
//     line(name:"C1", (0,0),(c1u  ,c1z), mark:(end:"stealth", fill:red), stroke:(paint:red, thickness: 2pt))
//     line(name:"C2", (0,0),(c2u, c2z), mark:(end:"stealth", fill:red), stroke:(paint:red, thickness: 2pt))
//     line("C1.end","C2.end", stroke:(paint:red, thickness: 2pt, dash: "dashed"))

//     // Подписи скоростей
//     content("C1.55%", angle:-a1 * 1deg, box(fill:white, inset:3pt, $C_1 = c1 $))
//     content("C2.70%", angle: a2 * 1deg, box(fill:white, inset:3pt, $C_2 = c2 $))

//     // Оси
//     line((3*c1u, 0), (c2u, 0), mark:(end: "stealth"), name: "axisu")
//     content("axisu.end", $U$, padding: 20, anchor: "north-west" )
//     line((0,0),(0,c2z - 30), mark:(end: "stealth"), name: "axisz")
//     content("axisz.end", $z$, padding: 5, anchor: "south-west" )

//     // Осевые скорости
//     line(name:"z1", (0,c1z),(c1u, c1z), stroke: (dash: "dashed"))
//     line(name:"z2", (0,c2z),(c2u, c2z), stroke: (dash: "dashed"))
//     content("z1.end", box(inset:3pt, $C_z_1 = #calc.round(-c1z) $), anchor: "west")
//     content("z2.0", box(inset:3pt, $C_z_2 = #calc.round(-c2z) $), anchor: "west")

//     // Дуги
//     arc(name:"a2", (0,0), start:-180deg, delta: a2*1deg, radius:c2/2, anchor:"origin", mark:(symbol:"stealth"))
//     arc(name:"a1", (0,0), start:   0deg, delta:-a1*1deg, radius:c1/4, anchor:"origin", mark:(symbol:"stealth"))

//     // Подписи дуг
//     content("a1.50%", angle:-a1/2*1deg, move(dx: 22pt, box(inset:3pt, $alpha_1^* = #calc.round(a1) degree$)) )
//     content("a2.50%", angle: a2/2*1deg, box(fill:white, inset:3pt, $alpha_2 = #calc.round(a2) degree$) )
//   })),
//   caption: [Треугольник скоростей в корневом сечении СЛ]
// ) <Tris-1>

// #undo-line()

// #figure(
//   image("assets/profiles/1/profile_combined1.svg", width: 100%),
//   caption: [Профиль СЛ в корневом сечении и демонстрация его конфузорности]
// )

// #figure(
//   text(size: 10pt, cetz.canvas(length:0.02cm, {
//     import cetz.draw: *
//     set-style(
//       mark: (transform-shape: false, fill: black),
//       stroke: (cap: "round")
//     )
//     // Variables
//     let c1z = -RawS3c2z; let c2z = -RawR2c1z
//     let c1u = -RawS3c2u; let c2u = -RawR2c1u
//     let a1  =  RawS3αs2; let a2  =  RawR2α1
//     let c2  = calc.round(RawR2c1); let c1 = calc.round(RawS3c2)
    
//     // Треугольник 1
//     line(name:"C1", (0,0),(c1u  ,c1z), mark:(end:"stealth", fill:red), stroke:(paint:red, thickness: 2pt))
//     line(name:"C2", (0,0),(c2u, c2z), mark:(end:"stealth", fill:red), stroke:(paint:red, thickness: 2pt))
//     line("C1.end","C2.end", stroke:(paint:red, thickness: 2pt, dash: "dashed"))

//     // Подписи скоростей
//     content("C1.55%", angle:-a1 * 1deg, box(fill:white, inset:3pt, $C_1 = c1 $))
//     content("C2.70%", angle: a2 * 1deg, box(fill:white, inset:3pt, $C_2 = c2 $))

//     // Оси
//     line((3*c1u, 0), (c2u, 0), mark:(end: "stealth"), name: "axisu")
//     content("axisu.end", $U$, padding: 20, anchor: "north-west" )
//     line((0,0),(0,c2z - 30), mark:(end: "stealth"), name: "axisz")
//     content("axisz.end", $z$, padding: 5, anchor: "south-west" )

//     // Осевые скорости
//     line(name:"z1", (0,c1z),(c1u, c1z), stroke: (dash: "dashed"))
//     line(name:"z2", (0,c2z),(c2u, c2z), stroke: (dash: "dashed"))
//     content("z1.end", box(inset:3pt, $C_z_1 = #calc.round(-c1z) $), anchor: "west")
//     content("z2.0", box(inset:3pt, $C_z_2 = #calc.round(-c2z) $), anchor: "west")

//     // Дуги
//     arc(name:"a2", (0,0), start:-180deg, delta: a2*1deg, radius:c2/2, anchor:"origin", mark:(symbol:"stealth"))
//     arc(name:"a1", (0,0), start:   0deg, delta:-a1*1deg, radius:c1/4, anchor:"origin", mark:(symbol:"stealth"))

//     // Подписи дуг
//     content("a1.50%", angle:-a1/2*1deg, move(dx: 22pt, box(inset:3pt, $alpha_1^* = #calc.round(a1) degree$)) )
//     content("a2.50%", angle: a2/2*1deg, box(fill:white, inset:3pt, $alpha_2 = #calc.round(a2) degree$) )
//   })),
//   caption: [Треугольник скоростей в средне-корневом сечении СЛ]
// ) <Tris-2>

// #undo-line()

// #figure(
//   image("assets/profiles/1/profile_combined2.svg", width: 100%),
//   caption: [Профиль СЛ в средне-корневом сечении и демонстрация его конфузорности]
// )

// #figure(
//   text(size: 10pt, cetz.canvas(length:0.022cm, {
//     import cetz.draw: *
//     set-style(
//       mark: (transform-shape: false, fill: black),
//       stroke: (cap: "round")
//     )
//     // Variables
//     let c1z = -RawS3c2z; let c2z = -RawR3c1z
//     let c1u = -RawS3c2u; let c2u = -RawR3c1u
//     let a1  =  RawS3αs2; let a2  =  RawR3α1
//     let c2  = calc.round(RawR3c1); let c1 = calc.round(RawS3c2)
    
//     // Треугольник 1
//     line(name:"C1", (0,0),(c1u  ,c1z), mark:(end:"stealth", fill:red), stroke:(paint:red, thickness: 2pt))
//     line(name:"C2", (0,0),(c2u, c2z), mark:(end:"stealth", fill:red), stroke:(paint:red, thickness: 2pt))
//     line("C1.end","C2.end", stroke:(paint:red, thickness: 2pt, dash: "dashed"))

//     // Подписи скоростей
//     content("C1.55%", angle:-a1 * 1deg, box(fill:white, inset:3pt, $C_1 = c1 $))
//     content("C2.70%", angle: a2 * 1deg, box(fill:white, inset:3pt, $C_2 = c2 $))

//     // Оси
//     line((3*c1u, 0), (c2u, 0), mark:(end: "stealth"), name: "axisu")
//     content("axisu.end", $U$, padding: 20, anchor: "north-west" )
//     line((0,0),(0,c2z - 30), mark:(end: "stealth"), name: "axisz")
//     content("axisz.end", $z$, padding: 5, anchor: "south-west" )

//     // Осевые скорости
//     line(name:"z1", (0,c1z),(c1u, c1z), stroke: (dash: "dashed"))
//     line(name:"z2", (0,c2z),(c2u, c2z), stroke: (dash: "dashed"))
//     content("z1.end", box(inset:3pt, $C_z_1 = #calc.round(-c1z) $), anchor: "west")
//     content("z2.0", box(inset:3pt, $C_z_2 = #calc.round(-c2z) $), anchor: "west")

//     // Дуги
//     arc(name:"a2", (0,0), start:-180deg, delta: a2*1deg, radius:c2/2, anchor:"origin", mark:(symbol:"stealth"))
//     arc(name:"a1", (0,0), start:   0deg, delta:-a1*1deg, radius:c1/4, anchor:"origin", mark:(symbol:"stealth"))

//     // Подписи дуг
//     content("a1.50%", angle:-a1/2*1deg, move(dx: 22pt, box(inset:3pt, $alpha_1^* = #calc.round(a1) degree$)) )
//     content("a2.50%", angle: a2/2*1deg, box(fill:white, inset:3pt, $alpha_2 = #calc.round(a2) degree$) )
//   })),
//   caption: [Треугольник скоростей в среднем сечении СЛ]
// ) <Tris-3>

// #undo-line()

// #figure(
//   image("assets/profiles/1/profile_combined3.svg", width: 100%),
//   caption: [Профиль СЛ в среднем сечении и демонстрация его конфузорности]
// )

// #figure(
//   text(size: 10pt, cetz.canvas(length:0.025cm, {
//     import cetz.draw: *
//     set-style(
//       mark: (transform-shape: false, fill: black),
//       stroke: (cap: "round")
//     )
//     // Variables
//     let c1z = -RawS3c2z; let c2z = -RawR4c1z
//     let c1u = -RawS3c2u; let c2u = -RawR4c1u
//     let a1  =  RawS3αs2; let a2  =  RawR4α1
//     let c2  = calc.round(RawR4c1); let c1 = calc.round(RawS3c2)
    
//     // Треугольник 1
//     line(name:"C1", (0,0),(c1u  ,c1z), mark:(end:"stealth", fill:red), stroke:(paint:red, thickness: 2pt))
//     line(name:"C2", (0,0),(c2u, c2z), mark:(end:"stealth", fill:red), stroke:(paint:red, thickness: 2pt))
//     line("C1.end","C2.end", stroke:(paint:red, thickness: 2pt, dash: "dashed"))

//     // Подписи скоростей
//     content("C1.55%", angle:-a1 * 1deg, box(fill:white, inset:3pt, $C_1 = c1 $))
//     content("C2.70%", angle: a2 * 1deg, box(fill:white, inset:3pt, $C_2 = c2 $))

//     // Оси
//     line((3*c1u, 0), (c2u, 0), mark:(end: "stealth"), name: "axisu")
//     content("axisu.end", $U$, padding: 20, anchor: "north-west" )
//     line((0,0),(0,c2z - 30), mark:(end: "stealth"), name: "axisz")
//     content("axisz.end", $z$, padding: 5, anchor: "south-west" )

//     // Осевые скорости
//     line(name:"z1", (0,c1z),(c1u, c1z), stroke: (dash: "dashed"))
//     line(name:"z2", (0,c2z),(c2u, c2z), stroke: (dash: "dashed"))
//     content("z1.end", box(inset:3pt, $C_z_1 = #calc.round(-c1z) $), anchor: "west")
//     content("z2.0", box(inset:3pt, $C_z_2 = #calc.round(-c2z) $), anchor: "south-east")

//     // Дуги
//     arc(name:"a2", (0,0), start:-180deg, delta: a2*1deg, radius:c2/2, anchor:"origin", mark:(symbol:"stealth"))
//     arc(name:"a1", (0,0), start:   0deg, delta:-a1*1deg, radius:c1/4, anchor:"origin", mark:(symbol:"stealth"))

//     // Подписи дуг
//     content("a1.50%", angle:-a1/2*1deg, move(dx: 22pt, box(inset:3pt, $alpha_1^* = #calc.round(a1) degree$)) )
//     content("a2.50%", angle: a2/2*1deg, box(fill:white, inset:3pt, $alpha_2 = #calc.round(a2) degree$) )
//   })),
//   caption: [Треугольник скоростей в средне-периферийном сечении СЛ]
// ) <Tris-4>

// #undo-line()

// #figure(
//   image("assets/profiles/1/profile_combined4.svg", width: 100%),
//   caption: [Профиль СЛ в средне-периферийном сечении и демонстрация его конфузорности]
// )

// #figure(
//   text(size: 10pt, cetz.canvas(length:0.03cm, {
//     import cetz.draw: *
//     set-style(
//       mark: (transform-shape: false, fill: black),
//       stroke: (cap: "round")
//     )
//     // Variables
//     let c1z = -RawS3c2z; let c2z = -RawR5c1z
//     let c1u = -RawS3c2u; let c2u = -RawR5c1u
//     let a1  =  RawS3αs2; let a2  =  RawR5α1
//     let c2  = calc.round(RawR5c1); let c1 = calc.round(RawS3c2)
    
//     // Треугольник 1
//     line(name:"C1", (0,0),(c1u  ,c1z), mark:(end:"stealth", fill:red), stroke:(paint:red, thickness: 2pt))
//     line(name:"C2", (0,0),(c2u, c2z), mark:(end:"stealth", fill:red), stroke:(paint:red, thickness: 2pt))
//     line("C1.end","C2.end", stroke:(paint:red, thickness: 2pt, dash: "dashed"))

//     // Подписи скоростей
//     content("C1.55%", angle:-a1 * 1deg, box(fill:white, inset:3pt, $C_1 = c1 $))
//     content("C2.70%", angle: a2 * 1deg, box(fill:white, inset:3pt, $C_2 = c2 $))

//     // Оси
//     line((3*c1u, 0), (c2u, 0), mark:(end: "stealth"), name: "axisu")
//     content("axisu.end", $U$, padding: 20, anchor: "north-west" )
//     line((0,0),(0,c2z - 60), mark:(end: "stealth"), name: "axisz")
//     content("axisz.end", $z$, padding: 5, anchor: "south-west" )

//     // Осевые скорости
//     line(name:"z1", (0,c1z),(c1u, c1z), stroke: (dash: "dashed"))
//     line(name:"z2", (0,c2z),(c2u, c2z), stroke: (dash: "dashed"))
//     content("z1.end", box(inset:3pt, $C_z_1 = #calc.round(-c1z) $), anchor: "west")
//     content("z2.0", box(inset:3pt, $C_z_2 = #calc.round(-c2z) $), anchor: "south-east")

//     // Дуги
//     arc(name:"a2", (0,0), start:-180deg, delta: a2*1deg, radius:c2/2, anchor:"origin", mark:(symbol:"stealth"))
//     arc(name:"a1", (0,0), start:   0deg, delta:-a1*1deg, radius:c1/4, anchor:"origin", mark:(symbol:"stealth"))

//     // Подписи дуг
//     content("a1.50%", angle:-a1/2*1deg, move(dx: 22pt, box(inset:3pt, $alpha_1^* = #calc.round(a1) degree$)) )
//     content("a2.50%", angle: a2/2*1deg, box(fill:white, inset:3pt, $alpha_2 = #calc.round(a2) degree$) )
//   })),
//   caption: [Треугольник скоростей в периферийном сечении СЛ]
// ) <Tris-5>

// #undo-line()

// #figure(
//   image("assets/profiles/1/profile_combined5.svg", width: 100%),
//   caption: [Профиль СЛ в периферийном сечении и демонстрация его конфузорности]
// ) <blade-s-last>

#pagebreak()

На рисунках @profile-cent-1[] и @profile-cent-2[] изображены соответственно центрированные комбинированные изображения профилей сопловой и рабочей лопаток.

#figure(
  image("assets/profiles/1/profiles.svg", width: 80%),
  caption: [Центрированная комбинация всех профилей СЛ]
) <profile-cent-1>

#undo-line()

#figure(
  image("assets/profiles/2/profiles.svg", width: 80%),
  caption: [Центрированная комбинация всех профилей РЛ]
) <profile-cent-2>

По профилям рабочих и сопловых лопаток вычисляется их количество на последней ступени. Это количество используется для проверки конфузорности профилей рабочих и сопловых лопаток на показанных выше изображениях.

По корневому сечению определяется относительный шаг для РК:
$
  dash(t)_"opt" &= 0.55 root(3, (180 degree)/( 180 degree - (beta_1 + beta_2^*)) (sin(beta_1))/(sin(beta_2^*))) (1- c/b) = \
  &= 0.55 root(3, (180 degree)/( 180 degree - (R5β1 degree + R5βs2 degree)) (sin(R5β1 degree))/(sin(R5βs2 degree))) (1- Prc/Prb) = Prt̄0,
$

#noind где $c$ --- максимальная толщина профиля;\
#hide[где] $b$ --- длина хорды профиля.

Оптимальный шаг решетки:
$ t_"opt" = dash(t)_"opt" dot b = Prt̄0 dot Prb = #zm(RawPrt0) ; $

Длина окружности в корневом сечении:
$ l' = 2 pi r' = 2 pi dot Prr = #zm(RawPrLᵒ) ; $

Тогда расчетное число рабочих лопаток:
$ z_r = ceil(l'/t_"opt") = ceil(PrLᵒ / Prst0) = Prsz; $

По периферийному сечению определяется относительный шаг для СА:
$
  dash(t)_"opt" &= 0.55 root(3, (180 degree)/( 180 degree - (alpha_1 + alpha_2^*)) (sin(alpha_2^*))/(sin(alpha_1))) (1- c/b) = \
  &= 0.55 root(3, (180 degree)/( 180 degree - (R4αs2 degree + R5α1 degree)) (sin(R5α1 degree))/(sin(R4αs2 degree))) (1- Prsc/Prsb) = Prst̄0,
$

#noind где $c$ --- максимальная толщина профиля;\
#hide[где] $b$ --- длина хорды профиля.

Оптимальный шаг решетки:
$ t_"opt" = dash(t)_"opt" dot b = Prst̄0 dot Prsb = #zm(RawPrst0) ; $

Длина окружности в периферийном сечении:
$ l'' = 2 pi r'' = 2 pi dot Prsr = #zm(RawPrsLᵒ) ; $

Тогда расчетное число сопловых лопаток:
$ z_s = ceil(l''/t_"opt") = ceil(PrsLᵒ / Prsr) = Prsz; $

По полученным профилям, расчетному количеству лопаток и геометрии продольного сечения, изображенной на @Mer, строится перо рабочей и сопловой лопатки последней ступени турбины. Для этого используется Waterfall-cad @waterfall-cad --- Haskell-враппер геометрического ядра OpenCASCADE, позволяющий автоматизировать построение рассматриваемых моделей, уменьшая время на их создание и исключая вероятность ошибки. Результатом этого шага являются две корректно позиционированные относительно начала координат step-модели пера рабочей и сопловой лопаток.

Затем полученные модели загружаются в SolidWorks, в котором для рабочей лопатки строится бандажная полка и хвостовик, а для сопловой лопатки --- фрагменты диафрагмы. Хвостовик выполнен по ёлочному типу (C-30). Полученная твердотельная модель показана на @hs-blade. Также на этом этапе строится модель диска последней ступени турбины.

#figure(
  image("assets/profiles/solid-model.png", height: 50% ),
  caption: [Твердотельная модель сопловой и рабочей лопаток последней ступени турбины]
) <hs-blade>

= Газодинамический расчет последней ступени

Газодинамический расчет проводится для оценки обтекания ступени и получения полей температуры и давления на пере РЛ. Для правильной постановки задачи также моделируется выходной диффузор установки.

== Подготовка модели последней ступени турбины к расчету в ANSYS CFX

Для подготовки к расчету необходимо корректно разместить модели сопловой и рабочей лопаток последней ступени турбины и сектор выходного диффузора, соответствующий одной опорной стойке. Для СЛ и РЛ с помощью функции FlowPath строится макет проточной части, необходимый для корректного прохождение моделируемого потока через СА и РК. На @flow-path показана готовая к экспорту в Ansys TurboGrid для построения сетки модель рабочей лопатки.

#figure(
  image("assets/ansys/cfx/flowpass.png", width:80%),
  caption: [Готовая для построения сетки в TurboGrid модель РЛ]
) <flow-path>

== Построение расчетной сетки

С помощью модуля TurboGrid построена расчетная сетка для сопловой (@path-mesh-stator[рисунок]) и рабочей (@path-mesh-rotor[рисунок]) лопаток с использованием метода Target Passage Mesh Size. Эта сетка заполняет пространство вне лопаток внутри двух секторов, соответствующих одной сопловой и одной рабочей лопатке и предназначена для использования метода конечных объемов (МКО). Количество сеточных элементов: 236817 для сопловой лопатки и 256200 для рабочей лопатки, число узлов: 251450 для сопловой лопатки и 270249 для рабочей лопатки.

#undo-line()

#figure(
  image("assets/ansys/cfx/mesh-stator.png", width:100%),
  caption: [Расчетная сетка для сопловой лопатки]
) <path-mesh-stator>

#undo-line()

#figure(
  image("assets/ansys/cfx/mesh-rotor.png", width:100%),
  caption: [Расчетная сетка для рабочей лопатки]
) <path-mesh-rotor>

Сеточная модель сектора выходного диффузора построена по твердотельной модели полости сектора диффузора, полученной булевым вычитанием модели сектора и её полнотелой оболочки. В качестве аргументов конструктору сеток сообщён целевой решатель (Ansys CFX), типичный размер элемента (45 мм), сгущения вдоль поверхностей диффузора и его опорной стойки, а также периодичность боковых граней сектора с помощью метода Match Control. Полученная сеточная модель изображена на @mesh-diff и содержит 708520 элементов и 190820 узлов.

#figure(
  image("assets/ansys/cfx/mesh-diffuser.png", width:100%),
  caption: [Расчетная сетка для сектора выходного диффузора]
) <mesh-diff>

== Газодинамический расчет последней ступени <Ansys-GAS>

Для выполнения расчета в блоке CFX-Pre необходимо задать граничные условия. Указывается число лопаток, 58 рабочих и 56 сопловых. Для сопловой лопатки и диффузора указывается тип закрепления Stationary (неподвижный), а для рабочих --- Rotating (вращающийся) с частотой вращения #zrpm(5441).

Параметры рабочего тела на входе и на выходе из моделируемой ступени заданы в соответствии с аналитическим расчетом:
+ $T_0^* = #zK(1090.46)$ --- полная температура на входе в ступень;
+ $P_0^* = #zPa(231169)$ --- полное давление на входе в ступень;
+ $alpha_1 = 10 degree$ --- угол входа в сопловой аппарат последней ступени;
+ $P_2 = #zkg-s(RawAGᵧ)$ --- массовый расход на выходе из диффузора.

В качестве модели рабочего тела используется идеальный газ. В качестве модели турбулентности выбрана k-#sym.omega SST, поскольку она подходит для определения точек отрыва, а также осуществляет плавный переход от стандартной модели k-#sym.omega вблизи стенки к модели k-#sym.epsilon в во внешней части потока.

Между областями рассматриваемых тел используется тип интерфейса Mixing Stage. Он осредняет параметры потока по окружности, сглаживая нестационарное взаимодействие между решетками.

На поверхностях симметрии выставлено условие периодичности.

Расчетная модель турбинной ступени показана на @InOut.

#figure(
  image("assets/ansys/cfx/model.png", width:100%),
  caption: [Модель последней ступени, подготовленная для гидродинамического расчета]
) <InOut>

На @Residuals показан график невязок расчета. Их значения менее $10^(-4)$ и установившийся гладкий характер свидетельствуют о сходимости расчета.

#figure(
  image("assets/ansys/cfx/residuals.png", width:100%),
  caption: [График невязок гидродинамического расчета]
) <Residuals>

На рисунках @root[]-@top[] изображены линии тока и скорости в межлопаточном канале, причем для сопловой лопатки показана скорость в абсолютном движении, а для рабочей --- в относительном. Видно, что ни за сопловой, ни за рабочей лопаткой нет вихрей, вход на рабочую лопатку безударный.

#figure(
  image("assets/ansys/cfx/lines/1.png", width:80%),
  caption: [Линии тока в корневом сечении]
) <root>

#undo-line()

#figure(
  image("assets/ansys/cfx/lines/2.png", width:80%),
  caption: [Линии тока в средне-корневом сечении]
) <midroot>

#undo-line()

#figure(
  image("assets/ansys/cfx/lines/3.png", width:80%),
  caption: [Линии тока в среднем сечении]
) <mid>

#undo-line()

#figure(
  image("assets/ansys/cfx/lines/4.png", width:80%),
  caption: [Линии тока в средне-периферийном сечении]
) <midtop>

#undo-line()

#figure(
  image("assets/ansys/cfx/lines/5.png", width:80%),
  caption: [Линии тока в периферийном сечении]
) <top>

= Определение прочностных характеристик основных элементов турбины

== Расчет рабочей лопатки на прочность и вибронадежность

Для оценки надежности РЛ необходимо выполнить статический прочностной расчет, который покажет, удовлетворяет ли спроектированная лопатка предъявляемым к ней условиям.

Расчет проведен с помощью модуля Ansys Mechanical, который позволяет определить напряженно-деформированное состояние тела под действием стационарных нагрузок. Основными такими нагрузками для РЛ ГТУ являются:
+ Газодинамическая нагрузка, обусловленная перепадом давления;
+ Центробежная нагрузка, обусловленная вращением ротора;
+ Тепловая нагрузка, обусловленная неравномерностью нагрева.

В качестве материала РЛ выбран суперсплав на основе никеля Inconel 792 (IN-792). Он обладает необходимыми для лопаток газовой турбины свойствами:
+ Высокой температурой плавления ($approx #zdc(1425)$);
+ Высокой прочностью и ударной вязкостью;
+ Устойчивостью к ползучести и усталости.

Воспроизведение термофизических свойств материала производилось по его химическому составу в программе JMatPro.

Для выполнения расчета была построена сеточная модель РЛ, содержащая 90227 элементов и 141755 узлов. Эта модель изображена на @meshrab.

#figure(
  image("assets/ansys/blade/mesh.png", width: 100%),
  caption: [Сеточная модель рабочей лопатки]
) <meshrab>

=== Расчет рабочей лопатки на статическую прочность в рамках упругой постановки <Ansys-blade-u>

Упругая постановка прочностного расчета проводится в рамках действия закона Гука. Деформации при такой постановке прямо пропорциональны напряжениям, при снятии нагрузки тело возвращается в исходное состояние.

В качестве граничных условий задается скорость вращения, неподвижное закрепление хвостовика и ограничение окружного перемещения бандажа. Примененные условия изображены на @gra-u. Также на лопатку импортируется и экстраполируется поле температур пера лопатки (@t-u[рисунок]) и давления от протекающего газа (@p-u[рисунок]), полученные как результат газодинамического расчета в @Ansys-GAS.

#figure(
  image("assets/ansys/blade/boundary_conditions.png", width: 100%),
  caption: [Граничные условия для рабочей лопатки]
) <gra-u>

#undo-line()

#figure(
  image("assets/ansys/blade/temperature.png", width: 100%),
  caption: [Температура на рабочей лопатке]
) <t-u>

#undo-line()

#figure(
  image("assets/ansys/blade/pressure.png", width: 100%),
  caption: [Давления на рабочей лопатке]
) <p-u>

По граничным условиям и сеточной модели в блоке Static Structural проводится расчет, результаты которого показаны на рисунках @stress-u[] и @def-u[].

#figure(
  image("assets/ansys/blade/elastic/stress.png", width:100%),
  caption: [Распределение эквивалентных напряжений]
) <stress-u>

#undo-line()

#figure(
  image("assets/ansys/blade/elastic/deformation.png", width:100%),
  caption: [Распределение абсолютных деформаций]
) <def-u>


Из представленных выше эпюр видно, что максимальные значения напряжений достигаются в области хвостовика. Их высокие значения связаны с недостатками упругой постановки расчета. Характер перемещений не содержит аномалий.

Для получения выводов о прочности лопатки, по полученным данным необходимо оценить запас статической прочности. Для этой оценки используется третья теория прочности, которая устанавливает, что причиной перехода материала в пластическое состояние являются максимальные касательные напряжения. Критерий прочности, опирающийся на эту теорию, формулируется так:

$ sigma_1 - sigma_3 <= [sigma], $ <stress-formula>

#noind где $sigma_1$ --- максимальное главное напряжение;\ #hide[где] $sigma_3$ --- минимальное  главное напряжение;\ #hide[где] $[sigma]$ --- допускаемое напряжение на растяжение.

Исходя из @stress-formula[формулы], по эпюре распределения напряжений необходимо определить следующие данные для нескольких областей:
- Maximum Principial Stress --- максимальное главное напряжение;
- Minimum Principial Stress --- минимальное главное напряжение.

В @regression приведены результаты расчета коэффициента запаса прочности:

#figure(
  block(stroke:black, table(
    columns: (auto, auto, auto, auto, auto, auto, auto),
    row-gutter: (1.7pt, auto),
    table.header([Область РЛ], $T, degree C$, $sigma_0.2^t, "МПа"$, $sigma_max, "Мпа"$, $sigma_min, "МПа"$, $sigma_"экв", "МПа"$, $n_т$),
    [Хвостовик], [700], [750], [459 ], [-4388], [4847], [0.139261],
    [Перо     ], [650], [779], [1189], [43   ], [1146], [0.510471],
    [Бандаж   ], [650], [779], [1340], [96   ], [1244], [0.470257],
  )),
  caption: [Определение коэффициента запаса прочности],
) <regression>

Полученные значения коэффициентов запаса прочности для каждой зоны на порядок меньше $1.1$, что свидетельствует о невыполнении условия прочности в упругой постановке. Для уточнения результата требуется провести расчет в упруго-пластической постановке.

=== Расчет рабочей лопатки на статическую прочность в рамках упруго-пластической постановки <Ansys-blade-up>

Если при упругой постановке все деформации полностью исчезают после снятия нагрузки, в упруго-пластической постановке рассматриваются пластические деформации, которые сохраняются после снятия нагрузки. Такие деформации связаны с перераспределением дислокаций кристаллической решетки материала, в связи с чем напряжения "перекладываются" на менее нагруженные области тела.

Расчет в упруго-пластической постановке проводится, чтобы учесть:
+ Напряженно-деформированное состояние лопатки в зонах концентрации напряжений (например, в районе контактных площадок хвостовика), в которых происходит перераспределение напряжений;
+ Последовательность циклов нагружения, соответствующую условиям эксплуатации установки;
+ Остаточные деформации и их влияние на долговечность конструкции.

Для проведения расчета в блоке Static Structural создаётся циклограмма нагружения, соответствующая условиям эксплуатации турбины. Используемая циклограмма показана на @cycle-blade.

#figure(
  lq.diagram(
    height: 5cm, margin: 0%,
    xlabel: $t, с$, ylabel: $omega, "об/мин"$,

    let trg = 5441, let ome = 1500,

    lq.line((0  ,0  ),(ome, trg), stroke: blue + 1pt),
    lq.line((ome,trg),(2*ome, 0), stroke: blue + 1pt),
  ),
  caption: [Циклограмма нагружения рабочей лопатки]
) <cycle-blade>

В качестве критерия сходимости используется Force Convergence --- отображение значений невязок по силам для каждого уравнения. Физический смысл заключается в оценке дисбаланса между внутренними и внешними силами в узлах сетки. Уменьшение невязок на несколько порядков свидетельствует о достижении равновесного состояния. Итерационный процесс продолжается до тех пор, пока максимальная невязка не станет меньше установленного предела для всех шагов нагружения, что свидетельствует о выполнении уравнений равновесия с требуемой точностью и корректном учёте пластического поведения материала. Полученный график невязок показан на @res-p.

#undo-line()

#figure(
  image("assets/ansys/blade/plastic/residuals.png", width:100%),
  caption: [График невязок расчета РЛ в упруго-пластической задаче]
) <res-p>

В результате были получены эпюры распределения эквивалентных напряжений (@p-str[рисунок]) и эквивалентных пластических деформаций (@p-pla[рисунок]).

#figure(
  image("assets/ansys/blade/plastic/stress.png", width:100%),
  caption: [Эпюра распределения эквивалентных напряжений]
) <p-str>

#undo-line()

#figure(
  image("assets/ansys/blade/plastic/plastic.png", width:100%),
  caption: [Эпюра распределения эквивалентных пластических деформаций]
) <p-pla>

Видно, что максимальные эквивалентные напряжения снизились по сравнению с упругим расчетом с #zMPa[16978] до #zMPa(1159.7). Это объясняется перераспределением внутренних сил в рамках больших площадей, возникающих в результате перехода материала в зону пластических деформаций.

Эквивалентные пластические деформации являются ключевым параметром для оценки деформации материала, ненулевые значения которого указывают на зоны, где произошло необратимое изменение структуры материала. Видно, что в зонах хвостовика и бандажной полки существуют пластические деформации.

Затем проводится количественная оценка ресурса рабочей лопатки при симметричном циклическом нагружении в условиях упруго-пластической постановки. Для этого необходимо рассчитать количество циклов до разрушения лопатки. Расчет производится по формуле Коффина-Мэнсона:

$ Delta epsilon = D^0.6 dot N^(-0.6) + (3.5 sigma_в)/E dot N^(-0.12), $

#noind где $Delta epsilon$ --- размах деформаций;\
#hide[где] $psi(T,t)$ --- относительное сужение образца при кратковременном разрыве,\
#hide[где $psi(T,t)$ ---] $D = ln( frac(100,100 - psi,style: "skewed") )$;\
#hide[где] $sigma_в (T,t)$ --- предел прочности, МПа;\
#hide[где] $E(T,t)$ --- модуль Юнга;\
#hide[где] $N$ --- количество циклов.

Для дальнейшего расчета необходимо определить размах деформаций по конструкции лопатки, на основе которого определяется критическая точка с максимальным значением размаха $Delta epsilon$.

Размах деформации вычисляется по формуле:
$ Delta epsilon = Delta epsilon^"el" + Delta epsilon^"pl", $

#noind где $Delta epsilon^"el"$ и $Delta epsilon^"pl"$ --- размах упругой и пластической деформаций соответственно, которые определяются по формулам:

$ Delta epsilon^"el" = sqrt(2)/3 sqrt(
  (Delta epsilon_x^"el" - Delta epsilon_y^"el")^2 +
  (Delta epsilon_y^"el" - Delta epsilon_z^"el")^2 +
  (Delta epsilon_z^"el" - Delta epsilon_x^"el")^2 + \
  + 3/2 ( (Delta epsilon_(x y)^"el")^2 + (Delta epsilon_(y z)^"el")^2 + (Delta epsilon_(z x)^"el")^2 )
); $

$ Delta epsilon^"pl" = sqrt(2)/3 sqrt(
  (Delta epsilon_x^"pl" - Delta epsilon_y^"el")^2 +
  (Delta epsilon_y^"pl" - Delta epsilon_z^"el")^2 +
  (Delta epsilon_z^"pl" - Delta epsilon_x^"pl")^2 + \
  + 3/2 ( (Delta epsilon_(x y)^"el")^2 + (Delta epsilon_(y z)^"el")^2 + (Delta epsilon_(z x)^"el")^2 )
); $

При этом значения $Delta epsilon_i^"el"$ и $Delta epsilon_i^"pl"$ определяются следующим образом:

$ Delta epsilon_i^"el" = Delta epsilon_i^"el"(A) - Delta epsilon_i^"el"(B); $
$ Delta epsilon_i^"pl" = Delta epsilon_i^"pl"(A) - Delta epsilon_i^"pl"(B), $

#noind где точки $A$ и $B$ определяют максимальный размах полной деформации в рассматриваемом узле конструкции за весь нормальный цикл работы установки.

Практическая реализация расчета размаха деформаций в Ansys производится с помощью Used Defined Result. На @user-blade изображена построенная с помощью этой функции эпюра распределения размаха деформаций.

#figure(
  image("assets/ansys/blade/plastic/de.png", width:100%),
  caption: [Эпюра распределения размаха деформаций]
) <user-blade>

Для расчета количества циклов до разрушения используется программа _Cycle.exe_, в которую для точки, соответствующей максимальному размаху деформации, передаются следующие параметры:
- Температура рассматриваемой точки $T$;
- Модуль упругости материала лопатки $E(T)$;
- Предел прочности материала лопатки $sigma_d (T)$;
- Относительное сужение $psi$.

Введённые данные и результат расчета показаны на @exe-blade.

#figure(
  box(stroke: black, inset: 1em,
    align(left, text(size: 9pt, font: "JetBrainsMono NF", read("assets/cycle_exe/blade.txt")))
  ),
  caption: [Оценка количества циклов до разрушения РЛ]
) <exe-blade>

В результате было получено значение $N = 2174$ циклов, что является приемлемым результатом для газотурбинной лопатки.

=== Расчет рабочей лопатки на длительную прочность <blade-long>

При высоких температурах прочность материала характеризуется пределом длительной прочности. Пределом длительной прочности называется напряжение, которое может выдержать материал без разрушения в течение заданного времени при данной нагрузке и температуре. 

Для представления зависимости предела длительной прочности от времени и температуры используется уравнение Ларсона-Миллера для никелевого суперсплава.
// В качестве исходных данных принимаются температура $T$, и требуемый ресурс $t$.
В качестве аппроксимирующей зависимости используется уравнение, приведенное в таблице для данного класса сплавов:

$ P &= T dot 10^(-3) dot (lg(t) - 2 lg(T) + 23.297) = 31.291 - 2.4 lg(sigma) - 0.0684 sigma; $

Принимая $T=#zK(921)$ и $t=#zh(30000)$ , получаем, что $sigma_"дл.п"=#zMPa(940)$.

Работоспособность конструкции по критерию исчерпания длительной прочности на заданном нормативном ресурсе считается обеспеченной, если для предела длительной прочности, отвечающего заданному ресурсу, обеспечивается запас прочности:

$ n_"дл.п" = sigma_"дл.п" / sigma_"экв" = 940 / 1160 = 0.81<1.1, $

#noind что меньше, чем $1.1$, допускаемое в зонах концентрации напряжений. Однако вероятнее всего такое значение вызвано сложной структурой хвостовика, что видно из неравномерного нагружения его полок. Если взять за эквивалентное напряжение среднее напряжение по полкам хвостовика, то:

$ n_"дл.п" = sigma_"дл.п" / sigma_"экв" approx 940 / 820 = 1.14 > 1.1, $

#noind то есть с допущением о равном распределении нагрузки по полкам хвостовика лопатка проходит по условию длительной прочности.

=== Модальный расчет и построение вибрационной диаграммы рабочей лопатки

Рабочие лопатки турбомашин подвергаются не только постоянным и медленно меняющимся воздействиям статических сил, но и быстро меняющимся возбуждающим воздействиям, вызывающим колебания лопаток.

Такие колебания связаны с неравномерностью потока газа по окружности сопловых аппаратов турбомашин. Неравномерность потока приводит к тому, что усилие на рабочую лопатку при ее перемещении (вращении) перед сопловой решеткой оказывается переменным во времени и, следовательно, представляет собой быстро меняющееся воздействие.

Для анализа вибрационной прочности лопатки строится вибрационная диаграмма, на которой видна зависимость частоты колебаний лопатки от частоты вращения ротора, а линии, выходящие из начала координат, представляют собой зависимости частот возмущающих сил от частоты вращения для гармоник разной кратности. Абсциссы точек пересечения лучей с кривыми предельных динамических частот определяют границы зон резонансных частот вращения данной ступени.

Собственные частоты лопаток первых двух тонов колебаний получены для разных режимов работы турбоустановки в Ansys Modal. Выбор первых двух тонов колебаний для дальнейшего анализа обусловлен практическими соображениями: именно эти формы колебаний представляют наибольшую опасность с точки зрения возникновения резонансных явлений. Высшие тоны колебаний не рассматриваются, так как гармоники возбуждения до шестой кратности обычно не пересекаются с их частотами в рабочем диапазоне оборотов, что минимизирует риск опасных резонансов. Вибрационная диаграмма рабочей лопатки последней ступени турбины представлена на рисунке @ror.

#figure(
  lq.diagram(
    height: 7cm, margin: (x:0%), ylim: (0, auto),
    ylabel: $f, "Гц"$, xlabel: $omega, "об/мин"$,
    legend: (position: left, dy: 3em),

    // Линии колебаний
    let trg = 5441,
    let x_main = ( 0, trg/4, trg/2, trg*3/4, trg, 1.5*trg, 2*trg ),

    let y_1_max = (618.4, 622.4, 634.3, 653.4, 679.0, 745.5, 865.0),
    let y_1_mid = (594.62,598.48,609.88,628.27,652.85,716.87,831.7),
    let y_1_min = (570.8, 574.5, 585.5, 603.1, 626.7, 688.2, 798.4),

    let y_2_max = (1061.8,1066.1,1078.7,1098.6,1124.7,1189.2,1273.5),
    let y_2_mid = (1021,1025.1,1037.2,1056.3,1081.4,1143.5,1224.5),
    let y_2_min = (980.2,984.1,995.7,1014.0,1038.1,1097.8,1175.5),

    lq.fill-between(x_main, y_1_max, y2: y_1_min, smooth:true, fill: lq.color.map.petroff10.at(0).transparentize(50%)),

    lq.fill-between(x_main, y_2_max, y2: y_2_min, smooth:true, fill: lq.color.map.petroff10.at(1).transparentize(50%)),

    lq.plot(x_main, y_1_mid, smooth:true, mark: "^", color: black, stroke: 1pt),
    lq.plot(x_main, y_2_mid, smooth:true, mark: "s", color: black, stroke: 1pt),

    lq.plot((0,0),(-80,-80), color: lq.color.map.petroff10.at(0),  mark: "^", label: $f_1(omega)$),
    lq.plot((0,0),(-80,-80), color: lq.color.map.petroff10.at(1), mark: "s", label: $f_2(omega)$),

    // Линии кратности
    let y_frac = (90.68, 181.36, 272.05, 362.73, 453.42, 544.1),

    ..for i in range(y_frac.len()) {
      (lq.line((0,0),(x_main.last(),y_frac.at(i)), stroke:gray+1pt),)
    },

    // Линия номинала
    lq.line((trg,0%),(trg, 100%), stroke: (thickness: 1pt, dash: "dashed" )),
  ),
  caption: [Вибрационная диаграмма рабочей лопатки]
) <ror>

На полученной диаграмме линии собственных частот лопатки представлены плавно восходящими линиями, линии кратностей --- линейно восходящими лучами, рабочая частота --- вертикальной линией.

Анализ диаграммы показывает, что ни одна из линий возбуждающих гармоник не пересекается с линиями собственных частот колебаний рабочей лопатки. Это означает, что в рабочем диапазоне частот вращения и при типичных возбуждающих гармониках отсутствуют условия для возникновения резонансных явлений, из чего можно сделать вывод о вибронадежности лопатки.

== Расчет диска на прочность и вибронадежность <Ansys-disk>

Методика расчета диска на статическую прочность во многом аналогична подходу, описанному в разделах @Ansys-blade-u[]-@Ansys-blade-up[]  для рабочей лопатки. Однако существуют принципиальные особенности, связанные со спецификой нагружения и конструкцией диска.

Важным аспектом является правильный подбор материала диска, коэффициент теплового расширения которого должен быть близок к соответствующему параметру материала лопаток. Это требование обусловлено необходимостью обеспечения согласованного термического расширения совместно работающих элементов --- значительная разница в коэффициентах теплового расширения может привести к трещинам из-за высоких термических напряжений или нарушению геометрических зазоров. Изходя из этого выбрана сталь 26NiCrMoV15, традиционно  применяющаяся для изготовления дисков и роторов газовых турбин.

Для сокращения вычислительных затрат задачи решаются для сектора диска (@disk-geo[рисунок]), соответствующего одной рабочей лопатке.

#figure(
  image("assets/ansys/disk/model_geometry.png", width:80%),
  caption: [Твердотельная модель сектора диска]
) <disk-geo>

Для имитации всего объема диска необходимо задать циклическую симметрию. По твердотельной модели и условию циклической симметрии построена сеточная модель сектора диска (@disk-mesh[рисунок]), содержащая 5464 элементов и 26652 узлов.

#figure(
  image("assets/ansys/disk/model_mesh.png", width:80%),
  caption: [Сеточная модель сектора диска]
) <disk-mesh>

В качестве граничных условий задается температурное поле диска, механические нагрузки и закрепления.

На верхнем ободе диска устанавливается температура, полученная из расчета РЛ в области хвостовика, а на нижней границе задается температура, отличающаяся на #zdc(200). Это позволяет построить характерный для условий эксплуатации турбины температурный градиент и учесть термические напряжения. Полученное распределение температур представлено на @disk-temp.

#figure(
  image("assets/ansys/disk/temperature.png", width:80%),
  caption: [Распределение температур по сектору диска]
) <disk-temp>

В качестве механических нагрузок помимо вращения диска моделируется давление от лопаток с помощью функции Pressure на верхнем ободе диска.

#pagebreak()
Давление лопаток вычисляется с помощью следующей формулы:

$ sigma = (sum_i^n m dot omega^2 dot r_c)/F = (2.97 dot 59 dot 570^2 dot 0.604)/0.38 = #zMPa(90.5) , $

#noind где $sum_i^n m$ --- суммарная масса лопаток;\
#hide[где] $omega$ --- угловая скорость вращения;\
#hide[где] $r_c$ --- радиус центра тяжести лопаток;\
#hide[где] $F$ --- площадь поверхности обода диска.

В качестве закрепления моделируются хиртовые соединения с помощью функции Displacement, которая позволяет ограничить выбранные степени свободы. Для исследуемого диска в точках закрепления ограничиваются осевые и радиальные перемещения

Заданные нагрузки и закрепления представлены на @disk-gra.

#figure(
  image("assets/ansys/disk/boundary_conditions.png", width:80%),
  caption: [Граничные для условия сектора диска]
) <disk-gra>

=== Расчет диска на статическую прочность в рамках упругой постановки

После определения нагрузок и граничных условий выполняется расчет прочности диска в рамках упругой постановки. Для анализа результатов используются эпюры распределения эквивалентных напряжений по фон-Мизесу и полной деформации (рисунки @disk-u-str[] и @disk-u-def[] соответственно).

#figure(
  image("assets/ansys/disk/elastic/stress.png", width:80%),
  caption: [Распределение эквивалентных напряжений]
) <disk-u-str>

#undo-line()

#figure(
  image("assets/ansys/disk/elastic/deformation.png", width:80%),
  caption: [Распределение абсолютных деформаций]
) <disk-u-def>

По полученным эпюрам можно сделать вывод, что перемещения соответствуют ожиданию, а значит граничные условия заданы верно. Максимальное значение эквивалентных напряжений равно #zMPa(7851), что нереалистично, условие прочности при таком значении не выполняется. На основании выводов, сделанных в @Ansys-blade-u для рабочей лопатки, для диска также необходимо провести расчет в упруго-пластической постановке.

=== Расчет диска на статическую прочность в рамках упруго-пластической постановки

Для проведения расчета в блоке Static Structural формируется условная циклограмма нагружения, моделирующая реальные эксплуатационные режимы работы турбины (@disk-cycl[рисунок]). Помимо скорости вращения, задается зависимость давления лопатки на диск от частоты вращения, так как с её изменением согласно циклограмме меняется центробежная нагрузка.

#figure(
  lq.diagram(
    height: 5cm, margin: 0%,
    xlabel: $t, с$, ylabel: $omega, #zrpm()$,

    let trg = 5441, let ome = 1500,
    lq.line((0, 0),(ome, trg), stroke: blue + 1pt),
    
    lq.yaxis( exponent: 0, position: right, label: $F, Н$,
      lq.line((ome, 90.5), (2 * ome, 0), stroke: blue + 1pt),
    ),
  ),
  caption: [Циклограмма нагружения диска рабочего колеса]
) <disk-cycl>

Для отображения истории сходимости используется параметр Force Convergence (@disk-res[рисунок]). Значения невязок снизились на несколько порядков, что свидетельствует о корректном проведении расчета.

#figure(
  image("assets/ansys/disk/plastic/residuals.png", width:100%),
  caption: [График невязок расчета диска в упруго-пластической задаче]
) <disk-res>

По результатам проведения расчета построены эпюры распределения эквивалентных напряжений (@disk-p-str) и эквивалентных пластических деформаций (@disk-p-pla[рисунок]).

#figure(
  image("assets/ansys/disk/plastic/stress.png", width:80%),
  caption: [Эпюра распределения эквивалентных напряжений]
) <disk-p-str>

#undo-line()

#figure(
  image("assets/ansys/disk/plastic/deformation_plastic.png", width:80%),
  caption: [Эпюра распределения эквивалентных пластических деформаций]
) <disk-p-pla>

Как видно из эпюр, эквивалентные напряжения по фон-Мизесу в упруго-пластической постановке показывают снижение по сравнению с упругим расчетом с #zMPa(7851.6) до #zMPa(59.61). Это объясняется перераспределением внутренних сил в рамках больших площадей, возникающих в результате пластической деформации материала.

Следующим этапом следует провести оценку ресурса диска при симметричном циклическом нагружении в условиях пластического деформирования. Для этого необходимо рассчитать количество циклов до разрушения.

В первую очередь считается размах деформаций по диску, на основе которого определяется критическая точка с максимальным значением $Delta epsilon $ (@disk-de[рисунок]). Методика расчета аналогична таковой в @Ansys-blade-up.

#figure(
  image("assets/ansys/disk/plastic/de2.png", width:80%),
  caption: [Размах деформаций по диску]
) <disk-de>

Параметры точки, соответствующей максимальному размаху деформации передаются в программу _Cycle.exe_ для оценки количества циклов до разрушения диска (@exe-disk[рисунок]).

#figure(
  box(stroke: black, inset: 1em,
    align(left, text(size: 9pt, font: "JetBrainsMono NF", read("assets/cycle_exe/disk.txt")))
  ),
  caption: [Оценка количества циклов до разрушения диска]
) <exe-disk>

В результате расчета было получено значение $N = 112$ циклов, оно 
свидетельствует о способности конструкции выдерживать циклическое нагружение за счет пластического перераспределения напряжений.

=== Расчет диска на длительную прочность

Расчет диска на длительную прочность производится аналогично такому расчету для рабочей лопатки в @blade-long. Для стали 26NiCrMoV15 уравнение Ларсена-Миллера имеет следующий вид:

$ P = T dot 10^(-3) dot (lg(t) - 2 lg(T) + 24) = 27.8 - 2.4 lg(sigma) - 0.062 sigma; $

Принимая $T=#zK(880)$  и $t = #zs(10000)$, получаем $sigma_"дл.п"=#zMPa(534.6)$.

$ n_"дл.п" = sigma_"дл.п" / sigma_"экв" = 534.6 / 59.614 = 8.97 > 1.5, $

#noind следовательно, диск удовлетворяет условию длительной прочности.

=== Модальный расчет и построение вибрационной диаграммы диска

Как и лопатки, диски испытывают действие переменных нагрузок. В толстых дисках связанная с колебаниями многоцикловая усталость не наблюдается, так как амплитуды колебаний и переменные напряжения невелики, однако эти напряжения могут влиять на процессы разрушения по механизмам малоцикловой усталости и ползучести. В связи с этим, при проектировании дисков проводится проверка возможности возникновения резонансных колебаний. Диски имеют большое число собственных частот и форм колебаний. В отличие от лопаток, формы колебаний дисков могут быть неподвижными и подвижными (стоячие и бегущие волны). Они обладают свойством циклической симметрии и различаются по количеству узловых диаметров.

Опасны критические режимы потому, что неподвижные постоянные нагрузки есть всегда. Наличие критических режимов в рабочем диапазоне частот вращения ротора считается недопустимым, поскольку в этом случае управлять частотой возмущающей силы невозможно.

Три основные формы собственных колебаний диска получены для работы турбоустановки в блоке Ansys Modal для нескольких режимов:
+ Стартовое положение --- #zrpm(1)\;
+ Номинальный режим --- #zrpm(5441)\;
+ Аварийный режим --- $1.5 dot 5441 = #zrpm(8161.5)$,
#noind что позволяет  оценить поведение собственных частот при переходе через рабочий диапазон и выявить возможные резонансные зоны.

Колебания с 2, 3 и 4 узловыми диаметрами являются наиболее критичными для дисков турбин --- именно эти формы колебаний чаще всего возбуждаются в рабочих режимах и могут привести к резонансным явлениям.

Построенная по результатам расчета вибрационная диаграмма представлена на @disk_camp.

#figure(
  lq.diagram(
    height:7cm, margin: (x:0%), ylim: (0, auto),
    ylabel: $f, "Гц"$, xlabel: $omega, #zrpm()$,
    legend: (position: left, dy: 3em),

    // Линии колебаний
    let trg = 5441,
    let x_main = ( 0, trg, trg * 1.5 ),

    let y_1_forw = ( 1651.7, 1769.3, 1930.4 ),
    let y_1_self = ( 1651.7, 1587.9, 1658.3 ),
    let y_1_back = ( 1651.7, 1406.5, 1386.3 ),

    let y_2_forw = ( 1774.8, 2044.1, 2190.4 ),
    let y_2_self = ( 1774.7, 1772.0, 1782.3 ),
    let y_2_back = ( 1774.7, 1500.0, 1374.2 ),

    let y_3_forw = ( 2004.6, 2364.4, 2556.9 ),
    let y_3_self = ( 2004.5, 2001.7, 2012.8 ),
    let y_3_back = ( 2004.4, 1639.0, 1468.7 ),

    let col = (
      lq.color.map.petroff10.at(0),
      lq.color.map.petroff10.at(1),
      lq.color.map.petroff10.at(2)
    ),

    lq.plot(x_main, y_1_forw, mark: none, stroke: col.at(0) + 1pt, label: $f_(2d)(omega)$),
    lq.plot(x_main, y_1_self, mark: none, stroke: col.at(0) + 1pt),
    lq.plot(x_main, y_1_back, mark: none, stroke: col.at(0) + 1pt),

    lq.plot(x_main, y_2_forw, mark: none, stroke: col.at(1) + 1pt, label: $f_(3d)(omega)$),
    lq.plot(x_main, y_2_self, mark: none, stroke: col.at(1) + 1pt),
    lq.plot(x_main, y_2_back, mark: none, stroke: col.at(1) + 1pt),

    lq.plot(x_main, y_3_forw, mark: none, stroke: col.at(2) + 1pt, label: $f_(4d)(omega)$),
    lq.plot(x_main, y_3_self, mark: none, stroke: col.at(2) + 1pt),
    lq.plot(x_main, y_3_back, mark: none, stroke: col.at(2) + 1pt),

    // Линии кратности
    let y_frac = (90.68, 181.36, 272.05, 362.73, 453.42, 544.1),

    ..for i in range(y_frac.len()) {
      (lq.line((0,0),(x_main.last(),y_frac.at(i)), stroke:gray+1pt),)
    },

    // Линия номинала
    lq.line( (trg, 100%), (trg, 0%), stroke: (thickness: 1pt, dash: "dashed") ),    
  ),
  caption: [Вибрационная диаграмма диска]
) <disk_camp>

На полученной диаграмме линии собственных частот диска представлены слабо восходящими линиями, обратно бегущая волна --- нисходящими линии, прямо бегущая волна --- восходящими линии, линии кратностей возбуждающего воздействия --- восходящие лучи, рабочая частота --- вертикальная пунктирная линия.

Анализ полученной  диаграммы показывает, что ни одна из линий возбуждающих гармоник не пересекается с формами собственных частот колебаний диска. Это означает, что в рабочем диапазоне частот вращения и при типичных возбуждающих гармониках отсутствуют условия для возникновения резонансных явлений, что говорит о вибропрочности диска.

На @disk-result представлена визуализация всех рассчитанных форм колебаний исследуемого диска.

#figure(
  grid(columns:3,
    image("assets/ansys/disk/modal/d2.png"),
    image("assets/ansys/disk/modal/d3.png"),
    image("assets/ansys/disk/modal/d4.png")
  ),
  caption: [Веерные формы колебаний диска с 2, 3 и 4 узловыми диаметрами]
) <disk-result>

== Расчет ротора ГТУ на вибронадежность

После проведения статических и модальных расчетов диска на прочность необходимо провести оценку прочности всего ротора установки. Основным критерием прочности ротора является его вибронадёжность, поскольку осевые нагрузки в установке невелики, а окружные и радиальные нагрузки учтены в расчете диска в @Ansys-disk.

Для проведения модального расчета построена упрощённая твердотельная модель ротора, изображенная на @rotor1.

#figure(
  image("assets/ansys/rotor/model-geometry.png", width:100%),
  caption: [Твердотельная модель ротора]
) <rotor1>

По этой модели построена сеточная модель, показанная на @rotor2.

#figure(
  image("assets/ansys/rotor/model-mesh.png", width:100%),
  caption: [Сеточная модель ротора]
) <rotor2>

Упрощение рассматриваемой модели ротора относительно эскиза ротора установки заключается в понижении детализации дисков для получения простой и предсказуемой сеточной модели, а также в отсутствии учёта массы лопаток компрессора.

Сеточная модель загружается в модуль Modal. Для расчета применяются следующие граничные и начальные условия:
+ Два подшипника жесткостью $10^9$ #zN-m2() с помощью функции Bearing;
+ Ограничения на вращение по оси Z, ограничение на перемещение со стороны опорно-упорного подшипника (сторона компрессора) реализованы с помощью функции Remote Displacement.
+ Скорость вращения для трех режимов:
  + Стартовое положение --- #zrpm(1)\;
  + Номинальный режим --- #zrpm(5441)\;
  + Аварийный режим --- $1.5 dot 5441 = #zrpm(8161.5)$.

Твердотельная модель ротора с применёнными граничными условиями показана на @rotor_bearing.

#figure(
  image("assets/ansys/rotor/boundary_conditions.png", width:100%),
  caption: [Граничные условия для ротора]
) <rotor_bearing>

По результатам расчета построена вибрационная диаграмма ротора, показанная на @rotor_campbell.

#figure(
  {show lq.selector(lq.legend): set grid(columns: 4)
  lq.diagram(
    height:9cm, margin: (x:0%), ylim: (0, auto),
    ylabel: $f, "Гц"$, xlabel: $omega, #zrpm()$,
    legend: (position: right, dy: -25%, dx: -1%),
    cycle: lq.color.map.petroff6,

    // Линия кратности
    let x_main = (0, 5441, 8161),

    lq.line((0, 0), (x_main.last(), x_main.last()/60), stroke: 1pt),

    // Линия номинала
    lq.line( (x_main.at(1), 0%), (x_main.at(1), 100%), stroke: (thickness: 1pt, dash: "dashed" )),

    // Линии колебаний
    let y_1 = (44.117, 42.847, 42.220),
    let y_2 = (44.134, 45.437, 46.104),
    let y_3 = (116.66, 116.66, 116.66),
    let y_4 = (144.80, 142.06, 140.68),
    let y_5 = (144.91, 147.70, 149.14),
    let y_6 = (262.73, 262.78, 262.84),

    lq.plot(x_main,y_1, mark-size:6pt, stroke:1pt, label: $f_1^-$),
    lq.plot(x_main,y_2, mark-size:6pt, stroke:1pt, label: $f_2^+$),
    lq.plot(x_main,y_3, mark-size:6pt, stroke:1pt, label: $f_3^-$),
    lq.plot(x_main,y_4, mark-size:6pt, stroke:1pt, label: $f_4^-$),
    lq.plot(x_main,y_5, mark-size:6pt, stroke:1pt, label: $f_5^+$),
    lq.plot(x_main,y_6, mark-size:6pt, stroke:1pt, label: $f_6^-$),

    // Критические частоты
    let x_crit = (2610.5, 2686.6, 6999.7),

    lq.scatter(x_crit, x_crit.map(x => x/60), mark: "^", size: 8pt, label: $omega_"кр"^i$),
  )},
  caption: [Вибрационная диаграмма ротора]
) <rotor_campbell>

Проанализировав критические скорости, можно сделать вывод, что данный ротор классифицируется как гибкий, так как номинальная рабочая частота ротора составляет #zrpm(5441) и превышает несколько первых критических скоростей. Критическими для данной системы являются скорости #zrpm(2610.5), #zrpm(2686.6) и #zrpm(6999.7) об/мин. Принцип работы гибкого ротора предполагает  эксплуатацию на скоростях, превышающих основные критические, что требует обеспечения быстрого прохода через них при разгоне и остановке во избежание длительного резонансного состояния. На полученной диаграмме видно, что наиболее близкая к номинальному режиму работы критическая частота вращения составляет #zrpm(6999.7).

Запас устойчивости на номинальном режиме:
$ Delta n = abs((n_"ном"-n_"крит")/n_"ном") dot 100% = abs((7000 - 5441) / 5441) dot 100% = 28.6%, $

#noind что превышает нормативное требование в $ 15%$ и свидетельствует о соблюдении условий виброустойчивости ротора в рабочем диапазоне частот вращения для первой кратности возбуждающих воздействий.

= Конструкция газотурбинной установки

== Комплексное воздухоочистительное устройство и входной тракт

Входным трактом называется сегмент проточной части ГТУ, предназначенный для подведения атмосферного воздуха к компрессору.

Качество подаваемого на вход компрессора воздушного потока является критически важным для эксплуатации ГТУ. Атмосферный воздух содержит твердые частицы (пыль, песок), солевые включения, влагу и иные загрязнители, которые являются причиной абразивного износа и коррозионных процессов проточной части. В целях защиты ГТУ от указанных воздействий применяются комплексные воздухоочистительные устройства (КВОУ), функционирующие как многоступенчатые системы фильтрации. Также на КВОУ монтируются блоки шумоподавления, предназначенные для снижения уровня шума от ГТУ для внешних наблюдателей.

=== Устройство КВОУ и входного тракта проектируемой установки

В проектируемой установке конструкция входного тракта и КВОУ повторяет конструкцию соответствующих узлов прототипа. Общий вид и компоновка входного тракта и КВОУ прототипа указаны на @bob-kvou @kvouu.

#figure(
  image("assets/bob/KVOU-65.jpg", width: 70%),
  caption: [Общий вид компоновки прототипа (ГТЭ-65.0) с установленным входным трактом и КВОУ]
) <bob-kvou>

#undo-line()

КВОУ устанавливается на крыше электростанции или приподнятой платформе для минимизации попадания увлекаемых потоком воздухом частиц с поверхности земли в проточную часть. По входному тракту очищенный воздух движется вниз, после чего попадает во входной направляющий аппарат компрессора ГТУ.

Элементами применяемой на проектируемой установке КВОУ являются:
+ Погодный козырёк, предотвращающий попадание большей части капель дождя в фильтрующий объём КВОУ;
+ Фильтр предварительной очистки, предназначенный для удаления оставшихся капель воды, крупных частиц или снега;
+ Фильтр грубой очистки, улавливающий частицы среднего размера (10-25 мкм);
+ Фильтр тонкой очистки, улавливающий мелкодисперсные частицы (1-10 мкм).

== Компрессор ГТУ

Компрессор в составе ГТУ предназначен для подачи воздуха с расчетными параметрами в камеру сгорания.

Повышение внутренней энергии рабочего тела в компрессоре происходит с помощью сообщения рабочими лопатками кинетической энергии, которая переводится в потенциальную энергию давления в процессе диффузорного течения в каналах рабочих и сопловых лопаток. В процессе работы компрессора из-за трения рабочего тела о элементы установки и самого сжатия рабочее тело также дополнительно нагревается, что повышает работу, затрачиваемую на сжатие, но полезно для работы камеры сгорания.

=== Устройство компрессора проектируемой установки

В проектируемой установке используется 16-ступенчатый осевой компрессор c постоянным средним диаметром проточной части. Эскиз компрессора с указанием конструктивных элементов показан на @bob-comp.

#figure(
  {
    image("assets/bob/compressor.png", width: 80%)
    text(12pt)[
      1 --- входной конфузор, 2 --- силовая опора конфузора, 3 --- входной направляющий аппарат, 4 --- обоймы направляющих лопаток, 5 --- устройства регулирования положения направляющих аппаратов, 6 --- передний корпус, 7 --- задний корпус, 8 --- выходной диффузор компрессора, 9 --- спрямляющий аппарат, 10 --- рассекатель потока, 11 --- спрямляющий аппарат, 12 --- диск ротора, 13 --- рабочая лопатка компрессора, 14 --- отборы охлаждающего воздуха
    ]
  },
  caption: [Эскиз компрессора проектируемой ГТУ]
) <bob-comp>

Входной конфузор компрессора соединен со входным трактом с помощью фланца. Входной конфузор отлит из чугуна с шаровидным графитом EN-GJS-400-18U-LT. Выбор материала обусловлен сложной формой литой детали и невысокой температурой на входе. В нижней половине конфузора выполнены наплывы для установки опорно-упорного подшипника и внешние лапы, передающие нагрузку от ГТУ на фундаментные опоры. На внутренние поверхности конфузора и силовые ребра наносится специальное органо-силикатное покрытие, облегчающее удаление льда.
 
Передний корпус компрессора --- литой из высокопрочного чугуна EN-GJS-400-18U-LT. Для реализации поворота направляющих аппаратов (НА) первых трех ступеней в корпусе предусмотрены места для цапф, а также расточки для жестко зафиксированных НА 3-й, 4-й, 5-й ступеней. Наружные цапфы поворотных лопаток объединены рычагами и кольцами в единую регулируемую электромеханическим приводом систему, которая расположена сбоку от переднего корпуса компрессора. Система позволяет корректировать массовый расход воздуха через проточную часть в диапазоне от 70% до 100 % номинального значения. Над рабочими лопатками 1-й ступени установлена противосрывная щелевая решетка.

Задний корпус компрессора выполнен сварным из стали 16МоЗ. За 8-й ступенью предусмотрены фланцы для патрубков отбора воздуха на думмис турбины. Думмис необходим для снижения осевого усилия на опорно-упорный подшипник. За 10-й ступенью в корпусе имеются камеры для отбора воздуха из проточной части компрессора на охлаждение горячих узлов турбины и на антипомпажные клапаны. За 13-й ступенью также происходит отбор охлаждающего воздуха. Внутри корпуса выполнены расточки для обойм направляющих аппаратов, обоймы изготовлены из стали 15X1М1ФЛ.

Выходной диффузор компрессора представляет из себя сварно-литую конструкцию из стали 15X1М1ФЛ и закреплен на обойме. Из диффузора предусмотрен отбор воздуха на охлаждение элементов соплового аппарата 1-й ступени турбины. Со стороны турбины к диффузору крепится сварной разделитель потока и лабиринтное уплотнение.

Направляющие лопатки 3–16-й ступеней имеют прямоугольный хвостовик с кольцевыми зацепами и заводятся в пазы радиально, где фиксируются кольцевыми шпонками. Для обеспечения тепловых перемещений сопловые аппараты 14–16-й ступеней состоят из четырех частей каждый, с тепловыми зазорами в местах сопряжений. Направляющие аппараты 3–13-й ступеней выполнены из двух половин. Материалы направляющих лопаток: 1–12-й --- 20Х13Ш; 13–16-й --- 20Х13. За последней ступенью расположен спрямляющий аппарат, который устраняет вихри в потоке.

Рабочие лопатки компрессора имеют хвостовики типа «ласточкин хвост» и заводятся в диск в осевом направлении. Материалы рабочих лопаток компрессора: 1–2-й ступень --- X4CrNiMo16-5-1; 3–12-й --- 20Х13Ш; 13–16-й --- 15Х11МФ-Ш. Фиксация рабочих лопаток 1–6-й ступеней в пазах дисков осуществляется стопорными пластинами, на остальных --- расчеканиванием металла на торце лопатки. Перо рабочих и направляющих лопаток всех ступеней покрыты противоэрозионно-противокоррозионным составом. 

Материалы дисков рабочих колёс компрессора: 1–13-й ступень --- 26NiCrMoV11-5, 13–16-й ступень --- 26NiCrMoV14-5. Пазы в диске для лопаточных хвостовиков в диске изготавливаются с помощью протяжки. Отверстия для отбора воздуха в дисках 10-й и 13-й ступеней высверливаются.  

=== Помпаж и способы защиты от него в проектируемой установке

Помпаж --- это аварийный режим работы компрессора, характеризующийся резким нарушением расчетной структуры потока воздуха. Из-за срыва потока происходит пульсирующее турбулентное движение воздуха, вызывающее сильные низкочастотные колебания давления, что приводит к противотоку. Такой режим работы может привести к катастрофическому разрушению установки. 

Для защиты от помпажа передний корпус имеет два фланца для крепления трубопроводов отбора воздуха на антипомпажные клапаны за 5-й ступенью. При их открытии воздух из компрессора перепускается в выходной диффузор турбины, что понижает гидравлическое сопротивление системы за компрессором, что предотвращает противоток. Антипомпажные клапаны необходимы для устойчивой работы компрессора на пусковых режимах.

== Камера сгорания

Камера сгорания ГТУ предназначена для преобразования энергии сгорания топлива во внутреннюю энергию газовоздушной смеси, поступающей в газовую турбину.

Для стационарных энергетических ГТУ в основном применяются камеры сгорания следующих типов:
+ Выносная КС, расположенная вне основного корпуса турбогруппы и имеющая цилиндрическую форму;
+ Кольцевая КС, представляющая собой единую тороидальную полость между внутренним и внешним корпусами;
+ Трубчато-кольцевая КС, состоящая из набора расположенных вокруг вала установки цилиндрических корпусов.

На разных этапах разработки прототипа в его конструкции применялись камеры сгорания двух разных типов: в ГТЭ-65.0 применялась кольцевая камера сгорания, тогда как в ГТЭ-65.1 используется трубчато-кольцевая камера сгорания @LEB. Трубчато-кольцевая камера сгорания считается более перспективной по следующим причинам:
+ Технология производства КС сгорания не налажена в России из-за высоких требований к исполнению элементов конструкции;
+ Регулирование трубчато-кольцевой КС проще и надёжнее из-за более простой чем в кольцевой КС геометрии зоны горения. Нет опасности развития кольцевых вихрей;
+ Испытание и ремонт трубчато-кольцевой КС проходят проще и дешевле из-за возможности испытать или заменить отдельный сектор.
Из недостатков трубчато-кольцевой КС по сравнению с кольцевой КС можно отметить большие габариты и массу, а также большую окружную неравномерность давления и температуры.

По совокупности указанных факторов на проектируемой установке применена трубчато-кольцевая камера сгорания.

Камера сгорания проектируемой установки имеет 6 секций, одна из которых изображена на @bob-KS. Секция состоит из блока горелочных устройств, закрытого корпусом, пламенной трубы и газосборника.

#figure(
  {
    image("assets/bob/KS.png", width: 80%)
    text(12pt)[
      1 --- пламенная труба, 2 --- газосборник, 3 --- блок горелочных устройств, 4 --- горелка центральная, 5 --- горелки периферийные
    ]
  },
  caption: [Конструкция одной секции трубчато-кольцевой камеры сгорания проектируемой установки]
) <bob-KS>

Горелочное устройство состоит из 8 периферийных премиксных горелок и центральной горелки в центре. Коаксиально с центральной горелкой закреплена пилотная горелка, которая производит розжиг. К каждому типу горелок осуществляется отдельный подвод топливовоздушной смеси. Для стабилизации режима горения и формы факела, а также обеспечения обратных токов, горелки обеспечены завихрителями. Их задача состоит в закрутке увлекаемого пламенем воздуха.

Далее следует пламенная (жаровая) труба, в которой происходит сжигание бедной предварительно подготовленной топливно-воздушной смеси с низкой эмиссией оксидов азота и монооксида углерода ($<50$ мг/м), что позволяет снизить негативное влияние на окружающую среду. Помимо этого, премиксное горение превосходит диффузионное по КПД и полноте сгорания. Пламенная труба имеет двустенную конструкцию. Подвод охлаждающего воздуха в объем горения (через внутреннюю стенку) осуществляется в специальном кожухе отбора воздуха. Также через внутреннюю стенку происходит смешение продуктов сгорания с воздухом из компрессора (он подводится через систему отверстий в стенке пламенной трубы) и догорание топлива. В стенках пламенной трубы реализованы трубы пламяпереброса — специальные каналы, помогающие уравновесить режимы работы секций камеры сгорания.

За пламенной трубой расположен газосборник, который соединяет цилиндрическую секцию камеры сгорания с кольцевым участком проточной части. Газосборник также имеет двустенную структуру и охлаждается потоком воздуха, проходящим через внешнюю стенку, внутренняя и наружная стенки изготавливаются отдельно с помощью аддитивных технологий, проходят механическую обработку, после чего внешняя стенка разрезается и надевается на внутреннюю, фиксируясь с помощью сварки.

Наибольшая температура газов распределена в центре факела внутри пламенной трубы и имеет величину порядка 1900 К. Так как это очень большая температура, превышающая температуру плавления металла стенок пламенной трубы, предпринимаются меры против попадания газа из этой области на стенки (создание противотока, завихрение факела), меры к ударному охлаждению стенки с помощью воздуха, а также экранирование стенки с помощью термозащитного покрытия в виде керамических плиток. Эти меры помогают не допустить повышение температуры на стенке больше 1100 К. Температуры стенок газосборника за счет ударного воздушного охлаждения находятся в районе 600 К.

== Газовая турбина

Газовая турбина в составе ГТУ предназначена для преобразования внутренней энергии рабочего тела в механическую энергию вращения вала.

Турбина проектируемой установки изображена на @bob-turb. Турбина состоит из четырёх ступеней, первая ступень имеет постоянную высоту, тогда как остальные ступени имеют угол раскрытия $24 degree$. Турбина состоит статорной и роторной части. Ротор турбины состоит из отдельных рабочих колёс, включающих в себя диск и рабочие лопатки. Статорную часть можно разделить на корпус турбины и выходной корпус.

#figure(
  {
    image("assets/bob/Turb.png", width: 80%)
    text(12pt)[
      1 --- рабочая лопатка, 2 --- бандажная полка, 3 --- хвостовик рабочей лопатки, 4 --- диск ротора, 5 --- сотовое уплотнение сопловой лопатки, 6 --- корпус турбины, 7 --- выходной корпус, 8 --- сопловая лопатка, 9 --- надроторная вставка, 10 --- патрубки подвода охлаждающего воздуха, 11 --- сотовое уплотнение рабочей лопатки, 12 --- верхняя полка сопловой лопатки, 13 --- канал для подвода охлаждающего воздуха
    ]
  },
  caption: [Эскиз турбины проектируемой установки]
) <bob-turb>

 Оба корпуса статора турбины сварные, выполняются из материала 16Mo3. В корпус турбины устанавливается литая обойма диафрагм из стали 15Х1М1ФЛ. В обойму по окружности заводятся и закрепляются с помощью кольцевой проточки сопловые лопатки, предназначенные для направления потока рабочего тела и перевод части внутренней энергии потока в кинетическую. Сопловые лопатки выполнены пакетами методом литья по выплавляемым моделям из материала IN-939. Выбор материала обусловлен требованием высокой температуры плавления и прочности, а также ударной вязкости. Также в корпусе турбины закрепляются надроторные вставки, удерживающие сотовые уплотнения над краями рабочих лопаток.

Для изготовления рабочих лопаток, как и для сопловых, применяется литьё по выплавляемым моделям, используемый материал --- сплав IN-792. Выбор материала обусловлен аналогично материалу сопловой лопатки. Рабочие лопатки 2-4 ступеней бандажированные, что позволяет обеспечить необходимую жесткость и вибрационную надежность, а также минимизировать протечки и сделать их более равномерными в окружном направлении. Крепление лопаток турбины в дисках осуществляется елочным замком, лопатки заводятся в диск в осевом направлении и фиксируются специальными пружинящими пластинами. Профиль паза для хвостовика лопатки одинаковый для всех дисков турбины и изготавливается протяжкой @egorshin2021.

Диск изготавливается из заготовок фрезеровкой, применяемый материал --- 26NiCrMoV11-5. Выбор материала обусловлен близким коэффициентом термического расширения к таковому у материала лопатки.

== Выходной тракт

Выходной тракт ГТУ предназначен для вывода отработанной газовоздушной смеси из проточной части ГТУ в атмосферу или котёл-утилизатор.

Основным элементом выходного тракт является выходной диффузор, обеспечивающий расширение выходящего из турбины газа совместно с повышением (восстановлением) его давления до уровня атмосферного. Это позволяет уменьшить давление за турбиной, повысив КПД установки.

Выходной диффузор проектируемой установки имеет угол раскрытия $13 degree$, что позволяет избежать отрыва потока от стенок.

== Охлаждение проточной части турбины

Температуры в проточной части современной ГТУ могут превосходить 1600 градусов цельсия, что превышает температуру плавления используемых конструкционных материалов. Для обеспечения работоспособности установки при таких параметрах необходимо применять охлаждение элементов камеры сгорания и газовой турбины, а также термозащитное покрытие @TURB.

// == Отборы на охлаждение

// Для организации охлаждения лопаток производится отбор холодного воздуха из компрессора, который в обход камеры сгорания подводится к охлаждаемым лопаткам. На проектируемой установке можно выделить 4 пути отбора воздуха, показанные на @bob-otbor.

// #figure(
//   {
//     image("assets/bob/KVOU-65.jpg")
//   },
//   caption: [Отборы воздуха из компрессора на охлаждение]
// ) <bob-otbor>

=== Охлаждение камеры сгорания

Для охлаждения камеры сгорания проектируемой ГТУ применяется два метода: использование удара воздуха о стенку корпуса камеры сгорания (струйное охлаждение), а также создание защитной плёнки воздуха у стенки. Также охлаждению способствует организация обратного тока газа, температура в котором ниже, чем в зоне горения. Помимо использования теплоемкости и заградительной способности воздуха, в самой горячей части камеры сгорания --- пламенной трубе --- используются специальные керамические термозащитные покрытия.

=== Охлаждение лопаток турбины

Воздух для охлаждения рабочих лопаток турбины подводится через специальные каналы в дисках компрессора и турбины, между которыми он проходит через коаксиальные каналы среднего вала ротора.

Воздух для охлаждения сопловых лопаток турбины подводится через патрубки, расположенные в корпусе статора, и далее через пространство между корпусом турбины и обоймой диафрагм, разделенное на полости с помощью самоустанавливающихся поперечных пластин. 

Для подведения воздуха в корне рабочих лопаток и периферии сопловых делается набор отверстий, сами лопатки выполняются полыми с внутренней структурой, обусловленной методом охлаждения.

Сопловые и рабочие лопатки 1-й и 2-й ступеней используют конвективно-плёночную систему охлаждения. Лопатки 3-й ступени имеют только конвективное внутреннее охлаждение. Лопатки 4-й ступени не имеют охлаждения. 

== Уплотнения проточной части

Уплотнения в ГТУ применяются для предотвращения или минимизации протечек воздуха или газа. Протечки возникают из-за разницы давлений до и после турбинных и компрессорных ступеней, а также давлений внутри проточной части и атмосферы. Их неустранение ведёт к понижению КПД вследствие перетекания части рабочего тела через лопатки, из-за чего часть потока не совершает полезной работы и нарушает расчетное течение за местом протечки @upl.

=== Уплотнения подвижных частей ГТУ <bob-up>

В подвижных зазорах между ротором и статором в проточной части проектируемой установки применяются следующие уплотнения:
- Лабиринтные уплотнения направляющих аппаратов компрессора,  снижающие перетечки воздуха в обход направляющих лопаток;
- Лабиринтное уплотнение проставочного элемента вала между компрессором и турбиной, снижающие перетечки воздуха из компрессора в турбину в обход камеры сгорания;
- Контактные сотовые уплотнения сопловых аппаратов турбины;
- Контактные сотовые уплотнения над бандажной полной рабочих лопаточных венцов турбины;
- Контактное сотовое концевое уплотнение думмиса.

Традиционным и наиболее распространенным типом являются лабиринтные уплотнения --- эти бесконтактные уплотнения представляют из себя расположенные перпендикулярно линии тока уплотнительные гребни, формирующие расширительные камеры. Эта конструкция препятствует свободному течению газа за счет дросселирования при перетекании между камерами через малый зазор. Гребни могут располагаться как на одной стороне, что удешевит изготовление, так и совместно на роторе и статоре, что добавит к сопротивлению от дросселирования сопротивление на разворот газа. Наклон гребней позволяет увеличить их эффективность, однако это также удорожает стоимость изготовления. Эффективность таких уплотнений пропорционально количеству гребней по ходу течения газа. В проточной части обычно 3-5 уплотнительных гребня, в концевых --- 10-12. Существенным минусом такого вида уплотнений является большая величина зазора, необходимая для предотвращения зацепления при радиальных перемещениях.

Для минимизации недостатков лабиринтных уплотнений применяются сотовые контактные уплотнения. Они представляют из себя пару из гребней на роторной части и специальных ячеистых сот на статорной части. Высота зазора рассчитывается так, что при работе на номинальном режиме гребни входят в контакт с сотами и сминают их, обеспечивая минимально возможный зазор. Соты изготавливаются из металлокерамического материала в виде тонких пластин, из которых собирают шестиугольники.

На @bob-dum изображен пример сотового уплотнения проектируемой ГТУ.

#figure(
  {
    image("assets/bob/endseal.png", width: 80%)
    text(12pt)[
      1 --- элемент статора, 2 --- ротор ГТУ, 3,5 --- гребешки ротора, 4,6 --- металлокерамические соты
    ]
  },
  caption: [Сотовое уплотнение на выходе из воздушной полости думмиса]
) <bob-dum>

=== Уплотнения неподвижных частей ГТУ

Уплотнение неподвижных соединений осуществляют с помощью контактных уплотнений, так как в отсутствии движения контакт не приводит к трению, но позволяет обеспечить наименьшую или нулевую протечку. Размещают такие уплотнения в стыках корпуса и разборных соединений. Типичным примером такого соединения является кольцо из мягкого материала (резина или мягкие металлы), которое при установке с натягом самоуплотняется, обеспечивая минимальные зазоры. Помимо этого, уплотнение достигается точной обработкой поверхности соединяемых элементов и большим затягом болтов.

== Ротор

Ротор проектируемой установки состоит из отдельных дисков, на которых закреплены рабочие лопатки компрессора и турбины, а также переднего, среднего и заднего валов. Соединение дисков между собой производится с помощью хиртовых соединений, центрирующих их и ограничивающих перемещение в радиальном и окружном направлении. Для фиксации дисков в осевом направлении, а также их соединения с передним и задним валами производится с помощью центральной стяжки. Эскиз ротора проектируемой установки представлен на @bob-rot.

Центральная стяжка представляет собой высокопрочный вал, проходящий через внутренние расточки дисков. Стяжка закреплена резьбовым концом в переднем валу и гайкой в заднем валу. Для увеличения жесткости ротора на центральной стяжке установлены демпферные конуса --- два в зоне компрессора и один в зоне турбины.

Передний и задний вал закрепляют диски относительно оси, средний вал заполняет промежуток между зонами компрессора и турбины. Средний вал состоит из коаксиальных колец, в пространстве между которыми протекает используемый для охлаждения турбины воздух.

Сборка конструкции осуществляется на вертикальном стенде. Балансировка проводится с помощью двухэтапной установки балансировочных грузов в трех плоскостях: в районе первой ступени компрессора, на среднем и заднем валах.

#figure(
  {
    image("assets/bob/rotor.png", width: 80%)
    text(12pt)[
      1 --- передний вал; 2 --- балансировочные плоскости; 3 --- рабочее колесо компрессора; 4 --- средний полый вал; 5 --- трубы для разграничения воздушных полостей; 6 --- рабочее колесо турбины; 7 --- задний полый вал; 8 --- гайка ротора; 9 --- демпфирующие конусы; 10 --- стяжка ротора; 11 --- резьбовое соединение; 12 --- фланец
    ]
  },
  caption: [Эскиз ротора проектируемой ГТУ]
) <bob-rot>

== Подшипники ГТУ

Подшипники --- это механические устройства, предназначенные для снижения трения вращения вала, а также ограничения его перемещения в радиальном и осевом направлении. В машиностроении в основном применяется два типа подшипников:
+ Подшипники скольжения, принцип работы которых заключается в использовании жидкого трения, при котором ротор и вкладыш разделены за счет наличия между ними масляного слоя;
+ Подшипники качения, использующие трение качения шариков, роликов или игл, находящихся между двумя кольцами.

Ротор проектируемой установки опирается на два подшипника скольжения: опорно-упорный подшипник со стороны компрессора и опорный со стороны выходного диффузора. Это обусловлено необходимостью ограничить передачу тепловых расширений на вал редуктора @Tutu.

Использование подшипников скольжения обусловлено следующими преимуществами по сравнению с подшипниками качения:
+ Работоспособность при больших ударных и вибрационных нагрузках;
+ Больший ресурс работы;
+ Более медленный рост стоимости изготовления при росте грузоподъемности;
+ Простое обслуживание за счет горизонтального разъема корпуса.

В то же время, подшипники скольжения имеют следующие недостатки:
+ Большие потери на трение по сравнению с подшипниками качения;
+ Больший расход смазочного материала и повышенные требования к надежности системы маслоснабжения;
+ Большие осевые размеры.

=== Опорный подшипник проектируемой установки

Конструкция опорного подшипника проектируемой установки изображена на @bob-pod-op.

Вкладыш опорного подшипника сферический, самоустанавливающийся. Материал вкладыша --- сталь 20. В переднем и заднем подшипниках для предотвращения низкочастотных колебаний, лучшей подачи смазочного масла в рабочую зону и обеспечения масляного клина внутренняя поверхность вкладыша выполнена овальной (лимонная расточка). В качестве антифрикционного материала выбран баббит марки Б-83.


#figure(
  {
    image("assets/bob/bearing-o.png", width: 80%)
    text(12pt)[
      1 --- основание опорного подшипника, 2 --- вкладыш, 3 --- трубки маслоподачи, 4 --- баббитовая наплавка, 5 --- лабиринтное уплотнение
    ]
  },
  caption: [Продольный разрез опорного подшипника]
) <bob-pod-op>

=== Опорно-упорный подшипник проектируемой установки

Конструкция опорно-упорного подшипника проектируемой установки изображена на @bob-pod-up.

#figure(
  {
    image("assets/bob/bearing-u.jpg", width: 80%)
    text(12pt)[
      1 --- основание подшипника, 2 --- вкладыш, 3 --- винт стопорный, 4 --- каналы для подвода смазочного материала, 5 --- баббитовая наплавка опорной части, 6, 7 – упорные колодки, 8, 9 --- баббитовые наплавки упорной части, 10 --- корпус, 11 --- ротор ГТУ
    ]
  },
  caption: [Продольный разрез опорно-упорного подшипника]
) <bob-pod-up>

Опорно-упорный подшипник выполнен со сферической опорной частью вкладыша, компенсирующей статический прогиб ротора. В качестве антифрикционного материала на опорной и упорной частях применен баббит Б83. Упорная часть подшипника рассчитана на восприятие суммарной нагрузки не более 10 т. Марка подводимого турбинного масла Тп-22С, оно подводится индивидуально к каждой колодке.

== Тепловые расширения в ГТУ

Эксплуатация ГТУ происходит в условиях чрезвычайно высоких температур, что приводит к значительным тепловым деформациям элементов конструкции. Управление этими расширениями является одной из ключевых задач для обеспечения надежности, эффективности и долговечности двигателя. Неправильный учет тепловых деформаций может привести к снижению КПД, повреждению лопаток и, в худшем случае, к катастрофическому разрушению установки. Основными направлениями тепловых расширений ГТУ являются осевое и радиальное.

 Осевое направление направление считается наиболее критичным. Ротор и статор изготовлены из разных материалов, которые имеют разные коэффициенты термического расширения и нагреваются неравномерно, что приводит к неодинаковому изменению их длины. Конструкция ГТУ должна обеспечивать толерантность к нормативной разнице этих расширений, чтобы контролировать осевые зазоры и не допустить контакта статорной и роторной части. Схема тепловых расширений проектируемой установки в осевом направлении изображена на @bob-deformation. "Полюсом" расширения установки является камера сгорания, тепло от которой по-разному распределяется в статоре и роторе, что может привести к непредсказуемым перемещениям. Для предопределения направления этих перемещений используется опорно-упорный подшипник.

#figure(
  {
    cetz.canvas({
      import cetz.draw: *

      // Компрессор и турбина
      line(name: "comp", (0, 0), (rel:(0,4)), (rel:(5,-1)), (rel:(0,-2)), close:true )
      line(name: "turb", (8, 0.75), (rel:(0,2.5)), (rel:(3,0.75)), (rel:(0,-4)), close:true )
      
      polygon((6.5,2),4, angle: 45deg, radius: 1, name: "cam")
      circle("cam", radius: 1/calc.sqrt(2))
      arc("cam", radius: 1/calc.sqrt(2),start: 45deg, delta: 90deg,mode: "PIE", anchor: "origin")
      arc("cam", radius: 1/calc.sqrt(2),start: -135deg, delta: 90deg,mode: "PIE", anchor: "origin")

      line(name: "d1",  "comp.2", (rel:(-2,0)) )
      line(name: "d1c", "comp", "cam"        )
      line(name: "d2c", "turb", "cam"        )
      line(name: "d3",  "turb"  , (rel:(3,0)) )

      content("comp", [К ])
      content("turb", [ГТ])
      content("cam.north", [КС], anchor: "south", padding: 0.2)

      circle("d1", radius: 0.06, fill:black)

      line(name: "abs", (-1,4.5),(10, 4.5), mark:(end:"stealth", stroke:red, fill: red), stroke:3pt + gradient.linear(blue, red))
      line(name: "rel", (1,-0.5),(12,-0.5), mark:(symbol:"stealth", stroke:red, fill: red), stroke:3pt + gradient.linear(red,blue,red))

      line("cam","rel"  , stroke: (dash: "dashed"))
      line("d1", "abs.0", stroke: (dash :"dashed"))

      content("d1", text(size:20pt," ["), anchor:"west",angle: 90deg)
      content("d1", text(size:20pt," ["), anchor:"west",angle:-90deg)

      content("d3", text(size:20pt," ["), anchor:"west",angle: 90deg)
      content("d3", text(size:20pt," ["), anchor:"west",angle:-90deg)

      // Номера
      content(name: "n1", (-2,4),   $1$,padding:0.1)
      content(name: "n2", (12,4),   $2$,padding:0.1)
      line(stroke:gray,"n1","d1"  )
      line(stroke:gray,"n2","d3"  )
    })
    text(size: 12pt)[ГТ --- газовая турбина, К --- компрессор, КС --- камера сгорания, 1 --- опорно-упорный подшипник, 2 --- опорный подшипник \ Нижняя линия показывает размах тепловых расширений ротора в его системе отсчета, верхняя линия показывает размах тепловых расширений в системе отсчета станции. Цветом условно показана величина деформации в осевом направлении ]
  },
  caption: [Схема тепловых расширений проектируемой ГТУ в осевом направлении]  
) <bob-deformation>

Радиальное расширение определяет величину радиальных зазоров между концами лопаток и корпусом установки. Оптимизация этих зазоров требует внимания, поскольку недостаточный зазор приводит к трению и вероятности задевания ротора о статор, что вызовет механическое повреждение уплотнений, тогда как чрезмерный зазор вызовет рост утечек рабочего тела над лопатками, что существенно снижает аэродинамическую эффективность и мощность турбины @STEL.

Управление тепловыми деформациями в ГТУ осуществляется с помощью двух методов:

+ Расчет холодных зазоров. На этапе проектирования зазоры в ненагретом ("холодном") двигателе задаются с предварительным запасом, учитывающим прогнозируемое тепловое расширение при выходе на номинальный режим. Именно поэтому на этапах запуска и остановки, когда зазоры еще велики, может наблюдаться так называемое "звонение" лопаток --- кратковременное касание, которое считается нормальным явлением.

+ Использование фикспункта и опорно-упорного подшипника. Фикспункт закрепляет корпус установки относительно системы отсчета станции, тогда как опорно-упорный подшипник закрепляет ротор относительно статора. Это основной метод управления осевым перемещением элементов ГТУ, позволяющий элементам установки предсказуемо перемещаться в строго определённом направлении.

== Передача моментов от источника к потребителю в ГТУ

Так как после преобразования энергии рабочего тела в механическую энергию вращения вала турбогруппы происходит её перенос к турбогенератору, состоящий из нескольких этапов, имеет смысл рассмотреть путь и способы передачи крутящего момента от вала источника к потребителю. Для изображения этого пути применяют принципиальные кинематические схемы.

На @bob-moment изображена принципиальная кинематическая схема проектируемой установки. 

#figure(
  {
    cetz.canvas({
      import cetz.draw: *

      // Генератор
      circle(name: "gen", (0,0), radius: 0.75)
      content("gen", text(30pt, sym.dash.wave))
      line(name:"genbash", "gen.north", (rel:(0,1)))
      content("genbash.40%", text(size: 20pt, sym.bar), angle:-60deg)
      content("genbash.60%", text(size: 20pt, sym.bar), angle:-60deg)
      content("genbash.80%", text(size: 20pt, sym.bar), angle:-60deg)

      // Редуктор
      rect(name: "w1", (3, 1),(4,-1))
      rect(name: "w2", (3,-1),(4,-2))
      content("w1", text(size:2em)[#sym.times])
      content("w2", text(size:2em)[#sym.times])

      // Компрессор и турбина
      line((6 ,-2.5),(6 ,-.5),(8 ,-1  ),(8 ,-2 ),close:true,name:"t1")
      line((10,-1  ),(10,-2 ),(12,-2.5),(12,-.5),close:true,name:"t2")

      line(name: "genline", "gen", "w1"     )
      line(name: "d1", "w2", "t1"           )
      line(name: "d2", "t1", "t2"           )
      line(name: "d3", "t2", (rel:(1.4, 0)) )

      content("t1",[К] )
      content("t2",[ГТ])

      // Опоры на валу от компрессора к редуктору
      content("d1.12%", [--], anchor: "south"               )
      content("d1.12%", [--], anchor: "south", angle: 180deg)
      content("d1.88%", [--], anchor: "south"               )
      content("d1.88%", [--], anchor: "south", angle: 180deg)
    
      // Опоры на валу от турбины
      content("d3.50%", [--], anchor: "south"               )
      content("d3.50%", [--], anchor: "south", angle: 180deg)

      // Опоры на валу от редуктора снизу и он сам
      line(name: "d0", "w2",(rel:(-1,0)))
      content("d0.50%", [--], anchor: "south")
      content("d0.50%", [--], anchor: "south", angle: 180deg)

      // Опоры на валу от редуктора сверху и он сам
      line(name: "u0", "w1",(rel:(1,0)))
      content("u0.50%", [--], anchor: "south")
      content("u0.50%", [--], anchor: "south", angle: 180deg)

      // Опоры на валу от редуктора сверху справа
      content("genline.88%", [--], anchor: "south")
      content("genline.88%", [--], anchor: "south", angle: 180deg)

      content("genline.12%", [--], anchor: "south")
      content("genline.12%", [--], anchor: "south", angle: 180deg)

      // Муфта между генератором и верхней шестерней
      polygon("genline.50%", 4, radius: 0.1 / calc.sqrt(2), angle: 45deg, fill: white, stroke: white)
      content("genline.50%", [--], anchor: "south", padding: -.05, angle:  90deg)
      content("genline.50%", [--], anchor: "south", padding: -.05, angle: -90deg)

      // Муфта между компрессором и нижней шестерней
      polygon("d1.30%", 4, radius: 0.1 / calc.sqrt(2), angle: 45deg, fill: white, stroke: white)
      content("d1.30%", [--], anchor: "south", padding: -.05, angle:  90deg)
      content("d1.30%", [--], anchor: "south", padding: -.05, angle: -90deg)

      polygon("d1.70%", 4, radius: 0.1 / calc.sqrt(2), angle: 45deg, fill: white, stroke: white)
      content("d1.70%", [--], anchor: "south", padding: -.05, angle:  90deg)
      content("d1.70%", [--], anchor: "south", padding: -.05, angle: -90deg)

      // Номера
      content(name: "n1", (11,0.5), $1$,padding:0.1)
      content(name: "n2", (7 ,0.5), $2$,padding:0.1)
      content(name: "n5", (5 ,0.5), $5$,padding:0.1)
      content(name: "n3", (2 ,-2 ), $3$,padding:0.1)
      content(name: "n4", (5 ,-2 ), $4$,padding:0.1)
      content(name: "n6", (2 , 1 ), $6$,padding:0.1)
      content(name: "n7", (1 , 1 ), $7$,padding:0.1)
      line(stroke:gray,"n7","gen")
      line(stroke:gray,"n6","genline")
      line(stroke:gray,"n5","w2")
      line(stroke:gray,"n4","d1")
      line(stroke:gray,"n3","d0")
      line(stroke:gray,"n2","t1")
      line(stroke:gray,"n1","t2")
    })
    text(12pt)[1 --- газовая турбина, 2 --- компрессор, 3 --- подшипник, 4 --- пластинчатая муфта, 5 --- понижающий редуктор, 6 --- зубчатая муфта, 7 --- турбогенератор ]
    },
  caption: [Принципиальная кинематическая схема проектируемой установки]
) <bob-moment>

=== Муфты в ГТУ

Муфта --- это механическое устройство, предназначенное для соединения валов с целью передачи крутящего момента и энергии.

В проектируемой установке используется два типа муфт:
+ Пластинчатая муфта применяется при соединении вала турбогруппы с ведущим валом редуктора. Она представляет из себя упругую муфту, состоящую из двух полумуфт и промежуточной вставки с пакетами гибких пластин из пружинной стали. Её использование обусловлено необходимостью гасить относительно большие радиальности, угловые и осевые несоосности валов, возникающие на валу турбогруппы в процессе работы ГТУ.
+ Зубчатая муфта применяется при соединении ведомого вала редуктора с валом турбогенератора. Она представляет из себя жесткую муфту, состоящую из двух полумуфт с внешними зубьями и обоймы с внутренними зубьями, соединяющей их. Её использование обусловлено большей жесткостью и КПД, чем у пластинчатой, при более мягком режиме работы.

=== Редуктор

Так как скорость вращения вала турбогруппы ($5441$ об/мин) не совпадает со скоростью вращения вала синхронного генератора ($3000$ об/мин), в установке необходимо применение редуктора.

Для проектируемой установки используется одноступенчатый редуктор со следующими характеристиками:
- Шевронный тип зацепления;
- Максимальная передаваемая мощность #zMW(80)\;
- КПД передачи 98%;
- Масса редуктора и соединительных муфт #zT(16.5)\;
- Корпус и рама сварные;
- Зубчатые колёса изготовлены из стали 36Х2Н2МФА с азотированным зубом модуля 10.

В редукторе применяются подшипники с баббитовой наплавкой, система маслоснабжения общая с турбогруппой. На крышке редуктора установлено вертикальное валоповоротное устройство, которое позволяет вращать одновременно весь валопровод ГТУ электроприроводом с частотой вращения #zrpm(6.7).

== Электрогенератор

Электрогенератор в ГТУ (трурбогенератор) служит для преобразования энергии вращения вала установки в электрическую энергию, отдаваемую в электрическую сеть. Так как такие генераторы являются синхронными машинами, скорость вращения вала в них соответствует частоте сети #zHz(50) @KVOU.

В проектируемой установке применяется турбогенератор Т3ФГ-65-2М производства "Электросилы" с активной мощностью #zMW(70), конструкция которого изображена на @bob-gen. Место установки --- перед компрессором.
#figure(
  image("assets/bob/gen.jpg", width: 80%),
  caption: [Турбогенератор Т3ФГ-80-2]
) <bob-gen>

Примененная в турбогенераторах типа Т3Ф система вентиляции позволяет осуществить при минимальных потерях мощности подачу холодного воздуха от воздухоохладителей ко всем активным частям машины по многопараллельной вытяжной схеме.

Для отвода выделяющихся потерь применено непосредственное воздушное охлаждение обмотки ротора и сердечника статора и косвенное --- обмотки статора. Механические потери, выделяемые в подшипниках, отводятся с помощью масла.         

Для охлаждения воздуха в корпус турбогенератора встроены воздухоохладители, по которым с помощью насосов, установленных вне турбогенератора, циркулирует вода.

= Оптимальный радиальный зазор в системе последняя ступень-диффузор

Выходной диффузор ГТУ позволяет существенно повысить КПД и мощность установки за счет поддержания статического давления за турбиной ниже атмосферного. Эффект достигается благодаря восстановлению давления при диффузорном движении, благодаря чему статическое давление на входе в диффузор меньше, чем на выходе.

Скорость этого восстановления по мере длины диффузора тем выше, чем больше его угол раскрытия. При осевом выходе потока из последней ступени турбины, этот угол ограничен значением $ gamma approx 15 degree (2gamma approx 30 degree)$, поскольку при более высоких значениях происходит отрыв потока от стенок диффузора, что не позволяет эффективно использовать его геометрию для восстановления давления.

Однако, поток на выходе из последней ступени не является однородным и имеет сложную, зависящую от радиуса структуру с ненулевыми окружными составляющими, чем обуславливается необходимость проектировать систему "последняя ступень --- диффузор" совместно, а не по отдельности. Одним из эффектов, учёт которых представляет интерес, является течение рабочего тела из зазора над рабочей лопаткой последней ступени у стенки диффузора. Поток в этом зазоре, с одной стороны, уменьшает КПД последней ступени турбины, так как не попадает в межлопаточные каналы рабочих лопаток, но в то же время может повысить этот КПД системы "последняя ступень --- диффузор" за счет поддержания более низкого статического давления на входе в диффузор за счет большего угла раскрытия диффузора @SpecEng.

== Описание эффекта <spec-2>

Причиной отрыва потока от стенки диффузора является недостаточное давление и скорость частиц в пристеночном слое. Минуя рабочие лопатки, поток из зазора сохраняет большее полное и статическое давление, а также скорость. После прохождения соплового аппарата поток рабочего тела имеет закрутку, которая выражается в наличии окружной составляющей скорости. При прохождении через межлопаточные каналы рабочих лопаток эта составляющая по большей части срабатывается на обеспечение вращения ротора установки, тогда как у части потока, минующей рабочую лопатку через зазор над ней и прилегающей к стенке диффузора винтовое течение сохраняется @SpecRus. На @spec-swirl изображено описанное течение на стенке диффузора.

#figure(
  {
    image("assets/spec/cone.svg")
    text(12pt)[ Последняя ступень турбины и диффузор условно разнесены. Рабочие лопатки условно показаны жёлтым диском, рассматриваемый зазор $delta$ выделен голубыми секторами, винтовое течение у стенки диффузора показано голубыми линиями.]
  },
  caption: [Изображение винтового течения у стенки диффузора]
) <spec-swirl>

Благодаря окружной составляющей скорости на прошедшую через зазор внешнюю часть потока со со стороны стенки диффузора действует центростремительная сила, которая повышает давление в этом потоке и противодействует его отрыву от стенки. Это позволяет увеличивать угол раскрытия диффузора $gamma$. На @spec-sector изображено распределение окружной скорости за последней ступенью турбины по радиусу при применении обратного закона закрутки и оптимальным радиальным зазором $delta_"opt"$.

#figure(
  {
    cetz.canvas({
      import cetz.draw: *

      let r-in = 4.0
      let r-out = 7.0
      let start-a = 60deg
      let end-a = 120deg
      let mid-a = 90deg

      // 1. Рисуем границы сектора (дуги и боковые линии)
      arc((0, 0), start: start-a, stop: end-a, radius: r-in, stroke: luma(150) + 1pt, anchor: "origin")
      arc(name:"top",(0, 0), start: start-a, stop: end-a, radius: r-out, stroke: luma(150) + 1pt, anchor: "origin")

      hide(arc(name: "hole",(0, 0), start: start-a - 20deg, stop: end-a + 20deg, radius: r-out * 0.96, anchor: "origin"))
    
      // Соединяем дуги радиальными линиями по краям
      cetz.decorations.wave( name: "lspit",
        line((start-a, r-in), (start-a, r-out)),
        amplitude: .45, segments: 1, stroke: luma(150) + 1pt
      )
      cetz.decorations.wave( name: "rspit",
        line((end-a, r-in), (end-a, r-out)),
        amplitude: .45, segments: 1, stroke: luma(150) + 1pt
      )

      intersections("i", "rspit", "lspit", "hole")
      arc-through(name: "hole-vis", "i.1", (0, r-out * 0.96), "i.0", stroke: (dash: "dashed", paint: luma(150)))

      line(name: "holemark", "hole-vis.5%", "top.3%", mark:(symbol:"stealth", fill: black, reverse:true, anchor: "base")
      )
      content("holemark.end", $delta$, anchor: "south-west", padding: 6pt)

      // 2. Координаты
      line(name: "rline", (mid-a, r-in - 0.6), (mid-a, r-out + 1.6), stroke: (paint: black), mark:(end:"stealth", fill: black))

      arc(name: "uline", (0,0), radius: r-out+0.6,start: 70deg, delta: 40deg, anchor: "origin", mark:(start:"stealth", fill: black))

      content("rline.end", $r$, anchor:"west", padding: 0.1)
      content("uline.start", $u$, anchor:"west", padding: 0.1)

      catmull(
        (mid-a,r-in),
        (mid-a+5deg, r-in+0.2),
        (mid-a,(r-in+r-out)/2),
        (mid-a -5deg, r-out -0.4),
        (mid-a -15deg, r-out -0.0),
        (mid-a,r-out),
        stroke: blue + 2pt
      )
    
      // 3. Точки
      circle((mid-a, r-in), radius: 0.1, fill: red, stroke: none)
      circle((mid-a, r-out), radius: 0.1, fill: red, stroke: none)
    })
    text(12pt)[Пунктирной дугой показана линия высоты рабочих лопаток]
  },
  caption: [Профиль окружной скорости за рабочими лопатками последней ступени турбины по радиальному направлению]
) <spec-sector>

Оценка газодинамических качеств диффузора производится с помощью коэффициента восстановления давления:

$ C_p = ( p_"out" - p_2 )/ frac(rho_2 c_2^2, 2, style: "horizontal"), $

#noind где $p_2, rho_2, c_2$ --- значения давления, плотности и скорости на входе в диффузор;\
#hide[где] $p_"out"$ --- среднее значение давления на выходе из диффузора.

При повышении угла раскрытия выходного диффузора при его неизменной длине повышается отношение его входной и выходной площади, что ведёт к росту коэффициента восстановления давления:

$ C_p = 1 - 1/( frac(A_"out", A_"in", style: "horizontal"))^2, $

#noind где $A_"in"$, $A_"out"$ --- площади живого сечения диффузора на входе и на выходе.

За счет повышения коэффициента восстановления давления выходного диффузора при неизменном давлении на выходе из него $p_"out"$ понижается входное давление $p_2$. Так как это давление является давлением на выходе из последней ступени турбины, его понижение повышает мощность и КПД системы "последняя ступень --- диффузор". Однако, как упоминалось ранее, та часть потока, которая ответственна за описываемый эффект, минует межлопаточный канал рабочих лопаток, чем вызывает снижение мощности и КПД системы последняя ступень-диффузор и повышение потерь с выходной скоростью. Балансом между этими факторами обусловлено существование оптимального зазора, при котором мощность и КПД системы "последняя ступень --- диффузор" будут максимальными.

Этот эффект усиливается применением обратного закона закрутки потока при профилировании рабочих лопаток последней ступени, поскольку такой закон обеспечивает повышение давления с ростом радиуса сечения.

== Экспериментальное исследование

Лабораторией Турбиностроения имени И. И. Кириллова СПбПУ были проведены экспериментальные исследования с целью определения оптимального зазора над рабочей лопаткой последней ступени $delta_"opt"$. Эти эксперименты показали существование такой величины зазора для обандаженного рабочего колеса модельной турбины с развитым осевым диффузором.

Исследования были проведены на модели "бандажированная турбинная ступень --- осевой диффузор" газовой турбины мощностью #zMW(1000), выполненной в масштабе 1:8.53 и установленной на экспериментальном стенде ЭТ-4 в лаборатории Турбиностроения. Радиальный зазор регулируется с помощью сменного дистанционного кольца. Эскиз стенда показан на @spec-model.

#figure(
  {
    image("assets/spec/model.png")
    text(12pt)[
      1 --- сопловой аппарат; 2 --- рабочие бандажированные лопатки; 3 --- силовые стойки; 4 --- кольцевой диффузор; 5 --- конический диффузор; 6 --- хонейкомб; 7 --- гидротормоз; 8 --- ротор; 9 --- дистанционное кольцо. 
    ]
  },
  caption: [Продольный разрез стенда ЭТ-4 лаборатории Турбиностроения им. И. И. Кириллова СПбПУ с исследуемой моделью блока "бандажированная турбинная ступень --- осевой диффузор" @SpecRus]
) <spec-model>

В дополнение к эксперименту было проведено численное моделирование в Ansys CFX.

На @spec-result показаны результаты эксперимента и численного моделирования в сравнении с идеальным диффузором. Из графика виден тренд на увеличение коэффициента восстановления диффузора с ростом величины радиального зазора. Однако, максимум КПД модельной установки в силу рассмотренных в @spec-2 достигается не при максимальном исследованном радиальном зазоре, а при зазоре $delta = #zmm(0.62)$, что видно из графика на @spec-KPD. На @spec-pressure показаны экспериментально измеренные распределения полного и статического давления по высоте канала перед диффузором. Показано, что с ростом зазора статическое и полное давления у периферии канала увеличиваются, что и обеспечивает эффект.

#figure(
  lq.diagram(
    legend: (inset:10pt, position: bottom + right),
    height: 9cm, ylim: (0, 1), xlim: (0, 1),
    xaxis: (subticks: 1), yaxis: (subticks: none),
    xlabel: text(12pt)[Относительная длина диффузора], ylabel: $C_p$,
    grid: (stroke-sub: 0.1pt),
    
    lq.plot(label:[Идеальный диффузор], color:black, mark:none, stroke: (thickness:2pt, cap: "round"), (0, 0.1),(0, 0.6)
    ),
    lq.plot(color: black, mark:none, stroke: (thickness:2pt, cap: "round"), (0.1, 0.24, 1),(0.78, 0.78, 0.96)
    ),

    lq.plot(label: [CFX $0.35$], color: olive,
      stroke: 1.5pt, smooth: true, mark-size: 5pt, mark: "s",
      (0,0.1,0.4,1),(0,0.35,0.61,0.76)
    ),
    lq.plot(label: [CFX $0.62$], color: blue,
      stroke: 1.5pt, smooth: true, mark-size: 5pt, mark: "^",
      (0,0.1,0.4,1),(0,0.33,0.63,0.785)
    ),
    lq.plot(label: [CFX $1.64$], color: red,
      stroke: 1.5pt, smooth: true, mark-size: 5pt, mark: "d",
      (0,0.1,0.4,1),(0,0.4,0.66,0.8)
    ),

    lq.plot(label: [Эксперимент $0.35$], color: olive,
      stroke: (dash: "loosely-dashed", thickness: 1.5pt),
      smooth: true,
      mark: none,
      (0, 0.07, 0.095, 0.135, 0.2,  0.25, 0.325,  0.4,  1),
      (0, 0.3,  0.4,   0.45,  0.52, 0.54, 0.59,    0.64, 0.76)
    ),
    lq.plot(label: [Эксперимент $0.62$], color: blue,
      stroke: (dash: "loosely-dashed", thickness: 1.5pt), smooth: true,
      mark: none,
      (0, 0.06, 0.1,  0.2,  0.25, 0.4,  1),
      (0, 0.3,  0.46, 0.56, 0.58, 0.66, 0.775)
    ),
    lq.plot(label: [Эксперимент $1.64$], color: red,
      stroke: (dash: "loosely-dashed", thickness: 1.5pt), smooth: true,
      mark: none,
      (0, 0.1,  0.2,  0.3,   0.4,  1),
      (0, 0.53, 0.61, 0.635, 0.68, 0.795)
    ),
    
  ),
  caption: [
  Изменение коэффициента восстановления статического давления по длине диффузора в зависимости от величины радиального зазора по результатам эксперимента и численного моделирования
  ]
) <spec-result>

#undo-line()

#figure(
  {
    lq.diagram(
      legend: (inset:5pt, position: horizon, dx: 20%, dy: 15%),
      height: 7cm, xaxis: (subticks: 1), yaxis: (subticks: 0),
      xlabel: text(12pt)[$delta,$ мм], ylabel: $eta, eta^*, eta_(+д), eta^*_(+д)$,
      grid: (stroke-sub: 0.1pt),
    
      lq.plot(label: $eta$,
        stroke: 1.5pt, smooth: true, mark-size: 5pt, mark: "d",
        (0.35, 0.62, 0.84, 1.64),(0.748, 0.766, 0.755, 0.73)
      ),
      lq.plot(label: $eta^*$,
        stroke: 1.5pt, smooth: true, mark-size: 5pt, mark: "s",
        (0.35, 0.62, 0.84, 1.64),(0.885, 0.912, 0.906, 0.87)
      ),
      lq.plot(label: $eta_(+д)$,
        stroke: 1.5pt, smooth: true, mark-size: 5pt, mark: "^",
        (0.35, 0.62, 0.84, 1.64),(0.846, 0.875, 0.862, 0.835)
      ),
      lq.plot(label: $eta^*_(+д)$,
        stroke: 1.5pt, smooth: true, mark-size: 5pt, mark: "o",
        (0.35, 0.62, 0.84, 1.64),(0.856, 0.885, 0.872, 0.845)
      ),
      lq.place(0.42, 0.77, rotate(-30deg, text(size: 10pt, box(radius:3pt, fill:white, inset:2pt, $alpha_2 = 91.3 degree$)))),
      lq.place(0.69, 0.79, rotate(-30deg, text(size: 10pt, box(radius:3pt, fill:white, inset:2pt, $alpha_2 = 91.0 degree$)))),
      lq.place(0.91, 0.78, rotate(-30deg, text(size: 10pt, box(radius:3pt, fill:white, inset:2pt, $alpha_2 = 91.6 degree$)))),
      lq.place(1.6, 0.77, rotate(-30deg, text(size: 10pt, box(radius:3pt, fill:white, inset:2pt, $alpha_2 = 92.0 degree$)))),
    )
    text(12pt)[$eta, eta^*$ --- КПД последней ступени турбины, $eta_(+д), eta^*_(+д)$ --- КПД системы "последняя ступень-диффузор"]
  },
  caption: [Зависимость КПД ступени и КПД системы "последняя ступень-диффузор" от величины радиального зазора]
) <spec-KPD>

#figure(
  {
    lq.diagram(
      legend: (position: right),
      height: 9cm, ylim: (0, 1), xlim: (0.88, 1.1),
      xaxis: (subticks: 1), yaxis: (subticks: none),
      xlabel:text(12pt)[Относительная длина диффузора], ylabel:$C_p$,
      grid: (stroke-sub: 0.1pt),
    
      lq.plot(label: $delta = 0.35$, color: red, clip: false,
        stroke: 1pt, smooth: true,
        mark-size: 4pt, mark: "s",
        (0.897, 0.905, 0.913, 0.9135, 0.911, 0.9097, 0.9096, 0.911, 0.9133, 0.913, 0.913, 0.915, 0.917, 0.917, 0.9168, 0.917, 0.913, 0.901),
        (0,     0.02,  0.04,  0.055,  0.077, 0.1,    0.154,  0.196, 0.435, 0.49,  0.567, 0.725,  0.81,  0.895, 0.938,  0.958, 0.983, 1)
      ),
      lq.plot(label: $delta=0.62$, color: olive, clip: false,
        stroke: 1pt, smooth: true,
        mark-size: 4pt, mark: "^",
        (0.914, 0.916, 0.9189, 0.9123, 0.9087, 0.9094, 0.9078, 0.909, 0.9095, 0.911, 0.9125, 0.9137, 0.9157, 0.9178, 0.918, 0.918, 0.923, 0.924),
        (0,     0.02,  0.04,   0.055,  0.077,  0.1,    0.1525, 0.197, 0.435,  0.49,  0.567, 0.725,  0.81,  0.895, 0.938,  0.958, 0.983, 1)
      ),
      lq.plot(label: $delta=0.88$, color: black, clip: false,
        stroke: 1pt, smooth: true,
        mark-size: 4pt, mark: "a6",
        (0.913, 0.9156, 0.9183, 0.908, 0.907, 0.9056, 0.904, 0.9056, 0.9059, 0.9068, 0.9083, 0.912, 0.913, 0.912, 0.910, 0.911, 0.913, 0.9185),
        (0,     0.02,  0.04,  0.055,  0.077, 0.1,    0.154,  0.196, 0.435, 0.49,  0.567, 0.725,  0.81,  0.895, 0.938,  0.958, 0.983, 1)
      ),
      lq.plot(label: $delta=1.64$, color: blue, clip: false,
        stroke: 1pt, smooth: true,
        mark-size: 4pt, mark: "d",
        (0.9157, 0.9165, 0.9177, 0.9186, 0.916, 0.9139, 0.9146, 0.9157, 0.916, 0.916, 0.9172, 0.9188, 0.9194, 0.919, 0.9215, 0.923, 0.9254, 0.923),
        (0,     0.02,  0.04,  0.055,  0.077, 0.1,    0.154,  0.196, 0.435, 0.49,  0.567, 0.725,  0.81,  0.895, 0.938,  0.958, 0.983, 1)
      ),

      lq.plot(color: red, clip: false,
        stroke: (thickness:1pt, dash: "dashed"), smooth: true,
        mark-size: 4pt, mark: "s",
        (0.897, 0.963, 1.029, 1.038, 1.035, 1.035, 1.040, 1.034, 1.005, 1.0, 0.996, 0.978, 0.972, 0.9657, 0.964, 0.963, 0.959, 0.901),
        (0,     0.02,  0.04,  0.055,  0.077, 0.1,    0.154,  0.196, 0.435, 0.49,  0.567, 0.725,  0.81,  0.895, 0.938,  0.958, 0.983, 1)
      ),
      lq.plot(color: olive, clip: false,
        stroke: (thickness:1pt, dash: "dashed"), smooth: true,
        mark-size: 4pt, mark: "^",
        (0.914, 0.959, 1.005, 1.025, 1.029, 1.031, 1.031, 1.023, 1.003, 1.0003, 0.997, 0.986, 0.9815, 0.968, 0.9642, 0.969, 0.965, 0.924),
        (0,     0.02,  0.04,  0.055,  0.077, 0.1,    0.154,  0.196, 0.435, 0.49,  0.567, 0.725,  0.81,  0.895, 0.938,  0.958, 0.983, 1)
      ),
      lq.plot(color: black, clip: false,
        stroke: (thickness:1pt, dash: "dashed"), smooth: true,
        mark-size: 4pt, mark: "a6",
        (0.913, 0.957, 1.002, 1.029, 1.030, 1.032, 1.034, 1.030, 1.006, 0.999, 0.994, 0.981, 0.973, 0.956, 0.954, 0.973, 0.987, 0.9185),
        (0,     0.02,  0.04,  0.055,  0.077, 0.1,    0.154,  0.196, 0.435, 0.49,  0.567, 0.725,  0.81,  0.895, 0.938,  0.958, 0.983, 1)
      ),
      lq.plot(color: blue, clip: false,
        stroke: (thickness:1pt, dash: "dashed"), smooth: true,
        mark-size: 4pt, mark: "d",
        (0.9157, 0.968, 1.021, 1.023, 1.0225, 1.026, 1.024, 1.016, 0.995, 0.991, 0.988, 0.982, 0.977, 0.974, 1.008, 1.038, 1.0865, 0.923),
        (0,     0.02,  0.04,  0.055,  0.077, 0.1,    0.154,  0.196, 0.435, 0.49,  0.567, 0.725,  0.81,  0.895, 0.938,  0.958, 0.983, 1)
      ),
    )
    text(12pt)[Сплошными линиями показано статическое давление, пунктирными --- полное давление]
  },
  caption: [Распределения относительных полного $dash(p)^*=frac(p^*,hat(p)^*, style: "horizontal")$ и статического $dash(p)=frac(p,hat(p), style: "horizontal")$ давлений по высоте канала на входе в диффузор (сечение 2-2)]
) <spec-pressure>

Таким образом, обосновано и экспериментально показано существование отличного от минимального оптимального радиального зазора в системе "последняя ступень-диффузор". Применение этого оптимального зазора позволит повысить КПД установки, а также минимизировать риск задевания уплотнений в зазоре над последней ступенью турбины.

#centred-heading("Заключение")

В ходе выполнения выпускной квалификационной работы была спроектирована газотурбинная установка мощностью #zMW(65).

В процессе проектирования решены следующие задачи:
+ Выполнен расчет тепловой схемы ГТУ и выбраны оптимальные параметры;
+ Выполнен приближенный расчет компрессора;
+ Выполнен приближенный расчет камеры сгорания;
+ Выполнен аналитический расчет турбины по среднему сечению;
+ Выполнена оптимизация и профилирование последней ступени турбины с использованием обратного закона закрутки потока;
+ Выполнен газодинамический расчет последней ступени турбины с помощью Ansys CFX;
+ Обеспечена и с помощью Ansys Mechanical численно обоснована статическая и вибрационная прочность рабочей лопатки и диска последней ступени турбины;
+ Обеспечена и с помощью Ansys Mechanical численно обоснована вибрационная прочность ротора установки;
+ Выбрана конструкция основных деталей и узлов ГТУ;
+ Выполнен анализ влияния радиального зазора в последней ступени турбины на КПД системы “последняя ступень-диффузор”.

#bibliography(
  "ref.yml",
  style: "gost-r-705-2008-numeric",
  title: "Список использованных источников",
)

#show: appendix

= ПРИЛОЖЕНИЕ Б. Результаты расчета параметров рабочего процесса ГТУ с помощью A2GTP

#let printA2GTP(file) = align(center)[
  #block(align(left, text(size: 9pt, font: "JetBrainsMono NF")[
    #set par(first-line-indent: 0pt)
    #for line in file.split("\n").slice(1, 47) [#line \ ]
    #colbreak()
    #for line in file.split("\n").slice(48, 95) [#line \ ]
  ]))
  #pagebreak(weak: true)
]

1) $T_3^* = #zK(1443)$:
#printA2GTP(read("A2GTP/data1.txt"))

2) $T_3^* = #zK(1493)$:
#printA2GTP(read("A2GTP/data2.txt"))

3) $T_3^* = #zK(1543)$:
#printA2GTP(read("A2GTP/data3.txt"))

4) $T_3^* = #zK(1593)$:
#printA2GTP(read("A2GTP/data4.txt"))

5) $T_3^* = #zK(1643)$:
#printA2GTP(read("A2GTP/data5.txt"))

// #set page(paper: "a4", flipped: true)

= Приложение Б. Эскиз проектируемой установки

#figure(
  image("assets/bob/Cut-1.png", width: 80%)
)

#figure(
  image("assets/bob/Cut-2.png", width: 80%)
)
