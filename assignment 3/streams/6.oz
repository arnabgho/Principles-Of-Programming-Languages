declare NSelect X1 X2  S1 S2 Length N AnySelected NumFalse NewList AllFalse  in

NumFalse={NewCell 0}

fun{Length List}
   case List
   of nil then 0
   [] X|Xs then 1+{Length Xs}   
   end
end


proc {NSelect List}
   case List
   of nil then skip
   [] X#S|Rest then
      thread
	 if {X==false}
	 then NumFalse:=@NumFalse+1 AnyDet=true
	    if NumFalse==N
	    then AllFalse=true
	    end
	 else if {IsDet AnySelected} then skip AnyDet=true
	      else {S} AnySelected=true AnyDet=true
	      end
	 end
      end
      {NSelect Rest}
   [] true#S|nil then
      thread
	 if AllFalse==true
	 then {S} AnySelected=true
	 end
      end
   end
   {Wait AnySelected}
end

N={Length NewList}-1

S1=true
{NSelect S1#S2}