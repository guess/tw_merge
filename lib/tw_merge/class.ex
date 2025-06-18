defmodule TwMerge.Class do
  @moduledoc false

  defstruct [:raw, :tailwind?, :group, :conflict_id, :modifiers, :modifier_id, :important?, :base]

  def parse(raw) do
    with {:ok, parsed, "", _, _, _} <- TwMerge.Parser.class(raw),
         base when is_binary(base) <- Keyword.get(parsed, :base),
         group when is_binary(group) <- group(base),
         modifier_id when is_binary(modifier_id) <- modifier_id(parsed) do
      %__MODULE__{
        raw: raw,
        tailwind?: true,
        group: group,
        conflict_id: "#{modifier_id}:#{group}",
        modifiers: Keyword.get_values(parsed, :modifier),
        modifier_id: modifier_id,
        base: base,
        important?: Keyword.has_key?(parsed, :important)
      }
    else
      _ ->
        %__MODULE__{
          raw: raw,
          tailwind?: false
        }
    end
  end

  defp group(class) do
    # Handle classes with arbitrary variables specially
    if String.contains?(class, "(") and String.contains?(class, ")") do
      group_with_arbitrary_variables(class)
    else
      # Standard v3 processing
      parts =
        case String.split(class, "-") do
          ["" | parts] -> parts
          parts -> parts
        end

      group_recursive(parts, TwMerge.ClassTree.get()) || get_group_id_for_arbitrary_property(class)
    end
  end

  defp group_with_arbitrary_variables(class) do
    # Extract the utility prefix before the first arbitrary variable
    case Regex.run(~r/^([^(]+)\(/, class) do
      [_, prefix] ->
        # Remove trailing hyphen if present and split into parts
        prefix = String.trim_trailing(prefix, "-")
        parts =
          case String.split(prefix, "-") do
            ["" | parts] -> parts
            parts -> parts
          end

        group_recursive(parts, TwMerge.ClassTree.get())

      nil ->
        # No arbitrary variable found, fallback to standard processing
        parts =
          case String.split(class, "-") do
            ["" | parts] -> parts
            parts -> parts
          end

        group_recursive(parts, TwMerge.ClassTree.get()) || get_group_id_for_arbitrary_property(class)
    end
  end

  defp group_recursive([], %{"group" => group}), do: group
  defp group_recursive([], %{"next" => %{"" => %{"group" => group}}}), do: group

  defp group_recursive([part | rest] = path, map) do
    if next = Map.get(map["next"], part) do
      group_recursive(rest, next)
    else
      if Enum.any?(map["validators"]) do
        path = Enum.join(path, "-")

        case Enum.find(sort_validators(map["validators"]), fn {_key, %{"function" => validator}} ->
               validator.(path)
             end) do
          nil -> nil
          {_key, %{"group" => group}} -> group
        end
      end
    end
  end

  defp group_recursive(_, _), do: nil

  defp sort_validators(map) do
    map
    |> Enum.to_list()
    |> Enum.reject(fn {key, _value} -> key == "any?" end)
    |> Enum.sort()
    |> append_any?(map)
  end

  defp append_any?(list, map) do
    case map["any?"] do
      nil -> list
      any? -> list ++ [{"any?", any?}]
    end
  end

  defp get_group_id_for_arbitrary_property(class_name) do
    # Check for v3 arbitrary property syntax [property:value]
    arbitrary_property_regex = ~r/^\[(.+)\]$/
    # Check for v4 arbitrary variable syntax (label:--variable)
    arbitrary_variable_regex = ~r/^\((.+)\)$/

    cond do
      Regex.match?(arbitrary_property_regex, class_name) ->
        [_, arbitrary_property_class_name] = Regex.run(arbitrary_property_regex, class_name)

        property =
          arbitrary_property_class_name
          |> String.split(":", parts: 2)
          |> List.first()

        if property do
          ".." <> property
        end

      Regex.match?(arbitrary_variable_regex, class_name) ->
        [_, arbitrary_variable_class_name] = Regex.run(arbitrary_variable_regex, class_name)

        property =
          arbitrary_variable_class_name
          |> String.split(":", parts: 2)
          |> List.first()

        if property do
          ".." <> property
        end

      true ->
        nil
    end
  end

  defp modifier_id(parsed_class) do
    modifiers =
      parsed_class |> Keyword.get_values(:modifier) |> sort_modifiers() |> Enum.join(":")

    if Keyword.has_key?(parsed_class, :important), do: modifiers <> "!", else: modifiers
  end

  @doc """
  Sort modifiers according to the following rules:

  - All known modifiers are sorted alphabetically.
  - Arbitrary modifiers retain their position.
  """
  def sort_modifiers(modifiers) do
    modifiers
    |> Enum.reduce({[], []}, fn modifier, {sorted, unsorted} ->
      if String.starts_with?(modifier, "[") or String.starts_with?(modifier, "(") do
        {sorted ++ Enum.sort(unsorted) ++ [modifier], []}
      else
        {sorted, unsorted ++ [modifier]}
      end
    end)
    |> then(fn {sorted, unsorted} -> sorted ++ Enum.sort(unsorted) end)
  end
end
