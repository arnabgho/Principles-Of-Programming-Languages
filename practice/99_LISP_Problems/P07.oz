declare
fun {Flatten_my L}
   case L
   of H|T
      then 
      case H
      of H1|T1 then {Append {Append {Flatten_my [H1] } {Flatten_my [T1] } } {Flatten_my [T]} }
      else
	 H|{Flatten_my T}
      end
   else
      nil
end

%{Browse {Flatten_my [1 2 [1 2 [ 1 2 3]  3] 4]}}