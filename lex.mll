{}

let white = [ ' ' '\t' '\r' ]
let consonant = [ 'b' 'c' 'd' 'f' 'g' 'h' 'j' 'k' 'l' 'm' 'n' 'p' 'q' 'r' 's' 't' 'v' 'w' 'x' 'z' ]

rule t d p b = parse
  | ([^ ' ' '\n' '\r' '\t' ] as c1) "é" (consonant as c2)  
      { if not p then Buffer.add_string b "<p>" ;
	Buffer.add_char b c1 ;
	Buffer.add_string b "é&shy;" ; 
	Buffer.add_char b c2 ;
	t d true b lexbuf } 

  | "nv"
      { if not p then Buffer.add_string b "<p>" ;
	Buffer.add_string b "n&shy;v" ;
	t d true b lexbuf }

  | ([ ^ ' ' '\n' '\r' '\t'] as c) "sp" 
      { if not p then Buffer.add_string b "<p>" ;
	Buffer.add_char b c ;
	Buffer.add_string b "s&shy;p" ; 
	t d true b lexbuf }   

  | white * '\n' ( white | '\n' ) * '\n' 
      { if p then Buffer.add_string b "</p>" ;
	t false false b lexbuf } 

  | white * ( [ '?' '!' ':' ] as c ) 
      { if not p then Buffer.add_string b "<p>" ;
	Buffer.add_string b "&nbsp;" ;
	Buffer.add_char b c ;
	t d true b lexbuf }

  | white * "<<" white * 
      { if p then (
  	  Buffer.add_string b " &laquo;&nbsp;" ;
	  t d p b lexbuf
	) else (
  	  Buffer.add_string b "<p class=ds>&laquo;&nbsp;" ;
	  t true true b lexbuf
        ) }

  | white * "---" white * 
      { if d then Buffer.add_string b "</p><p class=d>&mdash;&nbsp;" 
	else Buffer.add_string b "&mdash;" ;
	t d p b lexbuf }
	
  | ('\n' | white) * ">>" white * 
      { if d then ( 
          Buffer.add_string b "&nbsp;&raquo;</p>" ;
          t false false b lexbuf
        ) else (
	  Buffer.add_string b "&nbsp;&raquo; " ;
	  t d p b lexbuf
        ) }

  | ('\n' | white +) 
      { if p then Buffer.add_char b ' ' ;
	t d p b lexbuf }

  | _ as c 
      { if not p then Buffer.add_string b "<p class=t>" ;
	Buffer.add_char b c ;
	t d true b lexbuf }

  | eof 
      { if p then Buffer.add_string b "</p>" }

{
  let clean lexbuf = 
    let b = Buffer.create 1024 in  
    t false false b lexbuf ; 
    Buffer.contents b
}
