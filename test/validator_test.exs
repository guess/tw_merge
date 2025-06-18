defmodule TwMerge.ValidatorTest do
  @moduledoc """
  Tests for TwMerge validators, including v4 syntax support.
  """
  use ExUnit.Case

  import TwMerge.Validator

  describe "any?/0 and any?/1" do
    test "always returns true" do
      assert any?()
      assert any?("")
      assert any?("something")
    end
  end

  describe "any_non_arbitrary?/1" do
    test "validates non-arbitrary values" do
      assert any_non_arbitrary?("test")
      assert any_non_arbitrary?("1234-hello-world")
      assert any_non_arbitrary?("[hello")
      assert any_non_arbitrary?("hello]")
      assert any_non_arbitrary?("[)")
      assert any_non_arbitrary?("(hello]")
    end

    test "rejects arbitrary values and variables" do
      refute any_non_arbitrary?("[test]")
      refute any_non_arbitrary?("[label:test]")
      refute any_non_arbitrary?("(test)")
      refute any_non_arbitrary?("(label:test)")
    end
  end

  describe "arbitrary_image?/1" do
    test "validates arbitrary image values" do
      assert arbitrary_image?("[url:var(--my-url)]")
      assert arbitrary_image?("[url(something)]")
      assert arbitrary_image?("[url:bla]")
      assert arbitrary_image?("[image:bla]")
      assert arbitrary_image?("[linear-gradient(something)]")
      assert arbitrary_image?("[repeating-conic-gradient(something)]")
    end

    test "rejects non-image values" do
      refute arbitrary_image?("[var(--my-url)]")
      refute arbitrary_image?("[bla]")
      refute arbitrary_image?("url:2px")
      refute arbitrary_image?("url(2px)")
    end
  end

  describe "arbitrary_length?/1" do
    test "validates arbitrary length values" do
      assert arbitrary_length?("[3.7%]")
      assert arbitrary_length?("[481px]")
      assert arbitrary_length?("[19.1rem]")
      assert arbitrary_length?("[50vw]")
      assert arbitrary_length?("[56vh]")
      assert arbitrary_length?("[length:var(--arbitrary)]")
    end

    test "rejects non-length values" do
      refute arbitrary_length?("1")
      refute arbitrary_length?("3px")
      refute arbitrary_length?("1d5")
      refute arbitrary_length?("[1]")
      refute arbitrary_length?("[12px")
      refute arbitrary_length?("12px]")
      refute arbitrary_length?("one")
    end
  end

  describe "arbitrary_number?/1" do
    test "validates arbitrary number values" do
      assert arbitrary_number?("[number:black]")
      assert arbitrary_number?("[number:bla]")
      assert arbitrary_number?("[number:230]")
      assert arbitrary_number?("[450]")
    end

    test "rejects non-number values" do
      refute arbitrary_number?("[2px]")
      refute arbitrary_number?("[bla]")
      refute arbitrary_number?("[black]")
      refute arbitrary_number?("black")
      refute arbitrary_number?("450")
    end
  end

  describe "arbitrary_position?/1" do
    test "validates arbitrary position values" do
      assert arbitrary_position?("[position:2px]")
      assert arbitrary_position?("[position:bla]")
      assert arbitrary_position?("[percentage:bla]")
    end

    test "rejects non-position values" do
      refute arbitrary_position?("[2px]")
      refute arbitrary_position?("[bla]")
      refute arbitrary_position?("position:2px")
    end
  end

  describe "arbitrary_shadow?/1" do
    test "validates arbitrary shadow values" do
      assert arbitrary_shadow?("[0_35px_60px_-15px_rgba(0,0,0,0.3)]")
      assert arbitrary_shadow?("[inset_0_1px_0,inset_0_-1px_0]")
      assert arbitrary_shadow?("[0_0_#00f]")
      assert arbitrary_shadow?("[.5rem_0_rgba(5,5,5,5)]")
      assert arbitrary_shadow?("[-.5rem_0_#123456]")
      assert arbitrary_shadow?("[0.5rem_-0_#123456]")
      assert arbitrary_shadow?("[0.5rem_-0.005vh_#123456]")
      assert arbitrary_shadow?("[0.5rem_-0.005vh]")
    end

    test "rejects non-shadow values" do
      refute arbitrary_shadow?("[rgba(5,5,5,5)]")
      refute arbitrary_shadow?("[#00f]")
      refute arbitrary_shadow?("[something-else]")
    end
  end

  describe "arbitrary_size?/1" do
    test "validates arbitrary size values" do
      assert arbitrary_size?("[size:2px]")
      assert arbitrary_size?("[size:bla]")
      assert arbitrary_size?("[length:bla]")
    end

    test "rejects non-size values" do
      refute arbitrary_size?("[2px]")
      refute arbitrary_size?("[bla]")
      refute arbitrary_size?("size:2px")
      refute arbitrary_size?("[percentage:bla]")
    end
  end

  describe "arbitrary_value?/1" do
    test "validates arbitrary values" do
      assert arbitrary_value?("[1]")
      assert arbitrary_value?("[bla]")
      assert arbitrary_value?("[not-an-arbitrary-value?]")
      assert arbitrary_value?("[auto,auto,minmax(0,1fr),calc(100vw-50%)]")
    end

    test "rejects invalid arbitrary values" do
      refute arbitrary_value?("[]")
      refute arbitrary_value?("[1")
      refute arbitrary_value?("1]")
      refute arbitrary_value?("1")
      refute arbitrary_value?("one")
      refute arbitrary_value?("o[n]e")
    end
  end

  describe "arbitrary_variable?/1" do
    test "validates CSS variables with parentheses syntax" do
      assert arbitrary_variable?("(1)")
      assert arbitrary_variable?("(bla)")
      assert arbitrary_variable?("(not-an-arbitrary-value?)")
      assert arbitrary_variable?("(--my-arbitrary-variable)")
      assert arbitrary_variable?("(label:--my-arbitrary-variable)")
    end

    test "rejects invalid formats" do
      refute arbitrary_variable?("()")
      refute arbitrary_variable?("(1")
      refute arbitrary_variable?("1)")
      refute arbitrary_variable?("1")
      refute arbitrary_variable?("one")
      refute arbitrary_variable?("o(n)e")
    end
  end

  describe "arbitrary_variable_family_name?/1" do
    test "validates CSS variables with family-name labels" do
      assert arbitrary_variable_family_name?("(family-name:test)")
    end

    test "rejects non-family-name labels" do
      refute arbitrary_variable_family_name?("(other:test)")
      refute arbitrary_variable_family_name?("(test)")
      refute arbitrary_variable_family_name?("family-name:test")
    end
  end

  describe "arbitrary_variable_image?/1" do
    test "validates CSS variables with image labels" do
      assert arbitrary_variable_image?("(image:test)")
      assert arbitrary_variable_image?("(url:test)")
    end

    test "rejects non-image labels" do
      refute arbitrary_variable_image?("(other:test)")
      refute arbitrary_variable_image?("(test)")
      refute arbitrary_variable_image?("image:test")
    end
  end

  describe "arbitrary_variable_length?/1" do
    test "validates CSS variables with length labels" do
      assert arbitrary_variable_length?("(length:test)")
    end

    test "rejects non-length labels" do
      refute arbitrary_variable_length?("(other:test)")
      refute arbitrary_variable_length?("(test)")
      refute arbitrary_variable_length?("length:test")
    end
  end

  describe "arbitrary_variable_position?/1" do
    test "validates CSS variables with position labels" do
      assert arbitrary_variable_position?("(position:test)")
    end

    test "rejects non-position labels" do
      refute arbitrary_variable_position?("(other:test)")
      refute arbitrary_variable_position?("(test)")
      refute arbitrary_variable_position?("position:test")
      refute arbitrary_variable_position?("percentage:test")
    end
  end

  describe "arbitrary_variable_shadow?/1" do
    test "validates CSS variables with shadow labels" do
      assert arbitrary_variable_shadow?("(shadow:test)")
      assert arbitrary_variable_shadow?("(test)")
    end

    test "rejects non-shadow labels" do
      refute arbitrary_variable_shadow?("(other:test)")
      refute arbitrary_variable_shadow?("shadow:test")
    end
  end

  describe "arbitrary_variable_size?/1" do
    test "validates CSS variables with size labels" do
      assert arbitrary_variable_size?("(size:test)")
      assert arbitrary_variable_size?("(length:test)")
    end

    test "rejects non-size labels" do
      refute arbitrary_variable_size?("(other:test)")
      refute arbitrary_variable_size?("(test)")
      refute arbitrary_variable_size?("size:test")
      refute arbitrary_variable_size?("(percentage:test)")
    end
  end

  describe "fraction?/1" do
    test "validates fraction values" do
      assert fraction?("1/2")
      assert fraction?("123/209")
    end

    test "rejects invalid fractions" do
      refute fraction?("1")
      refute fraction?("1/2/3")
      refute fraction?("[1/2]")
    end
  end

  describe "integer?/1" do
    test "validates integer values" do
      assert integer?("1")
      assert integer?("123")
      assert integer?("8312")
    end

    test "rejects non-integer values" do
      refute integer?("[8312]")
      refute integer?("[2]")
      refute integer?("[8312px]")
      refute integer?("[8312%]")
      refute integer?("[8312rem]")
      refute integer?("8312.2")
      refute integer?("1.2")
      refute integer?("one")
      refute integer?("1/2")
      refute integer?("1%")
      refute integer?("1px")
    end
  end

  describe "number?/1" do
    test "validates number values" do
      assert number?("1")
      assert number?("123")
      assert number?("8312")
      assert number?("8312.2")
      assert number?("1.2")
    end

    test "rejects non-number values" do
      refute number?("[8312]")
      refute number?("[2]")
      refute number?("[8312px]")
      refute number?("[8312%]")
      refute number?("[8312rem]")
      refute number?("one")
      refute number?("1/2")
      refute number?("1%")
      refute number?("1px")
    end
  end

  describe "percent?/1" do
    test "validates percentage values" do
      assert percent?("1%")
      assert percent?("100.001%")
      assert percent?(".01%")
      assert percent?("0%")
    end

    test "rejects non-percentage values" do
      refute percent?("0")
      refute percent?("one%")
    end
  end

  describe "tshirt_size?/1" do
    test "validates t-shirt size values" do
      assert tshirt_size?("xs")
      assert tshirt_size?("sm")
      assert tshirt_size?("md")
      assert tshirt_size?("lg")
      assert tshirt_size?("xl")
      assert tshirt_size?("2xl")
      assert tshirt_size?("2.5xl")
      assert tshirt_size?("10xl")
    end

    test "rejects invalid t-shirt sizes" do
      refute tshirt_size?("")
      refute tshirt_size?("hello")
      refute tshirt_size?("1")
      refute tshirt_size?("xl3")
      refute tshirt_size?("2xl3")
      refute tshirt_size?("-xl")
      refute tshirt_size?("[sm]")
      refute tshirt_size?("2xs")
      refute tshirt_size?("2lg")
    end
  end

  describe "comprehensive edge cases and missing TypeScript test coverage" do
    test "arbitrary_length?/1 with comprehensive CSS units" do
      # All CSS length units from TypeScript tests
      assert arbitrary_length?("[3.7%]")
      assert arbitrary_length?("[481px]")
      assert arbitrary_length?("[19.1rem]")
      assert arbitrary_length?("[50vw]")
      assert arbitrary_length?("[56vh]")
      assert arbitrary_length?("[length:var(--arbitrary)]")
      assert arbitrary_length?("[calc(100vw - 50px)]")
      assert arbitrary_length?("[min(100%, 500px)]")
      assert arbitrary_length?("[max(10px, 1rem)]")
      assert arbitrary_length?("[clamp(1rem, 5vw, 3rem)]")
    end

    test "arbitrary_shadow?/1 with complex multi-shadow patterns" do
      # Multi-shadow syntax from TypeScript
      assert arbitrary_shadow?("[inset_0_1px_0,inset_0_-1px_0]")
      assert arbitrary_shadow?("[.5rem_0_rgba(5,5,5,5)]")
      assert arbitrary_shadow?("[-.5rem_0_#123456]")
      assert arbitrary_shadow?("[0.5rem_-0_#123456]")
      assert arbitrary_shadow?("[0.5rem_-0.005vh_#123456]")
      assert arbitrary_shadow?("[0.5rem_-0.005vh]")
    end

    test "arbitrary_value?/1 with complex nested values" do
      # Complex values from TypeScript tests
      assert arbitrary_value?("[auto,auto,minmax(0,1fr),calc(100vw-50%)]")
      assert arbitrary_value?("[not-an-arbitrary-value?]")
    end

    test "arbitrary_variable_size?/1 supports bg-size label" do
      # TypeScript supports bg-size label
      assert arbitrary_variable_size?("(bg-size:--cover)")
      assert arbitrary_variable_size?("(bg-size:test)")
    end

    test "number?/1 edge cases and boundary conditions" do
      # Additional edge cases from TypeScript
      assert number?(".5")
      assert number?("0.0")
      assert number?("123.456")
      refute number?("")
      refute number?(".")
      refute number?("1.")
      refute number?("e10")
    end

    test "percent?/1 comprehensive validation" do
      # More comprehensive percentage testing
      assert percent?("1%")
      assert percent?("100.001%")
      assert percent?(".01%")
      assert percent?("0%")
      assert percent?("0.0%")
      refute percent?("0")
      refute percent?("one%")
      refute percent?("%")
      refute percent?("1%%")
    end

    test "arbitrary_image?/1 comprehensive pattern testing" do
      # All image patterns from TypeScript
      assert arbitrary_image?("[url:var(--my-url)]")
      assert arbitrary_image?("[url(something)]")
      assert arbitrary_image?("[url:bla]")
      assert arbitrary_image?("[image:bla]")
      assert arbitrary_image?("[linear-gradient(something)]")
      assert arbitrary_image?("[repeating-conic-gradient(something)]")
      assert arbitrary_image?("[radial-gradient(circle, red)]")
      assert arbitrary_image?("[conic-gradient(from 0deg, red, blue)]")
    end

    test "integration testing - validators work together correctly" do
      # Cross-validator consistency testing
      assert arbitrary_value?("[--old-var]")
      assert arbitrary_variable?("(--new-var)")
      refute any_non_arbitrary?("[--old-var]")
      refute any_non_arbitrary?("(--new-var)")

      # Both v3 and v4 syntax coexist
      assert arbitrary_value?("[length:20px]")
      assert arbitrary_variable_length?("(length:--spacing)")
    end

    test "malformed input robustness" do
      # Test robustness with malformed inputs
      refute arbitrary_variable?("(")
      refute arbitrary_variable?(")")
      refute arbitrary_variable?("(unclosed")
      refute arbitrary_variable?("unopened)")
      refute arbitrary_value?("[unclosed")
      refute arbitrary_value?("unopened]")

      # Empty values
      refute arbitrary_variable?("")
      refute fraction?("")
      assert any_non_arbitrary?("")
    end
  end
end
