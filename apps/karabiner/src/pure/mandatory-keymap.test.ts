import { describe, expect, it } from 'vitest'
import { mandatoryKeymap } from './mandatory-keymap'

const mandatoryKeymapTestCases = [
  {
    from: 'semicolon',
    to: 'q',
    mandatory: ['command'],
    expected: {
      type: 'basic',
      from: {
        key_code: 'semicolon',
        modifiers: {
          mandatory: ['command'],
        },
      },
      to: [
        {
          key_code: 'q',
          modifiers: ['command'],
        },
      ],
    },
  },
]

describe('mandatoryKeymap', () => {
  it.each(mandatoryKeymapTestCases)(
    'mandatoryKeymap($from, $to, $mandatory) -> $expected',
    ({ from, to, mandatory, expected }) => {
      const result = mandatoryKeymap(from, to, mandatory)
      expect(result).toEqual(expected)
    },
  )
})
