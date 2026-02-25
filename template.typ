#import "@preview/cetz:0.4.2"
#import "@preview/lilaq:0.5.0" as lq
#import "@preview/zero:0.6.1": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import fletcher.shapes: trapezium

#let conf(body) = {
  set text(
    font: "Times New Roman",
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
  show figure.where(kind: table): it => {
    set figure.caption(position: top)
    show figure.caption: it => align(left, it)
    set block(breakable: true)
    set text(size: 10pt)
    show figure.caption: set text(size:14pt)
    set math.equation(numbering: none, supplement: [table-eq])
  it
}
  
  set list(marker: [--])
  set figure.caption(separator: [ --- ])
  show figure.where(kind:"listing"): set figure.caption(position:top)
  show figure.caption.where(kind: "listing"): it => align(left, it)

  show figure.where(kind: table): set figure.caption(position:top)
  show figure.caption.where(kind: table): it => align(left, it)

  // Название
  align(center, text(hyphenate: false)[
    Министерство науки и высшего образования Российской Федерации \ Санкт-Петербургский Политехнический университет Петра Великого \ Институт энергетики \ Высшая школа энергетического машиностроения

    \ \

    #place(right, align(center)[
      Работа допущена к защите \
      Директор ВШЭМ \
      #text("__________") А. С. Алешина \
      "#text("__")"#text("_____________") 2024 г.
    ])

    #place(horizon+center)[ \ \
      *ВЫПУСКНАЯ КВАЛИФИКАЦИОННАЯ РАБОТА БАКАЛАВРА*\
      *ГАЗОТУРБИННАЯ УСТАНОВКА МОЩНОСТЬЮ 65 МВт*\ \

      #align(left)[
        #h(-1.25cm) по направлению подготовки (специальности) 13.03.03 Энергетическое машиностроение

        #h(-1.25cm) Направленность (профиль) 13.03.03_12 Турбины и авиационные двигатели
      ]

      #v(6em)

      #table(
        columns:(1.5fr, 1fr, 1fr), align: left + bottom,
        stroke: none, row-gutter: 20pt,
        [Выполнил: \ Студент гр.3231303/21201],
        "_____________", [А. К. Дмитриев],
    
        [],[],[],
        [Руководитель: \ Профессор ВШЭМ, д.т.н.],
        "_____________", [В. А. Черников]
      )
    ]

    #place(bottom+center)[Санкт-Петербург \ 2026]
  ])

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
    set text(hyphenate: false, size: 14pt, weight: "regular")
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

  // Литература
  show bibliography: it => {
    show heading: set align(center)
    it
  }

  set math.equation(
    numbering: (..num) => numbering("(1.1)", counter(heading).get().first(), num.pos().first())
  )
  show math.equation.where(block: true): it => {
    if it.supplement != [table-eq] {
      linebreak()
      it
      linebreak()
  } else {it}
}

  // set-num(
  //   // exponent: "eng",
  //   product: math.dot
  // )
  set-round(
    mode: "figures",
    precision: 4,
    pad: false
  )

  body
}

#let noind = h(-1.25cm)
#let centred-heading(title) = [
  // #pagebreak(weak:true)
  
  #align(center, heading(numbering:none, title))
]
