defmodule Appduct.Writer.Reaction do
  use GenServer

  def start_link(init \\ 0) do
    GenServer.start_link(__MODULE__, init, name: __MODULE__)
  end

  def init(state) do
    {:ok, state}
  end

  def reaction(params, tkey) do
    GenServer.cast(__MODULE__, {:reaction, params, tkey})
  end

  def handle_cast({:reaction, params, tkey}, _state) do
    Appduct.Db.Reaction.write(params, tkey)
    {:noreply, 0}
  end
end
