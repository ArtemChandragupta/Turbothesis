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

import Data

p1 :: Waterfall.Path
p1 = Waterfall.fromPath2D (Path2D.pathFrom2D p1c1e
    [ Path2D.arcViaTo2D p1c1m p1c1s
    , Path2D.bezierTo2D p1ls2 p1ls3 p1ls1
    , Path2D.arcViaTo2D p1c2m p1c2e
    , Path2D.bezierTo2D p1lp3 p1lp2 p1lp0
    ])

p2 :: Waterfall.Path
p2 = Waterfall.fromPath2D (Path2D.pathFrom2D p2c1e
    [ Path2D.arcViaTo2D p2c1m p2c1s
    , Path2D.bezierTo2D p2ls2 p2ls3 p2ls1
    , Path2D.arcViaTo2D p2c2m p2c2e
    , Path2D.bezierTo2D p2lp3 p2lp2 p2lp0
    ])

p3 :: Waterfall.Path
p3 = Waterfall.fromPath2D (Path2D.pathFrom2D p3c1e
    [ Path2D.arcViaTo2D p3c1m p3c1s
    , Path2D.bezierTo2D p3ls2 p3ls3 p3ls1
    , Path2D.arcViaTo2D p3c2m p3c2e
    , Path2D.bezierTo2D p3lp3 p3lp2 p3lp0
    ])

p4 :: Waterfall.Path
p4 = Waterfall.fromPath2D (Path2D.pathFrom2D p4c1e
    [ Path2D.arcViaTo2D p4c1m p4c1s
    , Path2D.bezierTo2D p4ls2 p4ls3 p4ls1
    , Path2D.arcViaTo2D p4c2m p4c2e
    , Path2D.bezierTo2D p4lp3 p4lp2 p4lp0
    ])

p5 :: Waterfall.Path
p5 = Waterfall.fromPath2D (Path2D.pathFrom2D p5c1e
    [ Path2D.arcViaTo2D p5c1m p5c1s
    , Path2D.bezierTo2D p5ls2 p5ls3 p5ls1
    , Path2D.arcViaTo2D p5c2m p5c2e
    , Path2D.bezierTo2D p5lp3 p5lp2 p5lp0
    ])

lofter :: Solids.Solid
lofter = Loft.loft [
      (Transforms.translate (V3 0 0 p1r) p1)
    , (Transforms.translate (V3 0 0 p2r) p2)
    , (Transforms.translate (V3 0 0 p3r) p3)
    , (Transforms.translate (V3 0 0 p4r) p4)
    , (Transforms.translate (V3 0 0 p5r) p5)
    ]

main :: IO ()
main = do
    Waterfall.writeSTEP "blade.step" lofter
    Waterfall.SVG.writeDiagramSVG "blade.svg" (Waterfall.solidDiagram (V3 0 0 1) (Waterfall.uScale 10 lofter ))
