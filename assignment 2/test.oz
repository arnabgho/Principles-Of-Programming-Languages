


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



declare
fun {Pat X}
   case X
   of ident(N) then N
   else false
   end
end

{Browse {Pat ident(x) }}