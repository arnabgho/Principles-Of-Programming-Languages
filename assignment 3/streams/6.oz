declare NSelect X1 X2  S1 S2 Length N AnySelected NumFalse in

NumFalse={NewCell 0}

fun{Length List}
   case List
   of nil then 0
   [] X|Xs then 1+{Length Xs}   
   end
end


proc {NSelect List}
   N={Length List}-1
   case List
   of nil then skip
   [] X#S|Rest then
      thread
	 if {X==false}
	 then NumFalse:=@NumFalse+1
	 else if {IsDet AnySelected} skip
	      else {S} AnySelected=true
	      end
	 end
      end
      {NSelect Rest}
   [] true#S then 
      
   end  
end

S1=true
{NSelect S1#S2}