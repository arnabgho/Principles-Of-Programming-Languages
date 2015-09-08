declare Nop Handle SemStack Init in
fun {Nop}
   {PopSemStack}
end

fun {Handle}
   case @SemStack.1
   of X|Xr then
      case Xr
      of environment then
	 case X
	 of U|V then
	    SemStack := [[@SemStack.1.1.1 @SemStack.1.2] [@SemStack.1.1.2 @SemStack.1.2] @SemStack.2]
	 [] Nop then
	    {Nop}
	 end
      else
	 SemStack := [[@SemStack.1.1 @SemStack.2] [@SemStack.1.2 @SemStack.2]]
      end
   end
end

fun {Init S}
   SemStack = {NewCell [S 0]}
   {Handle}
end

{Browse {Handle [[[Nop]][Nop]]}}