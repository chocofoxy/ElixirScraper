defmodule Main do
  use Application
  require Logger

  def start(_type, _args) do
    IO.puts "started"
    start = System.monotonic_time(:millisecond)
    { _ , pid } = Scraper.scrapePage(self())
    IO.inspect Supervisor.count_children(pid)
    #handler( pid , 0 )
    stop = System.monotonic_time(:millisecond)
    time = (stop - start) / 1000
    IO.puts "time: #{time}s"
  end

  def handler( pid , product_num \\ 0 , stop \\ false) do
    if stop == false do
      receive do
        {:product, msg } ->
            if ( Supervisor.count_children(pid).active != 0 ) do
              IO.puts product_num
              handler(product_num  + msg |> length )
            else
              handler(product_num  + msg |> length , true)
            end
      after
        1_000 -> handler(product_num, true)
      end
    else
      IO.puts product_num
    end
  end


end
