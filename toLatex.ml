let head = "\\documentclass[10pt,twocolumn]{article}

\\usepackage[utf8]{inputenc}
\\usepackage[frenchb]{babel}

\\usepackage[T1]{fontenc}

\\usepackage[left=1cm,right=1cm,top=1.4cm,bottom=1.4cm]{geometry}
\\setlength{\\parindent}{0in}
\\setlength{\\parskip}{0.5cm}

\\begin{document}
"

let finalhead = "\\documentclass[10pt,openany]{book}

\\usepackage[papersize={6in,8in},margin=1.2cm]{geometry}

\\usepackage[utf8]{inputenc}
\\usepackage[frenchb]{babel}

\\usepackage{bookman}
\\usepackage[T1]{fontenc}

\\title{Varii Sensus}
\\author{Victor Nicollet}

\\usepackage{setspace}
\\doublespace

\\setlength{\\parindent}{0in}
\\setlength{\\parskip}{0.4cm}

\\begin{document}

\\pagestyle{empty}

\\maketitle
"

let final = true

class toLatex = object

  val buffer = 
    let buffer = Buffer.create 1024 in
    Buffer.add_string buffer (if final then finalhead else head) ;
    buffer 

  method start_chapter title =
    let nbsp = Str.regexp (Str.quote "&#160;") in
    Buffer.add_string buffer (if final then "\\chapter{" else "\\section{") ;
    Buffer.add_string buffer (Str.global_replace nbsp "~" title);
    Buffer.add_string buffer "}\\thispagestyle{empty} %%%%%%%%%%%%%%%%%%%%\n\n"

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
    Buffer.add_string buffer " «~"
  method start_dialog =  
    Buffer.add_string buffer " «~"
  method next_tirade = 
    Buffer.add_string buffer "\\\\\n---\\ "
  method emdash = 
    Buffer.add_string buffer "---"
  method end_dialog = 
    Buffer.add_string buffer "~»\n\n"
  method end_quote = 
    Buffer.add_string buffer "~» "
  method word word = 
    Buffer.add_string buffer word

  method contents = 
    Buffer.contents buffer ^ "\n\\end{document}\n"

end

