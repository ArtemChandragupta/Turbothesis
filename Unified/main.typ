#import "template.typ": *
#import "vars.typ": *

#show: conf

#centred-heading("Реферат")

#context counter(page).final().at(0) страниц, рисунков, таблиц, источников, приложений.

#upper[
  Ключевые слова: газотурбинная установка, осевой компрессор, камера сгорания, турбина, рабочая лопатка, сопловая лопатка, прототип гтэ-65, диффузор
]

Тема выпускной квалификационной работы: "Газотурбинная установка мощностью 65 МВт".

Целью данной работы является проектирование газотурбинной установки мощностью 65 МВт на основе прототипа ГТЭ-65.

Задачи, решенные в ходе выполнения работы:

#centred-heading("Abstract")

#context counter(page).final().at(0) pages,

#upper[
  keywords: gas-turbine, axial compressor, combustion chamber, turbine, diffuser
]

#outline(title: [*СОДЕРЖАНИЕ*])

#centred-heading("Обозначения и сокращения")

В настоящей работе использованы следующие обозначения и сокращения:

ГТУ --- газотурбинная установка;

ОК --- осевой компрессор;

КС --- камера сгорания;

КВОУ --- комплексное воздухоочистное устройство;

КПД --- коэффициент полезного действия;

РК --- рабочее колесо;

РЛ --- рабочая лопатка;

СА --- сопловой аппарат;

СЛ --- споловая лопатка.

#centred-heading("Введение")

В современной энергетике газотурбинные установки (ГТУ) играют важную роль, обеспечивая надежное и эффективное производство электроэнергии. ГТУ обладают рядом преимуществ, таких как высокая мощность, быстрый запуск, возможность работы в различных климатических условиях и относительно низкие эксплуатационные затраты. Эти установки широко используются в качестве основных и резервных источников энергии, а также для балансировки энергосистем, особенно в условиях роста доли возобновляемых источников энергии.

Одной из наиболее перспективных разработок в области газотурбинных установок является ГТЭ-65 --- газовая турбина мощностью 65 МВт, разработанная российскими инженерами. ГТЭ-65 представляет собой современную турбину, которая сочетает в себе высокую эффективность, надежность и экологичность. На данный момент ГТЭ-65 находится на стадии активной разработки и тестирования, что делает её перспективной для внедрения в энергетические системы различных регионов.

Целью данной курсовой работы является создание газовой турбины мощностью 65 МВт на основе ГТЭ-65. В рамках работы будут рассмотрены основные технические характеристики ГТЭ-65, анализированы её преимущества и недостатки, а также предложены пути оптимизации и улучшения конструкции для достижения заявленной мощности.

Актуальность данной работы обусловлена растущей потребностью в надежных и эффективных источниках энергии. В условиях глобального энергетического перехода и увеличения доли возобновляемых источников энергии, газотурбинные установки, такие как ГТЭ-65, становятся важным элементом энергетической инфраструктуры. Они обеспечивают стабильность энергосистем, позволяют быстро реагировать на изменения спроса и покрывать пиковые нагрузки. Кроме того, разработка и внедрение отечественных технологий в области ГТУ способствует укреплению энергетической независимости и повышению конкурентоспособности национальной энергетики.

Таким образом, создание газовой турбины мощностью 65 МВт на основе ГТЭ-65 является важной задачей, решение которой позволит удовлетворить потребности современной энергетики и обеспечить устойчивое развитие энергетической инфраструктуры.

= Обзор конструкции газовых турбин

== е

= Выбор оптимальных параметров цикла

== Исходные данные для расчета тепловой схемы

// + Полезная мощность $N = num(TAN) "Вт" $;
+ Температура газа перед турбиной $T_3^* = TATs3 "K;"$
// + Параметры наружного воздуха $P_н = num(TAPₙ) "Па" $, $T_н = TATₙ "K;" $
+ Топливо --- природный газ;
+ Прототип установки --- ГТЭ-65, изображен в приложении Б;
+ Частота вращения вала ГТУ --- $n = TAn "об/мин" $;

Примем два упрощения при расчете в разделе 1:
+ Охлаждение турбины не учитывается, расход охладителя равен нулю.
// + Не учитывается зависимость теплоемкости газа от температуры рабочего тела, принимается по рекомендациям пособия @PERV;

== Схема газотурбинной установки

Рассматриваемая установка является одновальной ГТУ простого типа, тепловая схема такой установки изображена на @HeatScheme[рисунке], цикл --- на @HeatGraph[рисунке].

