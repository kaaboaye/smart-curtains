defmodule Controller.UniqueId do
  @type t :: binary

  @len 16

  def generate_id do
    :crypto.strong_rand_bytes(@len)
  end

  def to_binary(id) when byte_size(id) == 22 do
    with {:ok, id} <- Base.url_decode64(id, padding: false) do
      {:ok, id}
    else
      _ -> :error
    end
  end

  def to_binary(_), do: :error

  def to_binary!(id) when byte_size(id) == 22 do
    {:ok, id} = Base.url_decode64(id, padding: false)
    id
  end

  def to_string(id) when byte_size(id) == @len do
    Base.url_encode64(id, padding: false)
  end
end
