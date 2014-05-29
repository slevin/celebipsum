defmodule Celebipsum.Server do

  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, HashDict.new, name: __MODULE__)
  end

  def generate(words) do
    GenServer.call __MODULE__, {:generate, words}
  end

  ## GenServer stuff
  def init(_) do
    :random.seed(:erlang.now)
    {:ok, Celebipsum.Reader.readcorpus}
  end

  def handle_call({:generate, words}, _from, corpus) do
    string = Celebipsum.Generator.generate(corpus, words)
    {:reply, string, corpus}
  end
end