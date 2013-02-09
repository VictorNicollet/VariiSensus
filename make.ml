let generate_words () = 

  let count_for name counter =

    let count = Hashtbl.create 1000 in

    counter count ; 

    let list = List.sort (fun (_,a) (_,b) -> compare b a)
      (Hashtbl.fold (fun k v acc -> (k,v) :: acc) count []) in

    let total = List.fold_left (fun acc (_,a) -> acc + a) 0 list in

    Printf.printf "==== %s - %d words - spread factor %f ====\n" name total 
      (float_of_int (List.length list) /. float_of_int total) ;

    List.iter (fun (word, count) ->
      Printf.printf "%3d (%2d%%) %s\n" count (count * 100 / total) word) list ;

    print_newline () 

  in

  count_for "All" (fun count -> 
    List.iter (fun (path,_) -> 
      let chan = open_in ("chapters/" ^ path) in 
      let lexbuf = Lexing.from_channel chan in 
      Lex.words count lexbuf 
    ) All.all 
  ) ;

  List.iter (fun (path,name) ->
    count_for name (fun count -> 
      let chan = open_in ("chapters/" ^ path) in 
      let lexbuf = Lexing.from_channel chan in 
      Lex.words count lexbuf 
    )
  ) All.all 

let body path = 
  let chan = open_in path in 
  let lexbuf = Lexing.from_channel chan in 
  Lex.clean lexbuf 

let index path last = 
 "<!DOCTYPE html>
<html>
<head>
  <meta http-equiv=\"Content-Type\" value=\"text/html; charset=UTF-8\"/>
  <meta property=\"og:title\" content=\"Varii Sensus\"/>
  <meta property=\"og:type\" content=\"book\"/>
  <meta property=\"og:url\" content=\"http://nicollet.net/book/\"/>
  <meta property=\"og:image\" content=\"http://nicollet.net/book/cliff-thumb.png\"/>
  <meta property=\"og:site_name\" content=\"Varii Sensus\"/>
  <meta property=\"fb:admins\" content=\"517629600\"/>
  <link href='http://fonts.googleapis.com/css?family=Francois+One' rel='stylesheet' type='text/css'>
  <link href='http://fonts.googleapis.com/css?family=Open+Sans' rel='stylesheet' type='text/css'>  
  <link rel=stylesheet href=\"http://nicollet.net/book/style.css\"/>
  <title>Varii Sensus</title>
</head>
<body>
  
    <center style=\"margin-top: 150px\">
      <h1 style=\"font-size:2.5em\">Varii Sensus</h1>
      <div class=\"navig\" style=\"float:none;text-align:center\">
	<a href=\"http://nicollet.net/book/"^path^"\">"^path^". "^last^"</a>
      </div>
    </center>
  
  <div id=foot><small>Varii Sensus &copy; 2013 Victor Nicollet.</small></div>
  <script type=\"text/javascript\">
    var _gaq = _gaq || [];
    _gaq.push(['_setAccount', 'UA-34610151-1']);
    _gaq.push(['_trackPageview']);
    (function() {
      var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
      ga.src = 'http://www.google-analytics.com/ga.js';
      var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
    })();
  </script>
</body>
</html>"


let wrap title page path prev next = 

  let arch = 
    if prev <> None || next <> None 
    then "<a id=archives href=archives>Archives</a>"      
    else ""
  in

  let opengraph = 
    match path with 
      | Some path when prev <> None || next <> None ->
	"
  <meta property=\"og:title\" content=\"Chapitre " ^ path ^ " - " ^ title ^"\"/>
  <meta property=\"og:type\" content=\"book\"/>
  <meta property=\"og:url\" content=\"http://nicollet.net/book/"^path^"\"/>
  <meta property=\"og:image\" content=\"http://nicollet.net/book/cliff-thumb.png\"/>
  <meta property=\"og:site_name\" content=\"Varii Sensus\"/>
  <meta property=\"fb:admins\" content=\"517629600\"/>"	
      | _ -> ""
  in

  let next = match next with 
    | None -> ""
    | Some (path,title) -> "<a class=next href=" ^ path ^ ">" ^ path ^ ". " ^ title ^ "&emsp;▶</a>"
  in 

  let prev = match prev with 
    | None -> ""
    | Some (path,title) -> "<a class=prev href=" ^ path ^ ">◀&emsp;" ^ path ^ ". " ^ title ^ "</a>"
  in

  let num = match path with 
    | Some path -> "<span>" ^ path ^ ". </span>"
    | None -> ""
  in

  "<!DOCTYPE html>
<html>
<head>
  <meta http-equiv=\"Content-Type\" value=\"text/html; charset=UTF-8\"/>" ^ opengraph ^ "
  <link href='http://fonts.googleapis.com/css?family=Francois+One' rel='stylesheet' type='text/css'>
  <link href='http://fonts.googleapis.com/css?family=Open+Sans' rel='stylesheet' type='text/css'>  
  <link rel=stylesheet href=\"style.css\"/>
  <title>" ^ title ^ " &ndash; Varii Sensus</title>
