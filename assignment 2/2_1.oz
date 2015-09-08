declare Nop Handle in
proc {Nop S}
   skip
end

proc {Handle S}
   case S
   of X|Xr then
      {Handle X}|{Handle Xr}
   [] nil then
      skip
   else case S
	of Nop then
	   {Nop S}
	end
   end
end
