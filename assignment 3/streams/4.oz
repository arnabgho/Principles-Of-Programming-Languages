declare Append MyFilter PartitionLeft PartitionRight QuickSort  in 
fun lazy {MyFilter MyFun Xs}
   case Xs
   of nil then nil
   [] H|T then if {MyFun H}== true
	       then H|{MyFilter MyFun T}
	       else {MyFilter MyFun T}
	       end
   end    
end

fun lazy {PartitionLeft Xs Val}
   local Left  Leq in
      fun{Leq X}
	 {Or X<Val X==Val}
      end
      Left={MyFilter Leq Xs}
      Left
   end
end

fun lazy {PartitionRight Xs Val}
   local Right G in
      fun{G X}
	 X>Val
      end
      Right={MyFilter G Xs }
      Right
   end
end
 
fun lazy {Append Xs Ys}
   case Xs
   of nil then Ys
   [] H|T then H|{Append T Ys}
   end
end

fun lazy {QuickSort Xs}
   case Xs
   of nil then nil
   [] H|T then
      local Left Right Result in
	 Left={PartitionLeft T H}
	 Right={PartitionRight T H}
	 Result={Append {Append {QuickSort Left} [H]} Right  }
	 Result
      end
   end
end

{Browse {List.take { QuickSort [ 45 32 12 32 12 90 100]  }  7   }}
{Browse {List.take { QuickSort [ 45]  }  7   }}