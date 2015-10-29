\insert 'Unify.oz'
\insert 'Closure.oz'

declare MultiSemStack New_Thread IterateAdd Proc_Call Case Set Conditional Iterate Record Print Dummy Pop SemStack Driver No_Op Composition Handle Variable_Dec Variable_Bind  Value_Bind in
SemStack = {NewCell [tuple(statements:[[nop] [nop] [nop]] environment:{Dictionary.new})]}
MultiSemStack = {NewCell [tuple(statements:[[nop] [nop] [nop]] environment:{Dictionary.new})]}
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
      %{Browse {Dictionary.entries KeyValueStore}}
   end
end

proc {No_Op}
   SemStack:=@SemStack.2
   {Print}
end

proc {Composition S1 S2 E}
   SemStack:=@SemStack.2
   local NewDictX NewDictY in
      NewDictX={Dictionary.clone E}
      NewDictY={Dictionary.clone E}
      if S2 == nil then
	 SemStack:=tuple(statements:S1 environment:NewDictX) | @SemStack
      else
	 SemStack:=tuple(statements:S1 environment:NewDictX) | tuple(statements:S2 environment:NewDictY)  | @SemStack
      end
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
	 [] record|Rest then {Record X.1.2.1 E} {Iterate Y E}
	 else {Iterate Y E}
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
      of proceed then {Closure_Driver V.2.1 E V.2.2 Val} {BindValueToKeyInSAS E.Ident [V Val]} %{Unify ident(Ident) [V Val] E}
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

proc {IterateAdd Env FormalPara ActualPara E}
   case FormalPara
   of ident(U)|V then
      case ActualPara
      of ident(H)|T then {Dictionary.put Env U E.H} {IterateAdd Env V T E}
      [] O|P then {Dictionary.put Env U {AddKeyToSAS}} {Unify ident(U) O Env} {IterateAdd Env V P E} %raise improperParameters() end
      end
   [] nil then skip
   end
end

proc {Proc_Call Proc Args E}
   if {Dictionary.member E Proc} then
      local Proceed in
	 Proceed = {RetrieveFromSAS E.Proc}
         if Proceed.1.1 == proceed then
	    if {List.length Args} == {List.length Proceed.1.2.1} then
	       local Env in
		  Env = {Dictionary.clone Proceed.2.1}
		  {IterateAdd Env Proceed.1.2.1 Args E}    % Proceed.1.2.1 is the formal parameters of proceed
		  SemStack:=@SemStack.2
		  SemStack:=tuple(statements:Proceed.1.2.2 environment:Env) | @SemStack
	       end
	    else raise numberOfArgsDontMatch(Proc) end
	    end
         else raise invalidProc(Proc) end
         end
      end
   else raise noProcInEnvironment(Proc)	end
   end
end

proc {New_Thread S E}
   SemStack:=@SemStack.2
   MultiSemStack:=[tuple(statements:S environment:E)] | @MultiSemStack
end

proc {Driver}
   local X S E in
      if @SemStack==nil then
	 if @MultiSemStack==nil then skip
	 else
	    SemStack:=@MultiSemStack.1
	    MultiSemStack:=@MultiSemStack.2
	    {Driver}
	 end
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
	 [] bind|V|ident(Ident)|nil then {Value_Bind Ident V E} {Driver}
	 [] conditional|ident(Ident) | S1 | S2 then {Conditional Ident S1 S2.1 E} {Driver}
	 [] match|ident(Ident)|P|S1|S2 then {Case Ident P S1 S2 E} {Driver}
	 [] apply|ident(Ident)|S1 then {Proc_Call Ident S1 E} {Driver}
	 [] dhaaga|S1|ant|nil then {New_Thread S1 E} {Driver}
	 [] S1|S2 then  {Composition S1 S2 E} {Driver}
	 end
      end
   end   
end

proc {Handle Statements}
   MultiSemStack:=[[tuple(statements:Statements environment:{Dictionary.new})]]
   SemStack:=@MultiSemStack.1
   MultiSemStack:=@MultiSemStack.2
   SemStack:=[tuple(statements:Statements environment:{Dictionary.new})]
   {Print}
   {Driver}
end

{Handle [localvar ident(x) [localvar ident(y) [[dhaaga [bind ident(y) literal(10)] ant] [dhaaga [bind ident(x) literal(20)] ant]]]]}