#figure(
  {
    diagram(
      node-stroke: 1.5pt,
      let inset-turb = 30pt,
      let radius-ks = 13pt,

      node( (0,1), $~$, shape:circle),
      edge(),
      node( (1,1), [К], name: <K>, shape: trapezium.with(dir: right, fit:1), inset:inset-turb ),
      edge(),
      node( (4,1), [Т], name: <T>, shape: trapezium.with(dir: left, fit:1), inset:inset-turb ),

      node( (2.5,0.0), h(2 * radius-ks), name:<KS-main>, shape:circle, inset:0pt ),
      node(shape:rect, enclose:((2.5,0.0),), circle(radius:radius-ks, stroke:none), inset:0pt),
      
      node( (1,1), name: <KK>, text(rgb(0,0,0,0%))[К], shape:rect, stroke:none, inset:inset-turb ),
      node( (4,1), name: <TT>, text(rgb(0,0,0,0%))[T], shape:rect, stroke:none, inset:inset-turb ),
    
      edge(<KK.north-east>, <KS-main.west>, corner:right, "-|>", label:$2$, label-pos: 55%),
      edge(<KS-main.east>, <TT.north-west>, corner:right, "-|>", label:$3$, label-pos: 45%),
      edge(<K.south-west>, "d","<|-", label:$1$),
      edge(<T.south-east>, "d","-|>", label:$4$),
      edge(<KS-main.north-east>, <KS-main.south-west>),
      edge(<KS-main.north-west>, <KS-main.south-east>),
      edge(<KS-main>,"u","<|-", label: "Топливо", label-pos:100%,label-side:center),

      node((2.5,0.3),[КС], stroke:none)
    )
    
    text(size:12pt)[\ К --- компрессор, КС --- камера сгорания, Т --- газовая турбина]
  },
  caption: [Тепловая схема одновальной ГТУ]
) <HeatScheme>

#figure(
  {
    show lq.selector(lq.label): set align(top + right)
    lq.diagram(
      width: 15cm, height:10cm, legend: (position: bottom + right),
      ylabel: $T$, xlabel: $S$,
      xaxis: (format-ticks: none), yaxis: (format-ticks: none),
      cycle: (black,),

      let y1 = CTs1,
      let y2 = CTs1 * calc.pow(Aπsₖ, (COkₙ - 1)/COkₙ),
      let y3 = TATs3,
      let y4 = TTs2ₜ,
    
      let cc1 = 1 / calc.ln(y3/y2),
      let cc2 = 1 / calc.ln(y4/y1),
      let lx = lq.linspace(1, 2),

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

    )
    
    text(hyphenate: false, size:12pt)[\ 1-2 --- адиабатное сжатие в компрессоре, 2-3 --- изобарный подвод теплоты в камере сгорания, 3-4 --- адиабатное расширение продуктов сгорания на лопатках газовой турбины, 4-1 --- изобарный отвод теплоты от продуктов сгорания в атмосферу]
  },
  caption: [Цикл одновальной ГТУ простого типа в T-S-диаграмме]
) <HeatGraph>

== Предварительный расчет параметров газотурбинного цикла

== Вариантный расчет параметров газотурбинного двигателя на ЭВМ

Проведен расчет параметров рабочего процесса в характерных сечениях проточной части и основных характеристик ГТУ при различных значениях степени повышения давления $pi_к^*$ и температуры газа перед турбиной $T_3^*$, по результатам расчета построены графики: $H_e, eta_e, phi=f(pi_К^*, T_3^*)$.

== Результаты расчета

// Графики на рисунках @ne[], @phi[] и @He[] отражают результаты расчета. Полные результаты расчета смотреть в Приложении Б.

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

#show lq.selector(lq.label): set align(top + right)

