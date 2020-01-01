defmodule Nordref.Permissions do
  alias Nordref.Users.User

  @doc """
  Check, whether the given `%User{}` is allowed to perform an action.

  ## Examples

      iex> can_access?(user, {:release_course, course})
      :ok

      iex> can_access?(user, {:release_course, course})
      :ok
  """
  def can_access?(%User{} = user, action) do
    case action do
      :view_seasons ->
        User.super_admin?(user) || User.admin?(user)

      :create_season ->
        User.super_admin?(user) || User.admin?(user)

      :show_season ->
        User.super_admin?(user) || User.admin?(user)

      true ->
        true
    end
  end
end
