local
fun halve nil = (nil, nil)
  | halve [a] = ([a], nil)
  | halve (a::b::cs) =
    let
	val(x, y) = halve cs
    in
	(a::x, b::y)
    end

fun merge ([], ys) = ys
  | merge(xs, []) = xs
  | merge(x::xs, y::ys) =
    if x < y then
	x::merge(xs, y::ys)
    else
	y::merge(x::xs, ys)

fun Mergesort [] = []
  | Mergesort [a] = [a]
  | Mergesort [a,b] = if a <= b then [a,b]
		      else [b,a]
  | Mergesort L =
            let val (M,N) = halve L
            in
              merge (Mergesort M, Mergesort N)
            end

fun Graph (N)=
    let 
	val adj:int list array = Array.array(N+1, [])
    in
	adj
    end

fun Add_Edge (node1, node2, adj)=
	let
	   val adj_node1 = Array.sub(adj, node1)
	   val adj_node2 = Array.sub(adj, node2)
	in
	  (Array.update(adj, node1, adj_node1@[node2]); Array.update(adj, node2, adj_node2@[node1]); adj)
	end
	    	
fun connected (visited:bool array, N, node) =
    if N > 1 andalso Array.sub(visited, node) = true then connected(visited, N-1, node+1)
    else if Array.sub(visited, node) = false then  false
    else true
	     
fun Find_Path (path:int list, parent:int array, last) =
    if path = [] then []
    else
	if Array.sub(parent,hd path) <> last then
	    let
	       val new_path = Array.sub(parent,hd path)::path
	    in
		Find_Path(new_path, parent,last)
	    end
	else path
	     
fun DFS (adj:int list array, visited:bool array, parent:int array, node,temp, path) =
    let
	val next_node = Array.sub(adj, node)
    in
	if next_node = [] then []
      else
      case Array.sub(visited,hd next_node) of
	  true => if hd next_node = temp then  (Array.update(adj,node,tl next_node); DFS(adj,visited,parent,node,temp,path))
		  else ( Array.update(parent,node, temp); Array.update(adj,node,tl next_node); DFS(adj,visited,parent,node,temp,[node]@path); [node]@path)
	| false => 
	  (Array.update(visited,1,true); Array.update(visited,hd next_node,true); Array.update(parent,node, temp); Array.update(adj, node, tl next_node); DFS(adj,visited,parent,hd next_node,node,path)@DFS(adj,visited,parent,node,temp,path))
    end
	

fun measure (adj:int list array, visited, node) =
    let
	val adj_lst = Array.sub(adj,node)
    in
	if adj_lst = [] then 0
	else 
	    if Array.sub(visited,hd adj_lst) = true then ( Array.update(adj,node,tl adj_lst); Array.update(visited,hd adj_lst,false); 1+measure(adj,visited,hd adj_lst)+measure(adj,visited,node))
	    else (Array.update(adj,node,tl adj_lst); measure(adj,visited, node))
    end
	 
fun run_path (adj:int list array, visited:bool array, path) =
    if path <> [] then
    (map (fn x=> Array.update(visited, x, false))path; map (fn x => measure(adj,visited, x))path)  
    else []
	     
fun last_node (path) =
    if path = [] then 0
    else 
	let
	    val tail = tl path
	    val last = hd tail
	in
	    last
	end
	    
fun run_corona (adj:int list array, N, copy_adj:int list array) =
    let
	val visited = Array.array(N+1,false)
	val parent = Array.array(N+1,0)
	val path =DFS(adj, visited, parent, 1, 0, [])
    in
	if connected(visited, N, 1)  andalso length path <> 3 then
	    let
		val last = last_node(path)
		val new_path = Find_Path(path,parent,last)
		val len = run_path (copy_adj,visited,new_path)
		val len2 = Mergesort len
		val len3 = tl len2
	    in		
		(print"CORONA "; print(Int.toString(length new_path)); print"\n";print(Int.toString(hd len2+1)); map(fn x=>print(print" "; Int.toString(x+1)))len3; print"\n" )
	    end
	else print("NO CORONA\n")
    end

		  
fun parse file =
    let
	fun readInt input = 
	    Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)
			
        val inStream = TextIO.openIn file
	val T = readInt inStream
	val _ = TextIO.inputLine inStream
	val adj_lst = Array.array(1, [])
        fun read_graphs (T)  =
	    if T = 0 then ()
	    else
	    let
		    val N = readInt inStream
		    val M = readInt inStream
		    val adj1 = Graph(N)
		    val adj2 = Graph(N)
		    fun read_nodes (M, adj1:int list array, adj2:int list array) =
			if M = 0 then ()
			else
			    let
				val node1 = readInt inStream
				val node2 = readInt inStream
			    in				
				(Add_Edge(node1,node2,adj1); Add_Edge(node1,node2,adj2); read_nodes(M-1, adj1, adj2))
			    end
	    in
		if M=N then (read_nodes(M,adj1,adj2); run_corona(adj1,N,adj2); read_graphs(T-1); ())
		else (read_nodes(M,adj1,adj2);print"NO CORONOA"; read_graphs(T-1); ())
	    end		    
    in
	read_graphs(T)
    end
in
fun coronograph file =
    let
	val list = parse file
    in
	()
    end

end
