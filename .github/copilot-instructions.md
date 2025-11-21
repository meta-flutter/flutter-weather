# Copilot Instructions for Flutter Weather

## Project Overview

This is a Flutter-based weather application that provides weather forecasts and current conditions. The app follows Flutter best practices and Material Design guidelines.

## Architecture

- **Framework**: Flutter (Dart)
- **Design Pattern**: Follow BLoC (Business Logic Component) or Provider pattern for state management
- **API Integration**: Weather data from third-party APIs
- **Platform Support**: iOS, Android, Web, Desktop

## Code Style Guidelines

### Dart/Flutter Conventions

- Follow the official [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use `dart format` for consistent code formatting
- Use meaningful variable and function names
- Prefer `const` constructors when possible for better performance
- Use `final` for immutable variables
- Keep widgets small and focused (single responsibility)

### File Organization

```
lib/
├── main.dart
├── models/          # Data models
├── screens/         # UI screens/pages
├── widgets/         # Reusable widgets
├── services/        # API and business logic
├── providers/       # State management
└── utils/           # Helper functions and constants
```

## Widget Guidelines

- **Stateless vs Stateful**: Prefer StatelessWidget when no state management is needed
- **Widget Composition**: Break down complex widgets into smaller, reusable components
- **Keys**: Use keys appropriately for widget identity in lists
- **BuildContext**: Be mindful of context usage across async operations

## State Management

- Use consistent state management pattern throughout the app
- Handle loading, success, and error states explicitly
- Avoid setState in StatelessWidgets
- Dispose controllers and streams properly

## API Integration

- Handle network errors gracefully
- Implement retry logic for failed requests
- Show user-friendly error messages
- Cache data when appropriate
- Use async/await for asynchronous operations

## Testing Requirements

### Unit Tests
- Test business logic and data models
- Mock API calls and external dependencies
- Aim for high code coverage on critical paths

### Widget Tests
- Test UI components in isolation
- Verify widget rendering and interactions
- Test different states (loading, error, success)

### Integration Tests
- Test complete user flows
- Verify app behavior end-to-end

## UI/UX Guidelines

- Follow Material Design principles
- Support both light and dark themes
- Ensure responsive design for different screen sizes
- Implement proper loading indicators
- Show meaningful error messages with retry options
- Handle edge cases (no internet, API errors, etc.)

## Performance Best Practices

- Minimize widget rebuilds
- Use `const` constructors where possible
- Implement lazy loading for lists
- Optimize images (use cached_network_image)
- Avoid expensive operations in build methods

## Error Handling

- Catch and handle exceptions appropriately
- Provide user feedback for errors
- Log errors for debugging
- Never expose sensitive information in error messages

## Accessibility

- Use Semantics widgets for screen readers
- Ensure sufficient color contrast
- Provide text alternatives for images
- Support font scaling

## Dependencies

- Keep dependencies up to date
- Use official/well-maintained packages
- Check package compatibility before adding
- Document why each dependency is needed

## Git Workflow

- Write clear commit messages
- Keep commits atomic and focused
- Create feature branches for new work
- Write descriptive PR descriptions

## Documentation

- Add comments for complex logic
- Document public APIs
- Keep README.md updated
- Include examples for reusable components

## Security

- Never commit API keys or secrets
- Use environment variables for sensitive data
- Validate user inputs
- Keep dependencies updated for security patches
