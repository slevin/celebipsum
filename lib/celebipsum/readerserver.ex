defmodule Celebipsum.ReaderServer do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, [])
  end

  def get_corpus(pid) do
    GenServer.call pid, :get_corpus
  end

  def init(_) do
    {:ok, Celebipsum.Reader.readcorpus}
  end

  def handle_call(:get_corpus, _from, corpus) do
    {:reply, corpus, corpus}
  end

end