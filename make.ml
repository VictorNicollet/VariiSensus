let body path = 
  let chan = open_in path in 
  let lexbuf = Lexing.from_channel chan in 
  Lex.clean lexbuf 

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
    | None -> "<div style=\"height:35px;\"></div>"
    | Some (path,title) -> "<a id=next href=" ^ path ^ ">" ^ path ^ ". " ^ title ^ "</a>"
  in 

  let prev = match prev with 
    | None -> "<div style=\"height:35px;\"></div>"
    | Some (path,title) -> "<a id=prev href=" ^ path ^ ">" ^ path ^ ". " ^ title ^ "</a>"
  in

  let num = match path with 
    | Some path -> "<span>" ^ path ^ ". </span>"
    | None -> ""
  in

  "<!DOCTYPE html>
<html>
<head>
  <meta http-equiv=\"Content-Type\" value=\"text/html;charset=UTF-8\"/>" ^ opengraph ^ "
  <link href='http://fonts.googleapis.com/css?family=Francois+One' rel='stylesheet' type='text/css'>
  <link href='http://fonts.googleapis.com/css?family=Open+Sans' rel='stylesheet' type='text/css'>  
  <link rel=stylesheet href=\"style.css\"/>
  <title>" ^ title ^ " &ndash; Varii Sensus</title>
</head>
<body>
  <div id=head>
    <div id=author><p><a href=\"http://nicollet.net\">Victor Nicollet</a></p></div>
    <h1><a href=\"http://nicollet.net/book\">Varii Sensus</a></h1>
    <p>Varii Sensus est un roman de fiction, dont un nouveau chapitre est mis en ligne chaque lundi.<br/> Il est recommandé de <a href=\"1\">commencer au premier chapitre</a>.
  </div>
  <div id=page>
    " ^ page ^ "
    <div id=side>
      <h2>" ^ num ^ title ^ "</h2>
      " ^ prev ^ " 
      " ^ next ^ " 
      " ^ arch ^ "
    </div>
  </div>
  <div id=foot>Varii Sensus &copy; 2012 Victor Nicollet<br/><small>Avec une photo par <a href=\"http://www.flickr.com/photos/quelgar/83763441/in/photostream/\">Lachlan O'Dea</a></div>
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

let generate_all = 
  let rec aux prev = function 
    | a :: (b :: _ as t) -> generate prev a (Some b) ; aux (Some a) t
    | [x] -> generate prev x None ;
    | [] -> assert false
  in aux None All.all

let generate_archives = 
  let list = String.concat "</li><li>" (List.map (fun (path,title) -> 
    "<a href=" ^ path ^ "><span>" ^ path ^ ". </span> " ^ title ^ "</a>"
  ) All.all) in
  let html = wrap "Archives" ("<ul id=archive><li>" ^ list ^ "</li></ul>") None None None in
  let path = "www/archives.htm" in
  print_endline path ;
  let chan = open_out path in
  output_string chan html ;
  close_out chan 

let generate_rss = 

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

let generate_htaccess = 
  let b = Buffer.create 1024 in
  Buffer.add_string b "RewriteEngine On\nRewriteBase /book/\n" ;
  Buffer.add_string b "RewriteCond %{REQUEST_FILENAME}.htm -f\n" ;
  Buffer.add_string b "RewriteRule ^(.*) $1.htm [L]\n\n" ;
  let rec aux = function
    | [path,_] -> 
      Buffer.add_string b "RewriteRule ^$ http://nicollet.net/book/" ;
      Buffer.add_string b path ;
      Buffer.add_string b " [R=303,L]\n\n" 
    | _ :: t -> aux t 
    | [] -> ()
  in
  aux All.all ;
  Buffer.add_string b "RewriteCond %{REQUEST_FILENAME} !-f\n" ;
  Buffer.add_string b "RewriteRule ^.* 404.htm [L]\n" ;
  print_endline "www/.htaccess" ;
  let chan = open_out "www/.htaccess" in
  output_string chan (Buffer.contents b) ;
  close_out chan 
	
let page404 = 
  generate None ("404","Page Non Trouvée") None 
