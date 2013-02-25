class toLatex = object

  val buffer = 
    let buffer = Buffer.create 1024 in
    Buffer.add_string buffer "\\documentclass[12pt|a4paper|draft]{book}
\\usepackage[frenchb]{babel}
\\title{VariiSensus}
\\author{Victor Nicollet}
\\begin{document}
" ;
    buffer 

  method start_title = 
    ""

  method start_chapter title = 
    Buffer.add_string buffer "\\chapter{" ;
    Buffer.add_string buffer title ;
    Buffer.add_string buffer "} %%%%%%%%%%%%%%%%%%%%\n\n"

  method start_emphasis = 
    Buffer.add_string buffer "\\textit{"
  method end_emphasis = 
    Buffer.add_string buffer "}"
  method start_small = 
    Buffer.add_string buffer "{\\small "
  method end_small = 
    Buffer.add_string buffer "}"
  method start_strong = 
    Buffer.add_string buffer "\\textbf{ "
  method end_strong = 
    Buffer.add_string buffer "}"
  method line_break = 
    Buffer.add_string buffer "\\\\\n"
  method end_paragraph = 
    Buffer.add_string buffer "\n\n" 
  method start_paragraph = 
    Buffer.add_string buffer ""
  method non_letter c = 
    Buffer.add_char buffer c
  method start_quote = 
    Buffer.add_string buffer "\\og\\ "
  method start_dialog =  
    Buffer.add_string buffer "\\og\\ "
  method next_tirade = 
    Buffer.add_string buffer "\\\\\n---\\ "
  method emdash = 
    Buffer.add_string buffer "---"
  method end_dialog = 
    Buffer.add_string buffer "\\ \\fg{}\n\n"
  method end_quote = 
    Buffer.add_string buffer "\\ \\fg{} "
  method word word = 
    Buffer.add_string buffer word

  method contents = 
    Buffer.contents buffer ^ "\n\\end{document}"

end

