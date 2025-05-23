# GitHub Copilot Instructions

This document contains the coding standards and practices for this project. Please follow these guidelines when generating code.

## General Coding Practices

### Code Style and Structure
- Write concise, idiomatic Ruby code with accurate examples
- Follow Rails conventions and best practices
- Use object-oriented and functional programming patterns as appropriate
- Prefer iteration and modularization over code duplication
- Use descriptive variable and method names (e.g., user_signed_in?, calculate_total)
- Structure files according to Rails conventions (MVC, concerns, helpers, etc.)

### Naming Conventions
- Use snake_case for file names, method names, and variables
- Use CamelCase for class and module names
- Follow Rails naming conventions for models, controllers, and views

### Ruby and Rails Usage
- Use Ruby 3.x features when appropriate (e.g., pattern matching, endless methods)
- Leverage Rails' built-in helpers and methods
- Use ActiveRecord effectively for database operations
- Prefix all rails commands with `bin/` like `bin/rails db:migrate`
- When generating migrations and running them, run them for both dev and test environments

### Clean Code Principles
- Replace hard-coded values with named constants
- Use meaningful names that reveal purpose
- Don't comment on what the code does - make the code self-documenting
- Each function should do exactly one thing
- Extract repeated code into reusable functions
- Keep related code together
- Hide implementation details
- Refactor continuously
- Fix technical debt early
- Leave code cleaner than you found it

## Service Objects
Service objects are used to:
- Make controllers simple
- Perform complex operations
- Make the code more DRY (if a complex operation is needed in more than one place)
- Make calls to external APIs

Service Object Guidelines:
- All services should inherit from ApplicationService
- Dry::Monads[:result] is included in ApplicationService
- Services should always return `Success(data)` or `Failure(MyError.new("whatever"))`

## View Components
- Use view components to create reusable UI pieces and encapsulate logic
- ApplicationComponent extends `Dry::Initializer`
- Define attributes using `option :order` or optional options like `option :extra, default: -> { false }`

## Testing
- Write comprehensive tests using RSpec
- Prefer request specs rather than system tests
- Follow TDD/BDD practices
- Use Rails fixtures or create Active Record objects for test data generation
- VCR is available when testing requests that use the network
- Use `let` to define test data
- Keep tests short and concise

## UI and Styling (Tailwind CSS)

### Component Styling
- Use utility classes over custom CSS
- Group related utilities with @apply when needed
- Use proper responsive design utilities
- Implement dark mode properly
- Use proper state variants
- Keep component styles consistent

### Layout
- Use Flexbox and Grid utilities effectively
- Implement proper spacing system
- Use container queries when needed
- Implement proper responsive breakpoints
- Use proper padding and margin utilities
- Implement proper alignment utilities

### Typography and Colors
- Use proper font size utilities
- Implement proper line height
- Use proper font weight utilities
- Use semantic color naming
- Implement proper color contrast
- Use opacity utilities effectively

### Components and Responsive Design
- Use shadcn/ui components when available
- Extend components properly
- Keep component variants consistent
- Use mobile-first approach
- Implement proper breakpoints
- Handle different screen sizes properly

### Performance
- Use proper purge configuration
- Minimize custom CSS
- Use proper caching strategies
- Implement proper code splitting
- Optimize for production
- Monitor bundle size
