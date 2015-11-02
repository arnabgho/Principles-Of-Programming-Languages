declare Barrier PrimesFrom IsPrime IsPrimeHelper IntsFrom MyFilter GetNDistinctNames Length  in
fun  {IntsFrom A}
   %{Browse A}
   A|{IntsFrom A+1}
end


fun {IsPrimeHelper X I}
   if I*I > X then true
   else
      if ((X mod I)==0) then false
      else {IsPrimeHelper X I+1}
      end
   end
end

fun {IsPrime X}
   if X<2 then false
   else
      if X==2 then true
      else {IsPrimeHelper X 2}
      end
   end
end

fun lazy {MyFilter MyFun X }
   case X of nil then nil
   [] H|T then
      if {MyFun H} then H|{MyFilter MyFun T}
      end
   end 
end   

fun {PrimesFrom A}
   local X Y in
      thread X={IntsFrom A} end
      thread Y={MyFilter IsPrime X} end 	 
      Y
   end
end

%{Browse {List.take {IntsFrom 2} 3 }}
%{Browse {IsPrime 6}}
%{ Browse {List.take  {PrimesFrom 2 } 3 } }
%{Browse {Or true false }}

%local X Y B in 
%    X = foo
%    {NewName Y}
%    B = true 
%    {Browse [X Y B]}
%end


%{Browse {List.length [1 2 3]}}

fun {GetNDistinctNames Res NumCreated N}
   if NumCreated==N then Res
   else
      local Y in
	 {NewName Y}
	 {GetNDistinctNames Y|Res NumCreated+1 N}
      end
   end
end

%local Xs X Y in
%   Xs={GetNDistinctNames nil 0 5 }
%   X=Xs.1
%   Y=Xs.2
%   {Browse X==Y }
%end


fun{Length Xs}
   case Xs of nil then 0
   [] H|T then 1+{Length T}
   end
end


local NVar Xs List Manage Z in
   %{Browse hi}
   Xs=[1 2 3]
   {Browse Xs}
   NVar={Length Xs}
   %NVar=3
   {Browse NVar}
   List={GetNDistinctNames nil 0 NVar }
   {Browse List}
   proc{Manage Xs List NumComplete N}
      {Browse NumComplete}
      {Browse List}
      {Browse {IsDet List.1}}
      if NumComplete==N-1 then thread List.1=Z end
      else
	 thread List.1=List.2.1 end
	 {Manage Xs List.2 NumComplete+1 N}
      end
   end

   {Manage Xs List 0 NVar}
   {Wait List.1}
   {Browse hello}
end

declare DP  Xd in
DP={Dictionary.new}
{DP.put 1 Xd=2 }
%{Browse Xd}

%thread {DP.get } end

declare Test P Q in 
proc{Test A}
   case A
   of X#Y then {Browse enjoy} {Browse X} {Browse Y}
   else {Browse A} 
   end
end

P=Q

{Test P#Q}

local X in
   X=true
   thread if X==false
	  then {Browse no}
	  else {Browse yes}
	  end
   end
   
end

	     