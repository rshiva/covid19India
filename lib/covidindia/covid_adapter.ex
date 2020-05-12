defmodule CovidIndia.CovidAdapter do

  alias CovidIndia.Person

  def call() do
    url1 = "https://api.covid19india.org/raw_data1.json"
    url2 = "https://api.covid19india.org/raw_data2.json"
    url3 = "https://api.covid19india.org/raw_data3.json"

    pids = Enum.map([url1, url2, url3],
            fn(url) ->
              Task.async(fn -> HTTPoison.get(url) end) end)

    bodies = Enum.flat_map(pids,
    fn(pid) ->
      case Task.await(pid,10000) do
        {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
          decoded_data = Jason.decode!(body)
          Enum.map(decoded_data["raw_data"],&Person.new/1)
        {:ok, %HTTPoison.Response{status_code: 404}} ->
          IO.puts "Not found :("
        {:error, %HTTPoison.Error{reason: reason}} ->
          IO.inspect reason
        end
    end
    )
    IO.puts "3 async all and caching it"
    write_cache_data(List.flatten(bodies))

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
