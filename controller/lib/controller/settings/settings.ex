defmodule Controller.Settings do
  @moduledoc """
  The Settings context.
  """

  import Ecto.Query, warn: false
  alias Controller.Repo

  alias Controller.Settings.{Setting, SettingsEntry}

  def get_settings do
    list_settings()
    |> Map.new(fn e ->
      {String.to_atom(e.key), setting_to_entry(e)}
    end)
  end

  def set(key, value) do
    key = Atom.to_string(key)

    attrs = %{
      value: %{
        v: value
      }
    }

    res =
      case get_setting(key) do
        nil -> %Setting{key: key}
        s -> s
      end
      |> Setting.changeset(attrs)
      |> Repo.insert_or_update()

    with {:ok, _} <- res do
      :ok
    else
      x -> x
    end
  end

  def get(key) when is_atom(key) do
    get(Atom.to_string(key))
  end

  def get(key) do
    with %{} = setting <- get_setting(key) do
      setting_to_entry(setting)
    end
  end

  def del(key) do
    key = Atom.to_string(key)

    with %{} = setting <- get_setting(key) do
      delete_setting(setting)
    end
  end

  def setting_to_entry(setting) do
    %SettingsEntry{
      key: setting.key,
      value: Map.get(setting.value, "v"),
      inserted_at: setting.inserted_at,
      updated_at: setting.updated_at
    }
  end

  @doc """
  Returns the list of settings.

  ## Examples

      iex> list_settings()
      [%Setting{}, ...]

  """
  def list_settings do
    Repo.all(Setting)
  end

  @doc """
  Gets a single setting.

  ## Examples

      iex> get_setting(123)
      %Setting{}

      iex> get_setting(456)
      nil

  """
  def get_setting(id), do: Repo.get(Setting, id)

  @doc """
  Gets a single setting.

  Raises `Ecto.NoResultsError` if the Setting does not exist.

  ## Examples

      iex> get_setting!(123)
      %Setting{}

      iex> get_setting!(456)
      ** (Ecto.NoResultsError)

  """
  def get_setting!(id), do: Repo.get!(Setting, id)

  @doc """
  Creates a setting.

  ## Examples

      iex> create_setting(%{field: value})
      {:ok, %Setting{}}

      iex> create_setting(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_setting(attrs \\ %{}) do
    %Setting{}
    |> Setting.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a setting.

  ## Examples

      iex> update_setting(setting, %{field: new_value})
      {:ok, %Setting{}}

      iex> update_setting(setting, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_setting(%Setting{} = setting, attrs) do
    setting
    |> Setting.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Setting.

  ## Examples

      iex> delete_setting(setting)
      {:ok, %Setting{}}

      iex> delete_setting(setting)
      {:error, %Ecto.Changeset{}}

  """
  def delete_setting(%Setting{} = setting) do
    Repo.delete(setting)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking setting changes.

  ## Examples

      iex> change_setting(setting)
      %Ecto.Changeset{source: %Setting{}}

  """
  def change_setting(%Setting{} = setting) do
    Setting.changeset(setting, %{})
  end
end
