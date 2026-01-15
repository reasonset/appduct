defmodule Appduct.Db.Reaction do
  
  def write(params, tkey) do
    with true <- check_barrage(tkey) do
      create(params)
      count(params)
      :ok
    else
      _ -> {:error, :barrage}
    end
  end
  
  def get_count(user_id, media_id) do
    db = Appduct.Db.Countdb.get_db()
    key = Enum.join([user_id, media_id], "/")
    
    case CubDB.get(db, key) do
      nil -> 0
      v -> v
    end
  end

  defp check_barrage(tkey) do
    db = Appduct.Db.Cubdb.get_db()
    now = System.os_time(:second)

    current =
      case CubDB.get(db, tkey) do
        nil -> 0
        v -> v
      end
    CubDB.put(db, tkey, now)

    IO.puts bwin()
    now - current > bwin()
  end

  defp create(params) do
    dir = Path.join([dbdir(), "reaction", params["user_id"], params["media_id"]])
    fileprefix = if params["negative"], do: "-", else: ""

    filename =
      fileprefix <> Enum.join([System.os_time(:millisecond), :rand.uniform(30000), "json"], ".")

    if !File.exists?(dir) do
      File.mkdir_p(dir)
    end

    File.write!(Path.join(dir, filename), JSON.encode!(params))
  end

  defp count(params) do
    case params["negative"] do
      true ->
        nil

      _ ->
        db = Appduct.Db.Countdb.get_db()
        key = Enum.join([params["user_id"], params["media_id"]], "/")

        current =
          case CubDB.get(db, key) do
            nil -> 0
            v -> v
          end

        CubDB.put(db, key, current + 1)
    end
  end
  
  defp dbdir do
    Application.get_env(:appduct, :db_dir)    
  end
  
  defp bwin do
    Application.get_env(:appduct, :barrage_window)
  end
end
