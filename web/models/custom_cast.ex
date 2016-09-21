defmodule Caster.CustomCast do
  @moduledoc """
  This is the model for the customcasts site

  It uses the same underlying table (the "casts" one).

  """
  use Caster.Web, :model
  use Caster.Cast.Mixin

  @allowed_params [:title, :url, :file_location,
                   :viewed, :interesting, :source, :note]
  @required_params [:title, :url]
  @source :customcast

  defp source do
    Atom.to_string(@source)
  end

  schema "casts" do
    field :title, :string
    field :url, :string
    field :file_location, :string
    field :viewed, :boolean, default: false
    field :interesting, :boolean, default: false
    field :source, :string, default: Atom.to_string(@source)
    field :note, :string

    timestamps()
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

  def sorted do
    from v in Caster.RailsCast,
      where: v.source == ^source,
      order_by: [desc: v.inserted_at]
  end

end