#figure(
  lq.diagram(
    width: 15cm, height:10cm, legend: (position: bottom + right),
    ylabel: $eta_e$, xlabel: $pi_k^*$,
    cycle: (
      (color: red,    mark: "o"),
      (color: orange, mark: "^"),
      (color: green,  mark: "s"),
      (color: blue,   mark: "v"),
      (color: purple, mark: "d"),
    ),
    ..for i in range(csv_data.len()) {
      let Tt = 1443 + 50 * i
      (lq.plot(pik,KPD.at(i), stroke:1.5pt, mark-size: 5pt, smooth:true, label:$T_3^* = Tt "K "$),)
    }
  ),
  caption: [Зависимость эффективного КПД ГТУ от степени повышения давления в компрессоре, при различных значениях температуры]
) <ne>
// #figure(
//   lq.diagram(
//     width: 15cm, height:10cm, legend: (position: bottom),
//     ylabel: $H_e$, xlabel: $pi_k^*$,
//     cycle: (
//       (color: red,    mark: "o"),
//       (color: orange, mark: "^"),
//       (color: green,  mark: "s"),
//       (color: blue,   mark: "v"),
//       (color: purple, mark: "d"),
//     ),
//     ..for i in range(csv_data.len()) {
//       let Tt = 1443 + 50 * i
//       (lq.plot(pik,He.at(i), stroke:1.5pt, mark-size: 5pt, smooth:true, label:$T_3^* = Tt "K "$),)
//     }
//   ),
//   caption: [Зависимость эффективной удельной работы ГТУ от степени повышения давления в компрессоре, при различных значениях температуры]
// ) <phi>
// #figure(
//   lq.diagram(
//     width: 15cm, height:8cm,
//     ylabel: $phi$, xlabel: $pi_k^*$,
//     cycle: (
//       (color: red,    mark: "o"),
//       (color: orange, mark: "^"),
//       (color: green,  mark: "s"),
//       (color: blue,   mark: "v"),
//       (color: purple, mark: "d"),
//     ),
//     ..for i in range(csv_data.len()) {
//       let Tt = 1443 + 50 * i
//       (lq.plot(pik,Phi.at(i), stroke:1.5pt, mark-size: 5pt, smooth:true, label:$T_3^* = Tt "K "$),)
//     }
//   ),
//   caption: [Зависимость коэффициента полезной работы ГТУ от степени повышения давления в компрессоре, при различных значениях температуры]
// ) <He>

// == Определение оптимальных значений параметров цикла

// Максимальный КПД установки достигается при максимальной температуре газа перед турбиной – $ATs0 "K."$ Жаростойкость материала лопаток турбины позволяет выдерживать такую температуру, поэтому в качестве входной температуры на турбину выбрана именно эта температура. Экстремум графика зависимости эффективного КПД ГТУ от степени повышения давления в компрессоре наблюдается при $pi_к^* = 24 $ и $eta_e = 0.360 $. Выбор такой степени сжатия не оправдан, т. к. при нём слишком низкие значения эффективной удельной работы и коэффициента полезной работы. Экстремум графика зависимости эффективной удельной работы ГТУ от степени повышения давления в компрессоре наблюдается при $pi_к^* = Aπsₖ $, значение эффективного КПД ГТУ при этом $eta_e = 0.346 $. Коэффициент полезной работы ГТУ с увеличением степени повышения давления $pi_к^*$ монотонно уменьшается, однако уменьшение $pi_к^*$ с целью его увеличения нецелесообразно, поскольку величина коэффициента полезной работы ГТУ увеличивается незначительно, при этом снижается величина эффективного внутреннего КПД и эффективной удельной работы.

// Таким образом, для дальнейших расчетов принимаем:

// $T_3^* = ATs0 "K," pi_k^* = Aπsₖ. $

// = Газодинамический расчет компрессора

// Рассчет производится по методике Ю. С. Подбуева. Продольный разрез компрессора прототипа представлен на @comp-1.

// #figure(
//   image("assets/profiles.svg"),
//   caption: "Продольный разрез компрессора ГТЭ-65"
// ) <comp-1>

// == Газодинамический расчет осевого компрессора

// #figure(
//   image("assets/comp/COMP-full.png"),
//   caption: [Схема многоступенчатого осевого компрессора]
// ) <COMP-full>

// #figure(
//   image("assets/comp/COMP-lopatki2.png"),
//   caption: [Схема первой и последней ступеней компрессора]
// ) <COMP-lop>

// При приближенном расчете осевого компрессора основными расчетными сечениями являются: сечение 1-1 на входе в первую ступень и сечение 2-2 на выходе из последней ступени (@COMP-full[рис.]). Определим параметры $P$ и $T$ в этих двух сечениях:

// Давление воздуха в сечении 1-1:
// $ P_1^* = sigma_"вх"^* dot P_н = COσsᵢₙ dot TAPₙ = CPs1 "Па", $

// #noind где $sigma_"вх"^*$ --- #context box(baseline: 100% - measure([a]).height, [коэффициент уменьшения полного давления во входной части \ компрессора (принимаем $sigma_"вх"^*=COσsᵢₙ$).]) \ \

// Температура в сечении 1-1:
// $ T_1^* = T_н = CTs1 "K;" $

// Давление воздуха в сечении К-К:
// $ P_к^* = P_н dot pi_к^* = TAPₙ dot Aπsₖ = CPsₖ "Па", $

