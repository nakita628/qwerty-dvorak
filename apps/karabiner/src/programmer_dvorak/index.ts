import { generateMandatoryKeymap } from '../pure/generate-mandatory-keymap'

/**
 * programmerDvorak
 * @returns
 */
export function programmerDvorak() {
  const mandatory = [
    ['command'],
    ['command', 'shift'],
    ['control'],
    ['control', 'shift'],
    ['option'],
    ['option', 'shift'],
  ]

  const programmer_dvorak = [
    ['semicolon', 'comma', 'period', 'p', 'y', 'f', 'g', 'c', 'r', 'l'],
    ['a', 'o', 'e', 'u', 'i', 'd', 'h', 't', 'n', 's'],
    ['quote', 'q', 'j', 'k', 'x', 'b', 'm', 'w', 'v', 'z'],
  ]

  const qwerty = [
    ['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'],
    ['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', 'quote'],
    ['z', 'x', 'c', 'v', 'b', 'n', 'm', 'comma', 'period', 'slash'],
  ]
  const manipulators = generateMandatoryKeymap(programmer_dvorak, qwerty, mandatory)
  const result = {
    title: 'Programmer Dvorak Qwerty',
    rules: [
      {
        description: 'Programmer Dvorak Qwerty',
        manipulators: manipulators,
      },
    ],
  }
  return result
}
