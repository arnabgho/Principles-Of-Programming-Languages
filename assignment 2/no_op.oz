%local I O X in 
%   I = {NewCell a} {Browse @I}
%   {Assign I b}    {Browse @I}
%   {Assign I X}    {Browse @I}
%   X = 5*5          
%   {Exchange I O thread O+1 end} {Browse @I}
%end

%{Browse {NewName} }

%local I X in
%   I={NewCell 1|nil} {Browse @I}
%   {Assign I 2|2|nil} {Browse @I}
%   X=I {Browse @X}
%end

declare Dummy SemStack Driver No_Op Composition Handle  in
SemStack = {NewCell [ tuple(statements:[[nop] [nop] [nop]] environment:{NewCell nil}) ]}
Dummy = {NewCell 0}


fun {No_Op}
   {Browse @SemStack }
   SemStack:=(@SemStack).2
   {Browse @SemStack }
   Dummy:={Driver}
   nil
end

%{Browse @SemStack}
%{Browse {No_Op}}
%{Browse @SemStack}


fun {Handle Statements}
   SemStack:=[ tuple(statements:Statements environment:{NewCell nil}) ]
   nil
end



fun {Composition S1 S2 E}
   {Browse @SemStack }
   SemStack:=(@SemStack).2
   SemStack:=tuple(statements:S1 environment:{NewCell E})| tuple(statements:S2 environment:{NewCell E})  | SemStack
   {Browse @SemStack }
   Dummy:={Driver}
   nil
end

   

fun {Driver}
   local X S E in
      if @SemStack==nil then nil
      else
	 X=(@SemStack).1
	 S=X.statements
	 E=X.environment 
	 case S
	 of nop|nil then  {No_Op}
	 [] S1|S2 then  {Composition S1 S2 E}
	 end
      end
   end   
end

%{Handle  [ [nop] [nop] ]}
Dummy:={Driver}