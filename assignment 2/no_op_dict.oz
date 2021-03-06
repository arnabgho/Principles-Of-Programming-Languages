declare Dummy SemStack Driver No_Op Composition Handle  in
SemStack = {NewCell [ tuple(statements:[[nop] [nop] [nop]] environment:{Dictionary.new}) ]}
Dummy = {NewCell 0}


fun {No_Op}
   %{Browse @SemStack }
   SemStack:=(@SemStack).2
   (@SemStack).1
   %{Browse @SemStack }
   %{Driver}
end
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

fun {Variable_Dec Ident S E}
   SemStack:=(@SemStack).2
   {Dictionary.put E Ident random}
   SemStack:=tuple(statements:S environment:E)|@SemStack
   (@SemStack).1
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
	 [] localvar|ident(Ident)|S_bar then {Variable_Dec Ident S_bar E}|{Driver} 
	 [] S1|S2 then  {Composition S1 S2 E} |  {Driver}
	 end
      end
   end   
end

%{Handle  [ [nop] [nop] ]}
{Browse {Driver}}