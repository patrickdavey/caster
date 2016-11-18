defmodule Caster.VimCast do
  @moduledoc """
  This is the model for the vimcasts site

  It uses the same underlying table (the "casts" one).

  """
  use Caster.Web, :model
  use Caster.Cast.Mixin

  @allowed_params [:title, :url, :file_location, :episode, :published_at,
                   :viewed, :interesting, :source, :note]
  @required_params [:title, :url, :published_at]
  @source :vimcast

  schema "casts" do
    field :title, :string
    field :url, :string
    field :file_location, :string
    field :episode, :integer
    field :viewed, :boolean, default: false
    field :interesting, :boolean, default: false
    field :source, :string, default: Atom.to_string(@source)
    field :note, :string
    field :published_at, Timex.Ecto.DateTime

    timestamps()
  end

  defp source do
    Atom.to_string(@source)
  end

  def sorted do
    from v in Caster.VimCast,
      where: v.source == ^source,
      order_by: [desc: v.published_at]
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    changes = Dict.merge(%{}, params)
    struct
    |> cast(changes, @allowed_params)
    |> validate_required(@required_params)
  end

  defmodule Downloader do
    require Logger
    alias Caster.Cast
    alias Caster.VimCast
    alias Caster.Repo

    @download_subdirectory "vimcasts"

    def download!(cast = %Cast{url: url}) do
      Task.Supervisor.async_nolink(Caster.TaskSupervisor, fn ->
        filepath = Path.expand("#{Application.get_env(:caster, :root_downloads_directory)}/#{@download_subdirectory}/#{Path.basename(url)}", Application.app_dir(:caster, "priv"))
        Mix.Generator.create_directory(Path.dirname(filepath))
        file = File.open! filepath, [:append]
        HTTPoison.get!(url, %{}, [stream_to: self])
        rloop({cast, file, filepath})
      end)
    end

    defp rloop({cast, file, filepath})  do
      receive do
        %HTTPoison.AsyncChunk{chunk: chunk} ->
          IO.binwrite(file, chunk)
          rloop({cast, file, filepath})
        %HTTPoison.AsyncEnd{} ->
          :ok = File.close file
          changeset = VimCast.changeset(cast, %{file_location: filepath})
          Repo.update!(changeset)
        after
          1_000 ->
            File.close file
            File.rm filepath
            Logger.info "exiting download loop, nothing after 1 second"
        end
    end
  end
end
