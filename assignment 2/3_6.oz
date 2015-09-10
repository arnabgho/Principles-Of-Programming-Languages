\insert 'Unify.oz'

declare Conditional  Iterate Record Print Dummy Pop SemStack Driver No_Op Composition Handle Variable_Dec Variable_Bind  Value_Bind in
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

proc {Iterate X E}
   local Y in
      case X
      of nil then
	 skip
      else
	 Y = X.2
         case X.1.2.1
         of ident(A) then
	    {Dictionary.put E A {AddKeyToSAS}}
	    {Iterate Y E}
         end
      end
   end
end

proc {Record Val E}
   local X in
      X = Val.2.2.1
      {Iterate X E}
   end
end

proc {Value_Bind Ident V E}
   SemStack:=@SemStack.2
   if V.1 == record then
      {Record V E}
   end
   {Unify ident(Ident) V E}
   {Print}
end

proc {Conditional Ident S1 S2 E}
   SemStack:=@SemStack.2
   if {Dictionary.member E Ident}==false
   then raise keyNotFoundEnvironmentException(Ident) end
   else
      case {RetrieveFromSAS E.Ident}
      of true then  SemStack:=tuple(statements:S1 environment:E) | @SemStack
      [] false then  SemStack:=tuple(statements:S2 environment:E) | @SemStack
      else raise keyNotBoundBoolean(Ident) end
      end
   end	 
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
	 [] conditional | ident(Ident) | S1 | S2 then {Conditional Ident S1 S2.1 E} {Driver} 
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
%{Handle [localvar ident(x) [localvar ident(y) [[bind ident(x) literal(100)] [bind ident(y) [record literal(a) [[literal(1) ident(x1)] [literal(2) ident(x2)]]]]]]]}
%{Handle [localvar ident(x) [localvar ident(y) [[bind ident(x) literal(100)] [bind ident(y) literal(200)]]]]}
%{Handle [localvar ident(x) [bind ident(x) literal(100)]]}
%{Handle [localvar ident(x) [localvar ident(y) [[bind ident(x) literal(100)] [bind ident(y) [record literal(a) [[literal(1) ident(x1)] [literal(2) ident(x2)]]]]]]]}
%{Browse {Dictionary.entries KeyValueStore}}
%{Handle [localvar ident(x) [localvar ident(y) [[bind ident(x) literal(100)] [bind ident(y) [record literal(a) [[literal(1) ident(x1)] [literal(2) ident(x2)]]]]]]]}

{Handle [conditional ident(x) s1 s2]}