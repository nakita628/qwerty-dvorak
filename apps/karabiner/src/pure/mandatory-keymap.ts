/**
 * mandatory keymap
 * @param { string } from - from
 * @param { string } to - to
 * @param { string[] } mandatory - mandatory
 */
export function mandatoryKeymap(from: string, to: string, mandatory: string[]) {
  return {
    type: 'basic',
    from: {
      key_code: from,
      modifiers: {
        mandatory: mandatory,
      },
    },
    to: [
      {
        key_code: to,
        modifiers: mandatory,
      },
    ],
  }
}
