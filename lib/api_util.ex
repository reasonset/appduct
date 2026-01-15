defmodule Appduct.ApiUtil do
  import Plug.Conn

  def unexpected(conn) do
    conn
    |> send_resp(500, JSON.encode!(%{"error" => "UNEXPECTED"}))
    |> halt
  end

  def invalid(conn) do
    conn
    |> send_resp(400, JSON.encode!(%{"error" => "INVALID_PARAMS"}))
    |> halt
  end
end
