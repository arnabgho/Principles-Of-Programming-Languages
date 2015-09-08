%{Browse @SemStack}
%{Browse {No_Op}}
%{Browse @SemStack}

%Days = {Dictionary.new}

fun {Handle Statements}
   SemStack:=[ tuple(statements:Statements environment:{Dictionary.new} ) ]
   %nil
end



fun {Composition S1 S2 E}
   %{Browse @SemStack }
   SemStack:=(@SemStack).2
   SemStack:=tuple(statements:S1 environment:E) | tuple(statements:S2 environment:E)  | @SemStack
   %{Browse @SemStack }
   (@SemStack).1
   %{Driver}
end

   

fun {Driver}
   local X S E in
      if @SemStack==nil then nil
      else
	 X=(@SemStack).1
	 S=X.statements
	 E=X.environment 
	 case S
	 of nop|nil then  {No_Op} | {Driver}
	 [] S1|S2 then  {Composition S1 S2 E} |  {Driver}
	 end
      end
   end   
end

%{Handle  [ [nop] [nop] ]}
{Browse {Driver}}