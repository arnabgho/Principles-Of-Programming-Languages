declare
  %==========
  % Returns the factorial of N
  %==========
  fun {Factorial N}
     local FactorialAux in
         %===============
         % Auxiliary function - similar to while loop
  % in the C code. N is the number whose factorial
  % we need. Product is the cumulative product 
         %===============
         fun {FactorialAux N Product}
             if N == 0 
             then Product 
             else {FactorialAux N-1 N*Product}
         end
         %==============
         % Main function calls auxiliary with proper initial
         % values. Corresponds to Line 3 of the C code 
         %============= 
         {FactorialAux N 1} 
  end