defmodule TwMerge.Parser do
  @moduledoc false
  import NimbleParsec

  @chars [?a..?z, ?A..?Z, ?0..?9, 45, ?_, ?., ?,, ?@, ?{, ?}, ?(, ?), ?>, ?*, ?&, ?', ?%, ?#]

  regular_chars = ascii_string(@chars, min: 1)

  modifier =
    [parsec(:arbitrary), regular_chars]
    |> choice()
    |> times(min: 1)
    |> ignore(string(":"))
    |> reduce({Enum, :join, [""]})
    |> unwrap_and_tag(:modifier)
    |> times(min: 1)

  important = "!" |> string() |> unwrap_and_tag(:important)

  base =
    [parsec(:arbitrary), parsec(:arbitrary_variable), regular_chars]
    |> choice()
    |> times(min: 1)
    |> reduce({Enum, :join, [""]})
    |> unwrap_and_tag(:base)

  postfix =
    "/"
    |> string()
    |> ignore()
    |> ascii_string([?a..?z, ?0..?9], min: 1)
    |> unwrap_and_tag(:postfix)

  defparsec(
    :arbitrary,
    "["
    |> string()
    |> concat(
      times(choice([parsec(:arbitrary), parsec(:arbitrary_variable), ascii_string(@chars ++ [?:, ?/], min: 1)]), min: 1)
    )
    |> concat(string("]"))
  )

  arbitrary_variable_content = ascii_string([?a..?z, ?A..?Z, ?0..?9, 45, ?_, ?., ?,, ?@, ?{, ?}, ?>, ?*, ?&, ?', ?%, ?#, ?:, ?/] -- [?(, ?)], min: 1)

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
  )
end
