import { expect, describe, it } from 'vitest'
import { enJpToggle } from '.'

export const expected = {
  title: 'Change the right command key to toggle between alphanumeric and kana',
  rules: [
    {
      description: 'Kana Eisuu Toggle right_command',
      manipulators: [
        {
          type: 'basic',
          conditions: [
            {
              input_sources: [
                {
                  language: 'ja',
                },
              ],
              type: 'input_source_if',
            },
          ],
          from: {
            key_code: 'right_command',
            modifiers: {
              optional: ['any'],
            },
          },
          to: [
            {
              key_code: 'japanese_eisuu',
            },
          ],
        },
        {
          type: 'basic',
          conditions: [
            {
              input_sources: [
                {
                  language: 'en',
                },
              ],
              type: 'input_source_if',
            },
          ],
          from: {
            key_code: 'right_command',
            modifiers: {
              optional: ['any'],
            },
          },
          to: [
            {
              key_code: 'japanese_kana',
            },
          ],
        },
      ],
    },
  ],
}

describe('enJpToggle', () => {
  it('enJpToggle() -> $expected', () => {
    const result = enJpToggle()
    expect(result).toEqual(expected)
  })
})
