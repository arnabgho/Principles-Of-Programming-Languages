declare
fun {Rep A B C M N}
   if N==1 then
      M|B|C|nil
   elseif N==2 then
      A|M|C|nil
   else
      A|B|M|nil
   end
end

declare
fun {Subset A M N}
   if N < 4 then
      {Rep A.1 A.2 A.3 M N} |  (A.4| A.5| A.6|nil) |  (A.7| A.8| A.9|nil) | nil
   elseif N < 7 then
      (A.1|A.2|A.3|nil) |  {Rep A.4 A.5 A.6 M N-3} |  (A.7| A.8| A.9|nil) | nil
   else
      (A.1|A.2|A.3|nil) |  (A.4| A.5| A.6|nil) |  {Rep A.7 A.8 A.9 M N-6} | nil
   end
end

declare
fun {Proc A M N}
   if N < 10 then
      if A.N == s then
	 {Subset A M N}|{Proc A M N+1}
      else
	 {Proc A M N+1}
      end
   else
      nil
   end
end

declare
fun {PredMove Grid M}
   case Grid
   of
      (A1|A2|A3|nil) |  (B1| B2| B3|nil) |  (C1| C2| C3|nil) | nil  then
         {Proc f(1:A1 2:A2 3:A3 4:B1 5:B2 6:B3 7:C1 8:C2 9:C3) M 1}
   end
end

{Browse {PredMove [[o o s][x o x][x o s]] o}}