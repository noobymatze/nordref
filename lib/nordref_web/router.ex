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
    plug NordrefWeb.Plugs.CurrentSeason
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
    get "/", PageController, :index
    get "/clubs/members", PageController, :club_members
    resources "/clubs", ClubController
    get "/users/instructors", UserController, :instructors
    resources "/users", UserController
    get "/administration", AdministrationController, :index
    get "/courses/release/:id", CourseController, :release
    get "/courses/registration", CourseController, :registration
    post "/courses/registration/g", CourseController, :register_g
    post "/courses/registration/:id", CourseController, :register
    resources "/courses", CourseController
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
