defmodule Caster.RailsCast do
  @moduledoc """
  This is the model for the railscasts site

  It uses the same underlying table (the "casts" one).

  """
  use Caster.Web, :model

  @allowed_params [:title, :url, :file_location, :episode, :published_at,
                   :viewed, :interesting, :source, :note]
  @required_params [:title, :url, :episode, :published_at]
  @source :railscast

  defp source do
    Atom.to_string(@source)
  end

  schema "casts" do
    field :title, :string
    field :url, :string
    field :file_location, :string
    field :episode, :integer
    field :viewed, :boolean, default: false
    field :interesting, :boolean, default: false
    field :source, :string, default: Atom.to_string(@source)
    field :note, :string
    field :published_at, Timex.Ecto.DateTime

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
      order_by: [desc: v.episode]
  end

end
