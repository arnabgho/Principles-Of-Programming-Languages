local Sine Sin in
   fun lazy {Sine X N Pow Sgn Fac }
      X*Pow*Sgn / Fac | {Sine X (N+1.0) (Pow*X*X) (~Sgn) (Fac*(2.0*N)*(2.0*N+1.0)) }
   end
   
   fun {Sin X}
      {Sine X 1.0 1.0 1.0 1.0}
   end

   {Browse {Sin 0.5}}
end