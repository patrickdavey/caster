defmodule Caster.Mix.Tasks.Caster.ExportNotesTest do
  use Caster.ModelCase

  test "can export notes to a file" do
    Caster.Repo.insert!(%Caster.Cast{title: "test", source: "custom", url: "a", note: "my happy note", updated_at: Ecto.DateTime.cast!("2013-04-17T14:00:00Z")})
    Caster.Repo.insert!(%Caster.Cast{title: "no url", source: "custom", url: nil, note: "no url note", updated_at: Ecto.DateTime.cast!("2015-04-17T14:00:00Z")})
    {:ok, _fd, file_path} = Temp.open "my-file"
    Mix.Tasks.Caster.ExportNotes.run("", file_path)
    contents = File.read!(file_path)
    File.rm file_path
    assert contents == "### no url\nno url note\n\n### [test](a)\nmy happy note"
  end
end
