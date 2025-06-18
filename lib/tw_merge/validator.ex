defmodule TwMerge.Validator do
  @moduledoc false
  @arbitrary_value_regex ~r/^\[(?:(\w[\w-]*):)?(.+)\]$/i
  @arbitrary_variable_regex ~r/^\((?:(\w[\w-]*):)?(.+)\)$/i
  @fraction_regex ~r/^\d+\/\d+$/
  @tshirt_size_regex ~r/^(?:xs|sm|md|lg|xl|\d+(\.\d+)?xl)$/
  @image_regex ~r/^(url|image|image-set|cross-fade|element|(repeating-)?(linear|radial|conic)-gradient)\(.+\)$/
  @color_function_regex ~r/^(rgba?|hsla?|hwb|(ok)?(lab|lch)|color-mix)\(.+\)$/
  @shadow_regex ~r/^(inset_)?-?((\d+)?\.?(\d+)[a-z]+|0)_-?((\d+)?\.?(\d+)[a-z]+|0)/
  @length_unit_regex ~r/\d+(%|px|r?em|[sdl]?v([hwib]|min|max)|pt|pc|in|cm|mm|cap|ch|ex|r?lh|cq(w|h|i|b|min|max))|\b(calc|min|max|clamp)\(.+\)|^0$/

  def arbitrary_value?(value) do
    Regex.match?(@arbitrary_value_regex, value)
  end

  def integer?(value) do
    case Integer.parse(value) do
      {_integer, ""} -> true
      _else -> false
    end
  end

  def number?(value) do
    # Tailwind allows settings float values without leading zeroes, such as `.01`, which `Float.parse/1` does not support.
    value =
      if Regex.match?(~r/^\.\d+$/, value) do
        "0" <> value
      else
        value
      end

    case Float.parse(value) do
      {_float, ""} -> true
      _else -> false
    end
  end

  def length?(value) do
    number?(value) or value in ~w(px full screen) or Regex.match?(@fraction_regex, value)
  end

  def percent?(value) do
    String.ends_with?(value, "%") and number?(String.slice(value, 0..-2//1))
  end

  def tshirt_size?(value) do
    Regex.match?(@tshirt_size_regex, value)
  end

  def arbitrary_length?(value) do
    arbitrary_value?(value, "length", &length_only?/1)
  end

  def arbitrary_number?(value) do
    arbitrary_value?(value, "number", &number?/1)
  end

  def arbitrary_size?(value) do
    arbitrary_value?(value, ~w(length size), &never?/1)
  end

  def arbitrary_position?(value) do
    arbitrary_value?(value, ~w(position percentage), &never?/1)
  end

  def arbitrary_image?(value) do
    arbitrary_value?(value, ~w(image url), &image?/1)
  end

  def image?(value), do: Regex.match?(@image_regex, value)

  def length_only?(value),
    do: Regex.match?(@length_unit_regex, value) and not Regex.match?(@color_function_regex, value)

  def arbitrary_shadow?(value) do
    arbitrary_value?(value, "", &shadow?/1)
  end

  def any?, do: true

  def any?(_value), do: true

  def never?(_value), do: false

  def shadow?(value), do: Regex.match?(@shadow_regex, value)

  def arbitrary_value?(value, label, test_value) do
    case Regex.run(@arbitrary_value_regex, value) do
      [_, label_part, actual_value] ->
        if is_binary(label_part) and label_part != "" do
          case label do
            ^label_part -> true
            list when is_list(list) -> label_part in list
            _ -> false
          end
        else
          test_value.(actual_value)
        end

      _ ->
        false
    end
  end

  # ===== New v4 Validators =====

  @doc """
  Validates arbitrary CSS variables with v4 parentheses syntax.
  Examples: (--primary), (color:--secondary)
  """
  def arbitrary_variable?(value) do
    Regex.match?(@arbitrary_variable_regex, value)
  end

  @doc """
  Validates arbitrary CSS variables with length labels.
  Examples: (length:--spacing), (--size)
  """
  def arbitrary_variable_length?(value) do
    arbitrary_variable?(value, "length")
  end

  @doc """
  Validates arbitrary CSS variables with image labels.
  Examples: (image:--bg), (url:--hero)
  """
  def arbitrary_variable_image?(value) do
    arbitrary_variable?(value, ~w(image url))
  end

  @doc """
  Validates arbitrary CSS variables with position labels.
  Examples: (position:--pos), (percentage:--offset)
  """
  def arbitrary_variable_position?(value) do
    arbitrary_variable?(value, ~w(position percentage))
  end

  @doc """
  Validates arbitrary CSS variables with shadow labels.
  Examples: (shadow:--elevation), (--drop-shadow)
  """
  def arbitrary_variable_shadow?(value) do
    arbitrary_variable?(value, "shadow", true)
  end

  @doc """
  Validates arbitrary CSS variables with size labels.
  Examples: (size:--width), (length:--height), (bg-size:--cover)
  """
  def arbitrary_variable_size?(value) do
    arbitrary_variable?(value, ~w(length size bg-size))
  end

  @doc """
  Validates arbitrary CSS variables with font family labels.
  Examples: (family-name:--heading-font)
  """
  def arbitrary_variable_family_name?(value) do
    arbitrary_variable?(value, "family-name")
  end

  @doc """
  Validates fraction values like 1/2, 3/4, 11/12, etc.
  """
  def fraction?(value) do
    Regex.match?(@fraction_regex, value)
  end

  @doc """
  Validates that a value is not an arbitrary value or arbitrary variable.
  Used for theme values that should not accept arbitrary syntax.
  """
  def any_non_arbitrary?(value) do
    not arbitrary_value?(value) and not arbitrary_variable?(value)
  end

  # Private helper function for arbitrary variable validation
  defp arbitrary_variable?(value, label, should_match_no_label \\ false) do
    case Regex.run(@arbitrary_variable_regex, value) do
      [_, label_part, _actual_value] ->
        if is_binary(label_part) and label_part != "" do
          case label do
            ^label_part -> true
            list when is_list(list) -> label_part in list
            _ -> false
          end
        else
          should_match_no_label
        end

      _ ->
        false
    end
  end
end
