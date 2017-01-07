defmodule Caster.Repo do
  use Ecto.Repo, otp_app: :caster

  def exists?(query, opts \\ []) do
    import Ecto.Query
    query = from q in query,
    select: true,
    limit: 1

    case one(query, opts) do
      nil -> false
      true -> true
    end
  end
end
