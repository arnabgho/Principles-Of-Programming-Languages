local Tuple Tuple2 I J K in
   Tuple = tuple(one:I two:J three:K)
   I = testi
   J = testj
   K = testk
   Tuple2 = tuple(I J K)
   {Browse [Tuple Tuple2]}
   {Browse [Tuple2.2 Tuple.two]}
end

