defmodule KinoSheetex do
  @moduledoc false

  alias KinoSheetex.GeneratedSource

  use Kino.JS, assets_path: "lib/assets"
  use Kino.JS.Live
  use Kino.SmartCell, name: "Fetch rows from a Google Sheet"

  @impl true
  def init(%{form: cached_form}, ctx) do
    {:ok, assign(ctx, form: cached_form)}
  end

  @impl true
  def init(_attrs, ctx) do
    {:ok, assign(ctx, form: default_form())}
  end

  @impl true
  def handle_connect(ctx) do
    {:ok, ctx.assigns.form, ctx}
  end

  @impl true
  def to_attrs(ctx) do
    ctx.assigns
  end

  @impl true
  def to_source(attrs) do
    GeneratedSource.new(attrs.form)
  end

  @impl true
  def handle_event("form-updated", formdata, ctx) do
    {:noreply, assign(ctx, form: parse_formdata(formdata))}
  end

  defp parse_formdata(formdata) do
    Enum.reduce(formdata, %{}, fn {key, value}, form ->
      if String.length(value) > 0, do: Map.put(form, key, value), else: form
    end)
  end

  defp default_form do
    %{"output_format" => "rows"}
  end
end
