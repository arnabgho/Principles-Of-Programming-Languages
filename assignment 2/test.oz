


%declare X in
%X={NewCell [1 2 3] }

%{Browse @X}

declare
fun {Test}
   local X in
      X=2
   end
   2
end

{Browse {Test}}

local Tuple I Jin
   Tuple = tuple(statements:I environment:J)
   I=[[nop] [nop]]
   J=nil
   {Browse Tuple.statements}
end

