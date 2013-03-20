let all = 
  (* Book 1 *)
  [ "1",  "Athanor" ;
    "2",  "Mynari" ;
    "3",  "Erenheim" ;
    "4",  "Sans-Visage" ;
    "5",  "Didalane" ;
    "6",  "Cauchemars" ;
    "7",  "Apocryphe" ;
    "8",  "Le Soiffard" ;
    "9",  "Apocalypse" ;
    "10", "Théologie" ;
    "11", "Serrig" ;
    "12", "Nomination" ;
    "13", "Arkadir" ; 
    "14", "Haute Trahison" ;
    "15", "Ordo Eborius" ;
    "16", "Suidaster" ;
    "17", "Mémoire" ;
    "18", "Hans Banach" ;
    "19", "Simmera" ;
    "20", "Geerart" ;
    "21", "Benjamin" ; 
    "22", "Guirevennec" ;
    "23", "Invasion" ;
    "24", "Archange" ;
    "25", "Josephus" ;
    "26", "Parchaki" ;
    "27", "Récompense" ;
    "28", "Généalogie" ;
    "29", "Prédécesseur" ;
    "30", "Informateur" ;
    "31", "Croisière" ;
    "32", "Patriarche" ;
    "33", "Poison" ;
    "34", "Nature&#160;Divine" ;
    "35", "Lucrèce" ;
    "36", "Sébastien" ; 
    "37", "Jeanne" ;
    "38", "Adinn" ;
    "39", "Abyssales" ;
    "40", "Empire" ;
    "41", "La&#160;Morgue" ;
    "42", "Immortels" ;
    "43", "Mygaën" ;
    "44", "Histoire" ;
    "45", "Altarane" ; 
    "46", "Nagovie" ; 
    "47", "Gwenadir" ;
    "48", "Varii&#160;Sensus" ;
  (* Book 2 *)
  ]

let rec sub s e = function 
  | [] -> []
  | x :: xs -> 
    if s = 0 then 
      if e = 0 then [] else x :: sub 0 (e - 1) xs
    else sub (s - 1) e xs

let book_1 = sub 0 48 all
