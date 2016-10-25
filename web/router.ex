defmodule Caster.Router do
  use Caster.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Caster do
    pipe_through :browser # Use the default browser stack

    get "/", CastController, :index
    resources "/casts", CastController, only: [:index, :show]
    resources "/custom_casts", CustomCastController, only: [:new, :create]
  end

  # Other scopes may use custom stacks.
  # scope "/api", Caster do
  #   pipe_through :api
  # end
end
