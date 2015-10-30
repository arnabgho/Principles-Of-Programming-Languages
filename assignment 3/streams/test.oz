declare PrimesFrom IsPrime IsPrimeHelper IntsFrom MyFilter  in

fun  {IntsFrom A}
   %{Browse A}
   A|{IntsFrom A+1}
end


fun {IsPrimeHelper X I}
   if I*I > X then true
   else
      if ((X mod I)==0) then false
      else {IsPrimeHelper X I+1}
      end
   end
end

fun {IsPrime X}
   if X<2 then false
   else
      if X==2 then true
      else {IsPrimeHelper X 2}
      end
   end
end

fun lazy {MyFilter MyFun X }
   case X of nil then nil
   [] H|T then
      if {MyFun H} then H|{MyFilter MyFun T}
      end
   end 
end   

fun {PrimesFrom A}
   local X Y in
      thread X={IntsFrom A} end
      thread Y={MyFilter IsPrime X} end 	 
      Y
   end
end

%{Browse {List.take {IntsFrom 2} 3 }}
%{Browse {IsPrime 6}}
%{ Browse {List.take  {PrimesFrom 2 } 3 } }
{Browse {Or true false }}