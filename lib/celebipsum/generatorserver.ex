defmodule Celebipsum.GeneratorServer do
  use GenServer

  def start_link(reader_server) do
    GenServer.start_link(__MODULE__, reader_server, name: __MODULE__, debug: [:trace])
  end

  def generate(words) do
    GenServer.call __MODULE__, {:generate, words}
  end

  def init(reader_server) do
    :random.seed(:erlang.now)
    {:ok, reader_server}
  end

  def handle_call({:generate, words}, _from, reader_server) do
    string = reader_server.get_corpus
    |> Celebipsum.Generator.generate(words)
    {:reply, string, reader_server}
  end

end