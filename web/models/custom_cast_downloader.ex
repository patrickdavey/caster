defmodule Caster.DownloaderBehaviour do
  @moduledoc """
    Used to define common behaviours for dowloaders
  """
  @doc "fetches data from an external source"
  @callback get_title(%{}) :: {:ok, term}
  @callback get_filepath(%{}) :: {:ok, term}
  @callback download!(%{}) :: {:ok}
end

defmodule Caster.CustomCastDownloader do
  defmodule ProdClient do
    @moduledoc """
    This is the model for fetching records from youtubedl

    """
    alias Caster.CustomCast
    alias Caster.Cast
    alias Caster.Repo

    @behaviour Caster.DownloaderBehaviour
    @download_subdirectory "custom"

    def get_title(%CustomCast{url: url}) do
      {title, 0} = System.cmd("youtube-dl", ["-e", url])
      {:ok, String.trim_trailing(title)}
    end

    def get_info(%{url: url}) do
      {info, 0} = System.cmd("youtube-dl", ["-J", "--flat-playlist", url])
      Poison.Parser.parse! info
    end

    def get_filepath(%Cast{url: url}) do
      {filepath, 0} = System.cmd("youtube-dl", ["--restrict-filenames", "--get-filename", url])
      filepath = Path.expand("#{Application.get_env(:caster, :root_downloads_directory)}/#{@download_subdirectory}/#{String.trim_trailing(filepath)}", Application.app_dir(:caster, "priv"))
      {:ok, filepath}
    end

    def download!(cast = %Cast{url: url}) do
      Task.Supervisor.async_nolink(Caster.TaskSupervisor, fn ->
        {:ok, filepath} = get_filepath(cast)
        Mix.Generator.create_directory(Path.dirname(filepath))
        System.cmd("youtube-dl", ["-o", filepath,  url])
        changeset = CustomCast.changeset(cast, %{file_location: filepath})
        Repo.update!(changeset)
        # the broadcasting _really_ shouldn't be here.
        Caster.Endpoint.broadcast("casts:cast#{cast.id}", "downloaded", %{msg: "downloaded"})
      end)
    end
  end

  defmodule TestClient do
    @moduledoc """
    This is the model for fetching records from youtubedl

    """
    alias Caster.Cast
    alias Caster.CustomCast
    alias Caster.Repo

    @behaviour Caster.DownloaderBehaviour
    @download_subdirectory "custom"

    def get_title(_) do
      {:ok, "my happy title"}
    end

    def get_filepath(_) do
      {:ok, "test/filepath"}
    end

    def download!(cast = %Cast{}) do
      {:ok, filepath} = get_filepath(cast)
      changeset = CustomCast.changeset(cast, %{file_location: filepath})
      Repo.update!(changeset)
      {:ok}
    end
  end
end
