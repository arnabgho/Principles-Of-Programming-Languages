%{Browse 1|2|3|nil|nil}

functor
import
    Browser(browse:Browse)
    System(showInfo:Print)

define
    {Browse (5 mod 3) }
    {Print "Hello World in console"}
end



%{Browse 4 'mod' 3}
%local X in
%   X=1
%   {Browse  [X] }
%end
