#!/usr/bin/env nu

mkdir output/silly_rescaled

ls output/silly/ | each {|f| 
  let file_name = $f.name
  let name = ($file_name | split row '-' | last | str trim | split row '.' | first)
  print $"resizing ($name)"
  magick $file_name -resize 1000x1000 -quality 80 $"output/silly_rescaled/($name).jpg"
}
null

