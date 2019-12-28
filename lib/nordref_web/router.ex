defmodule NordrefWeb.Router do
  use NordrefWeb, :router

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

  scope "/", NordrefWeb do
    pipe_through :browser

    get "/login", SessionController, :index
    post "/login", SessionController, :login
    resources "/licenses", LicenseController
  end

  scope "/", NordrefWeb do
    pipe_through [:browser, NordrefWeb.Plugs.Auth]

    get "/", UserController, :index
    resources "/clubs", ClubController
    resources "/users", UserController
    resources "/courses", CourseController
    get "/courses/release/:id", CourseController, :release
    resources "/seasons", SeasonController
  end

  # Other scopes may use custom stacks.
  # scope "/api", NordrefWeb do
  #   pipe_through :api
  # end
end
