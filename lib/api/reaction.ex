defmodule Appduct.Api.Reaction do
  import Plug.Conn
  import Appduct.ApiUtil

  def reaction(conn) do
    with %{
           "user_id" => user_id,
           "media_id" => media_id,
           "reaction" => reaction_type,
           "negative" => is_negative
         } <- conn.body_params,
         true <- valid_id?(user_id) and byte_size(user_id) >= 3,
         true <- valid_id?(media_id) and byte_size(media_id) >= 16,
         true <- reaction_type in ["like", "favorite", "love", "boo"],
         true <- is_boolean(is_negative) do
      # Maybe valid reaction
      reaction_params = %{
        "user_id" => user_id,
        "media_id" => media_id,
        "reaction" => reaction_type,
        "negative" => is_negative
      }

      write_reaction(reaction_params, conn.remote_ip)
      send_resp(conn, 204, "")
    else
      _ ->
        invalid(conn)
    end
  end

  def get_reactions(conn) do
    with %{
           "user_id" => user_id,
           "media_id" => media_id
         } <- conn.params,
         true <- valid_id?(user_id) and byte_size(user_id) >= 3,
         true <- valid_id?(media_id) and byte_size(media_id) >= 16 do
      count = Appduct.Db.Reaction.get_count(user_id, media_id)
      send_resp(conn, 200, JSON.encode!(%{"count" => count}))
    else
      _ ->
        invalid(conn)
    end
  end

  defp valid_id?(id) do
    is_binary(id) and
      byte_size(id) <= 64 and
      not String.contains?(id, "/") and
      not String.contains?(id, "\n") and
      id =~ ~r/^[A-Za-z0-9][A-Za-z0-9_-]+[A-Za-z0-9]$/
  end

  defp write_reaction(reaction_params, ipaddr) do
    Appduct.Writer.Reaction.reaction(reaction_params, target_key(reaction_params, ipaddr))
  end

  defp target_key(params, ipaddr) do
    {params["user_id"], params["media_id"], ipaddr}
  end
end
