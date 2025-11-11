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

import Data2

p1 :: Waterfall.Path
p1 = Waterfall.fromPath2D (Path2D.pathFrom2D ps1c1e
    [ Path2D.arcViaTo2D ps1c1m ps1c1s
    , Path2D.bezierTo2D ps1ls2 ps1ls3 ps1ls1
    , Path2D.arcViaTo2D ps1c2m ps1c2e
    , Path2D.bezierTo2D ps1lp3 ps1lp2 ps1lp0
    ])

p2 :: Waterfall.Path
p2 = Waterfall.fromPath2D (Path2D.pathFrom2D ps2c1e
    [ Path2D.arcViaTo2D ps2c1m ps2c1s
    , Path2D.bezierTo2D ps2ls2 ps2ls3 ps2ls1
    , Path2D.arcViaTo2D ps2c2m ps2c2e
    , Path2D.bezierTo2D ps2lp3 ps2lp2 ps2lp0
    ])

p3 :: Waterfall.Path
p3 = Waterfall.fromPath2D (Path2D.pathFrom2D ps3c1e
    [ Path2D.arcViaTo2D ps3c1m ps3c1s
    , Path2D.bezierTo2D ps3ls2 ps3ls3 ps3ls1
    , Path2D.arcViaTo2D ps3c2m ps3c2e
    , Path2D.bezierTo2D ps3lp3 ps3lp2 ps3lp0
    ])

p4 :: Waterfall.Path
p4 = Waterfall.fromPath2D (Path2D.pathFrom2D ps4c1e
    [ Path2D.arcViaTo2D ps4c1m ps4c1s
    , Path2D.bezierTo2D ps4ls2 ps4ls3 ps4ls1
    , Path2D.arcViaTo2D ps4c2m ps4c2e
    , Path2D.bezierTo2D ps4lp3 ps4lp2 ps4lp0
    ])

p5 :: Waterfall.Path
p5 = Waterfall.fromPath2D (Path2D.pathFrom2D ps5c1e
    [ Path2D.arcViaTo2D ps5c1m ps5c1s
    , Path2D.bezierTo2D ps5ls2 ps5ls3 ps5ls1
    , Path2D.arcViaTo2D ps5c2m ps5c2e
    , Path2D.bezierTo2D ps5lp3 ps5lp2 ps5lp0
    ])

lofter :: Solids.Solid
lofter = Transforms.mirror (V3 0 1 0) (Loft.loft
    [ (Transforms.translate (V3 0 0 ps1r) p1)
    , (Transforms.translate (V3 0 0 ps2r) p2)
    , (Transforms.translate (V3 0 0 ps3r) p3)
    , (Transforms.translate (V3 0 0 ps4r) p4)
    , (Transforms.translate (V3 0 0 ps5r) p5)
    ])

main :: IO ()
main = do
    Waterfall.writeSTEP "blade_stator.step" lofter
    Waterfall.SVG.writeDiagramSVG "blade_stator.svg" (Waterfall.solidDiagram (V3 0 0 1) (Waterfall.uScale 10 lofter ))
