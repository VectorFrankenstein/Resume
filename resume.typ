#let content = yaml("information.yaml") // Get the content file
// Set global params and values

#set page(
  margin: 0.5cm,
  numbering: "1",
)

#set text(
  size: 10pt,
  hyphenate: false,
)

#set list(
  spacing: 6pt
)

#set par(
  leading: 6pt,
  justify: true,
)
// #show par: set block(spacing: 4pt)

#show heading.where(
    level: 2,
): it => block(width: 100%)[
    #set align(left)
    #set text( size: 1em, weight: "bold")
    #it.body 
    #line(length: 100%, stroke: 1pt + black)
    #v(0em)// draw a line 
]

// Name title/heading
#show heading.where(
    level: 1,
): it => block(width: 100%)[
    #set text( size: 1.5em, weight: "bold")
    #it.body
    #v(-1em)
    #line(length: 100%)
]

#set heading(level: auto)

// Generic functions to keep the code readible

// My goal with these functions is to make them as reproducible as possible

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
    #set text(size: 11pt)
      
    #for entry in content.Contacts [
     #contacts(entry)
    ]
  ]
}

#let section(section_name) = {
  set align(left)
  set text(size: 1.5em, weight: "bold")
  v(2pt)
  section_name

  line(length: 100%, stroke: 1pt + black)
}

#let experience_function(experience_entry) = {
  [
    #if (experience_entry.at("URL", default: none) != none) [
      *#underline[#link(experience_entry.URL)[#experience_entry.Company]]* #h(1fr) *#experience_entry.Location* \
    ] else [
      *#underline[#experience_entry.Company]* #h(1fr) *#experience_entry.Location* \
    ]
    #text(style: "italic")[#experience_entry.Position] #h(1fr) #experience_entry.Start - #experience_entry.End
    #for task in experience_entry.Tasks [
      - #eval(task, mode: "markup")
    ]
    #v(-0.25em)
  ]
}

#let education_entry(education_entry) = {
  [
    #if (education_entry.at("URL", default: none) != none) [
      *#underline[#link(education_entry.URL)[#education_entry.Institute]]* #h(1fr) *#education_entry.Location* \
    ] else [
      *#underline[#education_entry.Institute]* #h(1fr) *#education_entry.Location* \
    ]
    #text(style: "italic")[#education_entry.Degree] #h(1fr) #education_entry.Start - #education_entry.End \ 
    #for (name,value) in education_entry.Metadata [
      *#name* : #value \
    ] #v(-0.25em) 
  ]
}


#let skills_entry(skills_entry) = {
  [
    *#underline[#skills_entry.Section]* \
    #for (hit, details) in skills_entry.Details [
      *#hit* : #details \
    ] #v(-0.25em) // Add some space for the next section
  ]
}

// To list out the project you have worked in
#let projects_function(project_entry) = {
  [
    
    #if (project_entry.at("URL", default: none) != none) [
      *#underline[#link(project_entry.URL)[#project_entry.Name]]* #h(1fr) #project_entry.Start - #project_entry.End \
    ] else [
      *#underline[#project_entry.Name]* #h(1fr) #project_entry.Start - #project_entry.End \ 
    ]
    #for tasks in project_entry.Highlights [
      - #eval(tasks, mode: "markup")
    ] #v(-0.25em) 
  ]
}

#let publication_entry(publication_entry) = {
  [
    #if (publication_entry.at("URL", default: none) != none) [
      *#underline[#link(publication_entry.URL)[#publication_entry.Name]]* #h(1fr) *#publication_entry.Contribution* \
    ] else [
      *#underline[#publication_entry.Name]* #h(1fr) *#publication_entry.Contribution* \
    ]
    #publication_entry.DOI #h(1fr) #publication_entry.Date \
    #v(-0.5em)
  ]
}

#let awards_function(awards_entry) = {
  [
    *#underline[#awards_entry.Name]* #h(1fr) *#awards_entry.Organization* \
    #awards_entry.Date \
    #for note in awards_entry.Notes [
      - #note
    ] #v(-0.5em)
  ]
}
// Actual content

// For now there are these manually written #v() adjustments throughout the page because I do not know a better way.

#v(-1em)

#introduction(content.Introduction)

#v(-1em)

= Experience
#for entry in content.Experience {
  experience_function(entry)
}
// #work_entry(content.Work)

#v(-0.75em) // to compensate for the previous sections's trailing white space

= Projects

#for entry in content.Projects {
  projects_function(entry)
}

#v(-0.75em)

= Skills

#for entry in content.Skills {
  skills_entry(entry)
}

#v(-0.75em) // compensate for line spacing

= Education 

#for entry in content.Education {
  education_entry(entry)
}

#v(-0.75em) // to compensate for the previous sections's trailing white space

= Research and Publications

#for entry in content.Publications {
  publication_entry(entry)
}

#v(-0.75em)

= Awards

#for entry in content.Awards {
  awards_function(entry)
}
