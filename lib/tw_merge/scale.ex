defmodule TwMerge.Scale do
  @moduledoc """
  Scale definitions for Tailwind CSS v4 configuration.
  These match the TypeScript scale functions that provide reusable value sets.
  """

  def break do
    ["auto", "avoid", "all", "avoid-page", "page", "left", "right", "column"]
  end

  def position do
    [
      "center",
      "top",
      "bottom",
      "left",
      "right",
      "top-left",
      # Deprecated since Tailwind CSS v4.1.0
      "left-top",
      "top-right",
      # Deprecated since Tailwind CSS v4.1.0
      "right-top",
      "bottom-right",
      # Deprecated since Tailwind CSS v4.1.0
      "right-bottom",
      "bottom-left",
      # Deprecated since Tailwind CSS v4.1.0
      "left-bottom"
    ]
  end

  def position_with_arbitrary do
    position() ++
      [
        &TwMerge.Validator.arbitrary_variable?/1,
        &TwMerge.Validator.arbitrary_value?/1
      ]
  end

  def overflow do
    ["auto", "hidden", "clip", "visible", "scroll"]
  end

  def overscroll do
    ["auto", "contain", "none"]
  end

  def unambiguous_spacing do
    [
      &TwMerge.Validator.arbitrary_variable?/1,
      &TwMerge.Validator.arbitrary_value?/1,
      &TwMerge.Config.from_theme(&1, "spacing")
    ]
  end

  def inset do
    [
      &TwMerge.Validator.fraction?/1,
      "full",
      "auto",
      &TwMerge.Validator.arbitrary_variable?/1,
      &TwMerge.Validator.arbitrary_value?/1,
      &TwMerge.Config.from_theme(&1, "spacing")
    ]
  end

  def grid_template_cols_rows do
    [
      &TwMerge.Validator.integer?/1,
      "none",
      "subgrid",
      &TwMerge.Validator.arbitrary_variable?/1,
      &TwMerge.Validator.arbitrary_value?/1
    ]
  end

  def grid_col_row_start_and_end do
    [
      "auto",
      %{
        "span" => [
          "full",
          &TwMerge.Validator.integer?/1,
          &TwMerge.Validator.arbitrary_variable?/1,
          &TwMerge.Validator.arbitrary_value?/1
        ]
      },
      &TwMerge.Validator.integer?/1,
      &TwMerge.Validator.arbitrary_variable?/1,
      &TwMerge.Validator.arbitrary_value?/1
    ]
  end

  def grid_col_row_start_or_end do
    [
      &TwMerge.Validator.integer?/1,
      "auto",
      &TwMerge.Validator.arbitrary_variable?/1,
      &TwMerge.Validator.arbitrary_value?/1
    ]
  end

  def grid_auto_cols_rows do
    [
      "auto",
      "min",
      "max",
      "fr",
      &TwMerge.Validator.arbitrary_variable?/1,
      &TwMerge.Validator.arbitrary_value?/1
    ]
  end

  def align_primary_axis do
    [
      "start",
      "end",
      "center",
      "between",
      "around",
      "evenly",
      "stretch",
      "baseline",
      "center-safe",
      "end-safe"
    ]
  end

  def align_secondary_axis do
    ["start", "end", "center", "stretch", "center-safe", "end-safe"]
  end

  def margin do
    [
      "auto",
      &TwMerge.Validator.arbitrary_variable?/1,
      &TwMerge.Validator.arbitrary_value?/1,
      &TwMerge.Config.from_theme(&1, "spacing")
    ]
  end

  def sizing do
    [
      &TwMerge.Validator.fraction?/1,
      "auto",
      "full",
      "dvw",
      "dvh",
      "lvw",
      "lvh",
      "svw",
      "svh",
      "min",
      "max",
      "fit",
      &TwMerge.Validator.arbitrary_variable?/1,
      &TwMerge.Validator.arbitrary_value?/1,
      &TwMerge.Config.from_theme(&1, "spacing")
    ]
  end

  def color do
    [
      &TwMerge.Config.from_theme(&1, "color"),
      &TwMerge.Validator.arbitrary_variable?/1,
      &TwMerge.Validator.arbitrary_value?/1
    ]
  end

  def bg_position do
    position() ++
      [
        &TwMerge.Validator.arbitrary_variable_position?/1,
        &TwMerge.Validator.arbitrary_position?/1,
        %{
          "position" => [
            &TwMerge.Validator.arbitrary_variable?/1,
            &TwMerge.Validator.arbitrary_value?/1
          ]
        }
      ]
  end

  def bg_repeat do
    ["no-repeat", %{"repeat" => ["", "x", "y", "space", "round"]}]
  end

  def bg_size do
    [
      "auto",
      "cover",
      "contain",
      &TwMerge.Validator.arbitrary_variable_size?/1,
      &TwMerge.Validator.arbitrary_size?/1,
      %{
        "size" => [
          &TwMerge.Validator.arbitrary_variable?/1,
          &TwMerge.Validator.arbitrary_value?/1
        ]
      }
    ]
  end

  def gradient_stop_position do
    [
      &TwMerge.Validator.percent?/1,
      &TwMerge.Validator.arbitrary_variable_length?/1,
      &TwMerge.Validator.arbitrary_length?/1
    ]
  end

  def radius do
    [
      # Deprecated since Tailwind CSS v4.0.0
      "",
      "none",
      "full",
      &TwMerge.Config.from_theme(&1, "radius"),
      &TwMerge.Validator.arbitrary_variable?/1,
      &TwMerge.Validator.arbitrary_value?/1
    ]
  end

  def border_width do
    [
      "",
      &TwMerge.Validator.number?/1,
      &TwMerge.Validator.arbitrary_variable_length?/1,
      &TwMerge.Validator.arbitrary_length?/1
    ]
  end

  def line_style do
    ["solid", "dashed", "dotted", "double"]
  end

  def blend_mode do
    [
      "normal",
      "multiply",
      "screen",
      "overlay",
      "darken",
      "lighten",
      "color-dodge",
      "color-burn",
      "hard-light",
      "soft-light",
      "difference",
      "exclusion",
      "hue",
      "saturation",
      "color",
      "luminosity"
    ]
  end

  def mask_image_position do
    [
      &TwMerge.Validator.number?/1,
      &TwMerge.Validator.percent?/1,
      &TwMerge.Validator.arbitrary_variable_position?/1,
      &TwMerge.Validator.arbitrary_position?/1
    ]
  end

  def blur do
    [
      # Deprecated since Tailwind CSS v4.0.0
      "",
      "none",
      &TwMerge.Config.from_theme(&1, "blur"),
      &TwMerge.Validator.arbitrary_variable?/1,
      &TwMerge.Validator.arbitrary_value?/1
    ]
  end

  def rotate do
    [
      "none",
      &TwMerge.Validator.number?/1,
      &TwMerge.Validator.arbitrary_variable?/1,
      &TwMerge.Validator.arbitrary_value?/1
    ]
  end

  def scale do
    [
      "none",
      &TwMerge.Validator.number?/1,
      &TwMerge.Validator.arbitrary_variable?/1,
      &TwMerge.Validator.arbitrary_value?/1
    ]
  end

  def skew do
    [
      &TwMerge.Validator.number?/1,
      &TwMerge.Validator.arbitrary_variable?/1,
      &TwMerge.Validator.arbitrary_value?/1
    ]
  end

  def translate do
    [
      &TwMerge.Validator.fraction?/1,
      "full",
      &TwMerge.Validator.arbitrary_variable?/1,
      &TwMerge.Validator.arbitrary_value?/1,
      &TwMerge.Config.from_theme(&1, "spacing")
    ]
  end
end
