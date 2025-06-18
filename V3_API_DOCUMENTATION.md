# TwMerge v3 API Documentation

This document serves as a backup of the current v3 API before migrating to v4 support.

## Public API

### Main Functions

#### `TwMerge.merge/1`
```elixir
@spec merge(list() | binary()) :: binary()
```
Merges TailwindCSS classes, resolving conflicts by giving precedence to classes that appear later.

**Examples:**
```elixir
TwMerge.merge("text-white bg-red-500 bg-blue-300")
# => "text-white bg-blue-300"

TwMerge.merge(["px-2 py-1 bg-red hover:bg-dark-red", "p-3 bg-[#B91C1C]"])
# => "hover:bg-dark-red p-3 bg-[#B91C1C]"
```

#### `TwMerge.merge/2`
```elixir
@spec merge(list() | binary(), term()) :: binary()
```
Merges classes with custom configuration.

**Examples:**
```elixir
config = %{prefix: "tw-"}
TwMerge.merge("tw-bg-red-500 tw-bg-blue-300", config)
# => "tw-bg-blue-300"
```

#### `TwMerge.join/1`
```elixir
@spec join(list()) :: binary()
```
Joins a list of class strings into a single space-separated string.

**Examples:**
```elixir
TwMerge.join(["bg-red-500", "text-white", "p-4"])
# => "bg-red-500 text-white p-4"
```

## Configuration

### Application Configuration
```elixir
config :tw_merge,
  prefix: "tw-",  # Optional prefix for TailwindCSS classes
  theme: %{...}   # Custom theme configuration
```

### Default Theme Configuration
Current v3 theme keys and their validators:
- `colors` - `[&any?/1]`
- `spacing` - `[&length?/1, &arbitrary_length?/1]`
- `blur` - `["none", "", &tshirt_size?/1, &arbitrary_value?/1]`
- `brightness` - `number()`
- `borderColor` - `[&from_theme(&1, "colors")]`
- `borderRadius` - `["none", "", "full", &tshirt_size?/1, &arbitrary_value?/1]`
- `borderSpacing` - `spacing_with_arbitrary()`
- `borderWidth` - `length_with_empty_and_arbitrary()`
- `contrast` - `number()`
- `grayscale` - `zero_and_empty()`
- `hueRotate` - `number_and_arbitrary()`
- `invert` - `zero_and_empty()`
- `gap` - `spacing_with_arbitrary()`
- `gradientColorStops` - `[&from_theme(&1, "colors")]`
- `gradientColorStopPositions` - `[&percent?/1, &arbitrary_length?/1]`
- `inset` - `spacing_with_auto_and_arbitrary()`
- `margin` - `spacing_with_auto_and_arbitrary()`
- `opacity` - `number()`
- `padding` - `spacing_with_arbitrary()`
- `saturate` - `number()`
- `scale` - `number()`
- `sepia` - `zero_and_empty()`
- `skew` - `number_and_arbitrary()`
- `space` - `spacing_with_arbitrary()`
- `translate` - `spacing_with_arbitrary()`

## Supported Utilities (v3)

### Layout
- `aspect-*`, `container`, `columns`, `break-*`, `box-*`, `display`, `float`, `clear`, `isolation`
- `object-*`, `overflow-*`, `overscroll-*`, `position`, `inset-*`, `visibility`, `z-*`

### Flexbox & Grid
- `basis-*`, `flex-*`, `grow-*`, `shrink-*`, `order-*`
- `grid-*`, `col-*`, `row-*`, `gap-*`
- `justify-*`, `align-*`, `place-*`

### Spacing
- `p-*`, `px-*`, `py-*`, `ps-*`, `pe-*`, `pt-*`, `pr-*`, `pb-*`, `pl-*`
- `m-*`, `mx-*`, `my-*`, `ms-*`, `me-*`, `mt-*`, `mr-*`, `mb-*`, `ml-*`
- `space-*`

### Sizing
- `w-*`, `min-w-*`, `max-w-*`, `h-*`, `min-h-*`, `max-h-*`, `size-*`

