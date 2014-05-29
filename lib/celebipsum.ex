defmodule Celebipsum do
  use Application.Behaviour

  def start(_type, _args) do
    Celebipsum.Supervisor.start_link
  end


## generation


end
