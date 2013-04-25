let all = 
  (* Book 1 *)
  [ "1",  "Giselle Guirevennec" ;
    "2",  "Fanatiques" ;
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
    "19", "Simmera Jottun" ;
    "20", "Geerart" ;
    "21", "Saint Benjamin" ; 
    "22", "Votre Monde" ;
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
    "34", "Nature Divine" ;
    "35", "Lucrèce Neerus" ;
    "36", "Saint Sébastien" ; 
    "37", "Jeanne Nigelle" ;
    "38", "Adinns et Adirs" ;
    "39", "Les Abyssales" ;
    "40", "L'Empire" ;
    "41", "La Morgue" ;
    "42", "Immortels" ;
    "43", "Maison Mygaën" ;
    "44", "Histoire" ;
    "45", "Maison Altarane" ; 
    "46", "Nagovie" ; 
    "47", "Gwenadir" ;
    "48", "Varii Sensus" ;
  (* Book 2 *)
  ]

let rec sub s e = function 
  | [] -> []
  | x :: xs -> 
    if s = 0 then 
      if e = 0 then [] else x :: sub 0 (e - 1) xs
    else sub (s - 1) e xs

let book_1 = sub 0 48 all
