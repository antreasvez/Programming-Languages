local
fun delete_Xes (Node, List)=
    List.filter(fn x=> x <> Node)List
  
fun delete (List, location) =
    if location = [] then List
    else
	(delete(delete_Xes(hd location, List), tl location))

fun remove (Elem,List)=
    if List = [] then []
    else if Elem = hd List then remove(Elem,tl List)
    else hd List::remove(Elem,tl List)
		      
fun delete_dublicates (List) =
    if List = [] then []
    else
	let
	    val Hd = hd List
	    val Tl = tl List
	in	    
	     Hd::delete_dublicates(remove(Hd,Tl))
	end
							     
fun check_port (Time, time, A, t) =
    let
	val ports = map(fn x=> List.filter(fn y => y = x)t)A
	val concport = List.concat ports
    in
	if concport <> [] then (Array.update(Time, time+4, A); A)
	else []
    end 
   	    	    
fun spread (Time:int list array, time, locations, M, Len, Stop, Airport, A, N)= (*M must be M+1*)
    if time > 2*(N+M) then Time
    else if time mod 2 = 0 then 
    let
	val t = Array.sub(Time, time)
	val Newt = map(fn x => x+1)t@map(fn x => x-1)t@map(fn x => x+M)t@map(fn x => x-M)t
	val Newert = List.filter(fn x=> x >= 0)Newt	
	val T = delete(Newert, locations)
	val correct_t = delete_dublicates(T)
	val NewT = List.filter(fn x=> x < N*M)correct_t
	val NewLen = length t + length correct_t
    in
	(Array.update(Time, time+2, NewT);  spread(Time, time+1, locations, M, NewLen, Stop, Airport, A, N); Time)
    end
    else if Airport = [] then
	let
	    val t = Array.sub(Time, time-1)
	in
	    spread(Time, time+1, locations, M, Len, Stop, check_port(Time, time, A, t), A, N)
	end
	    else
		let
		    val Port = map(fn x => x+1)Airport@map(fn x => x-1)Airport@map(fn x => x+M)Airport@map(fn x => x-M)Airport
		    val Newport = List.filter(fn x=> x > 0)Port
		    val T = delete(Newport, locations)
		    val port = delete_dublicates(T)
		    val NewLen = length Airport + length port
		    val Port = List.filter(fn x=> x < N*M)port
		in
		    (Array.update(Time, time+4, Port); spread(Time, time+1, locations, M, NewLen, Stop, Port, A, N))
		end

fun sotiris_spread (Time:int list array, sotiris, Xes, dest, time, M, N, Sot:int list array) =
    if List.exists (fn x => x = dest)sotiris then (print(Int.toString(time)); print"\n"; time)
    else
	let
	    val t = Array.sub(Time, time+1)
	    val Newsotiris = map(fn x => x+1)sotiris@map(fn x => x-1)sotiris@map(fn x => x+M)sotiris@map(fn x => x-M)sotiris
	    val Sot1 = List.filter(fn x=> x >= 0)Newsotiris
	    val Sot2 = delete(Sot1, t)
	    val Sot3 = delete_dublicates(Sot2)
	    val Sot4 = List.filter(fn x=> x < N*M)Sot3
	    val Sot5 = delete(Sot4, Xes)	  
	in
	    if Sot5 = [] then (Array.update(Sot,time, []); print"IMPOSSIBLE"; time+1)
	    else
	    ((*map(fn x=> (print(Int.toString(x)); print" "))Sot5; print"\n"; map(fn x=> (print(Int.toString(x)); print" "))t; print"\n";*) Array.update(Sot,time+1,Sot5); sotiris_spread(Time, Sot5, Xes, dest, time+1, M, N, Sot))
	end
    		    
fun readlist file =
    let
	val ins = TextIO.openIn file
        fun loop ins  = case TextIO.inputLine ins of 
                            SOME line => line :: loop ins
                          | NONE      => [] 
    in
	loop ins before TextIO.closeIn ins 
    end

fun find_Xes (String:string, Total:int, Node:int) = (* Total = N*M - 1 *) 
    if Total < 0 then []
    else 
	let
	    val ok:char = String.sub(String, Node)
	in
	    if ok  = #"X" orelse ok = #"\n" then Node::find_Xes(String, Total - 1, Node+1)
	    else find_Xes(String, Total - 1, Node+1)
	end
	    
fun find_A (String:string, Total:int, Node:int) = (* Total = N*M - 1 *) 
    if Total < 0 then []
    else 
	let
	    val ok:char = String.sub(String, Node)
	in
	    if ok  = #"A"  then Node::find_A(String, Total - 1, Node+1)
	    else find_A(String, Total - 1, Node+1)
	end
	    
fun find_S (String:string, Node:int) =
    let
	val Start:char = String.sub(String, Node)
    in
      if Start = #"S" then Node
      else find_S(String, Node+1)
    end

fun find_T (String:string, Node:int) =
    let
	val Start:char = String.sub(String, Node)
    in
      if Start = #"T" then Node
      else find_T(String, Node+1)
    end
	
fun find_Corona (String:string, Node:int) =
    let
	val Start:char = String.sub(String, Node)
    in
      if Start = #"W" then Node
      else find_Corona(String, Node+1)
    end

fun find_S (String:string, Node:int) =
    let
	val Start:char = String.sub(String, Node)
    in
      if Start = #"S" then Node
      else find_S(String, Node+1)
    end
	
fun add (Num,M)=
    if M = 0 then []
    else Num+M::add(Num,M-1)

fun final_Time (Time, Node, t) =
    if Node = 1000 then Time
    else
    let
	val t1 = Array.sub(Time, Node)@t
	val final_t = delete_dublicates(t1)
    in
	(Array.update(Time, Node, final_t); final_Time(Time, Node+1, final_t))
    end
	
fun find_path (Sot:int list array, M, moves, path, node) =
    if moves = 0 then (map(fn x=> print(x))path; ())
    else
	let
	    val temp1 = Array.sub(Sot, moves-1)
	in
	    if temp1 = [] then ()
	    else if List.exists(fn x=> x = node+M)temp1 then find_path(Sot, M, moves-1, "U"::path, node+M)
	    else if List.exists(fn x=> x = node-1)temp1 then find_path(Sot, M, moves-1, "R"::path, node-1)
	    else if List.exists(fn x=> x = node+1)temp1 then find_path(Sot, M, moves-1, "L"::path, node+1)
	    else find_path(Sot, M, moves-1, "D"::path, node-M)
	end
in					  
fun stayhome file =
    let
	val List = readlist file
	val String = String.concat List
	val Hd = hd List
	val M = String.size Hd
	val N = length List
	val Xes = find_Xes(String, N*M-1, 0)
	val A = find_A(String, N*M-1, 0)
	val timeStop = length Xes + 1
	val Time:int list array = Array.array(1000,[])
	val W = find_Corona(String, 0)
	val S = find_S(String, 0)
	val T = find_T(String, 0)
	val Sot = Array.array(N*M, [])
    in
	(Array.update(Sot,0,[S]); Array.update(Time,0,[W]); spread(Time, 0, Xes, M, 1, M*N-timeStop, [], A, N); final_Time(Time, 1, [W]); find_path(Sot,M,sotiris_spread(Time, [S], Xes, T, 0, M, N, Sot),[],T); print"\n"; ())
    end
end	

(*map(fn x=>(print(Int.toString(x)); print" "))Xes; print"\n"; print(Int.toString(S)); print"\n"; print(Int.toString(T));*)