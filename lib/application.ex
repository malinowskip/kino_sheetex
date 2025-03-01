defmodule KinoSheetex.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    Kino.SmartCell.register(KinoSheetex)

    children = []
    opts = [strategy: :one_for_one, name: KinoSheetex.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
