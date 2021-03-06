declare RemoveDummy IterRecordAdd RecurAdd RecordAdd ProcAdd MergeHelper Merge Closure Closure_Driver Closure_Driver_Helper Closure_Creator in
proc{MergeHelper Dict1 Xs}   
   case Xs			    
   of nil then skip	    
   [] H|T then {Dictionary.put Dict1 H 1} {MergeHelper Dict1 T}
   end				    
end				    
				    
proc{Merge Dict1 Dict2}        %Merges Dict2 to Dict1
   local Xs in
      Xs={Dictionary.keys Dict2}
      {MergeHelper Dict1 Xs}
   end
end

proc {IterRecordAdd S Closure_Env}
   local Y in
      case S
      of nil then skip
      else Y = S.2
	 case S.1.2.1
	 of ident(A) then {Dictionary.put Closure_Env A 1} {IterRecordAdd Y Closure_Env}
	 [] record|Rest then {RecordAdd S.1.2.1 Closure_Env} {IterRecordAdd Y Closure_Env}
	 else skip
	 end
      end
   end
end

proc {RecordAdd S Closure_Env}
   {IterRecordAdd S.2.2.1 Closure_Env}
end

proc {ProcAdd S Closure_Env}
   local X in
      {Closure S.2.2 X}
      {Closure_Driver_Helper S.2.1 X}
      {Merge Closure_Env X}
   end
end

proc {RecurAdd S Closure_Env}
   case S
   of nil then skip
   [] ident(H) then {Dictionary.put Closure_Env H 1}
   [] record|Rest then {RecordAdd S Closure_Env}
   [] proceed|Rest then {ProcAdd S Closure_Env}
   [] H|T then {RecurAdd H Closure_Env} {RecurAdd T Closure_Env}
   else skip
   end
end

proc {RemoveDummy Closure_Env Dummy}
   case Dummy
   of nil then skip
   [] H|T then {Dictionary.remove Closure_Env H} {RemoveDummy Closure_Env T}
   end
end

proc {Closure Statements Closure_Env}
   case Statements
   of nil then Closure_Env={Dictionary.new}
   [] nop|nil then Closure_Env={Dictionary.new}
   [] localvar | ident(Ident) | S_bar then local X in  {Closure S_bar X}  {Dictionary.remove X Ident} Closure_Env={Dictionary.clone X}  end 
   [] bind | ident(IdentL) | ident(IdentR) | nil then Closure_Env={Dictionary.new} {Dictionary.put Closure_Env IdentL 1} {Dictionary.put Closure_Env IdentR 1} 
   [] bind | ident(Ident) | V then Closure_Env={Dictionary.new} {Dictionary.put Closure_Env Ident 1}
      case V.1
      of record|Rest then {RecordAdd V.1 Closure_Env}
      [] proceed|Rest then {ProcAdd V.1 Closure_Env}
      else skip
      end
   [] bind | V | ident(Ident) | nil then Closure_Env={Dictionary.new} {Dictionary.put Closure_Env Ident 1}
      case V
      of record|Rest then {RecordAdd V Closure_Env}
      [] proceed|Rest then {ProcAdd V Closure_Env}
      else skip
      end
   [] conditional | ident(Ident) | S1 | S2 then local X Y in {Closure S1 X} {Closure S2 Y} {Merge X Y} Closure_Env={Dictionary.clone X} {Dictionary.put Closure_Env Ident 1}  end 
   [] match | ident(Ident) | P | S1 | S2 then local X Y in
						 {Closure S1 X} {Closure S2 Y} {Merge X Y} Closure_Env={Dictionary.clone X} {Dictionary.put Closure_Env Ident 1}
						 local Dummy in
						    Dummy={Dictionary.new}
						    case P
						    of record|Rest then {RecordAdd P Dummy}
						    [] ident(Ident3) then {Dictionary.put Dummy Ident3 1}
						    else skip
						    end
						    {RemoveDummy Closure_Env {Dictionary.keys Dummy}}
						 end
					      end
   [] apply|ident(Ident)|S then Closure_Env={Dictionary.new} {Dictionary.put Closure_Env Ident 1} {RecurAdd S Closure_Env}
   [] S1 | S2 then local X Y in {Closure S1 X} {Closure S2 Y} {Merge X Y} Closure_Env={Dictionary.clone X} end
   else Closure_Env={Dictionary.new}  
   end	   			    
end				    

proc{Closure_Driver_Helper Arguments Closure_Env}
   case Arguments
   of nil then skip   
   [] ident(H)|T then {Dictionary.remove Closure_Env H} {Closure_Driver_Helper T Closure_Env}
   end   
end

proc{Closure_Creator Environment List_Closure_Env Closure_Result}
   case List_Closure_Env
   of nil then skip
   [] H|T then if {Dictionary.member Environment H} then {Dictionary.put Closure_Result H Environment.H} {Closure_Creator Environment T Closure_Result}
	       else raise keyNotFoundEnvironment(H) end
	       end
   end
end


proc {Closure_Driver Arguments  Environment Statements Closure_Result}
   local Closure_Env in
      {Closure Statements Closure_Env}
      {Closure_Driver_Helper Arguments Closure_Env}
      Closure_Result={Dictionary.new}
      {Closure_Creator Environment {Dictionary.keys Closure_Env} Closure_Result}
   end
end
