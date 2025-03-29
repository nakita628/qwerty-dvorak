/**
 * toggle
 * @param { string } lan - language
 * @param { string } from - from
 * @param { string } to - to
 * @param { string[] } opt - optional
 */
export function toggle(lan: string, from: string, to: string, opt: string[]) {
  return {
    type: 'basic',
    conditions: [
      {
        input_sources: [
          {
            language: lan,
          },
        ],
        type: 'input_source_if',
      },
    ],
    from: {
      key_code: from,
      modifiers: {
        optional: opt,
      },
    },
    to: [
      {
        key_code: to,
      },
    ],
  }
}
