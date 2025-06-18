defmodule TwMerge.V4TestHelper do
  @moduledoc """
  Helper functions for v4 compatibility testing.
  """

  @doc """
  Lists all v4 breaking changes that need to be tested.
  """
  def v4_breaking_changes do
    [
      # Removed utilities
      "bg-opacity-*",
      "text-opacity-*",
      "border-opacity-*",
      "divide-opacity-*",
      "ring-opacity-*",
      "placeholder-color",
      "placeholder-opacity",
      
      # Changed syntax
      "shadow empty string removal",
      "border-radius empty string removal",
      "position utility deprecations"
    ]
  end

  @doc """
  Lists all new v4 utilities that need to be implemented.
  """
  def v4_new_utilities do
    [
      "field-sizing",
      "inset-shadow",
      "text-shadow",
      "mask-*",
      "transform-style",
      "rotate-x", "rotate-y", "rotate-z",
      "scale-z", "scale-3d",
      "translate-z",
      "backdrop-*",
      "will-change"
    ]
  end

  @doc """
  Lists v4 syntax changes that need parser support.
  """
  def v4_syntax_changes do
    [
      "CSS variables with parentheses: bg-(--var)",
      "Slash opacity syntax: bg-red-500/50",
      "New arbitrary value patterns"
    ]
  end

  @doc """
  Runs a test that should pass in v3 but change behavior in v4.
  """
  def assert_v3_behavior(input, expected_v3_output) do
    result = TwMerge.merge(input)
    assert result == expected_v3_output, 
      "v3 behavior test failed for: #{input}"
  end

  @doc """
  Runs a test that should eventually pass in v4 (currently will fail).
  """
  def assert_future_v4_behavior(input, expected_v4_output) do
    # For now, just document what the expected v4 behavior should be
    # This will be updated as v4 support is implemented
    IO.puts("v4 expected behavior for '#{input}' should be: '#{expected_v4_output}'")
  end
end