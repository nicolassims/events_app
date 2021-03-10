defmodule EventsAppWeb.Helpers do

  def same_user(connection, user_id) do
    user = connection.assigns[:current_user]
    user && user.id == user_id
  end

end
