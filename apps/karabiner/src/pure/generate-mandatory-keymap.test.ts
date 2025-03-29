import { describe, expect, it } from 'vitest'
import { generateMandatoryKeymap } from './generate-mandatory-keymap'

const generateMandatoryKeymapTestCases = [
  {
    from_layout: [
      ['semicolon', 'comma', 'period', 'p'],
      ['a', 'o', 'e', 'u'],
      ['quote', 'q', 'j', 'k'],
    ],
    to_layout: [
      ['q', 'w', 'e', 'r'],
      ['a', 's', 'd', 'f'],
      ['z', 'x', 'c', 'v'],
    ],
    mandatory_keys: [['command'], ['command', 'shift']],
    expected: [
      {
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
      {
        type: 'basic',
        from: {
          key_code: 'semicolon',
          modifiers: {
            mandatory: ['command', 'shift'],
          },
        },
        to: [
          {
            key_code: 'q',
            modifiers: ['command', 'shift'],
          },
        ],
      },
      {
        type: 'basic',
        from: {
          key_code: 'comma',
          modifiers: {
            mandatory: ['command'],
          },
        },
        to: [
          {
            key_code: 'w',
            modifiers: ['command'],
          },
        ],
      },
      {
        type: 'basic',
        from: {
          key_code: 'comma',
          modifiers: {
            mandatory: ['command', 'shift'],
          },
        },
        to: [
          {
            key_code: 'w',
            modifiers: ['command', 'shift'],
          },
        ],
      },
      {
        type: 'basic',
        from: {
          key_code: 'period',
          modifiers: {
            mandatory: ['command'],
          },
        },
        to: [
          {
            key_code: 'e',
            modifiers: ['command'],
          },
        ],
      },
      {
        type: 'basic',
        from: {
          key_code: 'period',
          modifiers: {
            mandatory: ['command', 'shift'],
          },
        },
        to: [
          {
            key_code: 'e',
            modifiers: ['command', 'shift'],
          },
        ],
      },
      {
        type: 'basic',
        from: {
          key_code: 'p',
          modifiers: {
            mandatory: ['command'],
          },
        },
        to: [
          {
            key_code: 'r',
            modifiers: ['command'],
          },
        ],
      },
      {
        type: 'basic',
        from: {
          key_code: 'p',
          modifiers: {
            mandatory: ['command', 'shift'],
          },
        },
        to: [
          {
            key_code: 'r',
            modifiers: ['command', 'shift'],
          },
        ],
      },
      {
        type: 'basic',
        from: {
          key_code: 'a',
          modifiers: {
            mandatory: ['command'],
          },
        },
        to: [
          {
            key_code: 'a',
            modifiers: ['command'],
          },
        ],
      },
      {
        type: 'basic',
        from: {
          key_code: 'a',
          modifiers: {
            mandatory: ['command', 'shift'],
          },
        },
        to: [
          {
            key_code: 'a',
            modifiers: ['command', 'shift'],
          },
        ],
      },
      {
        type: 'basic',
        from: {
          key_code: 'o',
          modifiers: {
            mandatory: ['command'],
          },
        },
        to: [
          {
            key_code: 's',
            modifiers: ['command'],
          },
        ],
      },
      {
        type: 'basic',
        from: {
          key_code: 'o',
          modifiers: {
            mandatory: ['command', 'shift'],
          },
        },
        to: [
          {
            key_code: 's',
            modifiers: ['command', 'shift'],
          },
        ],
      },
      {
        type: 'basic',
        from: {
          key_code: 'e',
          modifiers: {
            mandatory: ['command'],
          },
        },
        to: [
          {
            key_code: 'd',
            modifiers: ['command'],
          },
        ],
      },
      {
        type: 'basic',
        from: {
          key_code: 'e',
          modifiers: {
            mandatory: ['command', 'shift'],
          },
        },
        to: [
          {
            key_code: 'd',
            modifiers: ['command', 'shift'],
          },
        ],
      },
      {
        type: 'basic',
        from: {
          key_code: 'u',
          modifiers: {
            mandatory: ['command'],
          },
        },
        to: [
          {
            key_code: 'f',
            modifiers: ['command'],
          },
        ],
      },
      {
        type: 'basic',
        from: {
          key_code: 'u',
          modifiers: {
            mandatory: ['command', 'shift'],
          },
        },
        to: [
          {
            key_code: 'f',
            modifiers: ['command', 'shift'],
          },
        ],
      },
      {
        type: 'basic',
        from: {
          key_code: 'quote',
          modifiers: {
            mandatory: ['command'],
          },
        },
        to: [
          {
            key_code: 'z',
            modifiers: ['command'],
          },
        ],
      },
      {
        type: 'basic',
        from: {
          key_code: 'quote',
          modifiers: {
            mandatory: ['command', 'shift'],
          },
        },
        to: [
          {
            key_code: 'z',
            modifiers: ['command', 'shift'],
          },
        ],
      },
      {
        type: 'basic',
        from: {
          key_code: 'q',
          modifiers: {
            mandatory: ['command'],
          },
        },
        to: [
          {
            key_code: 'x',
            modifiers: ['command'],
          },
        ],
      },
      {
        type: 'basic',
        from: {
          key_code: 'q',
          modifiers: {
            mandatory: ['command', 'shift'],
          },
        },
        to: [
          {
            key_code: 'x',
            modifiers: ['command', 'shift'],
          },
        ],
      },
      {
        type: 'basic',
        from: {
          key_code: 'j',
          modifiers: {
            mandatory: ['command'],
          },
        },
        to: [
          {
            key_code: 'c',
            modifiers: ['command'],
          },
        ],
      },
      {
        type: 'basic',
        from: {
          key_code: 'j',
          modifiers: {
            mandatory: ['command', 'shift'],
          },
        },
        to: [
          {
            key_code: 'c',
            modifiers: ['command', 'shift'],
          },
        ],
      },
      {
        type: 'basic',
        from: {
          key_code: 'k',
          modifiers: {
            mandatory: ['command'],
          },
        },
        to: [
          {
            key_code: 'v',
            modifiers: ['command'],
          },
        ],
      },
      {
        type: 'basic',
        from: {
          key_code: 'k',
          modifiers: {
            mandatory: ['command', 'shift'],
          },
        },
        to: [
          {
            key_code: 'v',
            modifiers: ['command', 'shift'],
          },
        ],
      },
    ],
  },
]

describe('generateMandatoryKeymap', () => {
  it.each(generateMandatoryKeymapTestCases)(
    'should generate mandatory keymap',
    ({ from_layout, to_layout, mandatory_keys, expected }) => {
      const result = generateMandatoryKeymap(from_layout, to_layout, mandatory_keys)
      expect(result).toEqual(expected)
    },
  )
})
