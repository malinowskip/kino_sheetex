defmodule KinoSheetex do
  @moduledoc false

  alias Kino.SmartCell

  use Kino.JS, assets_path: "lib/assets"
  use Kino.JS.Live
  use Kino.SmartCell, name: "Fetch rows from a Google Sheet"

  @impl true
  def init(%{html_inputs: cached_html_inputs}, ctx) do
    {:ok, assign(ctx, html_inputs: cached_html_inputs)}
  end

  @impl true
  def init(_attrs, ctx) do
    {:ok, assign(ctx, html_inputs: %{})}
  end

  @impl true
  def handle_connect(ctx) do
    {:ok, ctx.assigns, ctx}
  end

  @impl true
  def to_attrs(ctx) do
    ctx.assigns
  end

  @impl true
  def to_source(attrs) do
    spreadsheet_id = attrs.html_inputs[:spreadsheet_id]
    sheetex_options = build_sheetex_options(attrs.html_inputs)

    result_variable = attrs.html_inputs[:result_variable]

    result_variable =
      if is_binary(result_variable) and SmartCell.valid_variable_name?(result_variable) do
        result_variable |> String.to_atom() |> Macro.var(nil)
      end

    expression_macro =
      quote do
        Sheetex.fetch_rows!(unquote(spreadsheet_id), unquote(sheetex_options))
      end

    if is_nil(result_variable) do
      expression_macro
    else
      quote do
        unquote(result_variable) = unquote(expression_macro)
      end
    end
    |> SmartCell.quoted_to_string()
  end

  @impl true
  def handle_event("input-updated", %{"input_id" => input_id, "value" => value}, ctx) do
    key = String.to_atom(input_id)

    ctx =
      if String.length(value) > 0 do
        assign(ctx, html_inputs: Map.put(ctx.assigns.html_inputs, key, value))
      else
        assign(ctx, html_inputs: Map.delete(ctx.assigns.html_inputs, key))
      end

    {:noreply, ctx}
  end

  # Options for `Sheetex.fetch_rows/2`.
  defp build_sheetex_options(html_inputs) do
    Enum.reduce(html_inputs, [], fn {key, value}, acc ->
      case key do
        :range ->
          Keyword.put(acc, :range, value)

        :key_env ->
          value = quote do: System.fetch_env!("LB_" <> unquote(value))
          Keyword.put(acc, :key, value)

        :oauth_token_env ->
          value = quote do: System.fetch_env!("LB_" <> unquote(value))
          Keyword.put(acc, :oauth_token, value)

        _ ->
          acc
      end
    end)
  end
end
