declare Xs Ys  DivideStreams Temp  Ones PositiveIntegers AddStreams MultiplyStreams   in
fun lazy {AddStreams Xs Ys}
   Xs.1+Ys.1 | {AddStreams Xs.2 Ys.2}
end


fun lazy {MultiplyStreams Xs Ys}
   Xs.1*Ys.1 | {MultiplyStreams Xs.2 Ys.2}
end

fun lazy {DivideStreams Xs Ys}
   Xs.1/Ys.1 | {DivideStreams Xs.2 Ys.2}
end

Ones=1.0|Ones

PositiveIntegers=1.0| {AddStreams Ones PositiveIntegers}

Temp=PositiveIntegers.1|{AddStreams Temp PositiveIntegers.2}

Xs={Int.toFloat ({OS.rand} mod 100 )}  | Xs

Ys=Ys

{Browse {List.take Xs 10}}