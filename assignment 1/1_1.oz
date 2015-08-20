local Take in
   fun {Take Xs N}
      if N==0 then nil
      elseif N<0 then nil	 
      elseif Xs==nil then nil	  
      else Xs.1|{Take Xs.2 N-1}
      end
   end
   {Browse {Take [1 2 3] 2}}
end