defmodule KinoSheetex.GeneratedSource do
  @moduledoc false
  alias Kino.SmartCell

  def new(form) do
    fetch_rows_expression(form)
    |> maybe_transform_to_kv(form)
    |> maybe_assign_to_variable(form)
    |> SmartCell.quoted_to_string()
  end

  defp fetch_rows_expression(form) do
    spreadsheet_id = Map.get(form, "spreadsheet_id")
    sheetex_options = build_sheetex_options(form)

    quote do
      Sheetex.fetch_rows!(unquote(spreadsheet_id), unquote(sheetex_options))
    end
  end

  defp maybe_transform_to_kv(ast, form) do
    output_format = Map.get(form, "output_format")

    cond do
      output_format == "kv" or output_format == "kv_atoms" ->
        to_kv_options = if output_format == "kv", do: [], else: [atom_keys: true]

        quote do
          unquote(ast) |> Sheetex.to_kv(unquote(to_kv_options))
        end

      output_format == "rows" ->
        ast
    end
  end

  defp maybe_assign_to_variable(ast, form) do
    with variable_name <- Map.get(form, "result_variable") do
      if is_binary(variable_name) and SmartCell.valid_variable_name?(variable_name) do
        variable = variable_name |> String.to_atom() |> Macro.var(nil)

        quote do
          unquote(variable) = unquote(ast)
        end
      else
        ast
      end
    end
  end

  # Options for `Sheetex.fetch_rows/2`.
  defp build_sheetex_options(form) do
    Enum.reduce(Map.to_list(form), [], fn {key, value}, acc ->
      case key do
        "range" ->
          Keyword.put(acc, :range, value)

        "key_env" ->
          value = quote do: System.fetch_env!("LB_" <> unquote(value))
          Keyword.put(acc, :key, value)

        "oauth_token_env" ->
          value = quote do: System.fetch_env!("LB_" <> unquote(value))
          Keyword.put(acc, :oauth_token, value)

        _ ->
          acc
      end
    end)
  end
end
