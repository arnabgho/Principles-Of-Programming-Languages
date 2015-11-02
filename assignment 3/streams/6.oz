declare NSelect X X1 X2  S1 S2 Length N AnySelected NumFalse NewList AllFalse AnyDet in

NumFalse={NewCell 0}

fun{Length List}
   case List
   of nil then 0
   [] X|Xs then 1+{Length Xs}   
   end
end


proc {NSelect List}
   %{Browse List}
   case List
   of nil then skip
   [] true#S|nil then {Browse S}
      thread
	 if AllFalse==true
	 then {S} AnySelected=true
	 end
      end   
   [] X#S|Rest then {Browse S}
      thread
	 if X==false
	 then NumFalse:=@NumFalse+1 AnyDet=true
	    if @NumFalse==N
	    then AllFalse=true
	    end
	 else if {IsDet AnySelected} then AnyDet=true
	      else {S} AnySelected=true AnyDet=true
	      end
	 end
      end
      {NSelect Rest}
   end
   {Wait AnyDet}
   {Browse hello}
end


%NewList=[ X1#proc {$} X=1 end
%	  X2#proc {$} {Browse X} end  true#proc {$} {Browse default} end ]

NewList=[ X1#proc {$} {Browse thread1} end
	  X2#proc {$} {Browse thread2} end
	  true#proc {$} {Browse default} end ]


N={Length NewList}-1

{Browse NewList}

X1=true
X2=true
{NSelect NewList}