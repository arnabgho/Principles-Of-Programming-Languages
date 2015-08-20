local FoldL FoldLCont in
   fun{FoldLCont B Xs Identity}
      if Xs.2 == nil then Xs
      else
	 {FoldLCont B {B Xs.1 Xs.2.1}|Xs.2.2 Identity}
      end
   end
   fun{FoldL B Xs Identity}
      {FolDLCont B {B Identity Xs.1}|Xs.2 Identity}
   end
   {Browse {$ A B} A+B end 0}
end