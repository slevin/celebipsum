defmodule Celebipsum.Supervisor do
  use Supervisor

  def start_link do
    result = {:ok, sup } = Supervisor.start_link(__MODULE__, [], debug: [:trace])
    #{:ok, reader} = Supervisor.start_child(sup, worker(Celebipsum.ReaderServer, []))
#    {:ok, _generator} = Supervisor.start_child(sup, worker(Celebipsum.GeneratorServer, reader))
    #{:ok, _generator} = Supervisor.start_child(sup, worker(Celebipsum.GeneratorServer, []))
    #result
  end

  def init([]) do
    supervise [], strategy: :rest_for_one
  end

end
