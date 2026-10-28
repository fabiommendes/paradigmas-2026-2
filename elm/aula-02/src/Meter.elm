module Meter exposing (Distance, meters, km, miles, inMeters, sum, changeScale)

type Distance = InMeters Float

meters : Float -> Distance
meters x = InMeters x

km : Float -> Distance
km = (*) 1000 >> meters

miles : Float -> Distance
miles = (*) 1200 >> meters -- approx.

inMeters : Distance -> Float
inMeters (InMeters x) = x


--- operacoes
sum : Distance -> Distance -> Distance
sum (InMeters x) (InMeters y) = InMeters (x + y)


changeScale : Float -> Distance -> Distance
changeScale scale (InMeters value) =
    InMeters (scale * value)