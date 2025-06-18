defmodule TwMerge.Config do
  @moduledoc false
  import TwMerge.Validator

  @theme_groups ~w(animate aspect blur breakpoint color container drop-shadow ease font font-weight inset-shadow leading perspective radius shadow spacing text text-shadow tracking borderWidth borderSpacing brightness contrast grayscale hueRotate invert opacity saturate scale sepia skew translate margin padding gap inset gradientColorStops gradientColorStopPositions space)

  alias TwMerge.Scale

  def config do
    prefix = Application.get_env(:tw_merge, :prefix)
    theme = Application.get_env(:tw_merge, :theme, default_theme())

    Map.merge(%{prefix: prefix, theme: theme}, settings())
  end

  defp default_theme do
    %{
      # v4 theme structure based on TypeScript configuration
      animate: ["spin", "ping", "pulse", "bounce"],
      aspect: ["video"],
      blur: [&tshirt_size?/1],
      breakpoint: [&tshirt_size?/1],
      color: [&any?/1, &arbitrary_variable?/1],
      container: [&tshirt_size?/1],
      "drop-shadow": [&tshirt_size?/1],
      ease: ["in", "out", "in-out"],
      font: [&any_non_arbitrary?/1, &arbitrary_variable_family_name?/1],
      "font-weight": [
        "thin",
        "extralight",
        "light",
        "normal",
        "medium",
        "semibold",
        "bold",
        "extrabold",
        "black"
      ],
      "inset-shadow": ["none", &tshirt_size?/1, &arbitrary_variable?/1, &arbitrary_value?/1],
      leading: ["none", "tight", "snug", "normal", "relaxed", "loose"],
      perspective: ["dramatic", "near", "normal", "midrange", "distant", "none"],
      radius: ["", "none", "full", &tshirt_size?/1, &arbitrary_variable?/1, &arbitrary_value?/1],
      shadow: ["", "inner", "none", &tshirt_size?/1, &arbitrary_variable?/1, &arbitrary_value?/1],
      spacing: ["px", &number?/1, &arbitrary_variable_length?/1],
      text: [&tshirt_size?/1],
      "text-shadow": [&tshirt_size?/1],
      tracking: ["tighter", "tight", "normal", "wide", "wider", "widest"]
    }
  end

  defp settings do
    %{
      groups: %{
        # --------------
        # --- Layout ---
        # --------------
        # Aspect Ratio
        # @see https://tailwindcss.com/docs/aspect-ratio
        "aspect" => %{
          "aspect" => [
            "auto",
            "square",
            &fraction?/1,
            &arbitrary_value?/1,
            &arbitrary_variable?/1,
            &from_theme(&1, "aspect")
          ]
        },
        # Container
        # @see https://tailwindcss.com/docs/container
        # @deprecated since Tailwind CSS v4.0.0
        "container" => ["container"],
        # Columns
        # @see https://tailwindcss.com/docs/columns
        "columns" => %{
          "columns" => [
            &number?/1,
            &arbitrary_value?/1,
            &arbitrary_variable?/1,
            &from_theme(&1, "container")
          ]
        },
        # Break After
        # @see https://tailwindcss.com/docs/break-after
        "break-after" => %{"break-after" => Scale.break()},
        # Break Before
        # @see https://tailwindcss.com/docs/break-before
        "break-before" => %{"break-before" => Scale.break()},
        # Break Inside
        # @see https://tailwindcss.com/docs/break-inside
        "break-inside" => %{"break-inside" => ["auto", "avoid", "avoid-page", "avoid-column"]},
        # Box Decoration Break
        # @see https://tailwindcss.com/docs/box-decoration-break
        "box-decoration" => %{"box-decoration" => ["slice", "clone"]},
        # Box Sizing
        # @see https://tailwindcss.com/docs/box-sizing
        "box" => %{"box" => ["border", "content"]},
        # Display
        # @see https://tailwindcss.com/docs/display
        "display" => [
          "block",
          "inline-block",
          "inline",
          "flex",
          "inline-flex",
          "table",
          "inline-table",
          "table-caption",
          "table-cell",
          "table-column",
          "table-column-group",
          "table-footer-group",
          "table-header-group",
          "table-row-group",
          "table-row",
          "flow-root",
          "grid",
          "inline-grid",
          "contents",
          "list-item",
          "hidden"
        ],
        # Screen Reader Only
        # @see https://tailwindcss.com/docs/display#screen-reader-only
        "sr" => ["sr-only", "not-sr-only"],
        # Floats
        # @see https://tailwindcss.com/docs/float
        "float" => %{"float" => ["right", "left", "none", "start", "end"]},
        # Clear
        # @see https://tailwindcss.com/docs/clear
        "clear" => %{"clear" => ["left", "right", "both", "none", "start", "end"]},
        # Isolation
        # @see https://tailwindcss.com/docs/isolation
        "isolation" => ["isolate", "isolation-auto"],
        # Object Fit
        # @see https://tailwindcss.com/docs/object-fit
        "object-fit" => %{"object" => ["contain", "cover", "fill", "none", "scale-down"]},
        # Object Position
        # @see https://tailwindcss.com/docs/object-position
        "object-position" => %{"object" => Scale.position_with_arbitrary()},
        # Overflow
        # @see https://tailwindcss.com/docs/overflow
        "overflow" => %{"overflow" => Scale.overflow()},
        # Overflow X
        # @see https://tailwindcss.com/docs/overflow
        "overflow-x" => %{"overflow-x" => Scale.overflow()},
        # Overflow Y
        # @see https://tailwindcss.com/docs/overflow
        "overflow-y" => %{"overflow-y" => Scale.overflow()},
        # Overscroll Behavior
        # @see https://tailwindcss.com/docs/overscroll-behavior
        "overscroll" => %{"overscroll" => Scale.overscroll()},
        # Overscroll Behavior X
        # @see https://tailwindcss.com/docs/overscroll-behavior
        "overscroll-x" => %{"overscroll-x" => Scale.overscroll()},
        # Overscroll Behavior Y
        # @see https://tailwindcss.com/docs/overscroll-behavior
        "overscroll-y" => %{"overscroll-y" => Scale.overscroll()},
        # Position
        # @see https://tailwindcss.com/docs/position
        "position" => ["static", "fixed", "absolute", "relative", "sticky"],
        # Top / Right / Bottom / Left
        # @see https://tailwindcss.com/docs/top-right-bottom-left
        "inset" => %{"inset" => Scale.inset()},
        # Right / Left
        # @see https://tailwindcss.com/docs/top-right-bottom-left
        "inset-x" => %{"inset-x" => Scale.inset()},
        # Top / Bottom
        # @see https://tailwindcss.com/docs/top-right-bottom-left
        "inset-y" => %{"inset-y" => Scale.inset()},
        # Start
        # @see https://tailwindcss.com/docs/top-right-bottom-left
        "start" => %{"start" => Scale.inset()},
        # End
        # @see https://tailwindcss.com/docs/top-right-bottom-left
        "end" => %{"end" => Scale.inset()},
        # Top
        # @see https://tailwindcss.com/docs/top-right-bottom-left
        "top" => %{"top" => Scale.inset()},
        # Right
        # @see https://tailwindcss.com/docs/top-right-bottom-left
        "right" => %{"right" => Scale.inset()},
        # Bottom
        # @see https://tailwindcss.com/docs/top-right-bottom-left
        "bottom" => %{"bottom" => Scale.inset()},
        # Left
        # @see https://tailwindcss.com/docs/top-right-bottom-left
        "left" => %{"left" => Scale.inset()},
        # Visibility
        # @see https://tailwindcss.com/docs/visibility
        "visibility" => ["visible", "invisible", "collapse"],
        # Z-Index
        # @see https://tailwindcss.com/docs/z-index
        "z" => %{"z" => [&integer?/1, "auto", &arbitrary_variable?/1, &arbitrary_value?/1]},

        # ------------------------
        # --- Flexbox and Grid ---
        # ------------------------

        # Flex Basis
        # @see https://tailwindcss.com/docs/flex-basis
        "basis" => %{
          "basis" => [
            &fraction?/1,
            "full",
            "auto",
            &from_theme(&1, "container"),
            &arbitrary_variable?/1,
            &arbitrary_value?/1,
            &from_theme(&1, "spacing")
          ]
        },
        # Flex Direction
        # @see https://tailwindcss.com/docs/flex-direction
        "flex-direction" => %{"flex" => ["row", "row-reverse", "col", "col-reverse"]},
        # Flex Wrap
        # @see https://tailwindcss.com/docs/flex-wrap
        "flex-wrap" => %{"flex" => ["nowrap", "wrap", "wrap-reverse"]},
        # Flex
        # @see https://tailwindcss.com/docs/flex
        "flex" => %{
          "flex" => [&number?/1, &fraction?/1, "auto", "initial", "none", &arbitrary_value?/1]
        },
        # Flex Grow
        # @see https://tailwindcss.com/docs/flex-grow
        "grow" => %{"grow" => ["", &number?/1, &arbitrary_variable?/1, &arbitrary_value?/1]},
        # Flex Shrink
        # @see https://tailwindcss.com/docs/flex-shrink
        "shrink" => %{"shrink" => ["", &number?/1, &arbitrary_variable?/1, &arbitrary_value?/1]},
        # Order
        # @see https://tailwindcss.com/docs/order
        "order" => %{
          "order" => [
            &integer?/1,
            "first",
            "last",
            "none",
            &arbitrary_variable?/1,
            &arbitrary_value?/1
          ]
        },
        # Grid Template Columns
        # @see https://tailwindcss.com/docs/grid-template-columns
        "grid-cols" => %{"grid-cols" => Scale.grid_template_cols_rows()},
        # Grid Column Start / End
        # @see https://tailwindcss.com/docs/grid-column
        "col-start-end" => %{"col" => Scale.grid_col_row_start_and_end()},
        # Grid Column Start
        # @see https://tailwindcss.com/docs/grid-column
        "col-start" => %{"col-start" => Scale.grid_col_row_start_or_end()},
        # Grid Column End
        # @see https://tailwindcss.com/docs/grid-column
        "col-end" => %{"col-end" => Scale.grid_col_row_start_or_end()},
        # Grid Template Rows
        # @see https://tailwindcss.com/docs/grid-template-rows
        "grid-rows" => %{"grid-rows" => Scale.grid_template_cols_rows()},
        # Grid Row Start / End
        # @see https://tailwindcss.com/docs/grid-row
        "row-start-end" => %{"row" => Scale.grid_col_row_start_and_end()},
        # Grid Row Start
        # @see https://tailwindcss.com/docs/grid-row
        "row-start" => %{"row-start" => Scale.grid_col_row_start_or_end()},
        # Grid Row End
        # @see https://tailwindcss.com/docs/grid-row
        "row-end" => %{"row-end" => Scale.grid_col_row_start_or_end()},
        # Grid Auto Flow
        # @see https://tailwindcss.com/docs/grid-auto-flow
        "grid-flow" => %{"grid-flow" => ["row", "col", "dense", "row-dense", "col-dense"]},
        # Grid Auto Columns
        # @see https://tailwindcss.com/docs/grid-auto-columns
        "auto-cols" => %{"auto-cols" => Scale.grid_auto_cols_rows()},
        # Grid Auto Rows
        # @see https://tailwindcss.com/docs/grid-auto-rows
        "auto-rows" => %{"auto-rows" => Scale.grid_auto_cols_rows()},
        # Gap
        # @see https://tailwindcss.com/docs/gap
        "gap" => %{"gap" => Scale.unambiguous_spacing()},
        # Gap X
        # @see https://tailwindcss.com/docs/gap
        "gap-x" => %{"gap-x" => Scale.unambiguous_spacing()},
        # Gap Y
        # @see https://tailwindcss.com/docs/gap
        "gap-y" => %{"gap-y" => Scale.unambiguous_spacing()},
        # Justify Content
        # @see https://tailwindcss.com/docs/justify-content
        "justify-content" => %{"justify" => ["normal" | Scale.align_primary_axis()]},
        # Justify Items
        # @see https://tailwindcss.com/docs/justify-items
        "justify-items" => %{"justify-items" => ["normal" | Scale.align_secondary_axis()]},
        # Justify Self
        # @see https://tailwindcss.com/docs/justify-self
        "justify-self" => %{"justify-self" => ["auto" | Scale.align_secondary_axis()]},
        # Align Content
        # @see https://tailwindcss.com/docs/align-content
        "align-content" => %{"content" => ["normal" | Scale.align_primary_axis()]},
        # Align Items
        # @see https://tailwindcss.com/docs/align-items
        "align-items" => %{
          "items" => [Scale.align_secondary_axis() | [%{"baseline" => ["", "last"]}]]
        },
        # Align Self
        # @see https://tailwindcss.com/docs/align-self
        "align-self" => %{
          "self" => ["auto" | [Scale.align_secondary_axis() | [%{"baseline" => ["", "last"]}]]]
        },
        # Place Content
        # @see https://tailwindcss.com/docs/place-content
        "place-content" => %{"place-content" => Scale.align_primary_axis()},
        # Place Items
        # @see https://tailwindcss.com/docs/place-items
        "place-items" => %{"place-items" => [Scale.align_secondary_axis() | ["baseline"]]},
        # Place Self
        # @see https://tailwindcss.com/docs/place-self
        "place-self" => %{"place-self" => ["auto" | Scale.align_secondary_axis()]},
        # Spacing
        # Padding
        # @see https://tailwindcss.com/docs/padding
        "p" => %{"p" => Scale.unambiguous_spacing()},
        # Padding X
        # @see https://tailwindcss.com/docs/padding
        "px" => %{"px" => Scale.unambiguous_spacing()},
        # Padding Y
        # @see https://tailwindcss.com/docs/padding
        "py" => %{"py" => Scale.unambiguous_spacing()},
        # Padding Start
        # @see https://tailwindcss.com/docs/padding
        "ps" => %{"ps" => Scale.unambiguous_spacing()},
        # Padding End
        # @see https://tailwindcss.com/docs/padding
        "pe" => %{"pe" => Scale.unambiguous_spacing()},
        # Padding Top
        # @see https://tailwindcss.com/docs/padding
        "pt" => %{"pt" => Scale.unambiguous_spacing()},
        # Padding Right
        # @see https://tailwindcss.com/docs/padding
        "pr" => %{"pr" => Scale.unambiguous_spacing()},
        # Padding Bottom
        # @see https://tailwindcss.com/docs/padding
        "pb" => %{"pb" => Scale.unambiguous_spacing()},
        # Padding Left
        # @see https://tailwindcss.com/docs/padding
        "pl" => %{"pl" => Scale.unambiguous_spacing()},
        # Margin
        # @see https://tailwindcss.com/docs/margin
        "m" => %{"m" => Scale.margin()},
        # Margin X
        # @see https://tailwindcss.com/docs/margin
        "mx" => %{"mx" => Scale.margin()},
        # Margin Y
        # @see https://tailwindcss.com/docs/margin
        "my" => %{"my" => Scale.margin()},
        # Margin Start
        # @see https://tailwindcss.com/docs/margin
        "ms" => %{"ms" => Scale.margin()},
        # Margin End
        # @see https://tailwindcss.com/docs/margin
        "me" => %{"me" => Scale.margin()},
        # Margin Top
        # @see https://tailwindcss.com/docs/margin
        "mt" => %{"mt" => Scale.margin()},
        # Margin Right
        # @see https://tailwindcss.com/docs/margin
        "mr" => %{"mr" => Scale.margin()},
        # Margin Bottom
        # @see https://tailwindcss.com/docs/margin
        "mb" => %{"mb" => Scale.margin()},
        # Margin Left
        # @see https://tailwindcss.com/docs/margin
        "ml" => %{"ml" => Scale.margin()},
        # Space Between X
        # @see https://tailwindcss.com/docs/margin#adding-space-between-children
        "space-x" => %{"space-x" => Scale.unambiguous_spacing()},
        # Space Between X Reverse
        # @see https://tailwindcss.com/docs/margin#adding-space-between-children
        "space-x-reverse" => ["space-x-reverse"],
        # Space Between Y
        # @see https://tailwindcss.com/docs/margin#adding-space-between-children
        "space-y" => %{"space-y" => Scale.unambiguous_spacing()},
        # Space Between Y Reverse
        # @see https://tailwindcss.com/docs/margin#adding-space-between-children
        "space-y-reverse" => ["space-y-reverse"],

        # --------------
        # --- Sizing ---
        # --------------

        # Size
        # @see https://tailwindcss.com/docs/width#setting-both-width-and-height
        "size" => %{"size" => Scale.sizing()},
        # Width
        # @see https://tailwindcss.com/docs/width
        "w" => %{"w" => [&from_theme(&1, "container"), "screen" | Scale.sizing()]},
        # Min-Width
        # @see https://tailwindcss.com/docs/min-width
        "min-w" => %{
          "min-w" => [
            &from_theme(&1, "container"),
            "screen",
            # Deprecated. @see https://github.com/tailwindlabs/tailwindcss.com/issues/2027#issuecomment-2620152757
            "none"
            | Scale.sizing()
          ]
        },
        # Max-Width
        # @see https://tailwindcss.com/docs/max-width
        "max-w" => %{
          "max-w" => [
            &from_theme(&1, "container"),
            "screen",
            "none",
            # Deprecated since Tailwind CSS v4.0.0. @see https://github.com/tailwindlabs/tailwindcss.com/issues/2027#issuecomment-2620152757
            "prose",
            # Deprecated since Tailwind CSS v4.0.0. @see https://github.com/tailwindlabs/tailwindcss.com/issues/2027#issuecomment-2620152757
            %{"screen" => [&from_theme(&1, "breakpoint")]}
            | Scale.sizing()
          ]
        },
        # Height
        # @see https://tailwindcss.com/docs/height
        "h" => %{"h" => ["screen", "lh" | Scale.sizing()]},
        # Min-Height
        # @see https://tailwindcss.com/docs/min-height
        "min-h" => %{"min-h" => ["screen", "lh", "none" | Scale.sizing()]},
        # Max-Height
        # @see https://tailwindcss.com/docs/max-height
        "max-h" => %{"max-h" => ["screen", "lh" | Scale.sizing()]},

        # ------------------
        # --- Typography ---
        # ------------------

        # Font Size
        # @see https://tailwindcss.com/docs/font-size
        "font-size" => %{
          "text" => [
            "base",
            &from_theme(&1, "text"),
            &arbitrary_variable_length?/1,
            &arbitrary_length?/1
          ]
        },
        # Font Smoothing
        # @see https://tailwindcss.com/docs/font-smoothing
        "font-smoothing" => ["antialiased", "subpixel-antialiased"],
        # Font Style
        # @see https://tailwindcss.com/docs/font-style
        "font-style" => ["italic", "not-italic"],
        # Font Weight
        # @see https://tailwindcss.com/docs/font-weight
        "font-weight" => %{
          "font" => [&from_theme(&1, "font-weight"), &arbitrary_variable?/1, &arbitrary_number?/1]
        },
        # Font Stretch
        # @see https://tailwindcss.com/docs/font-stretch
        "font-stretch" => %{
          "font-stretch" => [
            "ultra-condensed",
            "extra-condensed",
            "condensed",
            "semi-condensed",
            "normal",
            "semi-expanded",
            "expanded",
            "extra-expanded",
            "ultra-expanded",
            &percent?/1,
            &arbitrary_value?/1
          ]
        },
        # Font Family
        # @see https://tailwindcss.com/docs/font-family
        "font-family" => %{
          "font" => [
            &arbitrary_variable_family_name?/1,
            &arbitrary_value?/1,
            &from_theme(&1, "font")
          ]
        },
        # Font Variant Numeric
        # @see https://tailwindcss.com/docs/font-variant-numeric
        "fvn-normal" => ["normal-nums"],
        # Font Variant Numeric
        # @see https://tailwindcss.com/docs/font-variant-numeric
        "fvn-ordinal" => ["ordinal"],
        # Font Variant Numeric
        # @see https://tailwindcss.com/docs/font-variant-numeric
        "fvn-slashed-zero" => ["slashed-zero"],
        # Font Variant Numeric
        # @see https://tailwindcss.com/docs/font-variant-numeric
        "fvn-figure" => ["lining-nums", "oldstyle-nums"],
        # Font Variant Numeric
        # @see https://tailwindcss.com/docs/font-variant-numeric
        "fvn-spacing" => ["proportional-nums", "tabular-nums"],
        # Font Variant Numeric
        # @see https://tailwindcss.com/docs/font-variant-numeric
        "fvn-fraction" => ["diagonal-fractions", "stacked-fractions"],
        # Letter Spacing
        # @see https://tailwindcss.com/docs/letter-spacing
        "tracking" => %{
          "tracking" => [&from_theme(&1, "tracking"), &arbitrary_variable?/1, &arbitrary_value?/1]
        },
        # Line Clamp
        # @see https://tailwindcss.com/docs/line-clamp
        "line-clamp" => %{
          "line-clamp" => [&number?/1, "none", &arbitrary_variable?/1, &arbitrary_number?/1]
        },
        # Line Height
        # @see https://tailwindcss.com/docs/line-height
        "leading" => %{
          "leading" => [
            # Deprecated since Tailwind CSS v4.0.0. @see https://github.com/tailwindlabs/tailwindcss.com/issues/2027#issuecomment-2620152757
            (&from_theme(&1, "leading"))
            | Scale.unambiguous_spacing()
          ]
        },
        # List Style Image
        # @see https://tailwindcss.com/docs/list-style-image
        "list-image" => %{"list-image" => ["none", &arbitrary_variable?/1, &arbitrary_value?/1]},
        # List Style Position
        # @see https://tailwindcss.com/docs/list-style-position
        "list-style-position" => %{"list" => ["inside", "outside"]},
        # List Style Type
        # @see https://tailwindcss.com/docs/list-style-type
        "list-style-type" => %{
          "list" => ["disc", "decimal", "none", &arbitrary_variable?/1, &arbitrary_value?/1]
        },
        # Text Alignment
        # @see https://tailwindcss.com/docs/text-align
        "text-alignment" => %{"text" => ["left", "center", "right", "justify", "start", "end"]},
        # Placeholder Color
        # @deprecated since Tailwind CSS v3.0.0
        # @see https://v3.tailwindcss.com/docs/placeholder-color
        "placeholder-color" => %{"placeholder" => Scale.color()},
        # Text Color
        # @see https://tailwindcss.com/docs/text-color
        "text-color" => %{"text" => Scale.color()},
        # Text Decoration
        # @see https://tailwindcss.com/docs/text-decoration
        "text-decoration" => ["underline", "overline", "line-through", "no-underline"],
        # Text Decoration Style
        # @see https://tailwindcss.com/docs/text-decoration-style
        "text-decoration-style" => %{"decoration" => [Scale.line_style() | ["wavy"]]},
        # Text Decoration Thickness
        # @see https://tailwindcss.com/docs/text-decoration-thickness
        "text-decoration-thickness" => %{
          "decoration" => [
            &number?/1,
            "from-font",
            "auto",
            &arbitrary_variable?/1,
            &arbitrary_length?/1
          ]
        },
        # Text Decoration Color
        # @see https://tailwindcss.com/docs/text-decoration-color
        "text-decoration-color" => %{"decoration" => Scale.color()},
        # Text Underline Offset
        # @see https://tailwindcss.com/docs/text-underline-offset
        "underline-offset" => %{
          "underline-offset" => [&number?/1, "auto", &arbitrary_variable?/1, &arbitrary_value?/1]
        },
        # Text Transform
        # @see https://tailwindcss.com/docs/text-transform
        "text-transform" => ["uppercase", "lowercase", "capitalize", "normal-case"],
        # Text Overflow
        # @see https://tailwindcss.com/docs/text-overflow
        "text-overflow" => ["truncate", "text-ellipsis", "text-clip"],
        # Text Wrap
        # @see https://tailwindcss.com/docs/text-wrap
        "text-wrap" => %{"text" => ["wrap", "nowrap", "balance", "pretty"]},
        # Text Indent
        # @see https://tailwindcss.com/docs/text-indent
        "indent" => %{"indent" => Scale.unambiguous_spacing()},
        # Vertical Alignment
        # @see https://tailwindcss.com/docs/vertical-align
        "vertical-align" => %{
          "align" => [
            "baseline",
            "top",
            "middle",
            "bottom",
            "text-top",
            "text-bottom",
            "sub",
            "super",
            &arbitrary_variable?/1,
            &arbitrary_value?/1
          ]
        },
        # Whitespace
        # @see https://tailwindcss.com/docs/whitespace
        "whitespace" => %{
          "whitespace" => ["normal", "nowrap", "pre", "pre-line", "pre-wrap", "break-spaces"]
        },
        # Word Break
        # @see https://tailwindcss.com/docs/word-break
        "break" => %{"break" => ["normal", "words", "all", "keep"]},
        # Overflow Wrap
        # @see https://tailwindcss.com/docs/overflow-wrap
        "wrap" => %{"wrap" => ["break-word", "anywhere", "normal"]},
        # Hyphens
        # @see https://tailwindcss.com/docs/hyphens
        "hyphens" => %{"hyphens" => ["none", "manual", "auto"]},
        # Content
        # @see https://tailwindcss.com/docs/content
        "content" => %{"content" => ["none", &arbitrary_variable?/1, &arbitrary_value?/1]},

        # -------------------
        # --- Backgrounds ---
        # -------------------

        # Background Attachment
        # @see https://tailwindcss.com/docs/background-attachment
        "bg-attachment" => %{"bg" => ["fixed", "local", "scroll"]},
        # Background Clip
        # @see https://tailwindcss.com/docs/background-clip
        "bg-clip" => %{"bg-clip" => ["border", "padding", "content", "text"]},
        # Background Origin
        # @see https://tailwindcss.com/docs/background-origin
        "bg-origin" => %{"bg-origin" => ["border", "padding", "content"]},
        # Background Position
        # @see https://tailwindcss.com/docs/background-position
        "bg-position" => %{"bg" => Scale.bg_position()},
        # Background Repeat
        # @see https://tailwindcss.com/docs/background-repeat
        "bg-repeat" => %{"bg" => Scale.bg_repeat()},
        # Background Size
        # @see https://tailwindcss.com/docs/background-size
        "bg-size" => %{"bg" => Scale.bg_size()},
        # Background Image
        # @see https://tailwindcss.com/docs/background-image
        "bg-image" => %{
          "bg" => [
            "none",
            %{
              "linear" => [
                %{"to" => ["t", "tr", "r", "br", "b", "bl", "l", "tl"]},
                &integer?/1,
                &arbitrary_variable?/1,
                &arbitrary_value?/1
              ],
              "radial" => ["", &arbitrary_variable?/1, &arbitrary_value?/1],
              "conic" => [&integer?/1, &arbitrary_variable?/1, &arbitrary_value?/1]
            },
            &arbitrary_variable_image?/1,
            &arbitrary_image?/1
          ]
        },
        # Background Color
        # @see https://tailwindcss.com/docs/background-color
        "bg-color" => %{"bg" => Scale.color()},
        # Gradient Color Stops From Position
        # @see https://tailwindcss.com/docs/gradient-color-stops
        "gradient-from-pos" => %{"from" => Scale.gradient_stop_position()},
        # Gradient Color Stops Via Position
        # @see https://tailwindcss.com/docs/gradient-color-stops
        "gradient-via-pos" => %{"via" => Scale.gradient_stop_position()},
        # Gradient Color Stops To Position
        # @see https://tailwindcss.com/docs/gradient-color-stops
        "gradient-to-pos" => %{"to" => Scale.gradient_stop_position()},
        # Gradient Color Stops From
        # @see https://tailwindcss.com/docs/gradient-color-stops
        "gradient-from" => %{"from" => Scale.color()},
        # Gradient Color Stops Via
        # @see https://tailwindcss.com/docs/gradient-color-stops
        "gradient-via" => %{"via" => Scale.color()},
        # Gradient Color Stops To
        # @see https://tailwindcss.com/docs/gradient-color-stops
        "gradient-to" => %{"to" => Scale.color()},

        # ---------------
        # --- Borders ---
        # ---------------

        # Border Radius
        # @see https://tailwindcss.com/docs/border-radius
        "rounded" => %{"rounded" => Scale.radius()},
        # Border Radius Start
        # @see https://tailwindcss.com/docs/border-radius
        "rounded-s" => %{"rounded-s" => Scale.radius()},
        # Border Radius End
        # @see https://tailwindcss.com/docs/border-radius
        "rounded-e" => %{"rounded-e" => Scale.radius()},
        # Border Radius Top
        # @see https://tailwindcss.com/docs/border-radius
        "rounded-t" => %{"rounded-t" => Scale.radius()},
        # Border Radius Right
        # @see https://tailwindcss.com/docs/border-radius
        "rounded-r" => %{"rounded-r" => Scale.radius()},
        # Border Radius Bottom
        # @see https://tailwindcss.com/docs/border-radius
        "rounded-b" => %{"rounded-b" => Scale.radius()},
        # Border Radius Left
        # @see https://tailwindcss.com/docs/border-radius
        "rounded-l" => %{"rounded-l" => Scale.radius()},
        # Border Radius Start Start
        # @see https://tailwindcss.com/docs/border-radius
        "rounded-ss" => %{"rounded-ss" => Scale.radius()},
        # Border Radius Start End
        # @see https://tailwindcss.com/docs/border-radius
        "rounded-se" => %{"rounded-se" => Scale.radius()},
        # Border Radius End End
        # @see https://tailwindcss.com/docs/border-radius
        "rounded-ee" => %{"rounded-ee" => Scale.radius()},
        # Border Radius End Start
        # @see https://tailwindcss.com/docs/border-radius
        "rounded-es" => %{"rounded-es" => Scale.radius()},
        # Border Radius Top Left
        # @see https://tailwindcss.com/docs/border-radius
        "rounded-tl" => %{"rounded-tl" => Scale.radius()},
        # Border Radius Top Right
        # @see https://tailwindcss.com/docs/border-radius
        "rounded-tr" => %{"rounded-tr" => Scale.radius()},
        # Border Radius Bottom Right
        # @see https://tailwindcss.com/docs/border-radius
        "rounded-br" => %{"rounded-br" => Scale.radius()},
        # Border Radius Bottom Left
        # @see https://tailwindcss.com/docs/border-radius
        "rounded-bl" => %{"rounded-bl" => Scale.radius()},
        # Border Width
        # @see https://tailwindcss.com/docs/border-width
        "border-w" => %{"border" => Scale.border_width()},
        # Border Width X
        # @see https://tailwindcss.com/docs/border-width
        "border-w-x" => %{"border-x" => Scale.border_width()},
        # Border Width Y
        # @see https://tailwindcss.com/docs/border-width
        "border-w-y" => %{"border-y" => Scale.border_width()},
        # Border Width Start
        # @see https://tailwindcss.com/docs/border-width
        "border-w-s" => %{"border-s" => Scale.border_width()},
        # Border Width End
        # @see https://tailwindcss.com/docs/border-width
        "border-w-e" => %{"border-e" => Scale.border_width()},
        # Border Width Top
        # @see https://tailwindcss.com/docs/border-width
        "border-w-t" => %{"border-t" => Scale.border_width()},
        # Border Width Right
        # @see https://tailwindcss.com/docs/border-width
        "border-w-r" => %{"border-r" => Scale.border_width()},
        # Border Width Bottom
        # @see https://tailwindcss.com/docs/border-width
        "border-w-b" => %{"border-b" => Scale.border_width()},
        # Border Width Left
        # @see https://tailwindcss.com/docs/border-width
        "border-w-l" => %{"border-l" => Scale.border_width()},
        # Divide Width X
        # @see https://tailwindcss.com/docs/border-width#between-children
        "divide-x" => %{"divide-x" => Scale.border_width()},
        # Divide Width X Reverse
        # @see https://tailwindcss.com/docs/border-width#between-children
        "divide-x-reverse" => ["divide-x-reverse"],
        # Divide Width Y
        # @see https://tailwindcss.com/docs/border-width#between-children
        "divide-y" => %{"divide-y" => Scale.border_width()},
        # Divide Width Y Reverse
        # @see https://tailwindcss.com/docs/border-width#between-children
        "divide-y-reverse" => ["divide-y-reverse"],
        # Border Style
        # @see https://tailwindcss.com/docs/border-style
        "border-style" => %{"border" => [Scale.line_style() | ["hidden", "none"]]},
        # Divide Style
        # @see https://tailwindcss.com/docs/border-style#setting-the-divider-style
        "divide-style" => %{"divide" => [Scale.line_style() | ["hidden", "none"]]},
        # Border Color
        # @see https://tailwindcss.com/docs/border-color
        "border-color" => %{"border" => Scale.color()},
        # Border Color X
        # @see https://tailwindcss.com/docs/border-color
        "border-color-x" => %{"border-x" => Scale.color()},
        # Border Color Y
        # @see https://tailwindcss.com/docs/border-color
        "border-color-y" => %{"border-y" => Scale.color()},
        # Border Color S
        # @see https://tailwindcss.com/docs/border-color
        "border-color-s" => %{"border-s" => Scale.color()},
        # Border Color E
        # @see https://tailwindcss.com/docs/border-color
        "border-color-e" => %{"border-e" => Scale.color()},
        # Border Color Top
        # @see https://tailwindcss.com/docs/border-color
        "border-color-t" => %{"border-t" => Scale.color()},
        # Border Color Right
        # @see https://tailwindcss.com/docs/border-color
        "border-color-r" => %{"border-r" => Scale.color()},
        # Border Color Bottom
        # @see https://tailwindcss.com/docs/border-color
        "border-color-b" => %{"border-b" => Scale.color()},
        # Border Color Left
        # @see https://tailwindcss.com/docs/border-color
        "border-color-l" => %{"border-l" => Scale.color()},
        # Divide Color
        # @see https://tailwindcss.com/docs/divide-color
        "divide-color" => %{"divide" => Scale.color()},
        # Outline Style
        # @see https://tailwindcss.com/docs/outline-style
        "outline-style" => %{"outline" => [Scale.line_style() | ["none", "hidden"]]},
        # Outline Offset
        # @see https://tailwindcss.com/docs/outline-offset
        "outline-offset" => %{
          "outline-offset" => [&number?/1, &arbitrary_variable?/1, &arbitrary_value?/1]
        },
        # Outline Width
        # @see https://tailwindcss.com/docs/outline-width
        "outline-w" => %{
          "outline" => ["", &number?/1, &arbitrary_variable_length?/1, &arbitrary_length?/1]
        },
        # Outline Color
        # @see https://tailwindcss.com/docs/outline-color
        "outline-color" => %{"outline" => Scale.color()},

        # ---------------
        # --- Effects ---
        # ---------------

        # Box Shadow
        # @see https://tailwindcss.com/docs/box-shadow
        "shadow" => %{
          "shadow" => [
            # Deprecated since Tailwind CSS v4.0.0
            "",
            "none",
            &from_theme(&1, "shadow"),
            &arbitrary_variable_shadow?/1,
            &arbitrary_shadow?/1
          ]
        },
        # Box Shadow Color
        # @see https://tailwindcss.com/docs/box-shadow#setting-the-shadow-color
        "shadow-color" => %{"shadow" => Scale.color()},
        # Inset Box Shadow
        # @see https://tailwindcss.com/docs/box-shadow#adding-an-inset-shadow
        "inset-shadow" => %{
          "inset-shadow" => [
            "none",
            &from_theme(&1, "inset-shadow"),
            &arbitrary_variable_shadow?/1,
            &arbitrary_shadow?/1
          ]
        },
        # Inset Box Shadow Color
        # @see https://tailwindcss.com/docs/box-shadow#setting-the-inset-shadow-color
        "inset-shadow-color" => %{"inset-shadow" => Scale.color()},
        # Ring Width
        # @see https://tailwindcss.com/docs/box-shadow#adding-a-ring
        "ring-w" => %{"ring" => Scale.border_width()},
        # Ring Width Inset
        # @see https://v3.tailwindcss.com/docs/ring-width#inset-rings
        # @deprecated since Tailwind CSS v4.0.0
        # @see https://github.com/tailwindlabs/tailwindcss/blob/v4.0.0/packages/tailwindcss/src/utilities.ts#L4158
        "ring-w-inset" => ["ring-inset"],
        # Ring Color
        # @see https://tailwindcss.com/docs/box-shadow#setting-the-ring-color
        "ring-color" => %{"ring" => Scale.color()},
        # Ring Offset Width
        # @see https://v3.tailwindcss.com/docs/ring-offset-width
        # @deprecated since Tailwind CSS v4.0.0
        # @see https://github.com/tailwindlabs/tailwindcss/blob/v4.0.0/packages/tailwindcss/src/utilities.ts#L4158
        "ring-offset-w" => %{"ring-offset" => [&number?/1, &arbitrary_length?/1]},
        # Ring Offset Color
        # @see https://v3.tailwindcss.com/docs/ring-offset-color
        # @deprecated since Tailwind CSS v4.0.0
        # @see https://github.com/tailwindlabs/tailwindcss/blob/v4.0.0/packages/tailwindcss/src/utilities.ts#L4158
        "ring-offset-color" => %{"ring-offset" => Scale.color()},
        # Inset Ring Width
        # @see https://tailwindcss.com/docs/box-shadow#adding-an-inset-ring
        "inset-ring-w" => %{"inset-ring" => Scale.border_width()},
        # Inset Ring Color
        # @see https://tailwindcss.com/docs/box-shadow#setting-the-inset-ring-color
        "inset-ring-color" => %{"inset-ring" => Scale.color()},
        # Text Shadow
        # @see https://tailwindcss.com/docs/text-shadow
        "text-shadow" => %{
          "text-shadow" => [
            "none",
            &from_theme(&1, "text-shadow"),
            &arbitrary_variable_shadow?/1,
            &arbitrary_shadow?/1
          ]
        },
        # Text Shadow Color
        # @see https://tailwindcss.com/docs/text-shadow#setting-the-shadow-color
        "text-shadow-color" => %{"text-shadow" => Scale.color()},
        # Opacity
        # @see https://tailwindcss.com/docs/opacity
        "opacity" => %{"opacity" => [&number?/1, &arbitrary_variable?/1, &arbitrary_value?/1]},
        # Mix Blend Mode
        # @see https://tailwindcss.com/docs/mix-blend-mode
        "mix-blend" => %{"mix-blend" => [Scale.blend_mode() | ["plus-darker", "plus-lighter"]]},
        # Background Blend Mode
        # @see https://tailwindcss.com/docs/background-blend-mode
        "bg-blend" => %{"bg-blend" => Scale.blend_mode()},
        # Mask Clip
        # @see https://tailwindcss.com/docs/mask-clip
        "mask-clip" => %{
          "mask-clip" => ["border", "padding", "content", "fill", "stroke", "view"]
        },
        "mask-no-clip" => ["mask-no-clip"],
        # Mask Composite
        # @see https://tailwindcss.com/docs/mask-composite
        "mask-composite" => %{"mask" => ["add", "subtract", "intersect", "exclude"]},
        # Mask Image
        # @see https://tailwindcss.com/docs/mask-image
        "mask-image-linear-pos" => %{"mask-linear" => [&number?/1]},
        "mask-image-linear-from-pos" => %{"mask-linear-from" => Scale.mask_image_position()},
        "mask-image-linear-to-pos" => %{"mask-linear-to" => Scale.mask_image_position()},
        "mask-image-linear-from-color" => %{"mask-linear-from" => Scale.color()},
        "mask-image-linear-to-color" => %{"mask-linear-to" => Scale.color()},
        "mask-image-t-from-pos" => %{"mask-t-from" => Scale.mask_image_position()},
        "mask-image-t-to-pos" => %{"mask-t-to" => Scale.mask_image_position()},
        "mask-image-t-from-color" => %{"mask-t-from" => Scale.color()},
        "mask-image-t-to-color" => %{"mask-t-to" => Scale.color()},
        "mask-image-r-from-pos" => %{"mask-r-from" => Scale.mask_image_position()},
        "mask-image-r-to-pos" => %{"mask-r-to" => Scale.mask_image_position()},
        "mask-image-r-from-color" => %{"mask-r-from" => Scale.color()},
        "mask-image-r-to-color" => %{"mask-r-to" => Scale.color()},
        "mask-image-b-from-pos" => %{"mask-b-from" => Scale.mask_image_position()},
        "mask-image-b-to-pos" => %{"mask-b-to" => Scale.mask_image_position()},
        "mask-image-b-from-color" => %{"mask-b-from" => Scale.color()},
        "mask-image-b-to-color" => %{"mask-b-to" => Scale.color()},
        "mask-image-l-from-pos" => %{"mask-l-from" => Scale.mask_image_position()},
        "mask-image-l-to-pos" => %{"mask-l-to" => Scale.mask_image_position()},
        "mask-image-l-from-color" => %{"mask-l-from" => Scale.color()},
        "mask-image-l-to-color" => %{"mask-l-to" => Scale.color()},
        "mask-image-x-from-pos" => %{"mask-x-from" => Scale.mask_image_position()},
        "mask-image-x-to-pos" => %{"mask-x-to" => Scale.mask_image_position()},
        "mask-image-x-from-color" => %{"mask-x-from" => Scale.color()},
        "mask-image-x-to-color" => %{"mask-x-to" => Scale.color()},
        "mask-image-y-from-pos" => %{"mask-y-from" => Scale.mask_image_position()},
        "mask-image-y-to-pos" => %{"mask-y-to" => Scale.mask_image_position()},
        "mask-image-y-from-color" => %{"mask-y-from" => Scale.color()},
        "mask-image-y-to-color" => %{"mask-y-to" => Scale.color()},
        "mask-image-radial" => %{"mask-radial" => [&arbitrary_variable?/1, &arbitrary_value?/1]},
        "mask-image-radial-from-pos" => %{"mask-radial-from" => Scale.mask_image_position()},
        "mask-image-radial-to-pos" => %{"mask-radial-to" => Scale.mask_image_position()},
        "mask-image-radial-from-color" => %{"mask-radial-from" => Scale.color()},
        "mask-image-radial-to-color" => %{"mask-radial-to" => Scale.color()},
        "mask-image-radial-shape" => %{"mask-radial" => ["circle", "ellipse"]},
        "mask-image-radial-size" => %{
          "mask-radial" => [%{"closest" => ["side", "corner"], "farthest" => ["side", "corner"]}]
        },
        "mask-image-radial-pos" => %{"mask-radial-at" => Scale.position()},
        "mask-image-conic-pos" => %{"mask-conic" => [&number?/1]},
        "mask-image-conic-from-pos" => %{"mask-conic-from" => Scale.mask_image_position()},
        "mask-image-conic-to-pos" => %{"mask-conic-to" => Scale.mask_image_position()},
        "mask-image-conic-from-color" => %{"mask-conic-from" => Scale.color()},
        "mask-image-conic-to-color" => %{"mask-conic-to" => Scale.color()},
        # Mask Mode
        # @see https://tailwindcss.com/docs/mask-mode
        "mask-mode" => %{"mask" => ["alpha", "luminance", "match"]},
        # Mask Origin
        # @see https://tailwindcss.com/docs/mask-origin
        "mask-origin" => %{
          "mask-origin" => ["border", "padding", "content", "fill", "stroke", "view"]
        },
        # Mask Position
        # @see https://tailwindcss.com/docs/mask-position
        "mask-position" => %{"mask" => Scale.bg_position()},
        # Mask Repeat
        # @see https://tailwindcss.com/docs/mask-repeat
        "mask-repeat" => %{"mask" => Scale.bg_repeat()},
        # Mask Size
        # @see https://tailwindcss.com/docs/mask-size
        "mask-size" => %{"mask" => Scale.bg_size()},
        # Mask Type
        # @see https://tailwindcss.com/docs/mask-type
        "mask-type" => %{"mask-type" => ["alpha", "luminance"]},
        # Mask Image
        # @see https://tailwindcss.com/docs/mask-image
        "mask-image" => %{"mask" => ["none", &arbitrary_variable?/1, &arbitrary_value?/1]},

        # ---------------
        # --- Filters ---
        # ---------------
        # Filter
        # @see https://tailwindcss.com/docs/filter
        "filter" => %{
          "filter" => [
            # Deprecated since Tailwind CSS v3.0.0
            "",
            "none",
            &arbitrary_variable?/1,
            &arbitrary_value?/1
          ]
        },
        # Blur
        # @see https://tailwindcss.com/docs/blur
        "blur" => %{"blur" => Scale.blur()},
        # Brightness
        # @see https://tailwindcss.com/docs/brightness
        "brightness" => %{
          "brightness" => [&number?/1, &arbitrary_variable?/1, &arbitrary_value?/1]
        },
        # Contrast
        # @see https://tailwindcss.com/docs/contrast
        "contrast" => %{"contrast" => [&number?/1, &arbitrary_variable?/1, &arbitrary_value?/1]},
        # Drop Shadow
        # @see https://tailwindcss.com/docs/drop-shadow
        "drop-shadow" => %{
          "drop-shadow" => [
            # Deprecated since Tailwind CSS v4.0.0
            "",
            "none",
            &from_theme(&1, "drop-shadow"),
            &arbitrary_variable_shadow?/1,
            &arbitrary_shadow?/1
          ]
        },
        # Drop Shadow Color
        # @see https://tailwindcss.com/docs/filter-drop-shadow#setting-the-shadow-color
        "drop-shadow-color" => %{"drop-shadow" => Scale.color()},
        # Grayscale
        # @see https://tailwindcss.com/docs/grayscale
        "grayscale" => %{
          "grayscale" => ["", &number?/1, &arbitrary_variable?/1, &arbitrary_value?/1]
        },
        # Hue Rotate
        # @see https://tailwindcss.com/docs/hue-rotate
        "hue-rotate" => %{
          "hue-rotate" => [&number?/1, &arbitrary_variable?/1, &arbitrary_value?/1]
        },
        # Invert
        # @see https://tailwindcss.com/docs/invert
        "invert" => %{"invert" => ["", &number?/1, &arbitrary_variable?/1, &arbitrary_value?/1]},
        # Saturate
        # @see https://tailwindcss.com/docs/saturate
        "saturate" => %{"saturate" => [&number?/1, &arbitrary_variable?/1, &arbitrary_value?/1]},
        # Sepia
        # @see https://tailwindcss.com/docs/sepia
        "sepia" => %{"sepia" => ["", &number?/1, &arbitrary_variable?/1, &arbitrary_value?/1]},
        # Backdrop Filter
        # @see https://tailwindcss.com/docs/backdrop-filter
        "backdrop-filter" => %{
          "backdrop-filter" => [
            # Deprecated since Tailwind CSS v3.0.0
            "",
            "none",
            &arbitrary_variable?/1,
            &arbitrary_value?/1
          ]
        },
        # Backdrop Blur
        # @see https://tailwindcss.com/docs/backdrop-blur
        "backdrop-blur" => %{"backdrop-blur" => Scale.blur()},
        # Backdrop Brightness
        # @see https://tailwindcss.com/docs/backdrop-brightness
        "backdrop-brightness" => %{
          "backdrop-brightness" => [&number?/1, &arbitrary_variable?/1, &arbitrary_value?/1]
        },
        # Backdrop Contrast
        # @see https://tailwindcss.com/docs/backdrop-contrast
        "backdrop-contrast" => %{
          "backdrop-contrast" => [&number?/1, &arbitrary_variable?/1, &arbitrary_value?/1]
        },
        # Backdrop Grayscale
        # @see https://tailwindcss.com/docs/backdrop-grayscale
        "backdrop-grayscale" => %{
          "backdrop-grayscale" => ["", &number?/1, &arbitrary_variable?/1, &arbitrary_value?/1]
        },
        # Backdrop Hue Rotate
        # @see https://tailwindcss.com/docs/backdrop-hue-rotate
        "backdrop-hue-rotate" => %{
          "backdrop-hue-rotate" => [&number?/1, &arbitrary_variable?/1, &arbitrary_value?/1]
        },
        # Backdrop Invert
        # @see https://tailwindcss.com/docs/backdrop-invert
        "backdrop-invert" => %{
          "backdrop-invert" => ["", &number?/1, &arbitrary_variable?/1, &arbitrary_value?/1]
        },
        # Backdrop Opacity
        # @see https://tailwindcss.com/docs/backdrop-opacity
        "backdrop-opacity" => %{
          "backdrop-opacity" => [&number?/1, &arbitrary_variable?/1, &arbitrary_value?/1]
        },
        # Backdrop Saturate
        # @see https://tailwindcss.com/docs/backdrop-saturate
        "backdrop-saturate" => %{
          "backdrop-saturate" => [&number?/1, &arbitrary_variable?/1, &arbitrary_value?/1]
        },
        # Backdrop Sepia
        # @see https://tailwindcss.com/docs/backdrop-sepia
        "backdrop-sepia" => %{
          "backdrop-sepia" => ["", &number?/1, &arbitrary_variable?/1, &arbitrary_value?/1]
        },

        # --------------
        # --- Tables ---
        # --------------

        # Border Collapse
        # @see https://tailwindcss.com/docs/border-collapse
        "border-collapse" => %{"border" => ["collapse", "separate"]},
        # Border Spacing
        # @see https://tailwindcss.com/docs/border-spacing
        "border-spacing" => %{"border-spacing" => Scale.unambiguous_spacing()},
        # Border Spacing X
        # @see https://tailwindcss.com/docs/border-spacing
        "border-spacing-x" => %{"border-spacing-x" => Scale.unambiguous_spacing()},
        # Border Spacing Y
        # @see https://tailwindcss.com/docs/border-spacing
        "border-spacing-y" => %{"border-spacing-y" => Scale.unambiguous_spacing()},
        # Table Layout
        # @see https://tailwindcss.com/docs/table-layout
        "table-layout" => %{"table" => ["auto", "fixed"]},
        # Caption Side
        # @see https://tailwindcss.com/docs/caption-side
        "caption" => %{"caption" => ["top", "bottom"]},

        # ---------------------------------
        # --- Transitions and Animation ---
        # ---------------------------------

        # Transition Property
        # @see https://tailwindcss.com/docs/transition-property
        "transition" => %{
          "transition" => [
            "",
            "all",
            "colors",
            "opacity",
            "shadow",
            "transform",
            "none",
            &arbitrary_variable?/1,
            &arbitrary_value?/1
          ]
        },
        # Transition Behavior
        # @see https://tailwindcss.com/docs/transition-behavior
        "transition-behavior" => %{"transition" => ["normal", "discrete"]},
        # Transition Duration
        # @see https://tailwindcss.com/docs/transition-duration
        "duration" => %{
          "duration" => [&number?/1, "initial", &arbitrary_variable?/1, &arbitrary_value?/1]
        },
        # Transition Timing Function
        # @see https://tailwindcss.com/docs/transition-timing-function
        "ease" => %{
          "ease" => [
            "linear",
            "initial",
            &from_theme(&1, "ease"),
            &arbitrary_variable?/1,
            &arbitrary_value?/1
          ]
        },
        # Transition Delay
        # @see https://tailwindcss.com/docs/transition-delay
        "delay" => %{"delay" => [&number?/1, &arbitrary_variable?/1, &arbitrary_value?/1]},
        # Animation
        # @see https://tailwindcss.com/docs/animation
        "animate" => %{
          "animate" => [
            "none",
            &from_theme(&1, "animate"),
            &arbitrary_variable?/1,
            &arbitrary_value?/1
          ]
        },

        # ------------------
        # --- Transforms ---
        # ------------------

        # Backface Visibility
        # @see https://tailwindcss.com/docs/backface-visibility
        "backface" => %{"backface" => ["hidden", "visible"]},
        # Perspective
        # @see https://tailwindcss.com/docs/perspective
        "perspective" => %{
          "perspective" => [
            &from_theme(&1, "perspective"),
            &arbitrary_variable?/1,
            &arbitrary_value?/1
          ]
        },
        # Perspective Origin
        # @see https://tailwindcss.com/docs/perspective-origin
        "perspective-origin" => %{"perspective-origin" => Scale.position_with_arbitrary()},
        # Rotate
        # @see https://tailwindcss.com/docs/rotate
        "rotate" => %{"rotate" => Scale.rotate()},
        # Rotate X
        # @see https://tailwindcss.com/docs/rotate
        "rotate-x" => %{"rotate-x" => Scale.rotate()},
        # Rotate Y
        # @see https://tailwindcss.com/docs/rotate
        "rotate-y" => %{"rotate-y" => Scale.rotate()},
        # Rotate Z
        # @see https://tailwindcss.com/docs/rotate
        "rotate-z" => %{"rotate-z" => Scale.rotate()},
        # Scale
        # @see https://tailwindcss.com/docs/scale
        "scale" => %{"scale" => Scale.scale()},
        # Scale X
        # @see https://tailwindcss.com/docs/scale
        "scale-x" => %{"scale-x" => Scale.scale()},
        # Scale Y
        # @see https://tailwindcss.com/docs/scale
        "scale-y" => %{"scale-y" => Scale.scale()},
        # Scale Z
        # @see https://tailwindcss.com/docs/scale
        "scale-z" => %{"scale-z" => Scale.scale()},
        # Scale 3D
        # @see https://tailwindcss.com/docs/scale
        "scale-3d" => ["scale-3d"],
        # Skew
        # @see https://tailwindcss.com/docs/skew
        "skew" => %{"skew" => Scale.skew()},
        # Skew X
        # @see https://tailwindcss.com/docs/skew
        "skew-x" => %{"skew-x" => Scale.skew()},
        # Skew Y
        # @see https://tailwindcss.com/docs/skew
        "skew-y" => %{"skew-y" => Scale.skew()},
        # Transform
        # @see https://tailwindcss.com/docs/transform
        "transform" => %{
          "transform" => [&arbitrary_variable?/1, &arbitrary_value?/1, "", "none", "gpu", "cpu"]
        },
        # Transform Origin
        # @see https://tailwindcss.com/docs/transform-origin
        "transform-origin" => %{"origin" => Scale.position_with_arbitrary()},
        # Transform Style
        # @see https://tailwindcss.com/docs/transform-style
        "transform-style" => %{"transform" => ["3d", "flat"]},
        # Translate
        # @see https://tailwindcss.com/docs/translate
        "translate" => %{"translate" => Scale.translate()},
        # Translate X
        # @see https://tailwindcss.com/docs/translate
        "translate-x" => %{"translate-x" => Scale.translate()},
        # Translate Y
        # @see https://tailwindcss.com/docs/translate
        "translate-y" => %{"translate-y" => Scale.translate()},
        # Translate Z
        # @see https://tailwindcss.com/docs/translate
        "translate-z" => %{"translate-z" => Scale.translate()},
        # Translate None
        # @see https://tailwindcss.com/docs/translate
        "translate-none" => ["translate-none"],

        # ---------------------
        # --- Interactivity ---
        # ---------------------

        # Accent Color
        # @see https://tailwindcss.com/docs/accent-color
        "accent" => %{"accent" => Scale.color()},
        # Appearance
        # @see https://tailwindcss.com/docs/appearance
        "appearance" => %{"appearance" => ["none", "auto"]},
        # Caret Color
        # @see https://tailwindcss.com/docs/just-in-time-mode#caret-color-utilities
        "caret-color" => %{"caret" => Scale.color()},
        # Color Scheme
        # @see https://tailwindcss.com/docs/color-scheme
        "color-scheme" => %{
          "scheme" => ["normal", "dark", "light", "light-dark", "only-dark", "only-light"]
        },
        # Cursor
        # @see https://tailwindcss.com/docs/cursor
        "cursor" => %{
          "cursor" => [
            "auto",
            "default",
            "pointer",
            "wait",
            "text",
            "move",
            "help",
            "not-allowed",
            "none",
            "context-menu",
            "progress",
            "cell",
            "crosshair",
            "vertical-text",
            "alias",
            "copy",
            "no-drop",
            "grab",
            "grabbing",
            "all-scroll",
            "col-resize",
            "row-resize",
            "n-resize",
            "e-resize",
            "s-resize",
            "w-resize",
            "ne-resize",
            "nw-resize",
            "se-resize",
            "sw-resize",
            "ew-resize",
            "ns-resize",
            "nesw-resize",
            "nwse-resize",
            "zoom-in",
            "zoom-out",
            &arbitrary_variable?/1,
            &arbitrary_value?/1
          ]
        },
        # Field Sizing
        # @see https://tailwindcss.com/docs/field-sizing
        "field-sizing" => %{"field-sizing" => ["fixed", "content"]},
        # Pointer Events
        # @see https://tailwindcss.com/docs/pointer-events
        "pointer-events" => %{"pointer-events" => ["auto", "none"]},
        # Resize
        # @see https://tailwindcss.com/docs/resize
        "resize" => %{"resize" => ["none", "", "y", "x"]},
        # Scroll Behavior
        # @see https://tailwindcss.com/docs/scroll-behavior
        "scroll-behavior" => %{"scroll" => ["auto", "smooth"]},
        # Scroll Margin
        # @see https://tailwindcss.com/docs/scroll-margin
        "scroll-m" => %{"scroll-m" => Scale.unambiguous_spacing()},
        # Scroll Margin X
        # @see https://tailwindcss.com/docs/scroll-margin
        "scroll-mx" => %{"scroll-mx" => Scale.unambiguous_spacing()},
        # Scroll Margin Y
        # @see https://tailwindcss.com/docs/scroll-margin
        "scroll-my" => %{"scroll-my" => Scale.unambiguous_spacing()},
        # Scroll Margin Start
        # @see https://tailwindcss.com/docs/scroll-margin
        "scroll-ms" => %{"scroll-ms" => Scale.unambiguous_spacing()},
        # Scroll Margin End
        # @see https://tailwindcss.com/docs/scroll-margin
        "scroll-me" => %{"scroll-me" => Scale.unambiguous_spacing()},
        # Scroll Margin Top
        # @see https://tailwindcss.com/docs/scroll-margin
        "scroll-mt" => %{"scroll-mt" => Scale.unambiguous_spacing()},
        # Scroll Margin Right
        # @see https://tailwindcss.com/docs/scroll-margin
        "scroll-mr" => %{"scroll-mr" => Scale.unambiguous_spacing()},
        # Scroll Margin Bottom
        # @see https://tailwindcss.com/docs/scroll-margin
        "scroll-mb" => %{"scroll-mb" => Scale.unambiguous_spacing()},
        # Scroll Margin Left
        # @see https://tailwindcss.com/docs/scroll-margin
        "scroll-ml" => %{"scroll-ml" => Scale.unambiguous_spacing()},
        # Scroll Padding
        # @see https://tailwindcss.com/docs/scroll-padding
        "scroll-p" => %{"scroll-p" => Scale.unambiguous_spacing()},
        # Scroll Padding X
        # @see https://tailwindcss.com/docs/scroll-padding
        "scroll-px" => %{"scroll-px" => Scale.unambiguous_spacing()},
        # Scroll Padding Y
        # @see https://tailwindcss.com/docs/scroll-padding
        "scroll-py" => %{"scroll-py" => Scale.unambiguous_spacing()},
        # Scroll Padding Start
        # @see https://tailwindcss.com/docs/scroll-padding
        "scroll-ps" => %{"scroll-ps" => Scale.unambiguous_spacing()},
        # Scroll Padding End
        # @see https://tailwindcss.com/docs/scroll-padding
        "scroll-pe" => %{"scroll-pe" => Scale.unambiguous_spacing()},
        # Scroll Padding Top
        # @see https://tailwindcss.com/docs/scroll-padding
        "scroll-pt" => %{"scroll-pt" => Scale.unambiguous_spacing()},
        # Scroll Padding Right
        # @see https://tailwindcss.com/docs/scroll-padding
        "scroll-pr" => %{"scroll-pr" => Scale.unambiguous_spacing()},
        # Scroll Padding Bottom
        # @see https://tailwindcss.com/docs/scroll-padding
        "scroll-pb" => %{"scroll-pb" => Scale.unambiguous_spacing()},
        # Scroll Padding Left
        # @see https://tailwindcss.com/docs/scroll-padding
        "scroll-pl" => %{"scroll-pl" => Scale.unambiguous_spacing()},
        # Scroll Snap Align
        # @see https://tailwindcss.com/docs/scroll-snap-align
        "snap-align" => %{"snap" => ["start", "end", "center", "align-none"]},
        # Scroll Snap Stop
        # @see https://tailwindcss.com/docs/scroll-snap-stop
        "snap-stop" => %{"snap" => ["normal", "always"]},
        # Scroll Snap Type
        # @see https://tailwindcss.com/docs/scroll-snap-type
        "snap-type" => %{"snap" => ["none", "x", "y", "both"]},
        # Scroll Snap Type Strictness
        # @see https://tailwindcss.com/docs/scroll-snap-type
        "snap-strictness" => %{"snap" => ["mandatory", "proximity"]},
        # Touch Action
        # @see https://tailwindcss.com/docs/touch-action
        "touch" => %{"touch" => ["auto", "none", "manipulation"]},
        # Touch Action X
        # @see https://tailwindcss.com/docs/touch-action
        "touch-x" => %{"touch-pan" => ["x", "left", "right"]},
        # Touch Action Y
        # @see https://tailwindcss.com/docs/touch-action
        "touch-y" => %{"touch-pan" => ["y", "up", "down"]},
        # Touch Action Pinch Zoom
        # @see https://tailwindcss.com/docs/touch-action
        "touch-pz" => ["touch-pinch-zoom"],
        # User Select
        # @see https://tailwindcss.com/docs/user-select
        "select" => %{"select" => ["none", "text", "all", "auto"]},
        # Will Change
        # @see https://tailwindcss.com/docs/will-change
        "will-change" => %{
          "will-change" => [
            "auto",
            "scroll",
            "contents",
            "transform",
            &arbitrary_variable?/1,
            &arbitrary_value?/1
          ]
        },

        # -----------
        # --- SVG ---
        # -----------

        # Fill
        # @see https://tailwindcss.com/docs/fill
        "fill" => %{"fill" => ["none" | Scale.color()]},
        # Stroke Width
        # @see https://tailwindcss.com/docs/stroke-width
        "stroke-w" => %{
          "stroke" => [
            &number?/1,
            &arbitrary_variable_length?/1,
            &arbitrary_length?/1,
            &arbitrary_number?/1
          ]
        },
        # Stroke
        # @see https://tailwindcss.com/docs/stroke
        "stroke" => %{"stroke" => ["none" | Scale.color()]},

        # ---------------------
        # --- Accessibility ---
        # ---------------------

        # Forced Color Adjust
        # @see https://tailwindcss.com/docs/forced-color-adjust
        "forced-color-adjust" => %{"forced-color-adjust" => ["auto", "none"]}
      },
      conflicting_groups: %{
        "overflow" => ["overflow-x", "overflow-y"],
        "overscroll" => ["overscroll-x", "overscroll-y"],
        "inset" => ["inset-x", "inset-y", "start", "end", "top", "right", "bottom", "left"],
        "inset-x" => ["right", "left"],
        "inset-y" => ["top", "bottom"],
        "flex" => ["basis", "grow", "shrink"],
        "gap" => ["gap-x", "gap-y"],
        "p" => ["px", "py", "ps", "pe", "pt", "pr", "pb", "pl"],
        "px" => ["pr", "pl"],
        "py" => ["pt", "pb"],
        "m" => ["mx", "my", "ms", "me", "mt", "mr", "mb", "ml"],
        "mx" => ["mr", "ml"],
        "my" => ["mt", "mb"],
        "size" => ["w", "h"],
        "font-size" => ["leading"],
        "fvn-normal" => [
          "fvn-ordinal",
          "fvn-slashed-zero",
          "fvn-figure",
          "fvn-spacing",
          "fvn-fraction"
        ],
        "fvn-ordinal" => ["fvn-normal"],
        "fvn-slashed-zero" => ["fvn-normal"],
        "fvn-figure" => ["fvn-normal"],
        "fvn-spacing" => ["fvn-normal"],
        "fvn-fraction" => ["fvn-normal"],
        "line-clamp" => ["display", "overflow"],
        "rounded" => [
          "rounded-s",
          "rounded-e",
          "rounded-t",
          "rounded-r",
          "rounded-b",
          "rounded-l",
          "rounded-ss",
          "rounded-se",
          "rounded-ee",
          "rounded-es",
          "rounded-tl",
          "rounded-tr",
          "rounded-br",
          "rounded-bl"
        ],
        "rounded-s" => ["rounded-ss", "rounded-es"],
        "rounded-e" => ["rounded-se", "rounded-ee"],
        "rounded-t" => ["rounded-tl", "rounded-tr"],
        "rounded-r" => ["rounded-tr", "rounded-br"],
        "rounded-b" => ["rounded-br", "rounded-bl"],
        "rounded-l" => ["rounded-tl", "rounded-bl"],
        "border-spacing" => ["border-spacing-x", "border-spacing-y"],
        "border-w" => [
          "border-w-x",
          "border-w-y",
          "border-w-s",
          "border-w-e",
          "border-w-t",
          "border-w-r",
          "border-w-b",
          "border-w-l"
        ],
        "border-w-x" => ["border-w-r", "border-w-l"],
        "border-w-y" => ["border-w-t", "border-w-b"],
        "border-color" => [
          "border-color-x",
          "border-color-y",
          "border-color-s",
          "border-color-e",
          "border-color-t",
          "border-color-r",
          "border-color-b",
          "border-color-l"
        ],
        "border-color-x" => ["border-color-r", "border-color-l"],
        "border-color-y" => ["border-color-t", "border-color-b"],
        "scroll-m" => [
          "scroll-mx",
          "scroll-my",
          "scroll-ms",
          "scroll-me",
          "scroll-mt",
          "scroll-mr",
          "scroll-mb",
          "scroll-ml"
        ],
        "scroll-mx" => ["scroll-mr", "scroll-ml"],
        "scroll-my" => ["scroll-mt", "scroll-mb"],
        "scroll-p" => [
          "scroll-px",
          "scroll-py",
          "scroll-ps",
          "scroll-pe",
          "scroll-pt",
          "scroll-pr",
          "scroll-pb",
          "scroll-pl"
        ],
        "scroll-px" => ["scroll-pr", "scroll-pl"],
        "scroll-py" => ["scroll-pt", "scroll-pb"],
        "touch" => ["touch-x", "touch-y", "touch-pz"],
        "touch-x" => ["touch"],
        "touch-y" => ["touch"],
        "touch-pz" => ["touch"],
        "translate" => ["translate-x", "translate-y", "translate-none"],
        "translate-none" => ["translate", "translate-x", "translate-y", "translate-z"]
      },
      conflicting_group_modifiers: %{
        "font-size" => ["leading"]
      },
      order_sensitive_modifiers: [
        "*",
        "**",
        "after",
        "backdrop",
        "before",
        "details-content",
        "file",
        "first-letter",
        "first-line",
        "marker",
        "placeholder",
        "selection"
      ]
    }
  end

  for group <- @theme_groups do
    def from_theme(theme, unquote(group)) do
      theme[String.to_existing_atom(unquote(group))] || []
    end
  end
end
