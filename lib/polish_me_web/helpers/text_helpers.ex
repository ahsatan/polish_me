defmodule PolishMeWeb.Helpers.TextHelpers do
  def name_to_slug(name) when name in [nil, ""], do: nil

  def name_to_slug(name) do
    name
    |> String.downcase()
    |> String.replace("'", "")
    |> String.replace("&", "-n-")
    |> String.replace(~r/[^[:alnum:]]+/, "-")
    |> String.trim("-")
  end

  def enums_to_string(_enum_list, delimiter \\ ", ")
  def enums_to_string(nil, _delimiter), do: nil

  def enums_to_string(enum_list, delimiter) do
    enum_list
    |> Enum.map(&atom_to_string/1)
    |> Enum.join(delimiter)
  end

  def enums_to_string_map(nil), do: nil

  def enums_to_string_map(enum_list) do
    enum_list |> Enum.map(&{atom_to_string(&1), &1})
  end

  def atom_to_string(nil), do: nil

  def atom_to_string(atom) do
    atom
    |> Atom.to_string()
    |> process_words()
  end

  defp process_words(str) do
    str
    |> String.split("_")
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(" ")
  end
end
