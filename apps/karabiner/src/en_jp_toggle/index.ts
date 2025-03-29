import { toggle } from '../pure/toggle'

/**
 * enJpToggle
 */
export function enJpToggle() {
  const rules = [
    {
      description: 'Kana Eisuu Toggle right_command',
      manipulators: [
        toggle('ja', 'right_command', 'japanese_eisuu', ['any']),
        toggle('en', 'right_command', 'japanese_kana', ['any']),
      ],
    },
  ]

  return {
    title: 'Change the right command key to toggle between alphanumeric and kana',
    rules,
  }
}
