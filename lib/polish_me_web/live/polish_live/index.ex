defmodule PolishMeWeb.PolishLive.Index do
  use PolishMeWeb, :live_view

  alias Phoenix.HTML.Form
  alias PolishMe.Brands
  alias PolishMe.Brands.Brand
  alias PolishMe.Polishes
  alias PolishMe.Polishes.Polish
  alias PolishMeWeb.Helpers.TextHelpers

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} title={@page_title}>
      <:actions :if={@current_scope.user.is_admin}>
        <%= if @brand do %>
          <.button variant="primary" navigate={~p"/polishes/#{@brand.slug}/new"}>
            <.icon name="hero-plus" /> New {@brand.name} Polish
          </.button>
        <% else %>
          <.button variant="primary" navigate={~p"/polishes/new"}>
            <.icon name="hero-plus" /> New Polish
          </.button>
        <% end %>
      </:actions>

      <.filter_form form={@form} brand={@brand} />

      <.table
        id="polishes"
        rows={@streams.polishes}
        row_click={
          fn {_id, polish} ->
            JS.navigate(~p"/polishes/#{polish.brand.slug}/#{polish.slug}")
          end
        }
      >
        <:col :let={{_id, polish}} label="Brand">{polish.brand.name}</:col>
        <:col :let={{_id, polish}} label="Name">{polish.name}</:col>
        <:col :let={{_id, polish}} label="Colors">
          {TextHelpers.enums_to_string(polish.colors, "<br />") |> raw()}
        </:col>
        <:col :let={{_id, polish}} label="Finishes">
          {TextHelpers.enums_to_string(polish.finishes, "<br />") |> raw()}
        </:col>
        <:col :let={{_id, polish}} label="Topper">
          <.icon :if={polish.topper} name="hero-check" class="text-info" />
        </:col>
        <:action :let={{_id, polish}}>
          <div class="sr-only">
            <.link navigate={~p"/polishes/#{polish.brand.slug}/#{polish.slug}"}>Show</.link>
          </div>
          <.link
            :if={@current_scope.user.is_admin}
            id={"edit-polish-#{polish.brand.slug}--#{polish.slug}"}
            navigate={~p"/polishes/#{polish.brand.slug}/#{polish.slug}/edit"}
          >
            <.icon name="hero-pencil" class="size-4 text-accent" />
          </.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  attr :form, Form, required: true
  attr :brand, Brand, default: nil

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
        options={
          [
            "Name: A-Z": "name_asc",
            "Name: Z-A": "name_desc"
          ] ++
            if @brand, do: [], else: ["Brand: A-Z": "brand_asc", "Brand: Z-A": "brand_desc"]
        }
      />
      <.link
        patch={if @brand, do: ~p"/polishes/#{@brand.slug}", else: ~p"/polishes"}
        class="text-sm underline"
      >
        Reset
      </.link>
    </.form>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    {:ok, socket |> apply_action(socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    Polishes.subscribe_all()

    socket
    |> assign(:page_title, "Polishes")
    |> assign(:brand, nil)
  end

  defp apply_action(socket, :index_by_brand, %{"brand_slug" => brand_slug}) do
    brand = Brands.get_brand!(brand_slug)
    Polishes.subscribe_brand_polishes(brand.id)

    socket
    |> assign(:page_title, "#{brand.name} Polishes")
    |> assign(:brand, brand)
  end

  @impl true
  def handle_params(params, _uri, socket) do
    params = params |> filter_params() |> update_params(socket.assigns.brand)

    {:noreply,
     socket
     |> assign(:form, to_form(params))
     |> stream(:polishes, Polishes.filter_polishes(params), reset: true)}
  end

  @impl true
  def handle_event("filter", params, socket) do
    {:noreply,
     socket |> push_patch(to: patch_to(params |> filter_params(), socket.assigns.brand))}
  end

  defp patch_to(params, nil), do: ~p"/polishes?#{params}"
  defp patch_to(params, brand), do: ~p"/polishes/#{brand.slug}?#{params}"

  @impl true
  def handle_info({type, %Polish{}}, socket) when type in [:created, :updated] do
    params = socket.assigns.form.params |> filter_params() |> update_params(socket.assigns.brand)

    {:noreply, socket |> stream(:polishes, Polishes.filter_polishes(params), reset: true)}
  end

  defp filter_params(params) do
    params
    |> Map.take(~w(q colors finishes sort))
    |> Map.reject(fn {_k, v} -> v == "" end)
  end

  defp update_params(params, nil), do: params
  defp update_params(params, brand), do: params |> Map.put("brand_id", brand.id)
end
