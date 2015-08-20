local Neg Mult Fact Sin in
fun {Neg Pow}
   if Pow==1 then 1
   else
      ~1*{Neg Pow-1}
   end
end
fun {Mult X Pow}
   if Pow==0 then 1
   else
      X*{Mult X Pow-1}
   end
end
fun {Fact Pow}
   if Pow == 1 then 1
   else
      Pow*{Fact Pow-1}
   end
end
fun {Sin X Ind}
   if Ind < 6 then
      (({Neg Ind}*{Mult X (Ind*2-1)}) div {Fact (2*Ind-1)}) | {Sin X Ind+1}
   else
      nil
   end
end
{Browse {Sin 2 1}}
end