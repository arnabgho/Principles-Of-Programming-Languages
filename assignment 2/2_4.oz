\insert 'Unify.oz'

declare Print Dummy Pop SemStack Driver No_Op Composition Handle Variable_Dec Variable_Bind  Value_Bind in
SemStack = {NewCell [tuple(statements:[[nop] [nop] [nop]] environment:{Dictionary.new})]}
Dummy = {NewCell 0}

proc {Print}
   {Browse {@SemStack.1.statements}}
   %{Browse {Dictionary.entries @SemStack.1.environment}}
end

fun {No_Op}
   SemStack:=@SemStack.2
   {Print}
   %@SemStack
   1
end

fun {Handle Statements}
   SemStack:=[tuple(statements:Statements environment:{Dictionary.new})]
   {Print}
   1|{Driver}
end

fun {Composition S1 S2 E}
   SemStack:=@SemStack.2
   SemStack:=tuple(statements:S1 environment:E) | tuple(statements:S2 environment:E)  | @SemStack
   {Print}
   %@SemStack
   1
end

fun {Variable_Dec Ident S E}
   local X in
   	   X={AddKeyToSAS}
	   SemStack:=@SemStack.2
	   {Dictionary.put E Ident X}
	   SemStack:=tuple(statements:S environment:E)|@SemStack
	   %{Dictionary.get E Ident}  %Print the value in dict E corresponding to key Ident
           {Print}
           %@SemStack
      1
   end
end

fun {Variable_Bind IdentL IdentR E}
   SemStack:=@SemStack.2
   {Unify ident(IdentL) ident(IdentR) E}
   {Print}
   %@SemStack
   1
end

fun {Pop}
   SemStack:=@SemStack.2
   %@SemStack
   1
end

fun {Value_Bind Ident V E}
   {Unify ident(Ident) V E}
   %@SemStack
   {Print}
   1
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
	 [] bind|ident(IdentL)|ident(IdentR)|nil then {Variable_Bind IdentL IdentR E}|{Driver}
	 [] bind|ident(Ident)|V then {Value_Bind Ident V.1 E}|{Driver}
	 [] S1|S2 then  {Composition S1 S2 E}|{Driver}
	 end
      end
   end   
end

%{Browse {Handle [[nop] [nop] [nop]]}}
%{Browse {Handle [bind ident(x) ident(y)]}}
%{Browse {Handle [localvar ident(x) [localvar ident(y) [localvar ident(x) [nop]]]]}}
{Print}