// Импорт сторонних пакетов
#import "@preview/physica:0.9.5": *  // Физические формулы
#import "@preview/codly:1.3.0": *    // Листинги
#import "@preview/cetz:0.4.2"        // Диаграммы
#import "@preview/lilaq:0.5.0" as lq // Графики
#import "@preview/pinit:0.2.2": *    // Выделение
#import "@preview/mannot:0.3.0": *   // Математические аннотации
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#let conf(
  body
) = {
  set text(
    font: "Times New Roman",
    size: 14pt,
    lang: "ru"
  )
  set page(
    paper: "a4",
    margin: (left:3cm, right:1.5cm, y:2cm),
    number-align: right,
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
  show figure: it => {
    linebreak()
    it
    linebreak()
  }
  
  set list(marker: [---])
  set figure.caption(separator: [ --- ])
  show figure.where(kind:"listing"): set figure.caption(position:top)
  show figure.caption.where(kind: "listing"): it => align(right, it)

  show figure.where(kind: table): set figure.caption(position:top)
  show figure.caption.where(kind: table): it => align(left, it)

  // Название
  align(center, text(hyphenate: false)[
    *Министерство науки и высшего образования Российской Федерации* \ Санкт-Петербургский Политехнический университет Петра Великого \ Институт энергетики \ Высшая школа энергетического машиностроения

    #place(horizon+center)[
      *Предложения*\
      по улучшению методики вычисления \ параметров осевой турбины по среднему диаметру \ и \ параметров обратной закрутки потока

      #v(6em)

      #table(
        columns:(1.5fr, 1fr, 1fr), align: left,
        stroke: none, row-gutter: 20pt,
        [Представил и реализовал:],[],[],
    
        [Студент гр.3231303/21201 п/г 2],
        "_____________", [А. К. Дмитриев],
      )
    ]

    #place(bottom+center)[Санкт-Петербург \ 2025]
  ])

  set page(numbering: "1")

  // Содержание
  show outline: it => {
    show heading: set align(center)
    it
  }

  // Заголовки
  set heading(numbering: "1.1")
  show heading: it => {
    set text(hyphenate: false, size: 14pt)
    set block(above: 1.4em, below: 2em)
    pad(x: 1.25cm, it)
  }
  show heading.where(level: 1): it => {
    counter(math.equation).update(0)
    counter(figure.where(kind: image)).update(0)
    counter(figure.where(kind: table)).update(0)
    colbreak(weak: true)
    it
  }

  // Для листингов кода
  show: codly-init.with()
  codly(display-name: false,fill: luma(230))

  set math.equation(
    numbering: (..num) => numbering("(1.1)", counter(heading).get().first(), num.pos().first())
  )

  body
}
