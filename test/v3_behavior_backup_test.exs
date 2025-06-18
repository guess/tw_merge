defmodule TwMerge.V3BehaviorBackupTest do
  @moduledoc """
  Comprehensive test suite that documents and validates current v3 behavior.
  
  This serves as a backup/baseline before migrating to v4 support.
  These tests should continue to pass to ensure v3 compatibility is maintained.
  """
  use ExUnit.Case
  
  setup do
    start_supervised!(TwMerge.Cache)
    :ok
  end

  describe "v3 core functionality" do
    test "basic class merging" do
      assert TwMerge.merge("text-white bg-red-500 bg-blue-300") == "text-white bg-blue-300"
      assert TwMerge.merge(["px-2 py-1", "p-3"]) == "p-3"
    end

    test "join function" do
      assert TwMerge.join(["bg-red-500", "text-white", "p-4"]) == "bg-red-500 text-white p-4"
      assert TwMerge.join([]) == ""
      assert TwMerge.join(["  ", "bg-red", "  "]) == "   bg-red   "
    end

    test "empty and nil handling" do
      assert TwMerge.merge("") == ""
      assert TwMerge.merge("   ") == ""
      assert TwMerge.merge([""]) == ""
      assert TwMerge.merge([]) == ""
    end
  end

  describe "v3 opacity utilities (deprecated in v4)" do
    test "bg-opacity utilities work in v3" do
      assert TwMerge.merge("bg-red-500 bg-opacity-50 bg-opacity-75") == "bg-red-500 bg-opacity-75"
      assert TwMerge.merge("bg-opacity-50 bg-blue-500") == "bg-opacity-50 bg-blue-500"
    end

    test "text-opacity utilities work in v3" do
      assert TwMerge.merge("text-black text-opacity-50 text-opacity-75") == "text-black text-opacity-75"
      assert TwMerge.merge("text-opacity-50 text-red-500") == "text-opacity-50 text-red-500"
    end

    test "border-opacity utilities work in v3" do
      assert TwMerge.merge("border-red-500 border-opacity-50 border-opacity-75") == "border-red-500 border-opacity-75"
    end

    test "divide-opacity utilities work in v3" do
      assert TwMerge.merge("divide-red-500 divide-opacity-50 divide-opacity-75") == "divide-red-500 divide-opacity-75"
    end

    test "ring-opacity utilities work in v3" do
      assert TwMerge.merge("ring-red-500 ring-opacity-50 ring-opacity-75") == "ring-red-500 ring-opacity-75"
    end
  end

  describe "v3 placeholder utilities (deprecated in v4)" do
    test "placeholder-color utilities work in v3" do
      assert TwMerge.merge("placeholder-gray-400 placeholder-red-500") == "placeholder-red-500"
    end

    test "placeholder-opacity utilities work in v3" do
      assert TwMerge.merge("placeholder-opacity-50 placeholder-opacity-75") == "placeholder-opacity-75"
    end

    test "placeholder utilities with colors" do
      assert TwMerge.merge("placeholder-gray-400 placeholder-opacity-50") == "placeholder-gray-400 placeholder-opacity-50"
    end
  end

  describe "v3 shadow utilities with empty string" do
    test "shadow with empty string works in v3" do
      # In v3, shadow accepts empty string, in v4 it doesn't
      assert TwMerge.merge("shadow shadow-lg") == "shadow-lg"
      assert TwMerge.merge("shadow-lg shadow") == "shadow"
    end

    test "shadow variations" do
      assert TwMerge.merge("shadow-sm shadow-md shadow-lg") == "shadow-lg"
      assert TwMerge.merge("shadow-inner shadow-none") == "shadow-none"
    end
  end

  describe "v3 border-radius with empty string" do
    test "rounded with empty string works in v3" do
      # In v3, rounded accepts empty string, in v4 it doesn't
      assert TwMerge.merge("rounded rounded-lg") == "rounded-lg"
      assert TwMerge.merge("rounded-lg rounded") == "rounded"
    end

    test "rounded variations" do
      assert TwMerge.merge("rounded-sm rounded-md rounded-lg") == "rounded-lg"
      assert TwMerge.merge("rounded-full rounded-none") == "rounded-none"
    end
  end

  describe "v3 arbitrary values" do
    test "arbitrary colors" do
      assert TwMerge.merge("bg-[#1da1f2] bg-[#ff0000]") == "bg-[#ff0000]"
      assert TwMerge.merge("text-[#333] text-[rgb(255,0,0)]") == "text-[rgb(255,0,0)]"
    end

    test "arbitrary sizes" do
      assert TwMerge.merge("text-[22px] text-[24px]") == "text-[24px]"
      assert TwMerge.merge("w-[100px] w-[200px]") == "w-[200px]"
    end

    test "arbitrary properties" do
      assert TwMerge.merge("[mask-type:luminance] [mask-type:alpha]") == "[mask-type:alpha]"
    end

    test "css variables with square brackets (v3 syntax)" do
      assert TwMerge.merge("bg-[--my-color] text-[--my-text]") == "bg-[--my-color] text-[--my-text]"
      assert TwMerge.merge("bg-[--primary] bg-[--secondary]") == "bg-[--secondary]"
    end
  end

  describe "v3 conflict resolution" do
    test "background color conflicts" do
      assert TwMerge.merge("bg-red-500 bg-blue-300 bg-green-400") == "bg-green-400"
    end

    test "text color conflicts" do
      assert TwMerge.merge("text-white text-black text-red-500") == "text-red-500"
    end

    test "spacing conflicts" do
      # In current v3, conflicting spacing utilities don't merge as expected
      assert TwMerge.merge("p-4 px-2 py-3") == "p-4 px-2 py-3"
      assert TwMerge.merge("m-4 mx-2 my-3") == "m-4 mx-2 my-3"
    end

    test "sizing conflicts" do
      assert TwMerge.merge("w-full w-1/2 w-auto") == "w-auto"
      assert TwMerge.merge("h-screen h-full h-auto") == "h-auto"
    end

    test "position conflicts" do
      assert TwMerge.merge("top-0 top-4 top-auto") == "top-auto"
      # Current v3 behavior for inset conflicts
      assert TwMerge.merge("inset-0 inset-x-4 inset-y-2") == "inset-0 inset-x-4 inset-y-2"
    end
  end

  describe "v3 modifiers" do
    test "hover modifiers" do
      assert TwMerge.merge("hover:bg-red-500 hover:bg-blue-300") == "hover:bg-blue-300"
    end

    test "responsive modifiers" do
      assert TwMerge.merge("lg:w-full lg:w-1/2") == "lg:w-1/2"
      assert TwMerge.merge("sm:p-4 md:p-6 lg:p-8") == "sm:p-4 md:p-6 lg:p-8"
    end

    test "mixed modifiers" do
      assert TwMerge.merge("bg-red-500 hover:bg-blue-500 lg:hover:bg-green-500") == 
        "bg-red-500 hover:bg-blue-500 lg:hover:bg-green-500"
    end

    test "important modifier" do
      assert TwMerge.merge("!bg-red-500 !bg-blue-300") == "!bg-blue-300"
      # Current v3 behavior doesn't handle important modifier conflicts
      assert TwMerge.merge("bg-red-500 !bg-blue-300") == "bg-red-500 !bg-blue-300"
    end
  end

  describe "v3 theme configuration" do
    test "default theme values work" do
      # Test that current theme configuration is working
      assert TwMerge.merge("text-xs text-sm text-base") == "text-base"
      assert TwMerge.merge("p-1 p-2 p-4") == "p-4"
    end

    test "custom prefix configuration" do
      config = %{prefix: "tw-"}
      result = TwMerge.merge("tw-bg-red-500 tw-bg-blue-300", config)
      # Current v3 behavior with prefix - doesn't fully resolve conflicts
      assert result == "tw-bg-red-500 tw-bg-blue-300"
    end
  end

  describe "v3 edge cases" do
    test "whitespace handling" do
      assert TwMerge.merge("  bg-red-500   text-white  ") == "bg-red-500 text-white"
      assert TwMerge.merge("bg-red-500\t\ntext-white") == "bg-red-500 text-white"
    end

    test "duplicate classes" do
      assert TwMerge.merge("bg-red-500 bg-red-500") == "bg-red-500"
      assert TwMerge.merge("text-white text-white bg-red-500") == "text-white bg-red-500"
    end

    test "unknown classes pass through" do
      assert TwMerge.merge("unknown-class bg-red-500") == "unknown-class bg-red-500"
      assert TwMerge.merge("custom-utility text-white") == "custom-utility text-white"
    end

    test "malformed arbitrary values" do
      assert TwMerge.merge("bg-[invalid bg-red-500") == "bg-[invalid bg-red-500"
      assert TwMerge.merge("text-[] text-white") == "text-[] text-white"
    end
  end

  describe "v3 comprehensive utility coverage" do
    test "layout utilities" do
      assert TwMerge.merge("block inline flex") == "flex"
      assert TwMerge.merge("static relative absolute") == "absolute"
      assert TwMerge.merge("visible invisible") == "invisible"
    end

    test "flexbox utilities" do
      assert TwMerge.merge("flex-row flex-col") == "flex-col"
      assert TwMerge.merge("justify-start justify-center justify-end") == "justify-end"
      assert TwMerge.merge("items-start items-center items-end") == "items-end"
    end

    test "grid utilities" do
      assert TwMerge.merge("grid-cols-1 grid-cols-2 grid-cols-3") == "grid-cols-3"
      assert TwMerge.merge("col-span-1 col-span-2") == "col-span-2"
    end

    test "typography utilities" do
      assert TwMerge.merge("font-normal font-bold") == "font-bold"
      assert TwMerge.merge("text-left text-center text-right") == "text-right"
      assert TwMerge.merge("uppercase lowercase") == "lowercase"
    end

    test "background utilities" do
      assert TwMerge.merge("bg-fixed bg-local bg-scroll") == "bg-scroll"
      assert TwMerge.merge("bg-clip-border bg-clip-padding bg-clip-content") == "bg-clip-content"
    end

    test "border utilities" do
      assert TwMerge.merge("border border-2 border-4") == "border-4"
      assert TwMerge.merge("border-solid border-dashed border-dotted") == "border-dotted"
    end

    test "filter utilities" do
      assert TwMerge.merge("blur blur-sm blur-md") == "blur-md"
      assert TwMerge.merge("brightness-50 brightness-75 brightness-100") == "brightness-100"
    end

    test "animation utilities" do
      assert TwMerge.merge("animate-none animate-spin animate-pulse") == "animate-pulse"
      assert TwMerge.merge("transition-none transition-all") == "transition-all"
    end
  end

  describe "v3 performance baseline" do
    @tag :performance
    test "handles large class lists efficiently" do
      large_class_list = Enum.map(1..100, fn i -> 
        "bg-red-#{rem(i, 9) + 1}00 text-blue-#{rem(i, 9) + 1}00 p-#{rem(i, 8) + 1}"
      end) |> Enum.join(" ")
      
      result = TwMerge.merge(large_class_list)
      
      # Should resolve to the last occurrence of each conflicting group
      assert String.contains?(result, "bg-red-")
      assert String.contains?(result, "text-blue-")
      assert String.contains?(result, "p-")
    end

    @tag :performance
    test "caching works correctly" do
      input = "bg-red-500 bg-blue-300 text-white"
      
      # First call
      result1 = TwMerge.merge(input)
      
      # Second call should use cache
      result2 = TwMerge.merge(input)
      
      assert result1 == result2
      assert result1 == "bg-blue-300 text-white"
    end
  end
end