declare FibsFrom X in 
fun {FibsFrom A B}           % A < B
     A+B | {FibsFrom B A+B}
end
thread X =  {FibsFrom 0 1} end

{Browse true}
{Browse {List.take X 10}}