defmodule PolishMeWeb.StashPolishLive.Index do
  use PolishMeWeb, :live_view

  alias PolishMe.Stash
  alias PolishMe.Stash.StashPolish
  alias PolishMeWeb.Helpers.TextHelpers

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} title={@page_title}>
      <div id="stash-polishes" phx-update="stream" class="mt-6 grid grid-cols-2 md:grid-cols-3 gap-6">
        <.stash_polish_card
          :for={{dom_id, stash_polish} <- @streams.stash_polishes}
          stash_polish={stash_polish}
          id={dom_id}
        />
        <div
          id="empty"
          class="p-8 border-2 border-dashed border-gray-400 rounded-lg text-center text-lg font-semibold text-gray-600 col-span-2 md:col-span-3 only:block hidden"
        >
          No polishes found... add stash from a polish page!
        </div>
      </div>
    </Layouts.app>
    """
  end

  attr :stash_polish, StashPolish, required: true
  attr :id, :string, required: true

  def stash_polish_card(assigns) do
    ~H"""
    <div id={@id}>
      <.link navigate={
        ~p"/stash/polishes/#{@stash_polish.polish.brand.slug}/#{@stash_polish.polish.slug}"
      }>
        <div class="card bg-base-100 w-64 rounded-2xl shadow-md overflow-hidden border border-gray-200">
          <figure>
            <img src={~p"/uploads/stash/polish/emily_de_molly__bullseye.webp"} alt="Polish" />
          </figure>
          <div class="card-body">
            <div>
              <h2 class="card-title">
                {@stash_polish.polish.name}
                <div :if={is_new(@stash_polish.purchase_date)} class="badge badge-secondary">NEW</div>
              </h2>
              <div class="text-sm opacity-50">{@stash_polish.polish.brand.name}</div>
            </div>
            <div class="card-actions justify-between items-center">
              <div>
                <div class="badge badge-outline">
                  {TextHelpers.atom_to_string(@stash_polish.status)}
                </div>
                <div
                  :if={@stash_polish.status == :in_stash}
                  class="radial-progress text-info"
                  style={"--value:#{@stash_polish.fill_percent}; --size:2rem;"}
                  aria-valuenow={"#{@stash_polish.fill_percent}"}
                  role="fillpercentbar"
                >
                  {@stash_polish.fill_percent}
                </div>
              </div>
              <div>
                <div class="sr-only">
                  <.link navigate={
                    ~p"/stash/polishes/#{@stash_polish.polish.brand.slug}/#{@stash_polish.polish.slug}"
                  }>
                    Show
                  </.link>
                </div>
                <.link
                  id={"edit-stash-polish-#{@stash_polish.polish.brand.slug}--#{@stash_polish.polish.slug}"}
                  navigate={
                    ~p"/stash/polishes/#{@stash_polish.polish.brand.slug}/#{@stash_polish.polish.slug}/edit"
                  }
                >
                  <.icon name="hero-pencil" class="size-4 text-accent" />
                </.link>
                <.link
                  id={"delete-stash-polish-#{@stash_polish.polish.brand.slug}--#{@stash_polish.polish.slug}"}
                  phx-click={
                    JS.push("delete",
                      value: %{
                        brand_slug: @stash_polish.polish.brand.slug,
                        polish_slug: @stash_polish.polish.slug
                      }
                    )
                    |> hide("##{@id}")
                  }
                  data-confirm="Deletion is PERMANENT - are you sure?"
                >
                  <.icon name="hero-trash" class="size-4 text-error" />
                </.link>
              </div>
            </div>
          </div>
        </div>
      </.link>
    </div>
    """
  end

  defp is_new(nil), do: false
  defp is_new(purchase_date), do: Date.diff(Date.utc_today(), purchase_date) < 30

  @impl true
  def mount(_params, _session, socket) do
    Stash.subscribe_all(socket.assigns.current_scope)

    {:ok,
     socket
     |> assign(:page_title, "My Polish Stash")
     |> stream(:stash_polishes, Stash.list_stash_polishes(socket.assigns.current_scope),
       reset: true
     )}
  end

  @impl true
  def handle_event("delete", %{"brand_slug" => brand_slug, "polish_slug" => polish_slug}, socket) do
    stash_polish = Stash.get_stash_polish!(socket.assigns.current_scope, brand_slug, polish_slug)
    {:ok, _} = Stash.delete_stash_polish(socket.assigns.current_scope, stash_polish)

    {:noreply, stream_delete(socket, :stash_polishes, stash_polish)}
  end

  @impl true
  def handle_info({type, %StashPolish{}}, socket)
      when type in [:created, :updated] do
    {:noreply,
     stream(socket, :stash_polishes, Stash.list_stash_polishes(socket.assigns.current_scope),
       reset: true
     )}
  end

  def handle_info({:deleted, %StashPolish{} = stash_polish}, socket) do
    {:noreply, stream_delete(socket, :stash_polishes, stash_polish)}
  end
end
