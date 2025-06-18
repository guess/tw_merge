defmodule TwMerge.Parser do
  @moduledoc false
  import NimbleParsec

  @chars [?a..?z, ?A..?Z, ?0..?9, 45, ?_, ?., ?,, ?@, ?{, ?}, ?(, ?), ?>, ?*, ?&, ?', ?%, ?#]

  # For modifiers, we exclude parentheses to avoid conflicts with arbitrary variables
  modifier_chars = ascii_string(@chars -- [?(, ?)], min: 1)

  # Regular chars should not contain opening parentheses at the end to allow arbitrary variables
  regular_chars_strict = ascii_string(@chars -- [?(], min: 1)
  regular_chars = ascii_string(@chars, min: 1)

  modifier =
    [parsec(:arbitrary), modifier_chars]
    |> choice()
    |> times(min: 1)
    |> ignore(string(":"))
    |> reduce({Enum, :join, [""]})
    |> unwrap_and_tag(:modifier)
    |> times(min: 1)

  important = "!" |> string() |> unwrap_and_tag(:important)

  # Try to parse sequences that can include arbitrary values/variables mixed with regular chars
  base =
    choice([
      # First try: regular chars followed by arbitrary variable/value
      regular_chars_strict
      |> choice([
        parsec(:arbitrary) |> reduce({Enum, :join, [""]}),
        parsec(:arbitrary_variable) |> reduce({Enum, :join, [""]})
      ])
      |> reduce({Enum, :join, [""]}),
      # Second try: just arbitrary variable/value
      parsec(:arbitrary) |> reduce({Enum, :join, [""]}),
      parsec(:arbitrary_variable) |> reduce({Enum, :join, [""]}),
      # Last resort: regular chars only
      regular_chars
    ])
    |> unwrap_and_tag(:base)

  postfix =
    "/"
    |> string()
    |> ignore()
    |> choice([
      parsec(:arbitrary) |> reduce({Enum, :join, [""]}),
      ascii_string([?a..?z, ?0..?9, ?., ?%], min: 1)
    ])
    |> unwrap_and_tag(:postfix)

  defparsec(
    :arbitrary,
    "["
    |> string()
    |> concat(
      times(
        choice([
          parsec(:arbitrary),
          parsec(:arbitrary_variable),
          ascii_string(@chars ++ [?:, ?/, ?<, ?>, ?;, ?+], min: 1)
        ]),
        min: 1
      )
    )
    |> concat(string("]"))
  )

  # V4: Support for labeled arbitrary variables (e.g., color:--primary)
  arbitrary_variable_content =
    ascii_string(
      [?a..?z, ?A..?Z, ?0..?9, 45, ?_, ?., ?,, ?@, ?{, ?}, ?>, ?*, ?&, ?', ?%, ?#, ?:, ?/] --
        [?(, ?)],
      min: 1
    )

  defparsec(
    :arbitrary_variable,
    "("
    |> string()
    |> concat(arbitrary_variable_content)
    |> concat(string(")"))
  )

  defparsec(
    :class,
    modifier
    |> optional()
    |> concat(optional(important))
    |> concat(base)
    |> concat(optional(postfix))
    |> concat(optional(important))
  )
end
