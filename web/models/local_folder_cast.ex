defmodule Caster.LocalFolderCast do
  alias Caster.LocalFolder
  alias Caster.Cast
  alias Caster.LocalFolderCast
  alias Caster.Repo

  use Caster.Web, :model

  @required_params [:title, :file_location, :source, :episode]
  @allowed_params [:title, :file_location, :source, :episode]
  schema "casts" do
    field :title, :string
    field :file_location, :string
    field :episode, :integer
    field :source, :string

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    changes = Dict.merge(%{}, params)
    struct
    |> cast(changes, @allowed_params)
    |> validate_required(@required_params)
  end

  def import! do
     folders = Application.get_env(:caster, Caster.Sources)[:local_folders]
               |> Enum.map(fn(folder) -> %LocalFolder{source: folder.source, directory: folder.directory, title: folder.title, wildcard_match: folder.wildcard_match} end)
               |> Enum.each(&scan/1)
  end

  defp scan(%LocalFolder{source: source, directory: directory, wildcard_match: wildcard_match}) do
    Path.join(directory, wildcard_match)
    |> Path.wildcard
    |> Enum.sort
    |> Enum.with_index
    |> Enum.each(&insert_record_unless_existing(&1, source))
  end

  defp insert_record_unless_existing({file_location, index}, source) do
    case Repo.get_by(Cast, file_location: file_location) do
      %{id: _id} -> nil
      nil -> insert(file_location, index, source)
    end
  end

  defp insert(file_location, index, source) do
    title = Path.basename(file_location, Path.extname(file_location))
    %LocalFolderCast{}
      |> LocalFolderCast.changeset(source: Atom.to_string(source), file_location: file_location, title: title, episode: index)
      |> Repo.insert!()
  end

end
