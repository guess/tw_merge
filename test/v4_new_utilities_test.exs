defmodule TwMerge.V4NewUtilitiesTest do
  @moduledoc """
  Comprehensive tests for new v4 utilities added in Phase 3.2.
  
  Tests all the new utility groups and enhanced utilities to ensure
  proper merging behavior and conflict resolution.
  """
  use ExUnit.Case
  
  setup do
    start_supervised!(TwMerge.Cache)
    :ok
  end

  describe "field-sizing utilities" do
    test "field-sizing conflicts resolve correctly" do
      assert TwMerge.merge("field-sizing-fixed field-sizing-content") == "field-sizing-content"
      assert TwMerge.merge("field-sizing-content field-sizing-fixed") == "field-sizing-fixed"
    end

    test "field-sizing with arbitrary values" do
      assert TwMerge.merge("field-sizing-fixed field-sizing-[auto]") == "field-sizing-[auto]"
    end
  end

  describe "3D transform utilities" do
    test "rotate-x/y/z utilities conflict properly" do
      assert TwMerge.merge("rotate-x-45 rotate-x-90") == "rotate-x-90"
      assert TwMerge.merge("rotate-y-45 rotate-y-90") == "rotate-y-90"
      assert TwMerge.merge("rotate-z-45 rotate-z-90") == "rotate-z-90"
    end

    test "rotate-x/y/z are independent of regular rotate" do
      # These should not conflict with each other
      result = TwMerge.merge("rotate-45 rotate-x-90 rotate-y-180")
      assert result == "rotate-45 rotate-x-90 rotate-y-180"
    end

    test "scale-z utilities work correctly" do
      assert TwMerge.merge("scale-z-50 scale-z-75") == "scale-z-75"
      assert TwMerge.merge("scale-z-75 scale-z-[1.5]") == "scale-z-[1.5]"
    end

    test "scale-3d utility works" do
      assert TwMerge.merge("scale-3d scale-x-50") == "scale-3d scale-x-50"
    end

    test "translate-z utilities work correctly" do
      assert TwMerge.merge("translate-z-12 translate-z-24") == "translate-z-24"
      assert TwMerge.merge("translate-z-24 translate-z-[100px]") == "translate-z-[100px]"
    end

    test "translate-none conflicts with translate utilities" do
      assert TwMerge.merge("translate-x-4 translate-none") == "translate-none"
      assert TwMerge.merge("translate-none translate-x-4") == "translate-x-4"
      assert TwMerge.merge("translate-z-4 translate-none") == "translate-none"
    end

    test "transform-style utilities work correctly" do
      assert TwMerge.merge("transform-3d transform-flat") == "transform-flat"
    end
  end

  describe "mask utilities" do
    test "mask-clip utilities" do
      assert TwMerge.merge("mask-clip-border mask-clip-padding") == "mask-clip-padding"
      assert TwMerge.merge("mask-no-clip mask-clip-content") == "mask-clip-content"
    end

    test "mask-composite utilities" do
      assert TwMerge.merge("mask-add mask-subtract") == "mask-subtract"
      assert TwMerge.merge("mask-intersect mask-exclude") == "mask-exclude"
    end

    test "mask-image utilities" do
      assert TwMerge.merge("mask-none mask-[url(image.png)]") == "mask-[url(image.png)]"
    end

    test "mask-mode utilities" do
      assert TwMerge.merge("mask-alpha mask-luminance") == "mask-luminance"
      assert TwMerge.merge("mask-luminance mask-match") == "mask-match"
    end

    test "mask-origin utilities" do
      assert TwMerge.merge("mask-origin-border mask-origin-padding") == "mask-origin-padding"
      assert TwMerge.merge("mask-origin-content mask-origin-fill") == "mask-origin-fill"
    end

    test "mask-position utilities" do
      assert TwMerge.merge("mask-center mask-top") == "mask-top"
      assert TwMerge.merge("mask-left mask-[center_top]") == "mask-[center_top]"
    end

    test "mask-repeat utilities" do
      assert TwMerge.merge("mask-no-repeat mask-repeat") == "mask-repeat"
      assert TwMerge.merge("mask-repeat-x mask-repeat-y") == "mask-repeat-y"
    end

    test "mask-size utilities" do
      assert TwMerge.merge("mask-auto mask-cover") == "mask-cover"
      assert TwMerge.merge("mask-contain mask-[50%_100%]") == "mask-[50%_100%]"
    end

    test "mask-type utilities" do
      assert TwMerge.merge("mask-type-alpha mask-type-luminance") == "mask-type-luminance"
    end
  end

  describe "inset-shadow utilities" do
    test "inset-shadow conflicts resolve correctly" do
      assert TwMerge.merge("inset-shadow inset-shadow-lg") == "inset-shadow-lg"
      assert TwMerge.merge("inset-shadow-sm inset-shadow-xl") == "inset-shadow-xl"
      assert TwMerge.merge("inset-shadow-none inset-shadow") == "inset-shadow"
    end

    test "inset-shadow with arbitrary values" do
      assert TwMerge.merge("inset-shadow inset-shadow-[0_4px_8px_rgba(0,0,0,0.1)]") == 
        "inset-shadow-[0_4px_8px_rgba(0,0,0,0.1)]"
    end

    test "inset-shadow-color utilities" do
      assert TwMerge.merge("inset-shadow-red-500 inset-shadow-blue-600") == "inset-shadow-blue-600"
    end

    test "inset-shadow is independent of regular shadow" do
      # These should not conflict with each other
      result = TwMerge.merge("shadow-lg inset-shadow-sm")
      assert result == "shadow-lg inset-shadow-sm"
    end
  end

  describe "enhanced backdrop utilities" do
    test "backdrop utilities support arbitrary variables" do
      assert TwMerge.merge("backdrop-blur backdrop-blur-(--custom)") == "backdrop-blur-(--custom)"
      assert TwMerge.merge("backdrop-brightness-50 backdrop-brightness-(--brightness)") == 
        "backdrop-brightness-(--brightness)"
    end

    test "backdrop utilities conflict correctly" do
      assert TwMerge.merge("backdrop-blur-sm backdrop-blur-lg") == "backdrop-blur-lg"
      assert TwMerge.merge("backdrop-grayscale backdrop-grayscale-0") == "backdrop-grayscale-0"
    end

    test "backdrop-filter enhanced" do
      assert TwMerge.merge("backdrop-filter-none backdrop-filter-(--custom)") == 
        "backdrop-filter-(--custom)"
    end
  end

  describe "enhanced shadow utilities" do
    test "shadow utilities support v4 features" do
      # Test empty string (default shadow) conflicts
      assert TwMerge.merge("shadow shadow-lg") == "shadow-lg"
      assert TwMerge.merge("shadow-inner shadow-none") == "shadow-none"
    end

    test "shadow with arbitrary variables" do
      assert TwMerge.merge("shadow-lg shadow-(--custom)") == "shadow-(--custom)"
    end

    test "drop-shadow enhanced" do
      assert TwMerge.merge("drop-shadow drop-shadow-lg") == "drop-shadow-lg"
      assert TwMerge.merge("drop-shadow-sm drop-shadow-(--custom)") == "drop-shadow-(--custom)"
    end
  end

  describe "enhanced border radius utilities" do
    test "radius utilities support v4 features" do
      # Test empty string (default rounded) conflicts
      assert TwMerge.merge("rounded rounded-lg") == "rounded-lg"
      assert TwMerge.merge("rounded-none rounded-full") == "rounded-full"
    end

    test "radius with arbitrary variables" do
      assert TwMerge.merge("rounded-lg rounded-(--radius)") == "rounded-(--radius)"
    end
  end

  describe "sr utilities (already present)" do
    test "sr utilities work correctly" do
      assert TwMerge.merge("sr-only not-sr-only") == "not-sr-only"
      assert TwMerge.merge("not-sr-only sr-only") == "sr-only"
    end
  end
end