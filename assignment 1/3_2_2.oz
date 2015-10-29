local Sine SumEps ShowEps  Sin in
   fun lazy {Sine X N Pow Sgn Fac }
      X*Pow*Sgn / Fac | {Sine X (N+1.0) (Pow*X*X) (~Sgn) (Fac*(2.0*N)*(2.0*N+1.0)) }
   end

   fun {SumEps X Eps}
      if {Abs (X.1 - X.2.1)}<Eps then
	 X.1
      else
	 X.1+{SumEps X.2 Eps}
      end
   end

   fun {ShowEps X Eps}
      if {Abs (X.1 - X.2.1)}<Eps then
	 X.1|nil
      else
	 X.1|{SumEps X.2 Eps}
      end
   end
   fun {Sin X}
      {Sine X 1.0 1.0 1.0 1.0}
   end
   
   
   {Browse {SumEps {Sin ~1.57} 0.0001} }
   {Browse {ShowEps {Sin 0.5} 0.1} }
end
