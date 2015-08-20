local Factorial in
   fun {Factorial N}
      if N==0 then 1 else N*{Factorial N-1}end
   end
   {Browse {Factorial 5}}
end

	 