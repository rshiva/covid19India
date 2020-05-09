defmodule CovidindiaWeb.HomeLive do
  use CovidindiaWeb, :live_view
  alias CovidIndia.CovidAdapter

  def mount(_params, _session, socket) do
    socket = assign(socket,
    query: "",
    pdata: [],
    deceased_count: 0,
    hospitalized_count: 0,
    recovered_count: 0
    )
    {:ok, socket}
  end


  def render(assigns) do
    ~L"""
    <div id="search">

    <form phx-submit="search">
        <input type="text" name="query" value="<%= @query %>"
               placeholder="Search by state or city"
          />
        <button type="submit">
          <img src="" alt="Search">
        </button>
      </form>

      <%= if (@pdata > 0) do %>
        <div class="Count">
          Recovered: <%= @recovered_count %>
          Hospitalized: <%= @hospitalized_count %>
          Deceased: <%= @deceased_count %>
        </div>
      <% end %>

      <div>
        <ul>
          <%= for user <- @pdata do %>
            <li>
              <div class="">
                <div class="number">
                  Status: <%= user.currentstatus %>
                </div>
                <div>
                  <img src="" alt="Location">
                  State: <%= user.detectedstate %><br>
                  District: <%= user.detecteddistrict %><br>
                  Patient Number: <%= user.patientnumber %><br>
                  State Patient Number: <%= user.statepatientnumber %><br>
                  Source: <%= user.source1 %><br>
                  Transmission Type: <%= user.typeoftransmission %>
                </div>
              </div>
            </li>
          <% end %>
        </ul>
      </div>
    </div>

    """
  end

  def handle_event("search", %{"query" => query} , socket) do
    collection = CovidAdapter.search_by_state(query)
    socket = assign(socket,
        query: query,
        pdata: collection,
        deceased_count: CovidAdapter.search_wise_deceased_count(collection),
        hospitalized_count: CovidAdapter.search_wise_hopitalized_count(collection),
        recovered_count: CovidAdapter.search_wise_recovered_count(collection)
        )
    {:noreply, socket}
  end

end
