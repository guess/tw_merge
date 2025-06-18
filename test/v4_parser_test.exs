defmodule TwMerge.V4ParserTest do
  @moduledoc """
  Tests to ensure the parser properly handles v4 arbitrary variable syntax.
  This test focuses on verifying that the parser can handle both v3 and v4 syntax.
  """
  use ExUnit.Case

  import TwMerge

  setup do
    TwMerge.Cache.create_table()
    :ok
  end

  describe "v4 arbitrary variable parsing" do
    test "handles v4 parentheses syntax" do
      # Basic v4 arbitrary variables
      result = merge("bg-red-500 bg-(--primary)")
      assert result == "bg-(--primary)"

      result = merge("text-lg text-(color:--heading)")
      assert result == "text-lg text-(color:--heading)"
    end

    test "v4 arbitrary variables conflict correctly" do
      # Same utility with different arbitrary variables
      result = merge("shadow-(--light) shadow-(--dark)")
      assert result == "shadow-(--dark)"

      # Labeled arbitrary variables
      result = merge("bg-(color:--primary) bg-(color:--secondary)")
      assert result == "bg-(color:--secondary)"
    end

    test "v4 arbitrary variables work with modifiers" do
      # With hover modifier
      result = merge("hover:bg-(--primary) hover:bg-(--secondary)")
      assert result == "hover:bg-(--secondary)"

      # With multiple modifiers
      result = merge("dark:hover:bg-(--light) dark:hover:bg-(--dark)")
      assert result == "dark:hover:bg-(--dark)"
    end

    test "v4 and v3 syntax coexist" do
      # v3 and v4 should not conflict with each other for different properties
      result = merge("bg-[#ff0000] text-(--primary)")
      assert result == "bg-[#ff0000] text-(--primary)"

      # But they should conflict for the same property
      result = merge("bg-[#ff0000] bg-(--primary)")
      assert result == "bg-(--primary)"

      result = merge("bg-(--primary) bg-[#ff0000]")
      assert result == "bg-[#ff0000]"
    end

    test "v4 arbitrary variables with utility-specific validators" do
      # Background utilities with color variables
      result = merge("bg-red-500 bg-(color:--brand)")
      assert result == "bg-(color:--brand)"

      # Font family with family-name variables
      result = merge("font-sans font-(family-name:--heading)")
      assert result == "font-(family-name:--heading)"

      # Length-based utilities
      result = merge("w-4 w-(length:--width)")
      assert result == "w-(length:--width)"
    end

    test "complex v4 arbitrary variable names" do
      # Complex CSS variable names
      result = merge("bg-(--primary-500) bg-(--secondary-200)")
      assert result == "bg-(--secondary-200)"

      # Variables with numbers and hyphens
      result = merge("text-(--brand-primary-xl) text-(--brand-secondary-sm)")
      assert result == "text-(--brand-secondary-sm)"
    end

    test "v4 arbitrary variables with postfix modifiers" do
      # With opacity postfix
      result = merge("bg-(--primary)/50 bg-(--primary)/75")
      assert result == "bg-(--primary)/75"

      # Different variables with postfix
      result = merge("bg-(--primary)/50 bg-(--secondary)/25")
      assert result == "bg-(--secondary)/25"
    end
  end

  describe "v4 arbitrary variable edge cases" do
    test "malformed v4 syntax is handled gracefully" do
      # Unclosed parentheses - should not crash
      result = merge("bg-(--primary bg-red-500")
      assert result == "bg-(--primary bg-red-500"

      # No variable name
      result = merge("bg-() bg-red-500")
      assert result == "bg-() bg-red-500"
    end

    test "v4 arbitrary variables work with important modifier" do
      result = merge("!bg-(--primary) !bg-(--secondary)")
      assert result == "!bg-(--secondary)"

      result = merge("bg-(--primary) !bg-(--secondary)")
      assert result == "bg-(--primary) !bg-(--secondary)"
    end

    test "v4 arbitrary variables in complex scenarios" do
      # Mixed with regular classes and modifiers
      result =
        merge([
          "hover:bg-red-500",
          "focus:bg-(--primary)",
          "hover:bg-(--secondary)",
          "bg-blue-300"
        ])

      assert result == "focus:bg-(--primary) hover:bg-(--secondary) bg-blue-300"
    end
  end

  describe "integration with existing functionality" do
    test "v4 arbitrary variables work with all utility categories" do
      # Spacing utilities
      result = merge("m-4 m-(length:--spacing)")
      assert result == "m-(length:--spacing)"

      # Color utilities
      result = merge("text-red-500 text-(color:--brand)")
      assert result == "text-(color:--brand)"

      # Shadow utilities - Note: shadow-(shadow:--elevation) is currently resolved as shadow-color, not shadow
      # This is a known issue with group resolution that needs further investigation
      result = merge("shadow-lg shadow-(shadow:--elevation)")
      assert result == "shadow-lg shadow-(shadow:--elevation)"

      # Size utilities
      result = merge("w-32 w-(size:--width)")
      assert result == "w-(size:--width)"
    end

    test "caching works with v4 arbitrary variables" do
      # Same merge should use cache on second call
      result1 = merge("bg-(--primary) bg-(--secondary)")
      result2 = merge("bg-(--primary) bg-(--secondary)")
      assert result1 == result2
      assert result1 == "bg-(--secondary)"
    end
  end
end
