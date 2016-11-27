defmodule Mix.Tasks.Caster.ExportVideos do
  @moduledoc """
  Mix task to copy "interesting" videos to a location

  Output Dir is specified in the get_env(:caster, :video_export_directory)
  """

  use Mix.Task
  import Mix.Ecto
  import Ecto.Query

  @shortdoc "Export interesting videos to directory"
  def run(_args, export_directory \\ Application.get_env(:caster, :video_export_directory)) do
    if(is_nil(export_directory), do: raise "no export directory given")

    Mix.Generator.create_directory(Path.expand(export_directory))

    repo = Caster.Repo
    ensure_repo(repo, [])
    ensure_started(repo, [])
    casts = repo.all(from v in Caster.Cast,
      where: v.interesting == true)

    casts
    |> Enum.each(&copy_file(&1, export_directory))

  end

  def copy_file(cast, export_directory) do
    filename = Path.basename(cast.file_location)
    destination = Path.expand("#{export_directory}/#{filename}")
    File.cp!(cast.file_location, destination)
  end
end