// #noind где $pi_k^*$ --- #context box(baseline: 100% - measure([a]).height, [степень повышения давления компрессора (из первичного расчета\ $pi_k^*=Aπsₖ$).]) \ \

// Давление в сечении 2-2:
// $ P_2^* = P_к^* / sigma_"вых"^* = CPsₖ / COσsₒᵤₜ = CPs2 "Па", $

// #noind где $sigma_"вых"^*$ --- #context box(baseline: 100% - measure([a]).height, [коэффициент уменьшения полного давления в выходной части \ компрессора (принимаем $sigma_"вых"^*=COσsₒᵤₜ$).]) \ \

// Значение плотностей:
// $ rho_1 = P^*_1 / (R_в dot T_1^*) = CPs1 / (CORₙ dot CTs1) = Cρ1 " кг/м"^3; $

// Примем КПД компрессора $eta_"ад"^* = 0.88$, тогда:
// $ rho_2 = rho_1 (P_2^* / P_1^*)^(1/n) = Cρ1 (CPs2 / CPs1)^(1/Cnₖ) = Cρ2 " кг/м"^3, $

// #noind где $n$ --- показатель политропы определяется из равенства:

// $
//   k_в / (k_в-1) dot eta_"ад"^* = n/(n-1) \
//   // COkₙ / (COkₙ - 1) dot COηₐ = n/(n-1) => n = Cnₖ;
// $

// Примем величины осевой составляющей абсолютных скоростей в сечениях 1-1 и 2-2 соответственно $C_(z_1) = COcᶻ1 "м/с" $ и $C_(z_2) = COcᶻ2 "м/с" $. Втулочное отношение выберем $nu_1 = D_"вт"_1 "/" D_"н"_1 = COν1 $. Расход воздуха $G_"в" = AGₙ "кг/с" $.

// Из уравнения расхода первой ступени выразим значение наружного диаметра на входе в компрессор:
// $ G_в &= rho_1 dot pi/4 dot (D^2_н_1 - D^2_"вт"_1) dot C_z_1 = rho_1 dot pi/4 dot ( 1 - nu_1^2) dot D^2_н_1 dot C_z_1, $

// #noind откуда,
// $ D_Н_1 &= sqrt( (4 G_в)/(rho_1 dot pi dot (1-nu_1^2) dot C_z_1) ) = \  &= sqrt( (4 dot AGₙ) / (Cρ1 dot pi dot (1-COν1^2) dot COcᶻ1 ) ) = CD1 " м"; $

// Диаметр втулки первой ступени:
// $ D_"вт"_1 = nu_1 dot D_Н_1 = COν1 dot CD1 = CDᵥₜ1 "м;" $

// #block(breakable: false)[Средний диаметр первой ступени:
// $ D_"ср"_1 = (D_Н_1 + D_"вт"_1)/2 = (CD1 + CDᵥₜ1)/2 = CDₘ1 "м;" $]

// Длина рабочей лопатки первой ступени:
// $ l_1 = (D_н_1 - D_"вт"_1)/2 = (CD1 - CDᵥₜ1)/2 = Cl1 "м;" $

// Размеры проходного сечения 2-2:
// $ F_2 = G_в / (C_z_2 dot rho_2) = AGₙ / (COcᶻ2 dot Cρ2) = CF2 " м"^2; $

// Принимаем в проточной части $D_"ср" = "const" $, тогда:
// $ nu_2 = (pi dot D_"ср"^2 - F_2) / (pi dot D_"ср"^2 + F) = (pi dot CDₘ1^2 - CF2)/(pi dot CDₘ1^2 + CF2) = Cν2; $

// Длина рабочей лопатки на последней ступени:
// $ l_2 &= (1-nu_2) sqrt(F_2/(pi (1 - nu_2^2))) = \ &= (1-Cν2) sqrt(CF2/(pi (1 - Cν2^2))) = Cl2 "м;" $

// Для обеспечения требуемой частоты вращения необходимо задать окружную скорость на наружном диаметре первой ступени $u_н_1 = Cuₙ1 "м/с" $, тогда:

// $ n = (60 dot u_н_1) / (pi dot D_н_1) = (60 dot Cuₙ1) / (pi dot CD1) = TAn "об/мин". $

// Таким образом, для соединения вала турбоагрегата с валом генератора необходимо использовать редуктор, понижающий обороты до $3000 "об/мин"$, передаточное отношение которого $Z = 3000 "/" TAn $.

