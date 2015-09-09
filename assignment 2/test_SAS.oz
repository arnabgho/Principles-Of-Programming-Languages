\insert 'SingleAssignmentStore.oz'

local X in
   X={AddKeyToSAS}
   {Browse X}
   {Browse {RetrieveFromSAS X }}
   Y={AddKeyToSAS}
   {BindRefToKeyInSAS X Y}
   {Browse KeyValueStore.X  }
   {Browse KeyValueStore.Y }
end
