# Один вариант:
let text = open 1.txt | split row "\n" | skip 24 | first 68 | str join "\n"

let first  = $text | detect columns       | first 21
let second = $text | detect columns -s 23 | first 21
let third  = $text | detect columns -s 46 | first 21

$first | merge $second | merge $third | select 'ПИК' 'КПДЕ' 'НЕ' 'ФИ' | to csv | save 1.csv

# Пять вариантов вместе:
let t1 = open 1.txt
let t2 = open 2.txt
let t3 = open 3.txt
let t4 = open 4.txt
let t5 = open 5.txt

def transform [t] {
  let text = $t | split row "\n" | skip 24 | first 68 | str join "\n"

  let first  = $text | detect columns       | first 21
  let second = $text | detect columns -s 23 | first 21
  let third  = $text | detect columns -s 46 | first 21

  $first | merge $second | merge $third | select 'ПИК' 'КПДЕ' 'НЕ' 'ФИ'
}

def main [] {
  for x in [1 2 3 4 5] {
    
  }
}