// Адиабатический напор в проточной части компрессора по полным параметрам:

// $ H^*_"ад. пр. ч." &= k_в/(k_в-1) dot R_в dot T_1^* dot [ (P_2^* / P_1^*)^((k_в-1)/k_в)-1] = \ &= COkₙ/(COkₙ-1) dot CORₙ dot CTs1 dot [ (CPs2/CPs1)^( (COkₙ-1)/COkₙ ) ] = CHsₐ "Дж/кг"; $

// Приближенная величина теоретического напора или удельная работа, затрачиваемая на сжатие 1 кг воздуха:
// $ H_к^* = H^*_"ад. пр. ч." / eta^*_"ад" = CHsₐ / COηsₐ = CHsₖ "Дж/кг"; $

// Выберем средний теоретический напор $h_"ср" = COhₘ "Дж/кг" $.

// Число ступеней компрессора:
// $ i = ceil( H_к^* / h_"ср") = ceil(CHsₖ / COhₘ) = Ci; $

// Теоретический напор в первой ступени:
// $ h_1 = (0.6 dots 0.7) dot h_"ср" = COk1 dot COhₘ = Ch1 "Дж/кг"; $

// Теоретический напор в средних ступенях:
// $ h_"ср. ст." = (1.1 dots 1.2) dot h_"ср" = Ckₘ dot COhₘ = Ch2 "Дж/кг"; $

// #block(breakable: false)[Теоретический напор в последней ступени:
// $ h_п = (0.95 dots 1) dot h_"ср" = 1 dot COhₘ = COhₘ "Дж/кг"; $]

// Считая рост напора в ступенях от и его падение в ступенях линейным, изобразим распределение напора на @Ras[рисунке]:

// #figure(
//   text()[
//     #show: lq.cond-set(lq.grid.with(kind: "x"), stroke:none)
//     #show lq.selector(lq.label): set align(top + right)
  
//     #lq.diagram(
//       legend: (position: right + bottom),
//       width: 15cm, height: 8cm,
//       xlim: (0.1,16.9), ylim: (1.5e4,3.1e4),
//       xlabel: $i$,      ylabel: $h,"Дж/кг"$,
//       xaxis: (tick-distance:1, subticks:none,),

//       let h1 = RawCh1,
//       let h2 = RawCh2,
//       let hm = RawCOhₘ,

//       lq.bar(
//         (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16),
//         (
//           h1,
//           (h1 + (h2 - h1)*1/7),
//           (h1 + (h2 - h1)*2/7),
//           (h1 + (h2 - h1)*3/7),
//           (h1 + (h2 - h1)*4/7),
//           (h1 + (h2 - h1)*5/7),
//           (h1 + (h2 - h1)*6/7),
//           h2, h2, h2, h2, h2, h2, h2,
//           (h2 + hm)/2, hm
//         ), fill: aqua,
//       ),

//       lq.plot( (-1,17),(h2,h2), label: $h_"ср.ст."$, mark: none,
//         stroke:(dash:(10pt, 4pt), thickness:1.5pt, paint:olive)
//       ),
//       lq.plot( (-1,17),(hm,hm), label: $h_"ср"$, mark: none,
//         stroke:(dash:(10pt, 4pt), thickness:1.5pt, paint:red)
//       ),
//       lq.plot( (-1,17),(h1,h1), label: $h_1$, mark: none,
//         stroke:(dash:(10pt, 4pt), thickness:1.5pt, paint: fuchsia)
//       ),
//     )
//   ],
//   caption: [Распределение теоретического напора по ступеням компрессора]
// ) <Ras>

// В результате распределения напоров соблюдается условие:

// $ sum h_i = H_k^* = CHsₖ "Дж/кг". $

// Уточняем величину окружной скорости на среднем диаметре первой ступени:
// $ u_"ср"_1 = (pi dot D_"ср"_1 dot n)/60 = (pi dot CDₘ1 dot TAn)/60 = Cuₘ1 "м/c"; $

// Производим расчет первой ступени по среднему диаметру:

// #block(breakable: false)[Коэффициент расхода на среднем диаметре:
// $ phi = C_z_1 / u_"ср"_1 = COcᶻ1 / Cuₘ1 = CΦ1; $]

// Коэффициент теоретического напора:
// $ dash(h)_1 = h_1/u^2_"ср"_1 = Ch1 / Cuₘ1^2 = Ch̄1; $

// Отношение:
// $ dash(h)_1 / phi = Ch̄1 / CΦ1 = Cotn; $

