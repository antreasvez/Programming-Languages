fun power(j) =
    if j > 0 then 2*power(j-1)
    else 1

fun find_power(number, j) =
    if j >= 29 then power(29)
    else
	if	    
	    let		
		val pow = power(j+1)			       
	    in		
		pow > number			  
	    end		
	then power(j)		  
	else find_power(number, j+1)
		       
fun print_pow (list,j,ammount) =
    if list = [] then print("")
    else
	let
	    val x::xs = list
	in
	    
	    if x = power(j) andalso xs <> [] then print_pow(xs,j,ammount+1)					   
	    else		
		if x = power(j) andalso xs = [] then (print(","); print(Int.toString(ammount+1)))		 
		else (print(","); print(Int.toString(ammount)); print_pow(x::xs,j+1,0))
	end
	    			 			     				     
fun actual_powers2 K1 K R list repeats =
    if K > 0 andalso R > 0
    then
	if R+1 = find_power(R+1,0)
	then actual_powers2 (K1) (K-1) (R - find_power(R+1,0)) (find_power(R+1,0)::list) (repeats+1)
	else  actual_powers2 (K1) (K-1) (R - find_power(R,0) + 1) (find_power(R,0)::list) (repeats+1)	    
    else
	if K = 0 andalso R > 0 then (print"[]"; [])
	else (print("["); print(Int.toString(K1-repeats));  print_pow(list,1,0); print("]"); [])
			
fun powers_2 (T,list) =
    if T > 0 then
	let	    
	    val N::ys = list			    
	    val K::xs = ys			    
	in    
	    if  N>=K then (actual_powers2 (K) (K) (N-K) [] (0); print"\n"; powers_2(T-1,xs))		      
	    else	
		(print("[]\n"); powers_2(T-1,xs))	    
	end
    else ()
	
fun parse file =
    let
	fun readInt input = 
	    Option.valOf (TextIO.scanStream (Int.scan StringCvt.DEC) input)
			
        val inStream = TextIO.openIn file
	val N = readInt inStream
	val _ = TextIO.inputLine inStream
	fun readInts 0 acc = acc
	  | readInts i acc = readInts(i-1)(acc@[readInt inStream])
    in
	(N::readInts (2*N) ([]))
    end

fun powers2 file =
    let
	val list = parse file
	val T::xs = list
    in
	powers_2(T,xs); ()
    end
	
			
	

    
				 
					      
