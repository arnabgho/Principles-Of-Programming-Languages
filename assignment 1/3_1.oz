declare
fun {Sine X N Pow Sgn Fac }
   {Browse X}
   if N<6.5 then
      X*Pow*Sgn / Fac | {Sine X (N+1.0) (Pow*X*X) (~Sgn) (Fac*(2.0*N)*(2.0*N+1.0)) }
   else nil
   end
end


declare
fun {FoldR L B I}
   case L
   of nil then I
   [] H|T then {B H {FoldR T B I}}
   end 
end

declare
fun {Sum A B}
   A+B
end


{Browse {Sine 4.0 1.0 1.0 1.0 1.0}  }