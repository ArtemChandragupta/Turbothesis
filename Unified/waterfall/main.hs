import Linear (V3 (..), V2 (..), zero)
import qualified Waterfall
import qualified Waterfall.SVG
import qualified Waterfall.IO as WIO
import qualified Waterfall.Transforms as Transforms
import qualified Waterfall.TwoD.Transforms as Transforms2D
import qualified Waterfall.Booleans as Booleans
import qualified Waterfall.Solids as Solids
import qualified Waterfall.Sweep as Sweep
import qualified Waterfall.TwoD.Shape as Shape
import qualified Waterfall.Loft as Loft
import qualified Waterfall.Path.Common as Path
import qualified Waterfall.TwoD.Path2D as Path2D

p :: Waterfall.Path
p = Path.closeLoop (Path.pathFrom zero
    [ Path.arcViaRelative (V3 (-1) 1 0) (V3 0 3 0)
    , Path.bezierRelative (V3 0 0 0) (V3 0 (-0.5) 0) (V3 4 4 0)
    , Path.arcViaRelative (V3 1 (-1) 0) (V3 0 (-2) 0)
    , Path.bezierTo (V3 0 0 0) (V3 0 (-0.5) 0) (V3 0 0 0)
    ])

lofter3D :: Solids.Solid
lofter3D = Loft.loft [p
    , (Transforms.translate (V3 0 0 1) p)
    , (Transforms.translate (V3 0 0 2) p)
    , (Transforms.translate (V3 0 0 3) p)
    , (Transforms.translate (V3 0 0 4) p)
    ]

p1 :: Waterfall.Path
p1 = Waterfall.fromPath2D (Path2D.pathFrom2D (V2 0 0)
    [ Path2D.arcViaRelative2D (V2 (-1) 1 ) (V2 0 3 )
    , Path2D.bezierRelative2D (V2 0 0) (V2 0 (-0.5)) (V2 4 4)
    , Path2D.arcViaRelative2D (V2 1 (-1)) (V2 0 (-2))
    , Path2D.bezierTo2D (V2 0 0) (V2 0 (-0.5)) (V2 0 0)
    ])

lofter :: Solids.Solid
lofter = Loft.loft [p1
    , (Transforms.translate (V3 0 0 1) p1)
    , (Transforms.translate (V3 0 0 2) p1)
    , (Transforms.translate (V3 0 0 3) p1)
    , (Transforms.translate (V3 0 0 4) p1)
    ]

main :: IO ()
-- main = Waterfall.SVG.writeDiagramSVG "loft.svg" (Waterfall.solidDiagram (V3 1 1 1) (Waterfall.uScale 100 lofter ))
main = Waterfall.writeSTEP "fillet.step" lofter
