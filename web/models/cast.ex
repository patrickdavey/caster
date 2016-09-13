defmodule Caster.Cast do
  use Caster.Web, :model

  schema "casts" do
    field :name, :string
    field :url, :string
    field :file_location, :string
    field :episode, :integer
    field :viewed, :boolean, default: false
    field :interesting, :boolean, default: false
    field :source, :string
    field :note, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :url, :file_location, :episode, :viewed, :interesting, :source, :note])
    |> validate_required([:name, :url, :file_location, :episode, :viewed, :interesting, :source, :note])
  end
end
