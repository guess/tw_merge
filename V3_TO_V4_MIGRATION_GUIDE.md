# TwMerge v3 to v4 Migration Guide

This guide helps you migrate from TwMerge v3 (Tailwind CSS v3 support) to TwMerge v4 (Tailwind CSS v4 support).

## Overview

TwMerge v4 introduces breaking changes to align with Tailwind CSS v4. This migration is necessary to support the new Tailwind CSS v4 syntax and utilities while removing deprecated features.

## Breaking Changes

### 1. Removed Opacity Utilities

**What's Removed:**
- `bg-opacity-*`
- `text-opacity-*`
- `border-opacity-*`
- `divide-opacity-*`
- `ring-opacity-*`

**Migration:**
```diff
# v3 (Will be removed in v4)
- "bg-red-500 bg-opacity-50"
- "text-blue-600 text-opacity-75"

# v4 (New slash syntax - Future support)
+ "bg-red-500/50"
+ "text-blue-600/75"

# Temporary workaround (Use CSS custom properties)
+ "bg-red-500 [--tw-bg-opacity:0.5]"
+ "text-blue-600 [--tw-text-opacity:0.75]"
```

### 2. Removed Placeholder Utilities

**What's Removed:**
- `placeholder-color`
- `placeholder-opacity`

**Migration:**
```diff
# v3 (Will be removed in v4)
- "placeholder-gray-400 placeholder-opacity-50"

# v4 (Use arbitrary properties)
+ "[&::placeholder]:text-gray-400 [&::placeholder]:opacity-50"
```

### 3. Shadow Utility Changes

**What Changed:**
- Empty string no longer accepted in shadow scale

**Migration:**
```diff
# v3 (Empty string accepted)
- "shadow"  # Equivalent to "shadow-" 

# v4 (No empty string)
+ "shadow-sm"  # Use explicit shadow size
```

### 4. Border Radius Changes

**What Changed:**
- Empty string no longer accepted in border radius scale

**Migration:**
```diff
# v3 (Empty string accepted)
- "rounded"  # Equivalent to "rounded-"

# v4 (No empty string)
+ "rounded-sm"  # Use explicit radius size
```

### 5. New CSS Variable Syntax

**What Changed:**
- CSS variables now use parentheses instead of square brackets

**Migration:**
```diff
# v3 (Square brackets)
- "bg-[--primary-color]"
- "text-[--secondary-color]"

# v4 (Parentheses)
+ "bg-(--primary-color)"
+ "text-(--secondary-color)"
```

## New Features in v4

### 1. New Utility Classes

**Added:**
- `field-sizing-*` - Field sizing utilities
- `inset-shadow-*` - Inset shadow utilities
- `text-shadow-*` - Text shadow utilities
- `mask-*` - Mask utilities
- `transform-style-*` - Transform style utilities
- 3D transform utilities: `rotate-x-*`, `rotate-y-*`, `rotate-z-*`, `scale-z-*`, `translate-z-*`

### 2. Enhanced Validators

**New validators support:**
- CSS variables with parentheses syntax
- Fraction values (e.g., `1/2`, `3/4`)
- Enhanced arbitrary value patterns

### 3. Updated Theme Structure

**Theme key changes:**
```diff
# v3 Theme Keys
- colors → color
- borderRadius → radius
# Many utilities now use shared theme scales
```

## Migration Steps

### Step 1: Audit Your Current Usage

1. Search your codebase for deprecated utilities:
   ```bash
   # Find opacity utilities
   grep -r "bg-opacity-\|text-opacity-\|border-opacity-" your-project/
   
   # Find placeholder utilities
   grep -r "placeholder-color\|placeholder-opacity" your-project/
   
   # Find CSS variables with square brackets
   grep -r "\[--" your-project/
   ```

### Step 2: Update Dependencies

```diff
# mix.exs
def deps do
  [
-   {:tw_merge, "~> 0.1.0"}
+   {:tw_merge, "~> 1.0.0"}  # v4 support
  ]
end
```

### Step 3: Replace Deprecated Utilities

#### Opacity Utilities
```elixir
# Create a helper function for migration
defp migrate_opacity_classes(classes) do
  classes
  |> String.replace(~r/bg-(\w+)-(\d+)\s+bg-opacity-(\d+)/, "bg-\\1-\\2/\\3")
  |> String.replace(~r/text-(\w+)-(\d+)\s+text-opacity-(\d+)/, "text-\\1-\\2/\\3")
end
```

#### CSS Variables
```elixir
# Helper for CSS variable syntax
defp migrate_css_variables(classes) do
  String.replace(classes, ~r/\[(--.+?)\]/, "(\\1)")
end
```

### Step 4: Update Tests

Update your test expectations to match v4 behavior:

```diff
# Before
- assert TwMerge.merge("bg-red-500 bg-opacity-50") == "bg-red-500 bg-opacity-50"

# After  
+ assert TwMerge.merge("bg-red-500/50") == "bg-red-500/50"
```

### Step 5: Handle Configuration Changes

If you use custom configuration:

```diff
# v3 config
config :tw_merge,
  theme: %{
-   colors: [...],
-   borderRadius: [...]
  }

# v4 config  
config :tw_merge,
  theme: %{
+   color: [...],
+   radius: [...]
  }
```

## Compatibility Mode (If Available)

If your project needs gradual migration, you may be able to use compatibility mode:

```elixir
# Configuration to maintain v3 behavior temporarily
config :tw_merge,
  version: :v3  # Maintain v3 compatibility
```

**Note:** Compatibility mode (if implemented) would be temporary and removed in future versions.

## Testing Your Migration

### 1. Run Your Existing Tests
```bash
mix test
```

### 2. Test v4 Compatibility
```bash
mix test --only v4_breaking_change
mix test --only v4_new_feature
```

### 3. Visual Testing
Test your UI components to ensure styles render correctly after migration.

## Common Migration Issues

### Issue 1: Classes Not Merging
**Problem:** Classes that used to merge no longer do.
**Solution:** Check if you're using deprecated utilities and update to v4 syntax.

### Issue 2: Opacity Not Working
**Problem:** Background or text opacity not applying.
**Solution:** Use new slash syntax: `bg-red-500/50` instead of `bg-red-500 bg-opacity-50`.

### Issue 3: CSS Variables Not Recognized
**Problem:** CSS variables in square brackets not working.
**Solution:** Update to parentheses syntax: `bg-(--color)` instead of `bg-[--color]`.

## Resources

- [Tailwind CSS v4 Upgrade Guide](https://tailwindcss.com/docs/upgrade-guide)
- [TwMerge v4 Documentation](#) (Coming soon)
- [GitHub Issues](https://github.com/your-repo/tw_merge/issues) - Report migration problems

## Support

If you encounter issues during migration:

1. Check this guide for common solutions
2. Search existing GitHub issues
3. Create a new issue with a minimal reproduction case

## Timeline

- **v1.0.0-alpha**: Initial v4 support (breaking changes)
- **v1.0.0-beta**: Migration tools and documentation
- **v1.0.0**: Stable v4 support
- **v0.x**: v3 support (maintenance only)