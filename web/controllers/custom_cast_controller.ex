defmodule Caster.CustomCastController do
  use Caster.Web, :controller

  alias Caster.CustomCast
  alias Caster.CustomCastDownloader

  def index(conn, _params) do
    custom_casts = Repo.all(CustomCast)
    render(conn, "index.html", custom_casts: custom_casts)
  end

  def new(conn, _params) do
    changeset = CustomCast.changeset(%CustomCast{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"custom_cast" => %{ "url" => url }}) do
    { :ok, title } = CustomCastDownloader.get_title(%CustomCast{url: url})
    changeset = CustomCast.changeset(%CustomCast{}, %{ title: title, url: url })

    case Repo.insert(changeset) do
      {:ok, _custom_cast} ->
        conn
        |> put_flash(:info, "Custom cast created successfully.")
        |> redirect(to: custom_cast_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    custom_cast = Repo.get!(CustomCast, id)
    render(conn, "show.html", custom_cast: custom_cast)
  end

  def edit(conn, %{"id" => id}) do
    custom_cast = Repo.get!(CustomCast, id)
    changeset = CustomCast.changeset(custom_cast)
    render(conn, "edit.html", custom_cast: custom_cast, changeset: changeset)
  end

  def update(conn, %{"id" => id, "custom_cast" => custom_cast_params}) do
    custom_cast = Repo.get!(CustomCast, id)
    changeset = CustomCast.changeset(custom_cast, custom_cast_params)

    case Repo.update(changeset) do
      {:ok, custom_cast} ->
        conn
        |> put_flash(:info, "Custom cast updated successfully.")
        |> redirect(to: custom_cast_path(conn, :show, custom_cast))
      {:error, changeset} ->
        render(conn, "edit.html", custom_cast: custom_cast, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    custom_cast = Repo.get!(CustomCast, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(custom_cast)

    conn
    |> put_flash(:info, "Custom cast deleted successfully.")
    |> redirect(to: custom_cast_path(conn, :index))
  end
end
