defmodule Graiet do
  @info %{ url: "https://graiet.com/" ,
           uri: "https://graiet.com/electromenager.tn/page/[#]/?product_cat&s=[*]&post_type=product" ,
           name: "Graiet" }

  def info , do: @info

  def request(query,page \\ 1) do
      uri = String.replace(@info[:uri],"[#]",to_string(page)) |> String.replace("[*]",query)
      body = HTTPoison.get!(uri).body
      body |> Floki.parse_document!
  end

  def pages(document) do
    page_numbers = Floki.find(document,"a.page-numbers")
    { _ , _ , pages } = Enum.at page_numbers , (length(page_numbers) - 2)
    { num , _ } = pages |> List.first |> Integer.parse
    num
  end

  def products(document) do
    Floki.find(document,"div.product")
  end

  def product(raw_product) do
   %{ name: Floki.find(raw_product,"h3.name") |> Floki.text  ,
      img: Floki.find(raw_product,"a.product-image , img") |> Floki.attribute("src") ,
      url: Floki.find(raw_product,"a.product-image") |> Floki.attribute("href")  ,
      mark: Floki.find(raw_product,"ul.show-brand") |> Floki.text ,
      price:  Floki.find(raw_product,"span.woocommerce-Price-amount") |> Floki.text  ,
      oldPrice: nil   }
  end
end
