#import "@preview/cetz:0.5.2"
#import "@preview/lilaq:0.6.0" as lq
#import "@preview/zero:0.6.1": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import fletcher.shapes: trapezium

#let conf(body) = {
  set text(
    size: 14pt,
    lang: "ru"
  )
  set page(
    paper: "a4",
    margin: (left:3cm, right:1cm, y:2cm),
  )
  set par(
    justify: true,
    first-line-indent: (amount: 1.25cm, all: true)
  )

  // Leading fix
  let leading = 1.5em - 0.75em // "Normalization"
  set block(spacing: leading)
  set par(spacing:leading, leading:leading)

  set figure(
    supplement: [Рисунок],
    numbering: (..num) => numbering("1.1", counter(heading).get().first(), num.pos().first())
  )
  set ref(supplement: it => {
    if it.func() == heading {
      "разделе"
    } else if it.func() == figure {
      "рисунке"
    } else {
      ""    
    }
  })
  set ref(supplement: it => {
    if it.func() == heading {
      "разделе"
    } else if it.func() == figure {
      if it.kind == table {
        "таблице"
      } else if it.kind == image {
        "рисунке"
      } else {
        it.supplement
      }
    } else {
      ""
    }
  })
  
  show figure: it => {
    linebreak()
    it
    linebreak()
  }
  show figure: set text(hyphenate: false)
  show figure.where(kind: table): it => {
    set figure.caption(position: top)
    show figure.caption: it => align(left, it)
    set block(breakable: true)
    // set text(size: 10pt)
    show figure.caption: set text(size:14pt)
    set math.equation(numbering: none, supplement: [table-eq])
    it
  }
  show figure.where(kind: table): set figure(supplement: [Таблица])
  
  set figure.caption(separator: [ --- ])
  show figure.where(kind:"listing"): set figure.caption(position:top)
  show figure.caption.where(kind: "listing"): it => align(left, it)

  set list(marker: [--], indent: 1.25cm)
  set enum(indent: 1.25cm, full: true)

  show figure.where(kind: table): set figure.caption(position:top)
  show figure.caption.where(kind: table): it => align(left, it)

  // Титульник
  align(center, text(hyphenate: false)[
    Министерство науки и высшего образования Российской Федерации \ Санкт-Петербургский Политехнический университет Петра Великого \ Институт энергетики \ Высшая школа энергетического машиностроения

    \ \

    #place(right, align(center)[
      Работа допущена к защите \
      Директор ВШЭМ \
      #text("__________") А. С. Алешина \
      "#text("__")"#text("_____________") 2026 г.
    ])

    #place(horizon+center)[ \ \ \ \ 
      *ВЫПУСКНАЯ КВАЛИФИКАЦИОННАЯ РАБОТА БАКАЛАВРА*\
      *ГАЗОТУРБИННАЯ УСТАНОВКА ЭФФЕКТИВНОЙ МОЩНОСТЬЮ \ 65 МВт*\ \

      #align(left)[
        #h(-1.25cm) по направлению подготовки (специальности) 13.03.03 Энергетическое машиностроение

        #h(-1.25cm) Направленность (профиль) 13.03.03_12 Турбины и авиационные двигатели
      ]

      #v(4em)

      #table(
        columns:(1.5fr, 1fr, 1fr), align: left + bottom,
        stroke: none, row-gutter: 10pt,
        [Выполнил: \ Студент гр. 3231303/21201],
        "_____________", [А. К. Дмитриев],
    
        [],[],[],
        [Руководитель: \ Профессор ВШЭМ, д.т.н.],
        "_____________", [В. А. Черников],

        [],[],[],
        [Консультант по нормоконтролю: \ Доцент ВШЭМ, к.т.н.],
        "_____________", [Ю. В. Матвеев]
      )
    ]

    #place(bottom+center)[Санкт-Петербург \ 2026]
    #pagebreak()
  ])

  // Задание
  text[
    #set par(
      justify: true,
      first-line-indent: (amount: 0cm, all: true)
    )
    #set list(marker: [--], indent: 0cm)
    #set enum(indent: 0cm, full: true)
    // Название
    #align(center, text(hyphenate: false)[
      Министерство науки и высшего образования Российской Федерации \ Санкт-Петербургский Политехнический университет Петра Великого \ Институт энергетики \ Высшая школа энергетического машиностроения
    ]) \ 

    #align(right, block(align(left)[
      #h(-1.25cm)УТВЕРЖДАЮ \
      #h(-1.25cm)Руководитель ОП \
      #align(right)[А. Б. Степанова]
      #h(-1.25cm)"#text("__")"#text("_____________") 2026 г.
    ]))

    #align(center, text(hyphenate: false)[
      \ *ЗАДАНИЕ*
  
       *на выполнение выпускной квалификационной работы* 
    ])

    студенту Дмитриеву Артему Константиновичу, гр. 3231303/21201

    + Тема работы: _Газотурбинная установка эффективной мощностью 65 МВт_.

    + Срок сдачи студентом законченной работы: 1 июня 2026 года.

    + Исходные данные по работе:
      - Прототип установки --- ГТЭ-65;
      - Эффективная мощность установки --- 65 МВт;
      - Температура газа перед турбиной --- 1643 К;
      - Топливо --- природный газ;
      - Параметры наружного воздуха --- $p_н = 0.1013$ МПа, $T_н = 288$ K.

    + Содержание работы:
      - Расчет тепловой схемы газотурбинной установки;
      - Приближенный расчет компрессора;
      - Приближенный расчет камеры сгорания;
      - Газодинамический расчет турбины и проектирование последней ступени турбины;
      - Прочностной расчет лопатки и диска последней ступени турбины и ротора установки;
      - Описание конструкции установки;
      - Определение оптимального зазора в системе "последняя ступень-диффузор".

    + Перечень графического материала:
      - Продольный разрез гузотурбинной установки мощностью 65 МВт.
    + Перечень используемых информационных технологий, в том числе программное обеспечение, облачные сервисы, базы данных и прочие сквозные цифровые технологии:
      - Инструменты Julia: Pluto.jl, Makie.jl;
      - Typst и его пакеты CeTZ, Lilaq, Zero и fletcher;
      - Ansys 2020 R2: модули CFX, Mechanical;
      - A2GTP;
      - КОМПАС-3D V23 учебная версия;
      - SolidWorks 2022;
      - Инструменты Haskell: OpenCASCADE-hs, Waterfall-CAD;
      - Asymptote.

    + Консультанты по работе:
      - Коршунов Андрей Васильевич.
      // - Широких Андрей Антонович;

    + Дата выдачи задания: 1 апреля 2025 года.

    Руководитель ВКР #text("____________________________   ") В. А. Черников.

    Задание принял к исполнению 2 февраля 2026 года.

    Cтудент #text("_____________________________________   ") А. К. Дмитриев.
  ]

  set page(numbering: "1")

  // Содержание
  show outline: it => {
    show heading: set align(center)
    it
  }
  show outline.entry.where(level: 1): it => upper(it)

  // Заголовки
  set heading(numbering: "1.1")
  show heading: it => {
    set text(hyphenate: false, size: 14pt,
    // weight: "regular"
    )
    set block(above: 1.4em, below: 2em)
    pad(x: 1.25cm, it)
  }
  show heading.where(level: 1): it => {
    counter(math.equation).update(0)
    counter(figure.where(kind: image)).update(0)
    counter(figure.where(kind: table)).update(0)
    pagebreak(weak: true)
    upper(it)
  }

  // Ссылки на источники
  show bibliography: it => {
    show heading: set align(center)
    it
  }

  // Уравнения - нумерация только для упоминаемых
  set math.equation(
    numbering: (..num) => numbering("(1.1)", counter(heading).get().first(), num.pos().first())
  )
  show math.equation: it => {
    if it.block and not it.has("label") and it.numbering != none [
      #counter(math.equation).update(v => v - 1)
      #math.equation(it.body, block: true, numbering: none)
    ] else {
      it
    }
  }

  // Lilaq diagrams
  show: lq.set-diagram(
    width: 100%,
    yaxis: (exponent:0),
    xaxis: (exponent:0)
  )
  show lq.selector(lq.legend): set grid(row-gutter: 2pt)
  show lq.selector(lq.tick-label): set text(12pt)
  

  // Numerals formatting using Zero
  // set-num(
  //   exponent: "eng",
  //   product: math.dot
  // )
  set-round(
    mode: "figures",
    precision: 4,
    pad: false
  )
  set-unit(fraction: "inline")

  body
}

