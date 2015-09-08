declare
fun {MYLAST L}
   {Browse L}
   case L
   %of nil then nil   
   of X|nil then X
   else {MYLAST L.2}
   end
end


declare
fun {MYLAST_2 L}
   {Browse L}
   if L==nil then nil
   elseif L==(_|nil) then L.1
   else {MYLAST_2 L.2}
   end
end



{Browse {MYLAST [1 2 3] }}
      