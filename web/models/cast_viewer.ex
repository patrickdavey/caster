defmodule Caster.CastViewerBehaviour do
  @moduledoc """
    Used to allow watching a video
  """
  @doc "fetches data from an external source"
  @callback view!(%{}) :: {:ok}
end

defmodule Caster.CastViewer do
  defmodule ProdClient do
    @moduledoc """
    This lauches a cast in vlc
    # assumes vlc is available on the path

    """
    alias Caster.Cast
    alias Caster.Repo

    @behaviour Caster.CastViewerBehaviour

    def view!(cast = %Cast{file_location: file_location}) do
      Task.Supervisor.async_nolink(Caster.TaskSupervisor, fn ->
        System.cmd("vlc", [file_location])
        changeset = Cast.changeset(cast, %{viewed: true})
        Repo.update!(changeset)
        {:ok}
      end)
    end
  end

  defmodule TestClient do
    @moduledoc """
    This is the model for test watching videos

    """
    alias Caster.Cast
    alias Caster.Repo

    @behaviour Caster.CastViewerBehaviour

    def view!(cast = %Cast{}) do
      Task.Supervisor.async_nolink(Caster.TaskSupervisor, fn ->
        changeset = Cast.changeset(cast, %{viewed: true})
        Repo.update!(changeset)
        {:ok}
      end)
    end
  end
end
