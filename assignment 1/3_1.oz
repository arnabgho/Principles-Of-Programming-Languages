declare
fun {Sine X N Pow Sgn Fac }
   {Browse X}
   if N<6.5 then
      X*Pow*Sgn / Fac | {Sine X (N+1.0) (Pow*X*X) (~Sgn) (Fac*(2.0*N)*(2.0*N+1.0)) }
   else nil
   end
end

{Browse {Sine 4.0 1.0 1.0 1.0 1.0}  }

%  + Sine{X N+1 Pow*X*X ~Sgn Fac*(2*N)*(2*N+1) 

{Browse 1.0}