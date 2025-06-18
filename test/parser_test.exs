defmodule TwMerge.ParserTest do
  use ExUnit.Case
  alias TwMerge.Parser

  describe "basic class parsing" do
    test "parses simple utility classes" do
      assert {:ok, [base: "bg-red-500"], "", %{}, {1, 0}, 10} = Parser.class("bg-red-500")
      assert {:ok, [base: "text-lg"], "", %{}, {1, 0}, 7} = Parser.class("text-lg")
      assert {:ok, [base: "p-4"], "", %{}, {1, 0}, 3} = Parser.class("p-4")
    end

    test "parses classes with numeric values" do
      assert {:ok, [base: "w-1"], "", %{}, {1, 0}, 3} = Parser.class("w-1")
      assert {:ok, [base: "h-12"], "", %{}, {1, 0}, 4} = Parser.class("h-12")
      assert {:ok, [base: "m-96"], "", %{}, {1, 0}, 4} = Parser.class("m-96")
    end

    test "parses classes with negative values" do
      assert {:ok, [base: "-m-4"], "", %{}, {1, 0}, 4} = Parser.class("-m-4")
      assert {:ok, [base: "-top-1"], "", %{}, {1, 0}, 6} = Parser.class("-top-1")
    end

    test "parses classes with decimal values" do
      assert {:ok, [base: "w-1.5"], "", %{}, {1, 0}, 5} = Parser.class("w-1.5")
      assert {:ok, [base: "h-2.5"], "", %{}, {1, 0}, 5} = Parser.class("h-2.5")
    end
  end

  describe "modifier parsing" do
    test "parses hover modifier" do
      assert {:ok, [modifier: "hover", base: "bg-red-500"], "", %{}, {1, 0}, 16} = 
        Parser.class("hover:bg-red-500")
    end

    test "parses focus modifier" do
      assert {:ok, [modifier: "focus", base: "outline-none"], "", %{}, {1, 0}, 18} = 
        Parser.class("focus:outline-none")
    end

    test "parses multiple modifiers" do
      assert {:ok, [modifier: "hover", modifier: "focus", base: "bg-blue-500"], "", %{}, {1, 0}, 24} = 
        Parser.class("hover:focus:bg-blue-500")
    end

    test "parses responsive modifiers" do
      assert {:ok, [modifier: "sm", base: "text-lg"], "", %{}, {1, 0}, 10} = 
        Parser.class("sm:text-lg")
      assert {:ok, [modifier: "md", base: "p-8"], "", %{}, {1, 0}, 7} = 
        Parser.class("md:p-8")
      assert {:ok, [modifier: "lg", base: "w-full"], "", %{}, {1, 0}, 10} = 
        Parser.class("lg:w-full")
    end

    test "parses complex modifiers" do
      assert {:ok, [modifier: "peer-focus", base: "text-red-500"], "", %{}, {1, 0}, 21} = 
        Parser.class("peer-focus:text-red-500")
      assert {:ok, [modifier: "group-hover", base: "opacity-100"], "", %{}, {1, 0}, 22} = 
        Parser.class("group-hover:opacity-100")
    end
  end

  describe "important modifier parsing" do
    test "parses prefix important modifier" do
      assert {:ok, [important: "!", base: "bg-red-500"], "", %{}, {1, 0}, 11} = 
        Parser.class("!bg-red-500")
    end

    test "parses important with modifiers" do
      assert {:ok, [modifier: "hover", important: "!", base: "text-white"], "", %{}, {1, 0}, 17} = 
        Parser.class("hover:!text-white")
    end

    test "should support suffix important modifier (v4)" do
      # This test will initially fail - it shows what we need to implement
      assert {:ok, [base: "bg-red-500", important: "!"], "", %{}, {1, 0}, 11} = 
        Parser.class("bg-red-500!")
    end

    test "should support suffix important with modifiers (v4)" do
      # This test will initially fail - it shows what we need to implement
      assert {:ok, [modifier: "hover", base: "text-white", important: "!"], "", %{}, {1, 0}, 17} = 
        Parser.class("hover:text-white!")
    end
  end

  describe "arbitrary value parsing" do
    test "parses simple arbitrary values" do
      assert {:ok, [base: "[2px]"], "", %{}, {1, 0}, 5} = Parser.class("[2px]")
      assert {:ok, [base: "[100%]"], "", %{}, {1, 0}, 6} = Parser.class("[100%]")
    end

    test "parses arbitrary values with CSS functions" do
      {:ok, result, "", %{}, {1, 0}, _} = Parser.class("[calc(100%-2rem)]")
      assert [base: "[calc(100%-2rem)]"] = result
    end

    test "parses arbitrary values with CSS variables" do
      {:ok, result, "", %{}, {1, 0}, _} = Parser.class("[var(--primary)]")
      assert [base: "[var(--primary)]"] = result
    end

    test "parses complex arbitrary values" do
      {:ok, result, "", %{}, {1, 0}, _} = Parser.class("[calc(theme(fontSize.4xl)/1.125)]")
      assert [base: "[calc(theme(fontSize.4xl)/1.125)]"] = result
    end

    test "parses arbitrary properties" do
      {:ok, result, "", %{}, {1, 0}, _} = Parser.class("[color:red]")
      assert [base: "[color:red]"] = result

      {:ok, result, "", %{}, {1, 0}, _} = Parser.class("[background-color:var(--bg)]")
      assert [base: "[background-color:var(--bg)]"] = result
    end

    test "parses arbitrary values with URLs" do
      {:ok, result, "", %{}, {1, 0}, _} = Parser.class("[url(./bg.png)]")
      assert [base: "[url(./bg.png)]"] = result

      {:ok, result, "", %{}, {1, 0}, _} = Parser.class("[url(https://example.com/image.jpg)]")
      assert [base: "[url(https://example.com/image.jpg)]"] = result
    end

    test "parses nested arbitrary values" do
      {:ok, result, "", %{}, {1, 0}, _} = Parser.class("[content:'[hello]']")
      assert [base: "[content:'[hello]']"] = result
    end
  end

  describe "arbitrary variable parsing (v4)" do
    test "parses simple arbitrary variables" do
      {:ok, result, "", %{}, {1, 0}, _} = Parser.class("(--primary)")
      assert [base: "(--primary)"] = result
    end

    test "parses arbitrary variables with labels" do
      # These tests will initially fail - they show what we need to implement
      {:ok, result, "", %{}, {1, 0}, _} = Parser.class("(color:--primary)")
      assert [base: "(color:--primary)"] = result

      {:ok, result, "", %{}, {1, 0}, _} = Parser.class("(length:--spacing)")
      assert [base: "(length:--spacing)"] = result

      {:ok, result, "", %{}, {1, 0}, _} = Parser.class("(size:--width)")
      assert [base: "(size:--width)"] = result
    end

    test "parses arbitrary variables in utilities" do
      {:ok, result, "", %{}, {1, 0}, _} = Parser.class("bg-(--primary)")
      assert [base: "bg-(--primary)"] = result

      {:ok, result, "", %{}, {1, 0}, _} = Parser.class("text-(color:--accent)")
      assert [base: "text-(color:--accent)"] = result
    end

    test "parses arbitrary variables with modifiers" do
      {:ok, result, "", %{}, {1, 0}, _} = Parser.class("hover:bg-(--hover-color)")
      assert [modifier: "hover", base: "bg-(--hover-color)"] = result
    end
  end

  describe "postfix modifier parsing" do
    test "parses opacity postfix" do
      assert {:ok, [base: "bg-red-500", postfix: "50"], "", %{}, {1, 0}, 13} = 
        Parser.class("bg-red-500/50")
    end

    test "parses percentage postfix" do
      # This test may fail initially - shows what we need to support
      {:ok, result, "", %{}, {1, 0}, _} = Parser.class("bg-red-500/25%")
      assert [base: "bg-red-500", postfix: "25%"] = result
    end

    test "parses decimal postfix" do
      # This test may fail initially - shows what we need to support  
      {:ok, result, "", %{}, {1, 0}, _} = Parser.class("bg-red-500/0.5")
      assert [base: "bg-red-500", postfix: "0.5"] = result
    end

    test "parses postfix with modifiers" do
      {:ok, result, "", %{}, {1, 0}, _} = Parser.class("hover:bg-red-500/50")
      assert [modifier: "hover", base: "bg-red-500", postfix: "50"] = result
    end

    test "parses postfix with arbitrary values" do
      {:ok, result, "", %{}, {1, 0}, _} = Parser.class("shadow-lg/[0.25]")
      assert [base: "shadow-lg", postfix: "[0.25]"] = result
    end
  end

  describe "complex class combinations" do
    test "parses class with all components" do
      {:ok, result, "", %{}, {1, 0}, _} = Parser.class("hover:!bg-red-500/50")
      assert [modifier: "hover", important: "!", base: "bg-red-500", postfix: "50"] = result
    end

    test "parses multiple modifiers with arbitrary values" do
      {:ok, result, "", %{}, {1, 0}, _} = Parser.class("sm:hover:bg-[#ff0000]")
      assert [modifier: "sm", modifier: "hover", base: "bg-[#ff0000]"] = result
    end

    test "parses dark mode modifier" do
      {:ok, result, "", %{}, {1, 0}, _} = Parser.class("dark:bg-gray-900")
      assert [modifier: "dark", base: "bg-gray-900"] = result
    end

    test "parses group modifiers" do
      {:ok, result, "", %{}, {1, 0}, _} = Parser.class("group-hover:scale-105")
      assert [modifier: "group-hover", base: "scale-105"] = result
    end
  end

  describe "v4 specific enhancements" do
    test "parses modern CSS units in arbitrary values" do
      # Container query units
      {:ok, result, "", %{}, {1, 0}, _} = Parser.class("[width:50cqw]")
      assert [base: "[width:50cqw]"] = result

      {:ok, result, "", %{}, {1, 0}, _} = Parser.class("[height:100cqh]")
      assert [base: "[height:100cqh]"] = result

      # Dynamic viewport units
      {:ok, result, "", %{}, {1, 0}, _} = Parser.class("[height:100dvh]")
      assert [base: "[height:100dvh]"] = result

      {:ok, result, "", %{}, {1, 0}, _} = Parser.class("[width:100dvw]")
      assert [base: "[width:100dvw]"] = result
    end

    test "parses modern CSS color functions" do
      {:ok, result, "", %{}, {1, 0}, _} = Parser.class("[color:oklch(0.7_0.15_180)]")
      assert [base: "[color:oklch(0.7_0.15_180)]"] = result

      {:ok, result, "", %{}, {1, 0}, _} = Parser.class("[background:color-mix(in_srgb,red_50%,blue)]")
      assert [base: "[background:color-mix(in_srgb,red_50%,blue)]"] = result
    end

    test "parses any numeric values for spacing utilities" do
      # v4 should support any number for spacing
      {:ok, result, "", %{}, {1, 0}, _} = Parser.class("mt-17")
      assert [base: "mt-17"] = result

      {:ok, result, "", %{}, {1, 0}, _} = Parser.class("w-29")
      assert [base: "w-29"] = result

      {:ok, result, "", %{}, {1, 0}, _} = Parser.class("grid-cols-15")
      assert [base: "grid-cols-15"] = result
    end

    test "parses container query modifiers" do
      # These might be handled as regular modifiers, but worth testing
      {:ok, result, "", %{}, {1, 0}, _} = Parser.class("@sm:flex")
      assert [modifier: "@sm", base: "flex"] = result

      {:ok, result, "", %{}, {1, 0}, _} = Parser.class("@container:hidden")
      assert [modifier: "@container", base: "hidden"] = result
    end
  end

  describe "edge cases and error handling" do
    test "handles empty input" do
      assert {:error, _, _, %{}, _, _} = Parser.class("")
    end

    test "handles malformed arbitrary values" do
      assert {:error, _, _, %{}, _, _} = Parser.class("[unclosed")
      assert {:error, _, _, %{}, _, _} = Parser.class("unopened]")
    end

    test "handles malformed arbitrary variables" do
      assert {:error, _, _, %{}, _, _} = Parser.class("(unclosed")
      assert {:error, _, _, %{}, _, _} = Parser.class("unopened)")
    end

    test "handles complex nested structures" do
      {:ok, result, "", %{}, {1, 0}, _} = Parser.class("[background:url('data:image/svg+xml;utf8,<svg></svg>')]")
      assert [base: "[background:url('data:image/svg+xml;utf8,<svg></svg>')]"] = result
    end

    test "handles classes with underscores" do
      {:ok, result, "", %{}, {1, 0}, _} = Parser.class("font-mono_slashed")
      assert [base: "font-mono_slashed"] = result
    end

    test "handles classes with special characters" do
      {:ok, result, "", %{}, {1, 0}, _} = Parser.class("content-['→']")
      assert [base: "content-['→']"] = result
    end
  end
end