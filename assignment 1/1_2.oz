local Drop Length in
   fun {Length Xs}
      if Xs==nil then 0 else 1+{Length Xs.2} end
   end	 
   fun {Drop Xs N}
      if N>{Length Xs} then nil
      elseif N=={Length Xs} then Xs
      elseif N<0 then Xs
      elseif N==0 then Xs
      else {Drop Xs.2 N}
      end
   end
   {Browse {Drop [1 2 3 4 5] 0}}
   {Browse {Drop [1 2 3 4 5] ~1}}
   {Browse {Drop [1 2 3 4 5] 3}}
    {Browse {Drop [1 2 3 4 5] 6}}
end
