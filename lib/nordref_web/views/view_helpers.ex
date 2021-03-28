defmodule NordrefWeb.View.Helpers do
  alias Nordref.Permissions
  alias Nordref.Users.User
  alias Nordref.Seasons
  import Phoenix.HTML
  import Phoenix.HTML.Tag
  import Phoenix.HTML.Form
  import NordrefWeb.Gettext
  alias Calendar

  @doc """
  Returns true, if a user has the given permission, false otherwise.

  ## Examples

    iex> has_permission?(@current_user, {:release_course, course})
    true

  """
  def has_permission?(user, permission) do
    Permissions.has_permission?(user, permission)
  end

  def super_admin_or_admin?(user) do
    User.super_admin?(user) || User.admin?(user)
  end

  def club_admin?(user) do
    User.club_admin?(user)
  end

  def registration_open?(season) do
    Seasons.registration_open?(season)
  end

  @doc false
  def month_to_string(month) do
    case month do
      1 -> "Januar"
      2 -> "Februar"
      3 -> "März"
      4 -> "April"
      5 -> "Mai"
      6 -> "Juni"
      7 -> "Juli"
      8 -> "August"
      9 -> "September"
      10 -> "Oktober"
      11 -> "November"
      12 -> "Dezember"
    end
  end

  def format_date_time(datetime) do
    Calendar.strftime(datetime, "%d.%m.%Y")
  end

  def email_link(email, opts \\ []) do
    opts = Keyword.put_new(opts, :href, "mailto:#{email}")
    content_tag(:a, email, opts)
  end

  def phone_link(phone, opts \\ []) do
    opts = Keyword.put_new(opts, :href, "tel:#{phone}")
    content_tag(:a, phone, opts)
  end

  def localized_datetime_select(form, field, opts \\ []) do
    opts =
      opts
      |> Keyword.put(:month,
        options: [
          {gettext("January"), "1"},
          {gettext("February"), "2"},
          {gettext("March"), "3"},
          {gettext("April"), "4"},
          {gettext("May"), "5"},
          {gettext("June"), "6"},
          {gettext("July"), "7"},
          {gettext("August"), "8"},
          {gettext("September"), "9"},
          {gettext("October"), "10"},
          {gettext("November"), "11"},
          {gettext("December"), "12"}
        ]
      )
      |> Keyword.put_new(:builder, fn b ->
        ~e"""
        <%= b.(:day, []) %> <%= b.(:month, []) %> <%= b.(:year, []) %> - <%= b.(:hour, []) %> : <%= b.(:minute, []) %>
        """
      end)

    datetime_select(form, field, opts)
  end
end
