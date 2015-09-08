declare Nop Handle SemStack Init in
fun {Nop}
   nil
end

fun {Handle}
   case @SemStack
   of nil then
      nil
   else
      case @SemStack.1.statement
      of X|Xr then
	 SemStack := [tuple(statement:@SemStack.1.statement.1 environment:@SemStack.1.environment) tuple(statement:@SemStack.1.statement.2 environment:@SemStack.1.environment) @SemStack.2]
	 {Handle}
      [] Nop then
	 {Nop}
      end
   end
end

fun {Init S}
   SemStack = {NewCell [tuple(statement:S environment:{NewCell nil})]}
   {Handle}
end
