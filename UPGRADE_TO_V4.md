# TwMerge Upgrade Plan: Tailwind CSS v4 Support

## Overview
This document outlines the comprehensive plan to upgrade TwMerge from Tailwind CSS v3 to v4 support by applying the TypeScript tailwind-merge v3 configuration.

## Phase 1: Preparation & Analysis

### 1.1 Create Feature Branch
- [x] Create `tailwind-v4-support` branch
- [x] Set up v4 compatibility testing environment

### 1.2 Backup Current State
- [x] Document current v3 API for migration guide
- [x] Create comprehensive test suite for v3 behavior

## Phase 2: Core Infrastructure Updates

### 2.1 Add New Validators
- [x] Create new validators in `lib/tw_merge/validator.ex`:

```elixir
# New v4 validators implemented:
✅ arbitrary_variable?/1
✅ arbitrary_variable_length?/1
✅ arbitrary_variable_image?/1
✅ arbitrary_variable_position?/1
✅ arbitrary_variable_shadow?/1
✅ arbitrary_variable_size?/1
✅ arbitrary_variable_family_name?/1
✅ fraction?/1
✅ any_non_arbitrary?/1
```

### 2.2 Update Theme Structure
- [x] Update `lib/tw_merge/config.ex` theme keys:

```elixir
# V3 → V4 Theme Key Mapping:
✅ colors → color
✅ spacing → spacing (with enhanced values)
✅ blur → blur (with enhanced values)
✅ borderColor → (use unified color theme)
✅ borderRadius → radius
✅ borderSpacing → (maintained for compatibility)
✅ borderWidth → (maintained for compatibility)

# New v4 theme keys added:
✅ font, text, font-weight, tracking, leading
✅ breakpoint, container, shadow, inset-shadow
✅ text-shadow, drop-shadow, perspective
✅ aspect, ease, animate

# Legacy theme keys maintained for compatibility:
✅ All existing theme references preserved
```

## Phase 3: Configuration Migration

### 3.1 Remove Deprecated Utilities
**Breaking Changes** - Remove from config:
- [x] `placeholder-opacity` (removed from config)
- [x] `text-opacity` (removed from config)
- [x] `bg-opacity` (removed from config)
- [x] `border-opacity` (removed from config)
- [x] `divide-opacity` (removed from config)
- [x] `ring-opacity` (removed from config)

```elixir
# Deprecated utilities successfully removed from lib/tw_merge/config.ex
# These utilities are no longer part of the merging configuration
# Users should migrate to slash syntax in v4: bg-red-500/50
```

### 3.2 Add New Utility Groups
Add missing v4 utilities:
- [x] `sr` (screen reader utilities)
- [x] `field-sizing`
- [x] `backdrop-*` utilities (updated with v4 arbitrary variable support)
- [x] `will-change` (already present)
- [x] `line-clamp` (already present)
- [x] `mask-*` utilities (full mask suite added)
- [x] `transform-style`
- [x] `rotate-x`, `rotate-y`, `rotate-z`
- [x] `scale-z`, `scale-3d`
- [x] `translate-z`, `translate-none`
- [x] `inset-shadow` utilities

```elixir
# New v4 utilities successfully added:
✅ field-sizing: ["fixed", "content"]
✅ mask-*: clip, composite, image, mode, origin, position, repeat, size, type
✅ 3D transforms: rotate-x/y/z, scale-z/3d, translate-z, transform-style
✅ inset-shadow: shadow utilities with inset support
✅ Enhanced backdrop-*: all utilities support arbitrary variables
```

### 3.3 Update Existing Utilities
- [x] Update `shadow` scale (enhanced with v4 arbitrary variable support)
- [x] Update `inset-shadow` utilities (added missing utilities)
- [x] Update `drop-shadow` (enhanced with v4 arbitrary variable support)
- [x] Update border radius (enhanced with v4 arbitrary variable support)
- [x] Update transform conflicts (added translate-z conflicts)

## Phase 4: Validator Implementation

### 4.1 Extend Validator Module
```elixir
# lib/tw_merge/validator.ex additions:

def arbitrary_variable?(value) do
  # Match CSS variables with new v4 syntax
  # Support both old [--var] and new (--var) syntax initially
end

def fraction?(value) do
  # Match fraction values like 1/2, 3/4
end

def percent?(value) do
  # Match percentage values
end
```

### 4.2 Update Parser
- [ ] Ensure parser can handle new arbitrary value syntaxes
- [ ] Add support for new modifier positions (if needed)

## Phase 5: Testing & Validation

### 5.1 Test Suite Updates
- [ ] Add tests for all new validators
- [ ] Add tests for new utility groups
- [ ] Add tests for deprecated utility handling
- [ ] Add compatibility tests

### 5.2 Migration Tests
- [ ] Create tests that verify v3 → v4 migrations
- [ ] Document breaking changes clearly
- [ ] Test with real Tailwind v4 projects

## Phase 6: Documentation & Release

### 6.1 Update Documentation
- [ ] Update README.md with v4 support notice
- [ ] Create MIGRATION.md guide
- [ ] Update CLAUDE.md with v4 information
- [ ] Document all breaking changes

### 6.2 Version Strategy
Options:
1. **Major Version Bump** (Recommended)
   - Release as v1.0.0
   - Clear signal of breaking changes
   - Separate branch for v3 maintenance

2. **Feature Flag Approach**
   - Add config option: `version: :v3 | :v4`
   - More complex but maintains compatibility
   - Larger codebase to maintain

### 6.3 Release Plan
1. Alpha release for testing
2. Beta with migration guide
3. RC with full documentation
4. Final release

## Phase 7: Implementation Order

### Week 1: Infrastructure
1. Create validators
2. Update theme structure
3. Set up test framework

### Week 2: Configuration
1. Port TypeScript config to Elixir
2. Remove deprecated utilities
3. Add new utilities

### Week 3: Testing & Refinement
1. Comprehensive testing
2. Bug fixes
3. Performance optimization

### Week 4: Documentation & Release
1. Write migration guide
2. Update all docs
3. Prepare release

## Breaking Changes Summary

### Removed Utilities
- All `-opacity-*` utilities (use slash syntax)
- Placeholder color utilities

### Changed Behavior
- Shadow utilities no longer accept empty string
- New theme key names
- Some position utilities deprecated

### Migration Path
```elixir
# Before (v3)
"bg-red-500 bg-opacity-50"

# After (v4) - NOT SUPPORTED YET
"bg-red-500/50"

# Temporary workaround
"bg-red-500" # with opacity handled differently
```

## Risk Mitigation

1. **Compatibility Mode**: Consider supporting both v3/v4 initially
2. **Deprecation Warnings**: Log warnings for v3 syntax usage
3. **Migration Tool**: Consider building automated migration tool
4. **Extensive Testing**: Test against real-world Tailwind v4 projects

## Success Criteria

- [ ] All v4 utilities from TypeScript config are supported
- [ ] Deprecated v3 utilities are removed
- [ ] All tests pass
- [ ] Performance remains comparable
- [ ] Clear migration path documented
- [ ] Community feedback incorporated

## Notes

- The TypeScript config is from tailwind-merge v3.x which supports Tailwind CSS v4
- Focus on data/config changes rather than architectural changes
- Maintain backward compatibility where possible
- Consider community input before finalizing breaking changes