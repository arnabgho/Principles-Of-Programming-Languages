local FoldL FoldLCont Sum in
   fun{Sum A B}
      A+B
   end
   
   fun{FoldLCont B Xs Identity}
      if Xs.2 == nil then Xs
      else
	 {FoldLCont B {B Xs.1 Xs.2.1}|Xs.2.2 Identity}
      end
   end
   fun{FoldL B Xs Identity}
      if Xs==nil then Identity
      else{FoldLCont B {B Identity Xs.1}|Xs.2 Identity}
      end 
   end
   {Browse{FoldL Sum  nil 0}}
   {Browse{FoldL Sum  [2 3 5] 0}}
end