\insert 'Unify.oz'

declare Print Dummy Pop SemStack Driver No_Op Composition Handle Variable_Dec Variable_Bind  Value_Bind in
SemStack = {NewCell [tuple(statements:[[nop] [nop] [nop]] environment:{Dictionary.new})]}
Dummy = {NewCell 0}

proc {Print}
   if @SemStack == nil then
      {Browse emptyStack}
      {Browse storeIsBelow}
      {Browse {Dictionary.entries KeyValueStore}}
   else
      %{Browse @SemStack}
      {Browse @SemStack.1.statements}
      {Browse {Dictionary.entries @SemStack.1.environment}}
   end
end

proc {No_Op}
   SemStack:=@SemStack.2
   {Print}
end

proc {Composition S1 S2 E}
   SemStack:=@SemStack.2
   if S2 == nil then
      SemStack:=tuple(statements:S1 environment:E) | @SemStack
   else
      SemStack:=tuple(statements:S1 environment:E) | tuple(statements:S2 environment:E)  | @SemStack
   end
   {Print}
end

proc {Variable_Dec Ident S E}
   local X in
   	   X={AddKeyToSAS}
	   SemStack:=@SemStack.2
	   {Dictionary.put E Ident X}
	   SemStack:=tuple(statements:S environment:E)|@SemStack
           {Print}
   end
end

proc {Variable_Bind IdentL IdentR E}
   SemStack:=@SemStack.2
   {Unify ident(IdentL) ident(IdentR) E}
   {Print}
end

proc {Pop}
   SemStack:=@SemStack.2
   {Print}
end

proc {Value_Bind Ident V E}
   {Unify ident(Ident) V E}
   {Print}
end

proc {Driver}
   local X S E in
      if @SemStack==nil then skip
      else
	 X=@SemStack.1
	 S=X.statements
	 E=X.environment 
	 case S
	 of nil then {Pop} {Driver}
	 [] nop|nil then  {No_Op} {Driver}
	 [] localvar|ident(Ident)|S_bar then {Variable_Dec Ident S_bar E} {Driver}
	 [] bind|ident(IdentL)|ident(IdentR)|nil then {Variable_Bind IdentL IdentR E} {Driver}
	 [] bind|ident(Ident)|V then {Value_Bind Ident V.1 E} {Driver}
	 [] S1|S2 then  {Composition S1 S2 E} {Driver}
	 end
      end
   end   
end

proc {Handle Statements}
   SemStack:=[tuple(statements:Statements environment:{Dictionary.new})]
   {Print}
   {Driver}
end

%{Browse {Handle [[nop] [nop] [nop]]}}
%{Browse {Handle [bind ident(x) ident(y)]}}
%{Handle [localvar ident(x) [localvar ident(y) [localvar ident(x) [nop]]]]}
%{Handle [localvar ident(x) [localvar ident(y) [bind ident(x) ident(y)]]]}
{Handle [localvar ident(x) [localvar ident(y) [[bind ident(x) literal(100)] [bind ident(y) [record literal(a) [[literal(1) ident(x1)] [literal(2) ident(x2)]]]]]]]}