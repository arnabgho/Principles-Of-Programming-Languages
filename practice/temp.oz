local Factorial in
   fun {Factorial N Product}
      if N==1 then Product
      else {Factorial N-1 N*Product} end
   end
   {Browse {Factorial 5 1}}
end