### Typography
- `font-*`, `text-*`, `leading-*`, `tracking-*`, `line-clamp-*`
- `list-*`, `placeholder-*`, `text-decoration-*`, `underline-offset-*`
- `text-transform`, `text-overflow`, `text-wrap`, `indent-*`
- `vertical-align`, `whitespace`, `break-*`, `hyphens`, `content-*`

### Backgrounds
- `bg-*` (attachment, clip, opacity, origin, position, repeat, size, image, color)
- `gradient-*` (from, via, to positions and colors)

### Borders
- `rounded-*`, `border-*`, `divide-*`, `outline-*`

### Effects
- `shadow-*`, `opacity-*`, `mix-blend-*`, `bg-blend-*`

### Filters
- `filter`, `blur-*`, `brightness-*`, `contrast-*`, `drop-shadow-*`
- `grayscale-*`, `hue-rotate-*`, `invert-*`, `saturate-*`, `sepia-*`
- `backdrop-*`

### Tables
- `border-collapse`, `border-spacing-*`, `table-*`, `caption-*`

### Transitions & Animation
- `transition-*`, `duration-*`, `ease-*`, `delay-*`, `animate-*`

### Transforms
- `transform`, `scale-*`, `rotate-*`, `translate-*`, `skew-*`, `transform-origin`

### Interactivity
- `accent-*`, `appearance-*`, `cursor-*`, `caret-color-*`, `pointer-events-*`
- `resize-*`, `scroll-*`, `snap-*`, `touch-*`, `select-*`, `will-change-*`

### SVG
- `fill-*`, `stroke-*`

### Accessibility
- `sr-*`, `forced-color-adjust-*`

## Deprecated in v4 (Still Supported in v3)

### Opacity Utilities
- `bg-opacity-*` - Use `bg-color/opacity` syntax in v4
- `text-opacity-*` - Use `text-color/opacity` syntax in v4
- `border-opacity-*` - Use `border-color/opacity` syntax in v4
- `divide-opacity-*` - Use `divide-color/opacity` syntax in v4
- `ring-opacity-*` - Use `ring-color/opacity` syntax in v4

### Placeholder Utilities
- `placeholder-color` - Deprecated in v4
- `placeholder-opacity` - Deprecated in v4

### Other Deprecated Features
- Empty string in `shadow` scale (e.g., `shadow-""`)
- Empty string in `border-radius` scale (e.g., `rounded-""`)
- Some position utility combinations
- `max-w-prose` and `max-w-screen-*` utilities

## Conflict Resolution Rules

Classes are organized into conflicting groups where only one class from each group can be active:

### Major Conflict Groups
- **Background Colors**: `bg-red-500` conflicts with `bg-blue-300`
- **Text Colors**: `text-white` conflicts with `text-black`
- **Spacing**: `p-4` conflicts with `px-2 py-2`
- **Sizing**: `w-full` conflicts with `w-1/2`
- **Positioning**: `top-0` conflicts with `top-4`

### Resolution Strategy
- **Last wins**: The class that appears later in the input takes precedence
- **Specificity**: More specific classes (e.g., `px-4`) override general ones (e.g., `p-2`)
- **Modifiers preserved**: Modifiers like `hover:`, `lg:` are preserved independently

## Arbitrary Value Support

### Current Syntax (v3)
- `bg-[#1da1f2]` - Custom colors
- `text-[22px]` - Custom sizes
- `top-[117px]` - Custom positioning
- `bg-[url('/img.png')]` - Custom images
- `[mask-type:luminance]` - Custom properties

### CSS Variables (v3)
- `bg-[--my-color]` - Square bracket syntax for CSS variables

## Error Handling

### Invalid Classes
- Unknown classes are passed through unchanged
- Invalid arbitrary values are passed through unchanged
- Malformed class strings are handled gracefully

### Edge Cases
- Empty strings and whitespace are handled correctly
- Duplicate classes are deduplicated
- Mixed input types (strings and lists) are supported

## Performance Characteristics

### Caching
- Uses ETS-based caching for parsed class results
- Cache must be started via `TwMerge.Cache` in supervision tree
- Cache improves performance for repeated class combinations

### Parser
- Uses NimbleParsec for efficient class string parsing
- Supports complex class patterns and arbitrary values
- Handles modifiers and pseudo-classes correctly