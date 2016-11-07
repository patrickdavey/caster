defmodule Caster.Cast do
  @moduledoc """
  This is the base cast model. It should never actually be
  created, but we do allow updates through it.
  """
  use Caster.Web, :model

  @allowed_params [:viewed, :interesting, :note]
  @required_params [:title, :source]

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

  def changeset(struct, params \\ %{}) do
    changes = Dict.merge(%{}, params)
    struct
    |> cast(changes, @allowed_params)
    |> validate_required(@required_params)
  end

end
