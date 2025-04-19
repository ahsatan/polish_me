defmodule PolishMeWeb.BrandLive.Index do
  use PolishMeWeb, :live_view

  alias Phoenix.HTML.Form
  alias PolishMe.Brands

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} title={@page_title}>
      <:actions :if={@current_scope.user.is_admin}>
        <.button variant="primary" navigate={~p"/brands/new"}>
          <.icon name="hero-plus" /> New Brand
        </.button>
      </:actions>

      <.filter_form form={@form} />

      <.table
        id="brands"
        rows={@streams.brands}
        row_click={fn {_id, brand} -> JS.navigate(~p"/brands/#{brand.slug}") end}
      >
        <:col :let={{_id, brand}} label="Name">{brand.name}</:col>
        <:col :let={{_id, brand}} label="Website">{uri_host(brand.website)}</:col>
        <:action :let={{_id, brand}}>
          <div class="sr-only">
            <.link navigate={~p"/brands/#{brand.slug}"}>Show</.link>
          </div>
          <.link
            :if={@current_scope.user.is_admin}
            id={"edit-brand-#{brand.slug}"}
            navigate={~p"/brands/#{brand.slug}/edit"}
          >
            <.icon name="hero-pencil" class="size-4 text-accent" />
          </.link>
        </:action>
      </.table>
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
      <.input field={@form[:q]} placeholder="Search..." autocomplete="off" phx-debounce />
      <.input
        field={@form[:sort]}
        type="select"
        prompt="Sort"
        options={[
          "Name: A-Z": "name_asc",
          "Name: Z-A": "name_desc"
        ]}
      />
      <.link patch={~p"/brands"} class="text-sm underline">
        Reset
      </.link>
    </.form>
    """
  end

  defp uri_host(website) when website in [nil, ""], do: nil

  defp uri_host(website) do
    {:ok, %URI{host: host}} = URI.new(website)

    host
  end

  @impl true
  def mount(_params, _session, socket) do
    Brands.subscribe()

    {:ok, socket |> assign(page_title: "Brands")}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    params = params |> filter_params()

    {:noreply,
     socket
     |> assign(:form, to_form(params))
     |> stream(:brands, Brands.filter_brands(params), reset: true)}
  end

  @impl true
  def handle_event("filter", params, socket) do
    {:noreply, socket |> push_patch(to: ~p"/brands?#{params |> filter_params()}")}
  end

  @impl true
  def handle_info({type, %PolishMe.Brands.Brand{}}, socket)
      when type in [:created, :updated] do
    {:noreply,
     socket
     |> stream(:brands, socket.assigns.form.params |> filter_params() |> Brands.filter_brands(),
       reset: true
     )}
  end

  defp filter_params(params) do
    params
    |> Map.take(~w(q sort))
    |> Map.reject(fn {_k, v} -> v == "" end)
  end
end
