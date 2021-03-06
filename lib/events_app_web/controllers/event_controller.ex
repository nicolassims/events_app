defmodule EventsAppWeb.EventController do
  use EventsAppWeb, :controller

  alias EventsApp.Events
  alias EventsApp.Events.Event

  alias EventsAppWeb.Plugs
  plug Plugs.RequireUser when action in [:new, :edit, :create, :update]

  def index(conn, _params) do
    events = Events.list_events()
    render(conn, "index.html", events: events)
  end

  def new(conn, _params) do
    changeset = Events.change_event(%Event{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"event" => event_params}) do
    user = conn.assigns[:current_user]
    if user == nil do
      render(conn, "new.html", changeset: Event.changeset(%Event{}, %{}))
    else
      event_params = event_params
      |> Map.put("user_id", conn.assigns[:current_user].id)
      case Events.create_event(event_params) do
        {:ok, event} ->
          conn
          |> put_flash(:info, "Event created successfully.")
          |> redirect(to: Routes.event_path(conn, :show, event))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "new.html", changeset: changeset)
      end
    end
  end

  def show(conn, %{"id" => id}) do
    event = Events.get_event!(id)
    |> Events.load_comments()
    comm = %EventsApp.Comments.Comment{
      event_id: event.id,
      user_id: current_user(conn),
      response: 0,
    }
    new_comment = EventsApp.Comments.change_comment(comm)
    render(conn, "show.html", event: event, new_comment: new_comment)
  end

  def edit(conn, %{"id" => id}) do
    event = Events.get_event!(id)
    changeset = Events.change_event(event)
    render(conn, "edit.html", event: event, changeset: changeset)
  end

  def update(conn, %{"id" => id, "event" => event_params}) do
    event = Events.get_event!(id)

    case Events.update_event(event, event_params) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Event updated successfully.")
        |> redirect(to: Routes.event_path(conn, :show, event))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", event: event, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    event = Events.get_event!(id)
    {:ok, _event} = Events.delete_event(event)

    conn
    |> put_flash(:info, "Event deleted successfully.")
    |> redirect(to: Routes.event_path(conn, :index))
  end
end
