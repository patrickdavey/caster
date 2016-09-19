defmodule Caster.Repo.Migrations.AddPublishedAtToCasts do
  use Ecto.Migration

  def change do
    alter table(:casts) do
      add :published_at, :datetime
    end

  end
end
