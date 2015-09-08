declare
fun {GCD A B}
   if A==0 then B
   else {GCD (B mod A) A}
   end
end

declare
fun {Coprime A B}
   {GCD A B}==1
end

declare
fun {PhiHelp M Cur}
  % {Browse M }
  % {Browse Cur}
   case Cur
   of 1 then 1
   else
      if {Coprime M Cur}==true then 1+{PhiHelp M Cur-1}
      else {PhiHelp M Cur-1}
      end
   end
end


declare
fun {Phi M}
   {PhiHelp M M}
end

{Browse answer}
{Browse {Phi 10}}

%{Browse {Coprime 31 14}}
