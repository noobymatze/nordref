defmodule NordrefWeb.Router do
  use NordrefWeb, :router
  import Phoenix.LiveDashboard.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :put_root_layout, {NordrefWeb.LayoutView, :root}
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
    if Mix.env() == :test do
      pipe_through :browser
    else
      pipe_through [:browser, NordrefWeb.Plugs.Auth]
    end

    live_dashboard "/dashboard"
    live "/courses/registration", CourseRegistrationLive.New
    get "/", UserController, :index
    resources "/clubs", ClubController
    get "/users/instructors", UserController, :instructors
    resources "/users", UserController 
    get "/administration", AdministrationController, :index
    resources "/courses", CourseController
    get "/courses/release/:id", CourseController, :release
    resources "/registrations", RegistrationController
    resources "/seasons", SeasonController
    resources "/associations", AssociationController
    get "/seasons/:year/registrations", SeasonController, :download_registrations
    get "/logout", SessionController, :logout
  end

  # Other scopes may use custom stacks.
  # scope "/api", NordrefWeb do
  #   pipe_through :api
  # end
end
