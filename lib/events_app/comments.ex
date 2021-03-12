defmodule EventsApp.Comments do
  @moduledoc """
  The Comments context.
  """

  import Ecto.Query, warn: false
  alias EventsApp.Repo

  alias EventsApp.Comments.Comment

  @doc """
  Returns the list of comments.

  ## Examples

      iex> list_comments()
      [%Comment{}, ...]

  """
  def list_comments do
    Repo.all(Comment)
    |> Repo.preload(:user)
    |> Repo.preload(:event)
  end

  @doc """
  Gets a single comment.

  Raises `Ecto.NoResultsError` if the Comment does not exist.

  ## Examples

      iex> get_comment!(123)
      %Comment{}

      iex> get_comment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_comment!(id) do
    comment = update_response(id)
  end

  def update_response(id) do
    comment = Repo.get!(Comment, id)
    event = EventsApp.Events.get_event!(comment.event_id)
    notlastcomm = Enum.reduce(event.comments, false, fn x, acc ->
      cond do
        x.user_id == comment.user_id && x.id > comment.id
          -> acc || true
        true
          -> acc || false
      end
    end)

    if notlastcomm do
      lastresponse = Enum.reduce(event.comments, 0, fn x, acc ->
        cond do
          x.user_id == comment.user_id && x.id > comment.id
            -> acc = x.response
          true
            -> acc
        end
      end)

      %{ comment | response: lastresponse }
    else
      comment
    end
  end

  @doc """
  Creates a comment.

  ## Examples

      iex> create_comment(%{field: value})
      {:ok, %Comment{}}

      iex> create_comment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_comment(attrs \\ %{}) do
    %Comment{}
    |> Comment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a comment.

  ## Examples

      iex> update_comment(comment, %{field: new_value})
      {:ok, %Comment{}}

      iex> update_comment(comment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_comment(%Comment{} = comment, attrs) do
    comment
    |> Comment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a comment.

  ## Examples

      iex> delete_comment(comment)
      {:ok, %Comment{}}

      iex> delete_comment(comment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_comment(%Comment{} = comment) do
    Repo.delete(comment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking comment changes.

  ## Examples

      iex> change_comment(comment)
      %Ecto.Changeset{data: %Comment{}}

  """
  def change_comment(%Comment{} = comment, attrs \\ %{}) do
    Comment.changeset(comment, attrs)
  end
end
