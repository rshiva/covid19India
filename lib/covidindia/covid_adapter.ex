defmodule CovidIndia.CovidAdapter do

  alias CovidIndia.Person

  def call() do
    HTTPoison.start()
    url = "https://api.covid19india.org/raw_data3.json"
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        IO.puts "----I'm not called all the time "
        decoded_data = Jason.decode!(body)
        api_struct_data = Enum.map(decoded_data["raw_data"],&Person.new/1)
        write_cache_data(api_struct_data)
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found :("
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end

  def search_by_state(state) do
    fetch_cache_data()
    |> Enum.filter(&(&1.detectedstate == Recase.to_title(state)))
  end


  #Deceased, Recovered, Hospitalized,
  def count(collection) do
    Enum.count(collection)
  end

  def search_wise_deceased_count(collection) do
    collection
      |> Enum.filter(&(&1.currentstatus == "Deceased"))
      |> Enum.count()
  end

  def search_wise_recovered_count(collection) do
    # IO.puts "----- #{Enum.filter(collection,&(&1.detectedstate))}"
    collection
      |> Enum.filter(&(&1.currentstatus == "Recovered"))
      |> Enum.count()
  end

  def search_wise_hopitalized_count(collection) do
    collection
      |> Enum.filter(&(&1.currentstatus == "Hospitalized"))
      |> Enum.count()
  end

  def write_cache_data(api_struct_data) do
    #cache will expire after 4 hours
    Cachex.put(:cache_warehouse, "covidapi_data", api_struct_data, ttl: :timer.seconds(14400))
  end

  def fetch_cache_data() do
    case Cachex.keys(:cache_warehouse)  do
      {:ok, []} ->
        call()
      {:ok, _ } ->
        IO.puts "already cached"
    end

    {:ok, data} = Cachex.get(:cache_warehouse, "covidapi_data")
    data
  end



  # {:ok, data } = Cachex.keys(:cache_warehouse)
  # Cachex.clear(:cache_warehouse)


end
