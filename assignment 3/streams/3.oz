declare Append in 
fun lazy {Append Xs Ys}
   case Xs
   of nil then Ys
   [] H|T then H|{Append T Ys}
   end
end

{Browse {List.take {Append [1 2 3] [4 5 6] } 6  }  }