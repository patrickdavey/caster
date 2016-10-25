defmodule Caster.Cast do
  @moduledoc """
  This is the base cast model. It should not be instantiated, instead
  each Cast type will use the same schema but define their own
  changesets etc.

  This may indeed be a horrible way to to things, but it's my first
  Elixir project, Pull Requests and compelte reworks are welcome ;)
  """
  use Caster.Web, :model

  schema "casts" do
    field :title, :string
    field :url, :string
    field :file_location, :string
    field :episode, :integer
    field :viewed, :boolean, default: false
    field :interesting, :boolean, default: false
    field :source, :string
    field :note, :string
    field :published_at, Timex.Ecto.DateTime

    timestamps()
  end

  def downloaded?(cast) do
    cast.file_location != nil
  end
end
