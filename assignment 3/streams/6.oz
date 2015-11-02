declare NSelect NSelectLoop  X X1 X2  S1 S2 Length N AnySelected NumFalse NewList AllFalse AnyDet in

NumFalse={NewCell 0}

AnySelected={NewCell 0}

fun{Length List}
   case List
   of nil then 0
   [] X|Xs then 1+{Length Xs}   
   end
end


proc {NSelect List}
   %{Browse List}
   N={Length List}-1
   {Browse N}
   proc{NSelectLoop List}
      case List
      of nil then skip
      [] X#S|Rest then
	 {Browse enjoy}
	 thread
	    {Browse @AnySelected}
	    if X==false
	    then NumFalse:=@NumFalse+1 AnyDet=true
	       if @NumFalse==N
	       then AllFalse=true
	       end
	    else
	       if X==true then
		  if  @AnySelected==1 then AnyDet=true
		  else {S} AnySelected:=1 AnyDet=true
		  end
	       else
		  if X==hrue then
		     if AllFalse==true
		     then {S} AnySelected:=1
		     end
		  end
	       end
	    end
	 end
	 {NSelectLoop Rest}
      [] hrue#S|nil then
      	 thread
      	    if AllFalse==true
	    then {S} AnySelected:=1
	    end
	 end   
      end
   end
   {NSelectLoop List}
   {Wait AnyDet}
   {Browse hello}
end


%NewList=[ X1#proc {$} X=1 end
%	  X2#proc {$} {Browse X} end  true#proc {$} {Browse default} end ]

NewList=[ X1#proc {$} {Browse thread1} end
	  X2#proc {$} {Browse thread2} end
	  hrue#proc {$} {Browse default} end ]


%N={Length NewList}-1

{Browse NewList}

%X1=true
%X2=true
%X1=false
%X1=false
%X1=true
%X1=false
X1=true
X2=true
{NSelect NewList}