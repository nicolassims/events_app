defmodule EventsApp.Events do
  @moduledoc """
  The Events context.
  """

  import Ecto.Query, warn: false
  alias EventsApp.Repo

  alias EventsApp.Events.Event

  @doc """
  Returns the list of events.

  ## Examples

      iex> list_events()
      [%Event{}, ...]

  """
  def list_events do
    Repo.all(Event)
    |> Repo.preload(:user)
  end

  @doc """
  Gets a single event.

  Raises `Ecto.NoResultsError` if the Event does not exist.

  ## Examples

      iex> get_event!(123)
      %Event{}

      iex> get_event!(456)
      ** (Ecto.NoResultsError)

  """
  def get_event!(id) do
    Repo.get!(Event, id)
    |> Repo.preload(:user)
    |> Repo.preload(:comments)
  end

  @doc """
  Creates a event.

  ## Examples

      iex> create_event(%{field: value})
      {:ok, %Event{}}

      iex> create_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_event(attrs \\ %{}) do
    %Event{}
    |> Event.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a event.

  ## Examples

      iex> update_event(event, %{field: new_value})
      {:ok, %Event{}}

      iex> update_event(event, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_event(%Event{} = event, attrs) do
    event
    |> Event.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a event.

  ## Examples

      iex> delete_event(event)
      {:ok, %Event{}}

      iex> delete_event(event)
      {:error, %Ecto.Changeset{}}

  """
  def delete_event(%Event{} = event) do
    Repo.delete(event)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking event changes.

  ## Examples

      iex> change_event(event)
      %Ecto.Changeset{data: %Event{}}

  """
  def change_event(%Event{} = event, attrs \\ %{}) do
    Event.changeset(event, attrs)
  end

  def load_comments(%Event{} = event) do
    Repo.preload(event, [comments: :user])
  end

  def count_maxresponses(guests) do
    emails = Regex.scan(~r/[A-z0-9._%+-]+@[A-z0-9.-]+\.[A-z]{2,}[,]/, guests <> ",")
    length(emails)
  end

  def count_responses(comments, responsetype) do
    lastresponsemap = Enum.reduce(comments, %{}, fn x, acc ->
      Map.put(acc, x.user_id, x.response)
    end)

    value = Enum.reduce(lastresponsemap, 0, fn {k, v}, acc ->
      cond do
        v == responsetype
          -> acc = acc + 1
        true
          -> acc
      end
    end)

    if value == 1 do
      "1 is"
    else
      "#{value} are"
    end
  end
end