// Пропуск индентации, пропуск и возврат строки
#let noind = h(-1.25cm)
#let undo-line() = context {v(-measure[A].height - 0.75em)}
#let skip-line() = context {v( measure[A].height + 0.75em)}

#let centred-heading(title) = align(center, heading(numbering:none, title))

#let appendix(body) = {
  set heading(numbering: none, supplement: [Приложение])
  counter(heading).update(0)
  set text(hyphenate: false, size: 14pt, weight: "regular")
  body
}

#let table-multi-page(continue-header-label: [], ..table-args) = context {
  set text(size: 10pt)
  let columns = table-args.named().at("columns", default: 1)
  let column-amount = if type(columns) == int {
    columns
  } else if type(columns) == array {
    columns.len()
  } else {
    1
  }

  // Check as show rule for appearance of a header or a footer in grid if value is specified
  let label-has-content = value => value.has("children") and value.children.len() > 0 or value.has("text")

  // Counter of tables so we can create a unique table-part-counter for each table
  let table-counter = counter("table")
  table-counter.step()

  // Counter for the amount of pages in the table
  let table-part-counter = counter("table-part" + str(table-counter.get().first()))

  show <table-header>: header => {
    table-part-counter.step()
    context if (table-part-counter.get().first() != 1) and label-has-content(continue-header-label) {
      header
    }
  }

  grid(
    inset: 0mm,
    row-gutter: 2mm,
    grid.header(grid.cell(align(left + bottom, text(size:12pt)[#continue-header-label <table-header>] ))),
    block(stroke:black, ..table-args),
  )
}

// Zero units
#let zMW     = zi.declare("МВт")
#let zdc     = zi.declare($degree C$)
#let zm      = zi.declare("м")
#let zm2     = zi.declare("м^2")
#let zm3     = zi.declare("м^3")
#let zkg-s   = zi.declare("кг/с")
#let zrpm    = zi.declare("об/мин")
#let zmg-nm3 = zi.declare("мг/нм^3")
#let zW      = zi.declare("Вт")
#let zK      = zi.declare("K")
#let zPa     = zi.declare("Па")
#let zkg-m3  = zi.declare("кг/м^3")
#let zkg-m   = zi.declare("кг/м")
#let zkg-s   = zi.declare("кг/с")
#let zkg     = zi.declare("кг")
#let zJ-kg   = zi.declare("Дж/кг")
#let zJ-kgK  = zi.declare("Дж/кг/K")
#let zkg-m3  = zi.declare("кг/м^3")
#let zMPa    = zi.declare("МПа")
#let zh      = zi.declare("ч")
#let zs      = zi.declare("с")
#let zN-m2   = zi.declare("Н/м^2")
#let zmkm    = zi.declare("мкм")
#let zmm     = zi.declare("мм")
#let zT      = zi.declare("т")
#let zHz     = zi.declare("Гц")
#let zm-s    = zi.declare("м/с")
#let zg-kg   = zi.declare("г/кг.топл")
#let zppm    = zi.declare("ppm")
