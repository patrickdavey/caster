defmodule Caster.Repo.Migrations.CreateCast do
  use Ecto.Migration

  def change do
    create table(:casts) do
      add :title, :string, null: false
      add :url, :string
      add :file_location, :string
      add :episode, :integer
      add :viewed, :boolean, default: false, null: false
      add :interesting, :boolean, default: false, null: false
      add :source, :string, null: false
      add :note, :text

      timestamps()
    end

  end
end
