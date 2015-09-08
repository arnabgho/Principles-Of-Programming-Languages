declare
fun {Compress L}
   case L
   of nil then nil
   [] H|nil then H|nil
   [] H1|H2|T then
      if H1==H2 then  {Compress H2|T}
      else H1|{Compress H2|T}
      end
   end
end

{Browse {Compress [1 1 2 2 3]}}

      
      