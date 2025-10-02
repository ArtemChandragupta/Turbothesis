let data = [
  (iconv -f CP866 -t UTF-8 R1.RES)
  (iconv -f CP866 -t UTF-8 R2.RES)
  (iconv -f CP866 -t UTF-8 R3.RES)
  (iconv -f CP866 -t UTF-8 R4.RES)
  (iconv -f CP866 -t UTF-8 R5.RES)
]

def transform [t] {
  let text = $t | split row "\n" | skip 25 | first 68 | str join "\n"

  let first  = $text | detect columns       | first 21
  let second = $text | detect columns -s 23 | first 21
  let third  = $text | detect columns -s 46 | first 21

  $first | merge $second | merge $third | select 'ПИК' 'КПДЕ' 'НЕ' 'ФИ'
}

def main [] {
  for x in 1..5 {
    $data | get ($x - 1) | save $"data($x).txt"
    transform ($data | get ($x - 1)) | save $"($x).csv"
  }
}
