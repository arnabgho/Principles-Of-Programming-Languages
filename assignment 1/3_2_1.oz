local Sine Sum Sin in
fun lazy {Sine X N Pow Sgn Fac }
    X*Pow*Sgn / Fac | {Sine X (N+1.0) (Pow*X*X) (~Sgn) (Fac*(2.0*N)*(2.0*N+1.0)) }
end

fun {Sum X N}
   if N == 1.0 then
      X.1
   else
      X.1+{Sum X.2 (N-1.0)}
   end
end

fun {Sin X}
    {Sine X 1.0 1.0 1.0 1.0}
end

{Browse {Sum {Sin ~1.57} 20.0} }
end