</head>
<body>
  <div id=head>
    <h1><a href=\"http://nicollet.net/book\">Varii Sensus</a></h1>
    <div id=author><p>écrit par <a href=\"http://nicollet.net\">Victor Nicollet</a></p></div>
    <p>Varii Sensus est un roman de fiction, dont un nouveau chapitre est mis en ligne chaque semaine.</p>
  </div>
  <div id=page>
    <div id=top>
      <div class=navig>
        " ^ prev ^ " 
        " ^ next ^ "
        " ^ arch ^ " 
      </div>
      <h2>" ^ num ^ title ^ "</h2>
    </div>
    " ^ page ^ "
    <div id=bot>
      <div class=navig>
        " ^ prev ^ " 
        " ^ next ^ "
        " ^ arch ^ " 
      </div>
      <a id=\"RSS\" href=\"http://nicollet.net/book/rss.xml\">RSS</a>
    </div>    
  </div>
  <div id=foot>Varii Sensus &copy; 2013 Victor Nicollet<br/><small>Avec des photos par <a href=\"http://www.flickr.com/photos/quelgar/83763441/in/photostream/\">Lachlan O'Dea</a> et <a href=\"http://wallbase.cc/wallpaper/409811\">Wallbase</a>.</div>
  <script type=\"text/javascript\">
    var _gaq = _gaq || [];
    _gaq.push(['_setAccount', 'UA-34610151-1']);
    _gaq.push(['_trackPageview']);
    (function() {
      var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
      ga.src = 'http://www.google-analytics.com/ga.js';
      var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
    })();
  </script>
</body>
</html>"
  
let html prev (path,title) next = 

  let body = body ("chapters/" ^ path) in 
  let page = 
    "<div id=text>" ^ body ^ "</div>"
  in

  wrap title page (Some path) prev next
  
let generate prev (path,title) next = 
  let html = html prev (path,title) next in
  let path = "www/" ^ path ^ ".htm" in
  print_endline path ;
  let chan = open_out path in
  output_string chan html ;
  close_out chan 

let generate_all () = 
  let rec aux prev = function 
    | a :: (b :: _ as t) -> generate prev a (Some b) ; aux (Some a) t
    | [x] -> generate prev x None ;
    | [] -> assert false
  in aux None All.all

let generate_archives () = 
  let list = String.concat "</li><li>" (List.map (fun (path,title) -> 
    "<a href=" ^ path ^ "><span>" ^ path ^ ". </span> " ^ title ^ "</a>"
  ) All.all) in
  let html = wrap "Archives" ("<ul id=archive><li>" ^ list ^ "</li></ul>") None None None in
  let path = "www/archives.htm" in
  print_endline path ;
  let chan = open_out path in
  output_string chan html ;
  close_out chan 

let generate_rss () = 

  let date time = 
    let tm = Unix.gmtime time in 
    Unix.(Printf.sprintf "%s, %02d %s %d %02d:%02d:%02d +0000"
	    [| "Sun" ; "Mon" ; "Tue" ; "Wed" ; "Thu" ; "Fri" ; "Sat" |].(tm.tm_wday)
	    tm.tm_mday 
	    [| "Jan" ; "Feb" ; "Mar" ; "Apr" ; "May" ; "Jun" ; "Jul" ; "Aug" ; "Sep" ; "Oct" ; "Nov" ; "Dec" |].(tm.tm_mon)
	    (1900 + tm.tm_year)
	    tm.tm_hour tm.tm_min tm.tm_sec)
  in

  let items = String.concat "</item><item>" (List.map (fun (path,title) ->
    "<title>" ^ path ^ ".&#160;" ^ title ^ "</title><link>http://nicollet.net/book/" ^ path ^ "</link>"
  ) (List.rev All.all)) in

  let xml = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>
<rss version=\"2.0\">
<channel>
  <title>Varii Sensus</title>
  <description>Varii Sensus est un roman de fiction, dont un nouveau chapitre est mis en ligne chaque lundi.</description>
  <link>http://nicollet.net/book</link>
  <pubDate>" ^ date (Unix.gettimeofday ()) ^ "</pubDate>
  <item>" ^ items ^ "</item>
</channel>" in
  let path = "www/rss.xml" in
  print_endline path ;
  let chan = open_out path in
  output_string chan xml ;
  close_out chan 

let generate_index () = 
  let rec aux = function
    | [path,title] -> index path title
    | _ :: t -> aux t
    | [] -> ""
  in
  let html = aux All.all in
  print_endline "www/index.htm" ;
  let chan = open_out "www/index.htm" in
  output_string chan html ;
  close_out chan 
	
let page404 () = 
  generate None ("404","Page Non Trouvée") None 

let () = 
  if Array.length Sys.argv = 1 then begin 
    generate_all () ;
    generate_archives () ;
    generate_rss () ;
    generate_index () ;
    page404 () ; 
  end else if Sys.argv.(1) = "--words" then begin
    generate_words () 
  end 
