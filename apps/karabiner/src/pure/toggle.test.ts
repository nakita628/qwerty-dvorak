import { describe, expect, it } from 'vitest'
import { toggle } from './toggle'

const toggleTestCases = [
  {
    language: 'ja',
    from: 'right_command',
    to: 'japanese_eisuu',
    optional: ['any'],
    expected: {
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
  },
  {
    language: 'en',
    from: 'right_command',
    to: 'japanese_kana',
    optional: ['any'],
    expected: {
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
  },
]

describe('toggle', () => {
  it.each(toggleTestCases)(
    'toggle($language, $from, $to) -> $expected',
    ({ language, from, to, optional, expected }) => {
      const result = toggle(language, from, to, optional)
      expect(result).toEqual(expected)
    },
  )
})
