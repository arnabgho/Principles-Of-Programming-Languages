%{Browse {Reverse [1 2]}}

declare
fun {Listequal L1 L2 }
   {Browse L1}
   {Browse L2}
   case L1
   of nil
   then
      case L2
      of nil
      then true
      else false
      end
   [] H1|T1
      case L2
      of H2|T2
      then
	 if H1==H2 then {Listequal T1 T2}
	 else false
	 end
      else
	 false
      end
   else
      false
   end   
end

{Browse {Listequal [1 2 3] [1 2 3]}}