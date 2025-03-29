import * as fs from 'node:fs'

const programmer_dvorak = [
  [';', ',', '.', 'p', 'y', 'f', 'g', 'c', 'r', 'l'],
  ['a', 'o', 'e', 'u', 'i', 'd', 'h', 't', 'n', 's'],
  ["'", 'q', 'j', 'k', 'x', 'b', 'm', 'w', 'v', 'z'],
]

const qwerty = [
  ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'],
  ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';'],
  ['z', 'x', 'c', 'v', 'b', 'n', 'm', ',', '.', '/'],
]

function autoHotKey(from: string, to: string) {
  const key = `${from}::Send {Blind}${to}`
  return key
}

function generateAutoHotKey(from_layout: string[][], to_layout: string[][]) {
  const from_flat = from_layout.flatMap((row) => row)
  const to_flat = to_layout.flatMap((row) => row)
  const result = from_flat.map((col, i) => autoHotKey(col, to_flat[i]))
  return result
}

const result = generateAutoHotKey(programmer_dvorak, qwerty)

fs.writeFileSync('programmer_dvorak_to_qwerty.ahk', result.join('\n'))
