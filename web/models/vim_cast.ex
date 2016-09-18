defmodule Caster.VimCast do
  @moduledoc """
  This is the model for the vimcasts site

  It uses the same underlying table (the "casts" one).

  """
  use Caster.Web, :model

  @allowed_params [:title, :url, :file_location, :episode,
                   :viewed, :interesting, :source, :note]
  @required_params [:title, :url]
  @source :vimcast

  schema "casts" do
    field :title, :string
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
    changes = Dict.merge(%{
                         source: to_string(@source),
                       }, params)
    struct
    |> cast(changes, @allowed_params)
    |> validate_required([:title, :url])
  end
end
