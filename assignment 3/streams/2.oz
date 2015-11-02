declare AddStreams ProduceRandom Xs Ys Zs MultiplyStreams DivideStreams Ones PositiveIntegers  in

fun lazy {AddStreams Xs Ys}
   Xs.1+Ys.1 | {AddStreams Xs.2 Ys.2}
end

fun lazy {ProduceRandom }
  {Int.toFloat ({OS.rand} mod 100 ) } |{ProduceRandom}
end

fun lazy {MultiplyStreams Xs Ys}
   Xs.1*Ys.1 | {MultiplyStreams Xs.2 Ys.2}
end

fun lazy {DivideStreams Xs Ys}
   Xs.1/Ys.1 | {DivideStreams Xs.2 Ys.2}
end

%Xs={Int.toFloat  ({OS.rand} mod 100 ) }  | Xs

thread Xs = {ProduceRandom} end

Zs=Xs.1|{AddStreams Zs Xs.2}

Ones=1.0|Ones

PositiveIntegers=1.0| {AddStreams Ones PositiveIntegers}

thread Ys={DivideStreams Zs PositiveIntegers} end
{Browse {List.take Xs 3}}
{Browse {List.take Zs 3}}
{Browse {List.take Ys 3 } }