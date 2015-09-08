declare Nop Handle in
fun {Nop S}
   2
end

fun {Handle S}
   case S
   of X|Xr then
      {Handle X}|{Handle Xr}
   [] nil then
      nil
   else case S
	of Nop then
	   {Nop S}
	end
   end
end

{Browse {Handle [[[Nop]][Nop]]}}