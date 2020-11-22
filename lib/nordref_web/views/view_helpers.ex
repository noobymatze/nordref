defmodule NordrefWeb.View.Helpers do
  alias Nordref.Permissions
  alias Nordref.Users.User
  alias Nordref.Seasons
  import Phoenix.HTML.Link
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
end
