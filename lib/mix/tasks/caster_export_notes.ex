defmodule Mix.Tasks.Caster.ExportNotes do
  use Mix.Task

  @shortdoc "Export notes to file"
  def run(args) do
    [:postgrex, :ecto]
    |> Enum.each(&Application.ensure_all_started/1)

    Caster.Repo.start_link

    casts = Caster.Repo.all(Caster.Cast)

    Enum.each(casts, fn(s) -> IO.puts(s.title) end)
  end
end
