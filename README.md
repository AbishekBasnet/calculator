# Flutter Calculator App

A simple calculator application built with Flutter that provides basic arithmetic operations with a classic calculator interface.

## Features

- **Classic Calculator Layout**: 3x3 grid for digits 1-9, with a 4th row containing CE, 0, and C buttons
- **Operation Buttons**: 4th column with +, -, /, * operators
- **8-Digit Display**: Alphanumeric display that can show up to 8 digits and error messages
- **Error Handling**: Displays "ERROR" for division by zero and "OVERFLOW" for results exceeding 8 digits
- **State Persistence**: Remembers the last displayed value between app sessions using SharedPreferences
- **Material Design**: Clean, modern interface following Material Design guidelines

## Button Layout

```
7  8  9  /
4  5  6  *
1  2  3  -
CE 0  C  +
   =
```

## Error Handling

- **ERROR**: Displayed when dividing by zero
- **OVERFLOW**: Displayed when the result exceeds 8 digits
- **Clear Functions**: 
  - CE (Clear Entry): Clears current input
  - C (Clear): Clears everything and resets calculator

## State Persistence

The calculator saves the last displayed value using SharedPreferences. When you restart the app, it will show the most recent value. Operations are not persisted between sessions as per the specification.

## Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- An IDE with Flutter support (VS Code with Flutter extension, Android Studio, etc.)

### Installation

1. Clone or download this project
2. Navigate to the project directory
3. Run `flutter pub get` to install dependencies
4. Run `flutter run` to start the application

### Dependencies

- `flutter`: Flutter SDK
- `shared_preferences: ^2.2.2`: For state persistence
- `cupertino_icons: ^1.0.2`: iOS-style icons

## Usage

1. Tap digit buttons (0-9) to enter numbers
2. Tap operation buttons (+, -, *, /) to perform calculations
3. Tap = to execute the calculation
4. Use CE to clear the current entry
5. Use C to clear everything and reset the calculator
6. The calculator will automatically handle overflow and division by zero errors

## Architecture

The app follows Flutter best practices with:
- Stateful widget for managing calculator state
- SharedPreferences for data persistence
- Material Design components for UI
- Proper error handling and validation
- Clean separation of UI and logic

## Contributing

Feel free to submit issues and enhancement requests!

## License

This project is created for educational purposes.