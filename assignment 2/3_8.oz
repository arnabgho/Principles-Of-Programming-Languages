\insert 'Unify.oz'
\insert 'Closure.oz'

declare Case Set Conditional  Iterate Record Print Dummy Pop SemStack Driver No_Op Composition Handle Variable_Dec Variable_Bind  Value_Bind in
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
   if Val.1==record then 
      local X in
         X = Val.2.2.1    %Passing [[literal(feature1) ident(x1)] ... [literal(featuren) ident(xn)]] to Iterate
         {Iterate X E}
      end
   else
      skip
   end
end

proc {Value_Bind Ident V E}
   SemStack:=@SemStack.2
   local Val in
      case V.1 
      of record then {Record V E} {Unify ident(Ident) V E}
      [] proceed then Val = {Closure_Driver V.2.1 E V.2.2} {Unify ident(Ident) [V Val] E}
      else {Unify ident(Ident) V E} 
      end
   end
   {Print}
end

proc {Conditional Ident S1 S2 E}
   SemStack:=@SemStack.2
   if {Dictionary.member E Ident}==false
   then raise keyNotFoundEnvironmentException(Ident) end
   else
      case {RetrieveFromSAS E.Ident}
      of literal(true) then  SemStack:=tuple(statements:S1 environment:E) | @SemStack
      [] literal(false) then  SemStack:=tuple(statements:S2 environment:E) | @SemStack
      else raise keyNotBoundBoolean(Ident) end
      end
   end
   {Print}
end

proc {Set S E}
   SemStack:=tuple(statements:S environment:E) | @SemStack
   {Print}
end

proc {Case X P S1 S2 E}
   SemStack := @SemStack.2
   local E1 C in
      C = {NewCell 0}
      E1 = {Dictionary.clone E}
      {Record P E1}
      try {Unify P ident(X) E1} catch X then
	 C:=1
	 case X
	 of incompatibleTypes(A B) then
	    {Set S2 E}
	 [] alreadyAssigned(A B C) then
	 {Set S2 E}
	 end
      end
      if @C == 0 then {Set S1 E1} end
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
	 [] match|ident(X)|P|S1|S2 then {Case X P S1 S2 E} {Driver}
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

%{Handle [[nop] [nop] [nop]]}
%{Handle [bind ident(x) ident(y)]}
%{Handle [localvar ident(x) [localvar ident(y) [localvar ident(x) [nop]]]]}
%{Handle [localvar ident(x) [localvar ident(y) [bind ident(x) ident(y)]]]}
%{Handle [localvar ident(x) [localvar ident(y) [[bind ident(x) literal(100)] [bind ident(y) [record literal(a) [[literal(1) ident(x1)] [literal(2) ident(x2)]]]]]]]}
%{Handle [localvar ident(x) [localvar ident(y) [[bind ident(x) literal(100)] [bind ident(y) literal(200)]]]]}
%{Handle [localvar ident(x) [bind ident(x) literal(100)]]}
%{Handle [localvar ident(x) [localvar ident(y) [[bind ident(x) literal(100)] [bind ident(y) [record literal(a) [[literal(1) ident(x1)] [literal(2) ident(x2)]]]]]]]}
%{Handle [localvar ident(x) [localvar ident(y) [[bind ident(x) literal(100)] [bind ident(y) [record literal(a) [[literal(1) ident(x1)] [literal(2) ident(x2)]]]]]]]}
%{Handle [localvar ident(x) [localvar ident(y) [[bind ident(x) literal(true)] [conditional ident(x) [bind ident(y) literal(10)] [bind ident(y) literal(20)]]]]]}
%{Handle [localvar ident(x) [localvar ident(y) [[bind ident(y) [record literal(a) [[literal(1) ident(x1)] [literal(2) ident(x2)]]]] [match ident(y) [record literal(a) [[literal(1) ident(x3)] [literal(2) ident(x4)]]] [bind ident(x) literal(10)] [bind ident(x) literal(20)]]]]]}
%{Handle [localvar ident(x) [localvar ident(y) [[bind ident(x) literal(10)] [bind ident(x) ident(y)]]]]}
%{Handle [localvar ident(x) [bind ident(x) [proceed [y] [[nop]]]]]}
{Handle [localvar ident(x) [bind ident(x) [proceed [y] [bind ident(x) ident(y)]]]]}