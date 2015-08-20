local Factorial in
   fun {Factorial N}
      local Factorial_Aux in
	 fun {Factorial_Aux N cur}
	    if N==1 then cur else {Factorial_Aux N-1 cur*N} end
	 end
      {Factorial_Aux N 1}
   end
end
   
   
