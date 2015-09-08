%{Browse [[1 2 3] [1 2 3]]  }

declare
fun {Pack L Cur}
   case L
   of nil then nil
   [] _|nil then Cur
      %if Cur.1==H then {Append Cur H|nil}|nil
      %else Cur| (H|nil) |nil
      %end
   [] H1|H2|T then
      if H1==H2 then  {Pack H2|T {Append Cur H1|nil} }
      else Cur |{Pack H2|T H2|nil}
      end
   end
end

declare
fun {PackGen L}
   case L
   of H|T  then {Pack L L.1|nil}
   else nil
   end
end


{Browse {PackGen nil }}