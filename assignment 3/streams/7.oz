declare Barrier X Z in
proc{Barrier Procs}
   %{Browse 1}
   local BarrierLoop S in 
      fun {BarrierLoop Procs L}
	 case Procs
	 of Proc|Procr then M
	 in thread {Proc} M=L end
	    {BarrierLoop Procr M}
	 [] nil then L
	 end
      end
      S={BarrierLoop Procs unit}
      %S={BarrierLoop Procs Z}
      {Wait S}
      {Browse done}
   end
end

{Barrier [ proc {$} X=1 end
	   proc {$} {Browse X} end ] }

