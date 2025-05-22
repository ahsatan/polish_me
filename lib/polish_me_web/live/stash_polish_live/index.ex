defmodule PolishMeWeb.StashPolishLive.Index do
  use PolishMeWeb, :live_view

  alias Phoenix.HTML.Form
  alias PolishMe.Polishes
  alias PolishMe.Stash
  alias PolishMe.Stash.StashPolish
  alias PolishMeWeb.Helpers.TextHelpers

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} title={@page_title}>
      <.filter_form form={@form} />

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

  attr :form, Form, required: true

  def filter_form(assigns) do
    ~H"""
    <.form
      for={@form}
      id="filter-form"
      phx-change="filter"
      phx-submit="filter"
      class="sm:flex scale-90 justify-center gap-4 items-center"
    >
      <.input field={@form[:q]} id="q-input" placeholder="Search..." autocomplete="off" phx-debounce />
      <.input
        field={@form[:colors]}
        id="colors-input"
        type="select"
        multiple
        label="Colors"
        class="h-18"
        options={Polishes.get_colors() |> TextHelpers.enums_to_string_map()}
      />
      <.input
        field={@form[:finishes]}
        id="finishes-input"
        type="select"
        multiple
        label="Finishes"
        class="h-18"
        options={Polishes.get_finishes() |> TextHelpers.enums_to_string_map()}
      />
      <.input
        field={@form[:sort]}
        id="sort-input"
        type="select"
        prompt="Sort"
        options={[
          "Name: A-Z": "name_asc",
          "Name: Z-A": "name_desc",
          "Brand: A-Z": "brand_asc",
          "Brand: Z-A": "brand_desc",
          "Purchase Date: Newest First": "date_desc",
          "Purchase Date: Oldest First": "date_asc",
          "Fill %: High-Low": "fill_desc",
          "Fill %: Low-High": "fill_asc"
        ]}
      />
      <.link patch={~p"/stash/polishes/"} class="text-sm underline">
        Reset
      </.link>
    </.form>
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
                  class="text-xs radial-progress text-info"
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

    {:ok, socket |> assign(:page_title, "My Polish Stash")}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    params = params |> filter_params()

    {:noreply,
     socket
     |> assign(:form, to_form(params))
     |> stream(:stash_polishes, Stash.filter_stash_polishes(socket.assigns.current_scope, params),
       reset: true
     )}
  end

  @impl true
  def handle_event("filter", params, socket) do
    {:noreply, socket |> push_patch(to: ~p"/stash/polishes?#{params |> filter_params()}")}
  end

  def handle_event("delete", %{"brand_slug" => brand_slug, "polish_slug" => polish_slug}, socket) do
    stash_polish = Stash.get_stash_polish!(socket.assigns.current_scope, brand_slug, polish_slug)
    {:ok, _} = Stash.delete_stash_polish(socket.assigns.current_scope, stash_polish)

    {:noreply, socket |> stream_delete(:stash_polishes, stash_polish)}
  end

  @impl true
  def handle_info({type, %StashPolish{}}, socket)
      when type in [:created, :updated] do
    params = socket.assigns.form.params |> filter_params()

    {:noreply,
     socket
     |> stream(:stash_polishes, Stash.filter_stash_polishes(socket.assigns.current_scope, params),
       reset: true
     )}
  end

  def handle_info({:deleted, %StashPolish{} = stash_polish}, socket) do
    {:noreply, socket |> stream_delete(:stash_polishes, stash_polish)}
  end

  defp filter_params(params) do
    params
    |> Map.take(~w(q colors finishes sort))
    |> Map.reject(fn {_k, v} -> v == "" end)
  end
end
