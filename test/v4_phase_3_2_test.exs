defmodule TwMerge.V4Phase32Test do
  @moduledoc """
  Tests specifically for Phase 3.2 implementation - new v4 utilities.
  
  These tests focus on the core functionality that was added and verify
  that the most important v4 utilities work correctly.
  """
  use ExUnit.Case
  
  setup do
    start_supervised!(TwMerge.Cache)
    :ok
  end

  describe "Phase 3.2: New v4 utilities - Core functionality" do
    test "field-sizing utilities work" do
      # Basic functionality test
      assert TwMerge.merge("field-sizing-fixed field-sizing-content") == "field-sizing-content"
      assert TwMerge.merge("field-sizing-content field-sizing-fixed") == "field-sizing-fixed"
    end

    test "3D transform utilities work independently" do
      # Test that the new 3D transforms don't interfere with existing ones
      result = TwMerge.merge("rotate-45 rotate-x-90 rotate-y-180 scale-z-50")
      # All should remain as they don't conflict with each other
      assert result == "rotate-45 rotate-x-90 rotate-y-180 scale-z-50"
    end

    test "3D transform utilities have proper conflicts within their groups" do
      assert TwMerge.merge("rotate-x-45 rotate-x-90") == "rotate-x-90"
      assert TwMerge.merge("scale-z-50 scale-z-75") == "scale-z-75"
      assert TwMerge.merge("translate-z-12 translate-z-24") == "translate-z-24"
    end

    test "scale-3d utility works" do
      assert TwMerge.merge("scale-3d scale-x-50") == "scale-3d scale-x-50"
    end

    test "transform-style utilities work" do
      assert TwMerge.merge("transform-3d transform-flat") == "transform-flat"
    end

    test "inset-shadow utilities are present and work" do
      assert TwMerge.merge("inset-shadow inset-shadow-lg") == "inset-shadow-lg"
      assert TwMerge.merge("inset-shadow-sm inset-shadow-xl") == "inset-shadow-xl"
      
      # Test independence from regular shadow
      result = TwMerge.merge("shadow-lg inset-shadow-sm")
      assert result == "shadow-lg inset-shadow-sm"
    end

    test "basic mask utilities are present" do
      # Test that mask utilities exist and basic conflicts work
      assert TwMerge.merge("mask-alpha mask-luminance") == "mask-luminance"
      assert TwMerge.merge("mask-add mask-subtract") == "mask-subtract"
    end

    test "enhanced shadow utilities work with v4 features" do
      # Test that shadow empty string conflicts work (key v4 change)
      assert TwMerge.merge("shadow shadow-lg") == "shadow-lg"
      assert TwMerge.merge("shadow-inner shadow-none") == "shadow-none"
    end

    test "enhanced backdrop utilities support basic functionality" do
      # Test basic backdrop conflicts
      assert TwMerge.merge("backdrop-blur-sm backdrop-blur-lg") == "backdrop-blur-lg"
      assert TwMerge.merge("backdrop-grayscale backdrop-grayscale-0") == "backdrop-grayscale-0"
    end

    test "enhanced border radius utilities work with v4 features" do  
      # Test that border radius empty string conflicts work (key v4 change)
      assert TwMerge.merge("rounded rounded-lg") == "rounded-lg"
      assert TwMerge.merge("rounded-none rounded-full") == "rounded-full"
    end

    test "sr utilities work correctly (already present)" do
      assert TwMerge.merge("sr-only not-sr-only") == "not-sr-only"
      assert TwMerge.merge("not-sr-only sr-only") == "sr-only"
    end
  end

  describe "Phase 3.2: Integration with existing utilities" do
    test "new utilities don't break existing functionality" do
      # Test that adding new utilities doesn't break basic TwMerge functionality
      assert TwMerge.merge("bg-red-500 bg-blue-600") == "bg-blue-600"
      assert TwMerge.merge("text-sm text-lg") == "text-lg" 
      assert TwMerge.merge("p-4 p-8") == "p-8"
      assert TwMerge.merge("w-full w-1/2") == "w-1/2"
    end

    test "new v4 validators work with existing ones" do
      # Test that the new v4 validators integrate properly
      assert TwMerge.merge("bg-[#ff0000] bg-red-500") == "bg-red-500"
      # Note: v4 arbitrary variables will be tested separately once fully implemented
    end
  end
end