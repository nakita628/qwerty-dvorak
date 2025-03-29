import { mandatoryKeymap } from './mandatory-keymap'

export function generateMandatoryKeymap(
  from_layout: string[][],
  to_layout: string[][],
  mandatory_keys: string[][],
): object[] {
  return from_layout.flatMap((row_from, i) =>
    row_from.flatMap((col_from, j) =>
      mandatory_keys.map((mandatory) => mandatoryKeymap(col_from, to_layout[i][j], mandatory)),
    ),
  )
}
