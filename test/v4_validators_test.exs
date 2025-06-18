defmodule TwMerge.V4ValidatorsTest do
  @moduledoc """
  Tests for new v4 validators added to support Tailwind CSS v4 syntax.
  """
  use ExUnit.Case

  import TwMerge.Validator

  describe "arbitrary_variable?/1" do
    test "validates CSS variables with parentheses syntax" do
      assert arbitrary_variable?("(--primary)")
      assert arbitrary_variable?("(--secondary-color)")
      assert arbitrary_variable?("(--spacing-4)")

      # With labels
      assert arbitrary_variable?("(color:--brand)")
      assert arbitrary_variable?("(length:--size)")
      assert arbitrary_variable?("(font-family:--heading)")
    end

    test "rejects invalid formats" do
      # v3 square bracket syntax
      refute arbitrary_variable?("[--primary]")
      # no parentheses
      refute arbitrary_variable?("--primary")
      # empty
      refute arbitrary_variable?("()")
      # regular class
      refute arbitrary_variable?("bg-red-500")
      # malformed
      refute arbitrary_variable?("(invalid")
    end
  end

  describe "arbitrary_variable_length?/1" do
    test "validates CSS variables with length labels" do
      assert arbitrary_variable_length?("(length:--spacing)")
      assert arbitrary_variable_length?("(length:--margin-top)")
    end

    test "rejects non-length labels" do
      refute arbitrary_variable_length?("(color:--primary)")
      # no label
      refute arbitrary_variable_length?("(--spacing)")
      refute arbitrary_variable_length?("(size:--width)")
    end
  end

  describe "arbitrary_variable_image?/1" do
    test "validates CSS variables with image labels" do
      assert arbitrary_variable_image?("(image:--background)")
      assert arbitrary_variable_image?("(url:--hero-image)")
    end

    test "rejects non-image labels" do
      refute arbitrary_variable_image?("(color:--primary)")
      # no label
      refute arbitrary_variable_image?("(--image)")
      refute arbitrary_variable_image?("(length:--size)")
    end
  end

  describe "arbitrary_variable_position?/1" do
    test "validates CSS variables with position labels" do
      assert arbitrary_variable_position?("(position:--top)")
      assert arbitrary_variable_position?("(percentage:--offset)")
    end

    test "rejects non-position labels" do
      refute arbitrary_variable_position?("(color:--primary)")
      # no label
      refute arbitrary_variable_position?("(--position)")
      refute arbitrary_variable_position?("(length:--size)")
    end
  end

  describe "arbitrary_variable_shadow?/1" do
    test "validates CSS variables with shadow labels" do
      assert arbitrary_variable_shadow?("(shadow:--elevation)")
      # no label should match
      assert arbitrary_variable_shadow?("(--drop-shadow)")
    end

    test "rejects non-shadow labels" do
      refute arbitrary_variable_shadow?("(color:--primary)")
      refute arbitrary_variable_shadow?("(length:--size)")
    end
  end

  describe "arbitrary_variable_size?/1" do
    test "validates CSS variables with size labels" do
      assert arbitrary_variable_size?("(size:--width)")
      assert arbitrary_variable_size?("(length:--height)")
      assert arbitrary_variable_size?("(bg-size:--cover)")
    end

    test "rejects non-size labels" do
      refute arbitrary_variable_size?("(color:--primary)")
      # no label
      refute arbitrary_variable_size?("(--size)")
      refute arbitrary_variable_size?("(position:--top)")
    end
  end

  describe "arbitrary_variable_family_name?/1" do
    test "validates CSS variables with family-name labels" do
      assert arbitrary_variable_family_name?("(family-name:--heading)")
      assert arbitrary_variable_family_name?("(family-name:--body-font)")
    end

    test "rejects non-family-name labels" do
      refute arbitrary_variable_family_name?("(color:--primary)")
      # no label
      refute arbitrary_variable_family_name?("(--font)")
      refute arbitrary_variable_family_name?("(font:--heading)")
    end
  end

  describe "fraction?/1" do
    test "validates fraction values" do
      assert fraction?("1/2")
      assert fraction?("3/4")
      assert fraction?("11/12")
      assert fraction?("2/3")
      assert fraction?("5/6")
      assert fraction?("1/6")
      assert fraction?("7/12")
      assert fraction?("10/12")
    end

    test "rejects invalid fractions" do
      # not a fraction
      refute fraction?("1")
      # decimal
      refute fraction?("0.5")
      # incomplete
      refute fraction?("1/")
      # incomplete
      refute fraction?("/2")
      # non-numeric
      refute fraction?("a/b")
      # too many parts
      refute fraction?("1/2/3")
      # regular class
      refute fraction?("bg-red")
    end
  end

  describe "any_non_arbitrary?/1" do
    test "validates non-arbitrary values" do
      assert any_non_arbitrary?("red-500")
      assert any_non_arbitrary?("lg")
      assert any_non_arbitrary?("auto")
      assert any_non_arbitrary?("center")
      assert any_non_arbitrary?("4")
    end

    test "rejects arbitrary values and variables" do
      # v3 arbitrary value
      refute any_non_arbitrary?("[#ff0000]")
      # v3 arbitrary value with label
      refute any_non_arbitrary?("[length:20px]")
      # v4 arbitrary variable
      refute any_non_arbitrary?("(--primary)")
      # v4 arbitrary variable with label
      refute any_non_arbitrary?("(color:--brand)")
    end
  end

  describe "enhanced percent?/1" do
    test "validates percentage values" do
      assert percent?("50%")
      assert percent?("100%")
      assert percent?("0%")
      assert percent?("25.5%")
      assert percent?(".5%")
    end

    test "rejects non-percentage values" do
      # no % sign
      refute percent?("50")
      # different unit
      refute percent?("50px")
      # non-numeric
      refute percent?("abc%")
      # % at start
      refute percent?("%50")
    end
  end

  describe "integration with existing validators" do
    test "existing validators still work" do
      # Make sure we didn't break existing functionality
      assert arbitrary_value?("[#ff0000]")
      assert arbitrary_value?("[length:20px]")
      assert number?("42")
      assert tshirt_size?("lg")
      # length? expects unit names, not values with units
      assert length?("px")
    end

    test "new validators work alongside existing ones" do
      # Test that v3 and v4 syntax can coexist
      # v3 syntax
      assert arbitrary_value?("[--old-var]")
      # v4 syntax
      assert arbitrary_variable?("(--new-var)")

      # Both should be rejected by any_non_arbitrary
      refute any_non_arbitrary?("[--old-var]")
      refute any_non_arbitrary?("(--new-var)")
    end
  end

  describe "edge cases and error handling" do
    test "handles empty and nil values gracefully" do
      refute arbitrary_variable?("")
      refute fraction?("")
      # empty string is non-arbitrary
      assert any_non_arbitrary?("")
    end

    test "handles malformed parentheses" do
      refute arbitrary_variable?("(")
      refute arbitrary_variable?(")")
      refute arbitrary_variable?("(unclosed")
      refute arbitrary_variable?("unopened)")
    end

    test "handles complex CSS variable names" do
      assert arbitrary_variable?("(--my-very-long-variable-name)")
      assert arbitrary_variable?("(--var-with-123-numbers)")
      assert arbitrary_variable?("(color:--brand-primary-500)")
    end
  end
end
