declare MergeHelper Merge Closure in
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
