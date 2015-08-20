local ZipWith BinOp in
   fun{ZipWith BinOp Xs Ys}
      {BinOp Xs.1 Ys.1}|{ZipWith Xs.2 Ys.2}
   end
   {Browse {ZipWith fun {$ a b} a+b end [2 3 4] [7 8 0]}}
end