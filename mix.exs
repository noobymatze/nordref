defmodule Nordref.MixProject do
  use Mix.Project

  def project do
    [
      app: :nordref,
      version: "0.1.0",
      elixir: "~> 1.9",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),

      # Docs
      docs: [
        main: "Nordref",
        extras: ["README.md"],
        groups_for_modules: groups_for_modules(),
        source_url: "https://github.com/noobymatze/nordref",
        homepage_url: "https://noobymatze.github.io/nordref"
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Nordref.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.5.0"},
      {:phoenix_pubsub, "~> 2.0"},
      {:phoenix_ecto, "~> 4.1"},
      {:ecto_sql, "~> 3.4"},
      {:postgrex, "~> 0.15.3"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_view, "~> 0.12.1"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_dashboard, "~> 0.2.0"},
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.1"},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
      {:bcrypt_elixir, "~> 2.0"},
      {:csv, "~> 2.3"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"],
      docs: "docs -o docs/"
    ]
  end

  defp groups_for_modules do
    [
      Clubs: [
        Nordref.Clubs,
        Nordref.Clubs.Club,
        NordrefWeb.ClubController,
        NordrefWeb.ClubView
      ],
      Courses: [
        Nordref.Courses,
        Nordref.Courses.Course,
        NordrefWeb.CourseController,
        NordrefWeb.CourseView
      ],
      Seasons: [
        Nordref.Seasons,
        Nordref.Seasons.Season,
        NordrefWeb.SeasonController,
        NordrefWeb.SeasonView
      ],
      Users: [
        Nordref.Users,
        Nordref.Users.User,
        NordrefWeb.UserController,
        NordrefWeb.UserView
      ],
      Registration: [
        Nordref.Registrations,
        Nordref.Registrations.Registration,
        Nordref.Registrations.RegistrationView
      ],
      Licenses: [
        Nordref.Licenses,
        Nordref.Licenses.License,
        NordrefWeb.LicenseController,
        NordrefWeb.LicenseView
      ]
    ]
  end
end
