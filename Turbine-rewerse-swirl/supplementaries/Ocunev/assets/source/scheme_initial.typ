#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import fletcher.shapes: pill, parallelogram, diamond, hexagon, brace

#let v_stroke = rgb("#282828")

#set page(
  fill: rgb("#EBDBB2"),
  height: 22cm,
  margin: 0.5cm
)
#set text(size:11pt, fill: v_stroke)

#figure(
  diagram(
    node-stroke: v_stroke,
    edge-stroke: v_stroke,

    node((0,1), name: <P1>, corner-radius: 10pt, [
      Исходные данные $ [C] $ 
    ]),
    edge("=="),

    node((0,2), shape: parallelogram.with(angle: 30deg), name: <P2>, [
      $"задаем "[p_2], [phi], [psi] $
    ]),
    edge("=="),
  
    node((0,3), name: <P3>, [
      *Первичный расчет* \
      #diagram(edge-stroke: v_stroke,
      $ (G_"опт", [C]) edge(->, text(#0.8em, f_"пер")) & [I] $
      )
    ] ),
    edge("=="),
    
    node((0,4), name: <P4>, [
      *Расчет по ступеням* \
      #diagram(edge-stroke: v_stroke,
      $ (G_"опт", [C], [I], [p_2], [phi], [psi]) edge(->, text(#0.8em, f_"ступ")) & [S] $
      )
    ]),
    edge("=="),

    node((0,5), name: <P5>, shape: diamond, 
      fill: gradient.linear(green,red), 
      inset: 4pt, [
        $ ? cases(G_"опт" approx G_"A2GTP" \ Sigma N approx [C].N) $
    ]),
    edge("=="),

    node((0,6), shape: parallelogram.with(angle: 30deg), name: <P6>, [
      $"задаем " F, " " rho_k, " " alpha_1 "и " beta_2^* $
    ]),
    edge("=="),

    node((0,7), name: <P7>, [
      *Расчет обратной закрутки* \
      #diagram(edge-stroke: v_stroke,
      $ (G_"опт", [C], [I], [S], F, rho_k, alpha_1, beta_2^*) edge(->, text(#0.8em, f_"зак")) & [R] $
      )
    ]),
    edge("=="),

    node((0,8), name: <P8>, shape: diamond, 
      fill: gradient.linear(green,red), 
      inset: 6pt, [
        $ ? [R].p_2 arrow.tr arrow.tr $
    ]),
    edge("=="),

    node((0,9), name: <P9>, corner-radius: 10pt, [
      Профилирование РК и СА\
      Проверка конфузорности РК и СА
    ]),

    edge(<P8>,(1,8),(1,6),<P6>,"-|>"),
    edge(<P5>,(1,5),(1,2),<P2>,"-|>"),

    node((-1,1), [1], name: <n1>),
    node((-1,2), [2], name: <n2>),
    node((-1,3), [3], name: <n3>),
    node((-1,4), [4], name: <n4>),
    node((-1,5), [5], name: <n5>),
    node((-1,6), [6], name: <n6>),
    node((-1,7), [7], name: <n7>),
    node((-1,8), [8], name: <n8>),
    node((-1,9), [9], name: <n9>),
    edge(<n1>,<P1>, "--"),
    edge(<n2>,<P2>, "--"),
    edge(<n3>,<P3>, "--"),
    edge(<n4>,<P4>, "--"),
    edge(<n5>,<P5>, "--"),
    edge(<n6>,<P6>, "--"),
    edge(<n7>,<P7>, "--"),
    edge(<n8>,<P8>, "--"),
    edge(<n9>,<P9>, "--"),

  ),
)
