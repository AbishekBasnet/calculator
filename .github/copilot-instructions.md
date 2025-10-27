<!-- Use this file to provide workspace-specific custom instructions to Copilot. For more details, visit https://code.visualstudio.com/docs/copilot/copilot-customization#_use-a-githubcopilotinstructionsmd-file -->

# Flutter Calculator Project Instructions

This is a Flutter calculator application with the following specifications:
- 3x3 grid for digits 1-9
- 4th row with CE (clear entry), 0, and C (clear) buttons
- 4th column with operation buttons: +, -, /, *
- 8-digit alphanumeric display
- Error handling for ERROR, OVERFLOW messages
- State persistence to remember last value between app sessions
- Does not persist operations between sessions

## Development Guidelines
- Use Flutter best practices
- Implement proper state management
- Use SharedPreferences for state persistence
- Follow Material Design guidelines for calculator appearance
- Ensure proper error handling for division by zero and overflow conditions