defmodule Appduct.Router do
  use Plug.Router

  plug(Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["application/json", "multipart/form-data", "application/x-www-form-urlencoded"],
    json_decoder: JSON
  )

  plug(:match)
  plug(:dispatch)

  plug(RemoteIp)

  get "/" do
    send_resp(conn, 200, "Hello, World")
  end

  post "/reaction/plusone" do
    Appduct.Api.Reaction.reaction(conn)
  end

  get "/reaction/reactions" do
    Appduct.Api.Reaction.get_reactions(conn)
    send_resp(conn, 200, "Hello, World")
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end
end
