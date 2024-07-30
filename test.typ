#let content = yaml("test.yaml")

#let contacts(entry) = {
  if (entry.at("URL",default:none) != none and entry.at("Logo", default:none)!= none) {
   box(image(entry.Logo),height:1em)
   link(entry.URL)[#entry.Show]
   //h(1fr)
  } else if entry.at("URL", default:none) != none {
   link(entry.URL)[#entry.Show]
  } else if entry.at("Logo",default:none) != none {
    box(image(entry.Logo),height:1em)
    [#entry.Show]
  } else {
    [#entry.show]
  }
}

//#let contacts(entry) = {
// 
// if entry.URL != none {
//  set text(9.5pt)
//  [#link(entry.URL)[#entry.Show]✯]
//  h(1fr)
// } else {
//  set text(9.5pt)
//  [#entry.Show]
//  h(1fr)
// }
// 
//}

#let introduction(content) = {
  set align(center)
  
  [
    #set text(size: 2.0em, weight: "bold")
    
    #upper(content.Name)
    
    #v(-0.75em)
  ]

  
  [
    #set text(size: 1.25em, weight: "bold")
    
    #content.Profession
    
    #v(-0.75em)
  ]
  
  [
    #set text(size: 1em)
    
    #content.Location

    #v(-0.75em)  
  ]


  [
    #set text(size: 9.5pt)
      
    #for entry in content.Contacts [
     #contacts(entry)
    ]
  ]
}

#introduction(content.Introduction)