// Зададим степень реактивности $Omega = COΩ $ и найдем:
// $ Omega / phi = COΩ / CΦ1 = Cotm; $

// По графику на @otn[рисунке] находим $(dash(h)_1/phi)_(b/t=1) = CP0ᵍ;$

// Коэффициент:
// $ J = ((dash(h)_1 / phi))  / (dash(h)_1/phi)_(b/t=1) = Cotn / CP0ᵍ = CJ; $

// Пользуясь графиком на @J[рисунке] определяем $b/t = 1/Ctb -> t/b = Ctb.$

// При постоянной вдоль радиуса хорде относительный шаг у втулки первой ступени:
// $ (t/b)_"вт" = t/b dot D_"вт"_1 / D_"ср"_1 = Ctb dot CDᵥₜ1/CDₘ1 = Ctbem. $

// #figure(
//   {
//     show lq.selector(lq.legend): set grid(row-gutter: 8pt)
//     lq.diagram(
//       legend: (inset:10pt),
//       width: 15cm, height: 9cm, ylim: (0.6, 0.87), xlim: (0, 1.5),
//       xlabel: $Omega"/"phi$, ylabel: $(dash(h)_1"/"phi)_(b/t=1)$,

//       let lx = lq.linspace(0.11, 1.368),

//       lq.plot(mark: none, stroke: 2pt,
//         lx, lx.map(lx => 0.935 - 0.777*lx + 0.503 * lx * lx)
//       ),
//       lq.plot(mark:none, stroke:(dash:(10pt, 4pt), thickness: 1.5pt),
//         (RawCotm,RawCotm),(0.6, RawCP0ᵍ), label: $Omega"/"phi = Cotm$
//       ),
//       lq.plot(mark:none, stroke:(dash:(10pt, 4pt), thickness: 1.5pt),
//         (0,RawCotm),(RawCP0ᵍ,RawCP0ᵍ), label: $(dash(h)_1 "/" phi)_(b/t=1)=CJ$
//       )
//     )
//   },
//   caption: [график зависимости $(dash(h)_1/phi)_(b/t=1)$ от $Omega/phi$]
// ) <otn>

// #figure(
//   lq.diagram(
//     width: 15cm, height: 9cm, ylim: (0.6, 1.7), xlim:(0.4,2),
//     xlabel: $b"/"t$, ylabel: $J$,

//     lq.plot(mark: none, stroke: 2pt,
//       (0.5, 0.551, 0.6  , 0.7  , 0.9 , 1, 1.279, 1.653, 1.886),
//       (0.6, 0.654, 0.697, 0.788, 0.94, 1, 1.194, 1.447, 1.595),
//     ),
//     lq.plot(mark:none, stroke: (dash: (10pt, 4pt), thickness: 2pt ),
//       (0.4,1/RawCtb),(RawCJ, RawCJ), label: $J = CJ$
//     ),
//     lq.plot(mark:none, stroke: (dash: (10pt, 4pt), thickness: 2pt ),
//       (1/RawCtb,1/RawCtb),(0,RawCJ), label: $b"/"t = #calc.round(digits: 4,1/RawCtb)$
//     )
//   ),
//   caption: [график зависимости коэффициента $J$ от густоты решетки]
// ) <J>

// Окружные скорости на входе и на выходе из рабочего колеса принимаем одинаковыми, т. е. $u_"ср"_1 = u_"ср"_2 = u = Cu "м/с" $.

// Проекция абсолютной скорости на окружное направление входной скорости на входе в рабочее колесо:
// $ C_u_1 &= u(1-Omega) - h_1/(2u) = \ &= Cu dot (1-COΩ) - Ch1 / (2 dot Cu) = Ccᵤ1 "м/с"; $

// На выходе из рабочего колеса:
// $ C_u_2 &= u(1-Omega) + h_1/(2u) = \ &= Cu dot (1-COΩ) + Ch1 / (2 dot Cu) = Ccᵤ2 "м/с"; $

// Абсолютная скорость на входе в рабочее колесо:
// $ C_1 = sqrt(C^2_z_1 + C^2_u_1) = sqrt( COcᶻ1^2 + COcᶻ2^2 ) = Cc1 "м/с"; $

// Угол наклона вектора абсолютной скорости на входе в рабочее колесо:
// $ a_1 = "arcctg" (C_u_1/C_z_1) = "arctg" ( Ccᵤ1/COcᶻ1 ) = Cα1 degree; $

// Температура воздуха перед рабочим колесом:
// $ T_1 = T_1^* - C_1^2 / (2 dot k_в/(k_в-1) dot R_в) = CTs1 - Cc1^2 / (2 dot COkₙ/(COkₙ-1) dot CORₙ) = CT1 "K"; $

