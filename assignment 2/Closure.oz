declare MergeHelper Merge Closure Closure_Driver Closure_Driver_Helper Closure_Creator in
proc{MergeHelper Dict1 Xs Merged}   
   case Xs			    
   of nil then Merged=Dict1	    
   [] H|T then {Dictionary.put Dict1 H 1} {MergeHelper Dict1 T Merged}
   end				    
end				    
				    
fun{Merge Dict1 Dict2}
   local Xs Merged in
      Xs={Dictionary.items Dict2}
      {MergeHelper Dict1 Xs Merged}
      Merged
   end
end

proc {Closure Statements Closure_Env}
   case Statements
   of nil then Closure_Env={Dictionary.new}
   [] nop|nil then Closure_Env={Dictionary.new}
   [] localvar | ident(Ident) | S_bar then local X in  {Closure S_bar.1 X}  {Dictionary.remove X Ident} Closure_Env=X  end 
   [] bind | ident(IdentL) | ident(IdentR) | nil then Closure_Env={Dictionary.new} {Dictionary.put Closure_Env IdentL 1} {Dictionary.put Closure_Env IdentR 1} 
   [] bind | ident(Ident) | V then Closure_Env={Dictionary.new} {Dictionary.put Closure_Env Ident 1} 
   [] conditional | ident(Ident) | S1 | S2 then local X Y in {Closure S1 X} {Closure S2 Y} Closure_Env={Merge X Y}  end 
   [] match | ident(Ident) | P | S1 | S2 then local X Y in {Closure S1 X} {Closure S2 Y} Closure_Env={Merge X Y} {Dictionary.put Closure_Env Ident 1}  end
   [] S1 | S2 then local X Y in {Closure S1 X} {Closure S2 Y} Closure_Env={Merge X Y}  end
   else Closure_Env={Dictionary.new}  
   end	   			    
end				    

proc{Closure_Driver_Helper Arguments Closure_Env}
   case Arguments
   of nil then skip   
   [] H|T then {Dictionary.remove Closure_Env H} {Closure_Driver_Helper T Closure_Env}
   end   
end

proc{Closure_Creator Environment List_Closure_Env Closure_Result}
   case List_Closure_Env
   of H|T then if {Dictionary.member Environment H} then {Dictionary.put Closure_Result Environment.H} {Closure_Creator Environment T Closure_Result}
	       else raise keyNotFoundEnvironment(H) end
	       end
   [] nil then skip
   end
end


fun{Closure_Driver Arguments  Environment Statements }
   local Closure_Env Closure_Result in
      {Closure Statements Closure_Env}
      {Closure_Driver_Helper Arguments Closure_Env}
      Closure_Result={Dictionary.new}
      {Closure_Creator Environment {Dictionary.items Closure_Env} Closure_Result}
      Closure_Result
   end
end
