% 0 indicates no one has won 1 indicates 'o' has won and 2 indicates 'x' has won  

declare
fun lazy {CheckDiagonals Grid}
   case Grid
   of
      (A1|A2|A3|nil) |  (B1| B2| B3|nil) |  (C1| C2| C3|nil) | nil  then
      if {And A1==o {And A1==B2 B2==C3}} then 1
      elseif {And A3==o {And A3==B2 B2==C1}} then 1
      elseif {And A1==x {And A1==B2 B2==C3}} then 2
      elseif {And A3==x {And A3==B2 B2==C1}} then 2
      else 0
      end
   end
end


declare
fun lazy {CheckRows Grid}
   case Grid
   of
      (A1|A2|A3|nil) |  (B1| B2| B3|nil) |  (C1| C2| C3|nil) | nil  then
      if {And A1==o  {And A1==A2 A2==A3}} then 1
      elseif  {And B1==o  {And B1==B2 B2==B3}} then 1
      elseif  {And C1==o  {And C1==C2 C2==C3}} then 1
      elseif {And A1==x  {And A1==A2 A2==A3}} then 2
      elseif  {And B1==x  {And B1==B2 B2==B3}} then 2
      elseif  {And C1==x  {And C1==C2 C2==C3}} then 2
      else 0	 
      end
   end   
end


declare
fun lazy {CheckColumns Grid}
   case Grid
   of
      (A1|A2|A3|nil) |  (B1| B2| B3|nil) |  (C1| C2| C3|nil) | nil  then
      if {And A1==o  {And A1==B1 B1==C1}} then 1
      elseif  {And A2==o  {And A2==B2 B2==C2}} then 1
      elseif  {And A3==o  {And A3==B3 B3==C3}} then 1
      elseif {And A1==x  {And A1==B1 B1==C1}} then 2
      elseif  {And A2==x  {And A2==B2 B2==C2}} then 2
      elseif  {And A3==x  {And A3==B3 B3==C3}} then 2
      else 0	 
      end
   end  
end

%{Browse {Or '1'=='1'  '2'=='2'} }

declare WhoWon
fun  {WhoWon Grid}
   if {Or {Or {CheckRows Grid}==1 {CheckColumns Grid}==1} {CheckDiagonals Grid}==1   } then o
   elseif  {Or {Or {CheckRows Grid}==2 {CheckColumns Grid}==2} {CheckDiagonals Grid}==2   } then x
   else draw
   end 
end


%{Browse  (1|2|3|nil) |  (1| 2| 3|nil) |  (1| 2| 3|nil) | nil }

{Browse {WhoWon [[x x s][o x s][o x x ]]  }}
{Browse {WhoWon [[x x o][x x o][x o o ]]  }}
{Browse {WhoWon [[s s s][s s o][s s s ]]  }}