// #block(breakable: false)[Проекция относительной скорости $W$ на окружное направление входной скорости на входе в рабочее колесо:
// $ W_u_1 = C_u_1 - u = Ccᵤ1 - Cu = Cwᵤ1 "м/с"; $]

// Относительная скорость на входе в колесо:
// $ W_1 = sqrt(C^2_z_1 + W^2_u_1) = sqrt(COcᶻ1^2 + (Cwᵤ1)^2) = Cw1 "м/с"; $

// Число Маха по относительной скорости на входе в рабочее колесо первой ступени:
// $ M_W_1 = W_1 / sqrt(k_в dot R_в dot T_1) = Cw1 / sqrt(COkₙ dot CORₙ dot CT1) = CMʷ1; $

// Наклон входной относительной скорости при отсчете от отрицательного направления оси $u$ характеризуется углом $beta$:
// $ beta_1 = "arcctg" (W_u_1/C_z_1) = "arcctg" (Cwᵤ1 / COcᶻ1) = Cβ1 degree; $

// Уменьшение осевой составляющей скорости в одной ступени:
// $ Delta C_z = (C_z_1 - C_z_2)/i = ( COcᶻ1 - COcᶻ2 )/Ci = CΔcᶻ "м/с"; $

// Осевая составляющая скорости на выходе из рабочего колеса первой ступени:
// $ C_z_2 = C_z_1 - (Delta C_z)/2 = COcᶻ1 - CΔcᶻ / 2 = CCcᶻ2 "м/с"; $

// #block(breakable: false)[Абсолютная скорость на выходе в рабочее колесо:
// $ C_2 = sqrt(C^2_z_2 + C^2_u_2) = sqrt( CCcᶻ2^2 + Ccᵤ2^2 ) = Cc2 "м/с"; $]

// Угол наклона вектора для построения треугольников скоростей:
// $ a_2 = "arcctg" (C_u_2/C_z_2) = "arctg" ( Ccᵤ2 / CCcᶻ2 ) = Cα2 degree; $

// Проекция относительной скорости $W$ на окружное направление входной скорости на выходе из рабочего колеса:
// $ W_u_2 = C_u_2 - u = Ccᵤ2 - Cu = Cwᵤ2 "м/с"; $

// Относительная скорость на выходе из колеса:
// $ W_2 = sqrt(C^2_z_2 + W^2_u_2) = sqrt(COcᶻ2^2 + (Cwᵤ2)^2) = Cw2 "м/с"; $

// Наклон выходной относительной скорости:
// $ beta_2 = "arctg" (W_u_2/C_z_2) = "arctg" (Cwᵤ2/COcᶻ2) = Cβ2 degree; $

// Угол поворота в решетке рабочего колеса:
// $ epsilon = beta_2 - beta_1 = Cβ2 degree - Cβ1 degree = Cϵ degree; $

// Коэффициент расхода на внешнем диаметре:
// $ phi_н = C_z_1 / u_н_1 = COcᶻ1 / Cuₙ1 = CΦₙ; $

// Проверка числа Маха по средней относительной скорости на внешнем диаметре первой ступени:
// $ M_W_с = u_н_1 dot sqrt(1+phi_н^2)/sqrt(k_в dot R_в dot T_1^*) = Cuₙ1 dot sqrt(1 + CΦₙ^2) / sqrt(COkₙ dot CORₙ dot CTs1) = CMʷₘ; $

// Сверхзвуковое число $M_W_c$ свидетельствует о необходимости профилирования лопаточного аппарата первой ступени турбины по закону $Omega = "const"$ вдоль радиуса.

// На @Tri[рисунке] приведён построенный по полученным данным треугольник скоростей:

// #figure(
//   text(size: 12pt, cetz.canvas(length:0.05cm, {
//     import cetz.draw: *
//     set-style(
//       mark: (transform-shape: false, fill: black),
//       stroke: (cap: "round")
//     )
//     // Variables
//     let cz1 = -RawCOcᶻ1
//     let cz2 = -RawCCcᶻ2
//     let cu1 = -RawCcᵤ1
//     let cu2 = -RawCcᵤ2
//     let cu  =  RawCu
//     let a1  =  RawCα1 * 1deg
//     let a2  =  RawCα2 * 1deg
//     let b1  =  RawCβ1 * 1deg
//     let b2  =  RawCβ2 * 1deg
//     let start = calc.max( calc.abs(cu1), calc.abs(cu2) )
    
