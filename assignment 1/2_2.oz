local FoldR Map Twice Sum in
   fun{Twice A}
      2*A
   end
   fun{Sum A B}
      A+B
   end
   fun{FoldR BinaryFunction Xs Identity}
      case Xs
      of nil then Identity
      [] H|T then { BinaryFunction H {FoldR BinaryFunction T Identity}  }
      end
   end

   %{Browse {FoldR Sum [1 2 3] 0}}
   local NewBinaryFunction in
      fun{Map UnaryFunction Xs}
	 fun{NewBinaryFunction A B}
	    if B==nil then {UnaryFunction A}|nil
	    else {UnaryFunction A} |  B 
	    end
	 end
	 {FoldR NewBinaryFunction Xs nil}
      end
   end
   {Browse {Map Twice nil } }
end
