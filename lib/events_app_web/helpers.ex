defmodule EventsAppWeb.Helpers do

  def any_user(connection) do
    user = connection.assigns[:current_user]
    user != nil
  end

  def current_user(connection) do
    user = connection.assigns[:current_user]
    user && user.id
  end

  def same_user(connection, user_id) do
    user = connection.assigns[:current_user]
    user && user.id == user_id
  end

end
