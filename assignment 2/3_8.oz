\insert 'Unify.oz'
\insert 'Closure.oz'

declare IterateAdd Proc_Call Case Set Conditional  Iterate Record Print Dummy Pop SemStack Driver No_Op Composition Handle Variable_Dec Variable_Bind  Value_Bind in
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

proc {Value_Bind Ident V E}
   SemStack:=@SemStack.2
   local Val in
      case V.1 
      of proceed then Val = {Closure_Driver V.2.1 E V.2.2} {BindValueToKeyInSAS E.Ident [V Val]} %{Unify ident(Ident) [V Val] E}
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
   case ActualPara
   of ident(H)|T then
      case FormalPara
      of ident(U)|V then {Dictionary.put Env U E.H} {IterateAdd Env V T E}
      else raise improperParameters() end
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
	 [] match|ident(Ident)|P|S1|S2 then {Case Ident P S1 S2 E} {Driver}
	 [] apply|ident(Ident)|S then {Proc_Call Ident S E} {Driver}
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
%{Handle [localvar ident(x) [bind ident(x) [proceed [ident(y)] [bind ident(y) ident(x)]]]]}
%{Handle [localvar ident(z) [
%			    [localvar ident(x) [
%						[localvar ident(t)
%						 [bind ident(t) literal(10)]
%						 [
%					          [bind ident(x) [proceed [ident(y)] [bind ident(y) ident(t)]]]
%						 ]
%						]
%						[apply ident(x) ident(z)]
%					       ]
%			    ]
%			   ]
%	]
%}

%{Handle [localvar ident(x)
% [[localvar ident(y)
%   [[localvar ident(x)
%     [[bind ident(x) ident(y)]
%      [bind ident(y) literal(true) ]
%      [conditional ident(y) [nop]
%       [bind ident(x) literal(true)]]]]
%    [bind ident(x) literal(35)]]]]]
%}

%{Handle [localvar ident(x)
%	 [bind ident(x) literal(10)]
%	 [bind ident(x) literal(10)]
%	]
% }

%{Handle [localvar ident(foo)
%  [localvar ident(result)
%   [[bind ident(foo) literal(true)]
%    [conditional ident(foo) [ bind ident(result) literal(true)]
%     [bind ident(result) literal(false)]]
%    [bind ident(result) literal(false)]]]]
%}

%{Handle [localvar ident(foo)
%  [localvar ident(result)
%   [[bind ident(foo) literal(false)]
%    [conditional ident(foo) [bind ident(result) literal(true)]
%     [bind ident(result) literal(false)]]
%    [bind ident(result) literal(false)]]]]
%}

%{Handle [localvar ident(x)
%	 [localvar ident(p)[localvar ident(q) [ bind ident(p) literal(1)] [bind ident(q) literal(2)]
% [[bind ident(x)
%   [proceed [ident(y) ident(x)] [nop]]]]
%	 [apply ident(x) ident(p) ident(q)]]]]
%}

%[localvar ident(x)
% [[bind ident(x)
%   [proceed [ident(y) ident(x)] [nop]]]
%  [apply ident(x)
%   literal(1)
%   [record literal(label) [literal(f1) literal(1)]]]]]

%{Handle [localvar ident(x)
% [localvar ident(y)
%  [localvar ident(z)
%   [[bind ident(x)
%     [record literal(label)
%      [[literal(f1) ident(y)]
%      [literal(f2) ident(z)]]]]
%    [bind ident(x)
%     [record literal(label) [[literal(f1) literal(2)] [literal(f2) literal(1)]]]]]]]]}

%{Handle [localvar ident(foo)
%  [localvar ident(bar)
%   [[bind ident(foo) [record literal(person) [[literal(name) ident(bar)]]]]
%    [bind ident(bar) [record literal(person) [[literal(name) ident(foo)]]]]
%    [bind ident(foo) ident(bar)]]]]}  %Infinite loop??

{Handle [localvar ident(foo)
  [localvar ident(bar)
   [[bind ident(foo) [record literal(person) [[literal(name) ident(foo)]]]]
    [bind ident(bar) [record literal(person) [[literal(name) ident(bar)]]]]
    [bind ident(foo) ident(bar)]]]]}