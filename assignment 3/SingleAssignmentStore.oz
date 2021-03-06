declare KeyValueStore
KeyValueStore={Dictionary.new}
CurrentKey={NewCell 0}

declare
fun {ReturnRootKey Key}
   case KeyValueStore.Key
   of reference(X) then {ReturnRootKey X}
   else Key
   end
end

declare 
proc{BindValueToKeyInSAS Key Val}
   case {Dictionary.get KeyValueStore {ReturnRootKey Key}}
   of equivalence(X) then {Dictionary.put KeyValueStore X Val }
   [] X then  raise alreadyAssigned(Key Val X) end
   end
end

declare
proc {BindRefToKeyInSAS Key RefKey}
   local X Y in
      X={ReturnRootKey Key}
      Y={ReturnRootKey RefKey}
      {Dictionary.put KeyValueStore X reference(Y)}
   end
end

declare
fun {AddKeyToSAS}
   CurrentKey := @CurrentKey+1
   {Dictionary.put KeyValueStore @CurrentKey equivalence(@CurrentKey)}
   @CurrentKey
end

declare
fun {RetrieveFromSAS Key}
   case {Dictionary.member KeyValueStore Key}
   of false then raise keyNotFoundException(Key) end
   else {Dictionary.get KeyValueStore {ReturnRootKey Key}}
   end
end