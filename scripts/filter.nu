#!/usr/bin/env nu

mkdir output/final/serious
mkdir output/final/silly

let active = (
  cat source_data/active_members_winter2024.tsv 
  | from tsv 
  | where {|it| $it.Status == "Semi-active" or $it.Status == "Very Active"}
  | each {|it| mut it = $it; $it.Name = ($it.Name | str trim); $it}
)

for member in $active {
  let underscore_name = $member.Name | str replace " " "_"
  let first_name = $member.Name | split row ' ' | first
  let silly_file = $"output/silly_rescaled/($member.Name).jpg"
  let serious_file = $"output/serious/($underscore_name).jpg"
  use_or_search "output/silly_rescaled" $first_name $silly_file "output/final/silly"
  use_or_search "output/serious" $first_name $serious_file "output/final/serious"
}

def use_or_search [
  dir: path,
  first_name: string,
  file_name: string,
  output: path,
] {
  # If exact match, just copy and return.
  if ($file_name | path type) == "file" {
    cp $file_name $output
    return
  }

  # If no exact match, try to search by first name and ask for a selection.
  let options = (ls $dir | where {|it| $it.type == "file" and ($it.name | str contains $first_name)})
  if ($options | length) > 0 {
    print $"No exact match for (ansi red_bold)($file_name)(ansi reset). "
    let choice = ($options | input list --fuzzy "Choose a match (ESC to skip, fuzzy search on):")
    if $choice != null {
      print $"Chose (ansi green)($choice.name | path basename)(ansi reset)"
      cp $choice.name $output
      return
    }
    print $" (ansi red)No choice - continuing(ansi reset)"
  } else {
    print $"(ansi red) Could not find any matches for ($file_name) (ansi reset)"
  }
}
null

