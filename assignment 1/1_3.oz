local Merge in
   fun {Merge Xs Ys}
      if Xs==nil then Ys
      elseif Ys==nil then Xs
      elseif Xs.1<Ys.1 then Xs.1|{Merge Xs.2 Ys}
      else Ys.1|{Merge Xs Ys.2}
      end
   end
   {Browse {Merge [1 2 3] [4 5] }}
   {Browse {Merge nil [4 5] }}
   {Browse {Merge nil nil }}
   {Browse {Merge [3 1 5] [4 2 6] }}
end