//     // Оси
//     line((start,0),(-start,0), mark:(end: "stealth"), name: "axisu")
//     content("axisu.end", $U$, padding: 5, anchor: "north-west" )
//     line((0,0),(0,cz1), mark:(end: "stealth"), name: "axisz")
//     content("axisz.end", $z$, padding: 5, anchor: "south-west" )

//     // Треугольник 1
//     line(name:"C1", (0,0),(cu1  ,cz1), mark:(end:"stealth", fill:red), stroke:(paint:red, thickness: 2pt))
//     line(name:"W1", (0,0),(cu1 + cu, cz1), mark:(end:"stealth", fill:red), stroke:(paint:red, thickness: 2pt))
//     line(name:"U1", "W1.end","C1.end", mark:(end: "stealth", fill:red),stroke:(paint:red, thickness: 2pt))

//     // Треугольник 2
//     line(name:"C2", (0,0),(cu2, cz2), mark:(end:"stealth", fill:blue), stroke:(paint:blue, thickness: 2pt))
//     line(name:"W2", (0,0),(cu2 + cu, cz2), mark:(end:"stealth", fill:blue), stroke:(paint:blue, thickness: 2pt))
//     line(name:"U2","W2.end","C2.end", mark:(end: "stealth", fill:blue),stroke:(paint:blue, thickness: 2pt))

//     // линии для U1 и U2
//     line(name:"U1s","U1.start", (rel:(0,-20)))
//     line(name:"U1e","U1.end",   (rel:(0,-20)))
//     line(name:"U_1", "U1s.16", "U1e.16", mark:(symbol: "stealth"))
//     line(name:"U2s","U2.start", (rel:(0,-40)))
//     line(name:"U2e","U2.end",   (rel:(0,-40)))
//     line(name:"U_2", "U2s.36", "U2e.36", mark:(symbol: "stealth"))

//     // Подписи
//     content("C1.70%", angle:  a1, box(fill:white, inset:3pt, $C_1 = Cc1 "м/с"$))
//     content("W1.70%", angle: -b1, box(fill:white, inset:3pt, $W_1 = Cw1 "м/с"$))
//     content("C2.70%", angle:  a2, box(fill:white, inset:3pt, $C_2 = Cc2 "м/с"$))
//     content("W2.70%", angle: -b2, box(fill:white, inset:3pt, $W_2 = Cw2 "м/с"$))
//     content("U_1.mid", box(fill:white, inset:3pt, $U_1 = Cu "м/с"$))
//     content("U_2.mid", box(fill:white, inset:3pt, $U_2 = Cu "м/с"$))
//     content("axisz.90", angle: 90deg, box(fill:white, inset:3pt, $C_z_1 = COcᶻ1 "м/с"$), anchor: "south")
//     content("axisz.90", angle:-90deg, box(fill:white, inset:3pt, $C_z_2 = CCcᶻ2 "м/с"$), anchor: "south")

//     // Дуги
//     arc(name:"a2", (0,0), start:180deg, stop: 180deg + a2, radius:80, anchor:"origin", mark:(symbol:"stealth"))
//     arc(name:"b2", (0,0), start:0deg, stop: -b2, radius:45, anchor:"origin", mark:(symbol:"stealth"))
//     arc(name:"a1", (0,0), start:-180deg, stop: -180deg + a1, radius:45, anchor:"origin", mark:(symbol:"stealth"))
//     arc(name:"b1", (0,0), start:0deg, stop: 0deg - b1, radius:80, anchor:"origin", mark:(symbol:"stealth"))

//     // Подписи дуг
//     content("a1.50%", angle: a1/2, box(fill:white, inset:3pt, $alpha_1 = Cα1 degree$) )
//     content("b1.33%", angle: -b1/3, box(fill:white, inset:3pt, $beta_1 = Cβ1 degree$) )
//     content("a2.33%", angle: a2/3, box(fill:white, inset:3pt, $alpha_2 = Cα2 degree$) )
//     content("b2.50%", angle: -b2/2, box(fill:white, inset:3pt, $beta_2 = Cβ2 degree$) )
//   })),
//   caption: text(size:14pt)[Треугольник скоростей на среднем диаметре первой ступени компрессора]
// ) <Tri>

// = Расчет камеры сгорания

= Газодинамический расчет турбины по среднему диаметру

#centred-heading("Заключение")

#bibliography(
  "ref.bib",
  style: "gost-r-705-2008-numeric",
  title: "Список использованных источников",
  full: true
)
