defmodule Mix.Tasks.Caster.ExportNotes do
  @moduledoc """
  Mix task to export any notes (assumed in markdown format)
  out to a file.

  File is specified in the get_env(:caster, :notes_export_file)
  """

  use Mix.Task
  import Mix.Ecto
  import Ecto.Query

  @shortdoc "Export notes to file"
  def run(_args, notes_file \\ Application.get_env(:caster, :notes_export_file)) do
    repo = Caster.Repo
    ensure_repo(repo, [])
    ensure_started(repo, [])
    casts = repo.all(from v in Caster.Cast,
      where: not(is_nil(v.note)) and v.note != "",
      order_by: [desc: v.updated_at])

    notes = casts
            |> Enum.map_join("\n\n", &format_note/1)

    File.write!(Path.expand(notes_file), to_charlist(notes), [:write, :utf8])
  end

  defp format_note(%{note: note, url: nil, title: title}) do
    "### #{title}\n#{note}\n"
  end

  defp format_note(%{note: note, url: url, title: title}) do
    "### [#{title}](#{url})\n#{note}\n"
  end
end
