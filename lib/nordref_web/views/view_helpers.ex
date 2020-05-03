defmodule NordrefWeb.View.Helpers do
  import Nordref.Permissions
  import Phoenix.HTML.Link

  @doc """
  Generate a link to the given URL, which is only visible if the
  given action is allowed for the user.

  ## Examples

      iex> guarded_link("New season", @current_user, :create_season, to: Routes.season_path(@conn, :index))
      nil
  """
  def guarded_link(text, current_user, action, opts) do
    if current_user != nil and can_access?(current_user, action) do
      link(text, opts)
    else
      nil
    end
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
end
