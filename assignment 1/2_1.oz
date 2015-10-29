local ZipWith in
   fun{ZipWith BinOp Xs Ys}
      if Xs==nil then Ys
      elseif Ys==nil then Xs	 
      else {BinOp Xs.1 Ys.1}|{ZipWith BinOp Xs.2 Ys.2}
      end
   end
   {Browse {ZipWith fun {$ A B} A*B end [4] [7 8 ]}}
   {Browse {ZipWith fun {$ A B} A*B end nil [7 8 ]}}
end