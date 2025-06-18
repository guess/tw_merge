# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

TwMerge is an Elixir library that provides utilities for merging TailwindCSS classes intelligently. It resolves conflicting TailwindCSS classes by giving precedence to classes that appear later in the class list, solving the common issue where CSS specificity doesn't match the developer's intent.

## Common Development Commands

### Build and Dependencies
- `mix deps.get` - Install dependencies
- `mix compile` - Compile the project

### Testing
- `mix test` - Run all tests
- `mix test test/tw_merge_test.exs` - Run specific test file
- `mix test test/tw_merge_test.exs:LINE_NUMBER` - Run specific test at line number
- `mix coveralls` - Run tests with coverage report
- `mix coveralls.html` - Generate HTML coverage report

### Code Quality
- `mix format` - Format code according to .formatter.exs
- `mix credo` - Run static code analysis
- `mix format --check-formatted` - Check if code is properly formatted (CI-friendly)

### Documentation
- `mix docs` - Generate documentation
- `mix hex.publish` - Publish to Hex.pm (requires authentication)

## Architecture and Structure

### Core Modules
- **`TwMerge`** (lib/tw_merge.ex) - Main public API with `merge/1`, `merge/2`, and `join/1` functions
- **`TwMerge.Cache`** (lib/cache.ex) - ETS-based caching system for parsed classes (must be added to supervision tree)
- **`TwMerge.Class`** (lib/tw_merge/class.ex) - Handles parsing and categorization of individual TailwindCSS classes
- **`TwMerge.ClassTree`** (lib/tw_merge/class_tree.ex) - Tree structure for organizing conflicting class groups
- **`TwMerge.Config`** (lib/tw_merge/config.ex) - Configuration management (currently supports TailwindCSS prefix)
- **`TwMerge.Parser`** (lib/tw_merge/parser.ex) - NimbleParsec-based parser for class strings
- **`TwMerge.Validator`** (lib/tw_merge/validator.ex) - Validation logic for class values

### Reference Implementation
The TypeScript tailwind-merge library source code is available at `tailwind-merge/` for reference. Key files:
- **`tailwind-merge/src/lib/default-config.ts`** - The v4-compatible configuration that should be ported to Elixir
- **`tailwind-merge/src/lib/validators.ts`** - Validator implementations for v4 syntax
- **`tailwind-merge/tests/`** - Comprehensive test suite that can guide Elixir test implementation

### Key Design Decisions
1. **Caching Strategy**: Uses ETS for caching parsed classes to improve performance. The cache process must be started as part of the application supervision tree.
2. **Conflict Resolution**: Classes are organized into conflicting groups (e.g., all background color classes conflict). The last class in the input list wins.
3. **Parser Implementation**: Uses NimbleParsec for efficient parsing of class strings, including support for arbitrary values in square brackets.

### Configuration
The library supports configuring a TailwindCSS prefix via application config:
```elixir
config :tw_merge,
  prefix: "tw-"
```

## Tailwind CSS Version Support

**Current Status**: This library supports Tailwind CSS v3. 

**v4 Migration**: See `UPGRADE_TO_V4.md` for the comprehensive plan to add Tailwind CSS v4 support. The TypeScript reference implementation in `tailwind-merge/` provides the v4-compatible configuration and validators that need to be ported.