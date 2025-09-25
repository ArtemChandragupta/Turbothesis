#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import fletcher.shapes: pill, parallelogram, diamond, hexagon, brace

#let v_stroke = rgb("#282828")

#set page(
  fill: rgb("#EBDBB2"),
  margin: 0.2cm,
  height: 23cm
)
#set text(size:11pt, fill: v_stroke)

#figure(
  diagram(
    node-stroke: v_stroke,
    edge-stroke: v_stroke,

    node((0,1), corner-radius: 10pt, [
      Исходные данные $ [C] $ 
    ]),
    edge("=="),

    node((0,2), shape: parallelogram.with(angle: 30deg), name: <P2>, [
      $"задаем "[p_2], [phi], [psi] $
    ]),
    edge("=="),
  
    node((0,3), name:<I>, [
      *Первичный расчет* \
      #diagram(edge-stroke: v_stroke,
      $ (G_"опт", [C]) edge(->, text(#0.8em, f_"пер")) & [I] $
      )
    ] ),
    edge(<P2>,<I>,"=="),
    edge("=="),

    node((0,4), name: <S>, [
      *Расчет по ступеням* \
      #diagram(edge-stroke: v_stroke,
      $ (G_"опт", [C], [I], [p_2], [phi], [psi]) edge(->, text(#0.8em, f_"ступ")) & [S] $
      )
    ]),
    edge("=="),

    node((0,5), shape: parallelogram.with(angle: 30deg), name: <F>, [
      $"задаем " alpha_1 "и " beta_2^* $
    ]),
    edge("=="),

    node((0,6), name: <RR>, [
      *Расчет обратной закрутки* \
      #diagram(edge-stroke: v_stroke,
      $ (G_"опт", [C], [I], [S], F, rho_k, alpha_1, beta_2^*) edge(->, text(#0.8em, f_"зак")) & [R] $
      )
    ]),
    edge("=="),

    node((0,7), corner-radius: 10pt, [
      Профилирование РК и СА \
      Проверка конфузорности РК и СА \
    ]),

    node((1,5), name: <FF>, [
      Для $F_i in [-0.5,0] $ и $rho_(k i) in [0.2, 0.5] $:

      Расчет обратной закрутки

      #diagram(edge-stroke: v_stroke,
      $ (G_"опт", [I], [S], [C], F_i, rho_(k i)) edge(->, text(#0.8em, f_"зак")) & [R]_i $
      )
    ]),
    edge(),
    node((1,6), [
      $ [ [R]_i ] <- [R]_i: [R]_i.p_2 arrow.tr arrow.tr $
    ]),
    edge(),
    node((1,7), shape: hexagon,
    fill: gradient.linear(green,red),
    name: <CC>, [
      Выбираем "хорошие" $f$ и $rho_k$ \ 
      $ [ [R]_i ] <- [R]_i^5 : |alpha_2| >= 86 degree$, $|Delta rho_k| <= 0.1$

      Из этой области $[ [R]_i ]$ выбирается \ [R] с наименьшим градиентом
    ]),
    node((1.9,5),[меняем $alpha_1$, $beta_2^*$], shape: parallelogram.with(angle: 30deg), name:<Lub>),
    edge(<CC.west>, (0.5,7),(0.5,6),<RR>, "-|>", [$F, rho_k$]),
    edge(<F>,<FF>, "-|>"),
    edge(<CC>,(1.9,7),<Lub>, "-|>"),
    edge(<Lub>,<FF>, "-|>"),

    node(enclose:((0.5,0),(3,4.3)), stroke:(dash: "dashed", paint: rgb("#D65D0E"))),
    node(enclose:((0.5,4.6),(3,8)), stroke:(dash: "dashed", paint: rgb("#458588"))),

    node((1,1), name: <Gi>, [
      Для $G_i in [120 ... 180] $: \
      Первичный расчет \
      #diagram(edge-stroke: v_stroke,
      $ (G_i, [C]) edge(->, text(#0.8em, f_"пер")) & [I]_i $
      )
    ] ),
    edge(),
    node((1,2), [
      Для $G_i in [120 ... 180] $: \
      Расчет по ступеням \
      #diagram(edge-stroke: v_stroke,$ (G_i, [C], [I]_i, [p_2],[phi],[psi]) edge(->, text(#0.8em, f_"ступ")) & [S]_i $
      )
    ]),
    edge(),
    node((1,3), [
      $ G_"опт" <- G_i: [S]_i^4.alpha_2 = 90 degree $
    ]),
    edge(),
    node((1,4), name: <rr>, shape: diamond, 
    fill: gradient.linear(green,red), 
    inset: 4pt, [
      $ ? cases(G_"опт" approx G_"A2GTP" \ Sigma N approx [C].N) $
    ]),
    edge(<P2>,(0.5,2),(0.5,1),<Gi>, "-|>"),
    edge(<rr.west>, (0.5,4), (0.5,3) , <I.east>, "-|>", [$ G_"опт", phi_"опт",psi_"опт" $]),
    edge(<rr>, (1.9,4),<Shu>, "-|>"),
    node((1.9,1), shape: parallelogram.with(angle: 30deg), name: <Shu>, [
      меняем $[phi],[psi]$
    ]),
    edge(<Shu>,<Gi>, "-|>"),
  ),
)
