declare Dummy Pop SemStack Driver No_Op Composition Handle Variable_Dec Variable_Bind  in
SemStack = {NewCell [tuple(statements:[[nop] [nop] [nop]] environment:{Dictionary.new})]}
Dummy = {NewCell 0}


fun {No_Op}
   %{Browse @SemStack }
   SemStack:=@SemStack.2
   @SemStack
   %{Browse @SemStack }
   %{Driver}
end


fun {Handle Statements}
   SemStack:=[tuple(statements:Statements environment:{Dictionary.new})]
   {Driver}
end

fun {Composition S1 S2 E}
   %{Browse @SemStack }
   SemStack:=@SemStack.2
   SemStack:=tuple(statements:S1 environment:E) | tuple(statements:S2 environment:E)  | @SemStack
   %{Browse @SemStack }
   @SemStack
   %{Driver}
end

fun {Variable_Dec Ident S E}
   SemStack:=@SemStack.2
   {Dictionary.put E Ident random}   %Change random?
   SemStack:=tuple(statements:S environment:E)|@SemStack
   @SemStack
end

fun {Variable_Bind IdentL IdentR E}
   SemStack:=@SemStack.2
   %Update Store
   @SemStack
end

fun {Pop}
   SemStack:=@SemStack.2
   @SemStack
end

fun {Driver}
   local X S E in
      if @SemStack==nil then nil
      else
	 X=@SemStack.1
	 S=X.statements
	 E=X.environment 
	 case S
	 of nil then {Pop}|{Driver}
	 [] nop|nil then  {No_Op}|{Driver}
	 [] localvar|ident(Ident)|S_bar then {Variable_Dec Ident S_bar E}|{Driver}
	 [] bind|ident(IdentL)|ident(IdentR) then {Variable_Bind IdentL IdentR E}|{Driver}
	 [] S1|S2 then  {Composition S1 S2 E}|{Driver}
	 end
      end
   end   
end

%{Handle  [ [nop] [nop] ]}
{Browse {Handle [[nop] [nop] [nop]]}}