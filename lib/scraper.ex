defmodule Scraper do

  def scrapePage( parent ) do
    pages = Graiet.request("samsung") |> Graiet.pages
    children = []
    children = for n <- 1..pages do
      child = %{  id: :rand.uniform(100000), start: {Scraper , :page, [ n , parent ]} }
      children ++ child
    end
    Supervisor.start_link(children, strategy: :one_for_one)
  end

  def page( number , receiver ) do
    products = Graiet.request("samsung",number) |> Graiet.products()
    send receiver , {:product , products }
  end

end
