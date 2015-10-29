declare As Bs Cs Ds Hamming Scale Merge  in

fun lazy {Scale Xs Val}
   case Xs
   of nil then nil
   [] H|T then Val*H|{Scale T Val}
   end   
end


fun lazy {Merge Xs Ys Zs}
   if Xs.1<Ys.1
   then
      if Xs.1<Zs.1
      then Xs.1|{Merge Xs.2 Ys Zs}
      else
	 if Xs.1==Zs.1
	 then Xs.1 | {Merge Xs.2 Ys Zs.2}
	 else Zs.1 | {Merge Xs Ys Zs.2}
	 end
      end
   else
      if Ys.1<Xs.1
      then
	 if Ys.1<Zs.1
	 then Ys.1|{Merge Xs Ys.2 Zs}
	 else
	    if Ys.1==Zs.1
	    then Ys.1 | {Merge Xs Ys.2 Zs.2}
	    else Zs.1 | {Merge Xs Ys Zs.2}
	    end
	 end
      else
	 if Xs.1==Ys.1
	 then
	    if Xs.1<Zs.1
	    then Xs.1 | {Merge Xs.2 Ys.2 Zs}
	    else
	       if Xs.1==Zs.1
	       then Xs.1 | {Merge Xs.2 Ys.2 Zs.2}
	       else
		  if Xs.1>Zs.1
		  then Zs.1| {Merge Xs Ys Zs.2}
		  end
	       end
	    end
	 end
      end
   end
end



Hamming=1|Ds
thread As={Scale Hamming 2} end
thread Bs={Scale Hamming 3} end
thread Cs={Scale Hamming 5} end
thread Ds={Merge As Bs Cs} end

{Browse {List.take Hamming 15 }}