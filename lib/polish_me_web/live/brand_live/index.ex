defmodule PolishMeWeb.BrandLive.Index do
  use PolishMeWeb, :live_view

  alias Phoenix.HTML.Form
  alias PolishMe.Brands
  alias PolishMe.Brands.Brand

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

      <%!-- Modified from: https://daisyui.com/components/list/ --%>
      <div class="overflow-x-auto">
        <table class="table">
          <thead>
            <tr>
              <th></th>
              <th></th>
              <th><span class="sr-only">{gettext("Actions")}</span></th>
            </tr>
          </thead>
          <tbody>
            <tr :for={{_dom_id, brand} <- @streams.brands}>
              <td phx-click={JS.navigate(~p"/brands/#{brand.slug}")} class="hover:cursor-pointer">
                <div class="logo">
                  <div>
                    <img
                      :if={brand.logo_url}
                      src={brand.logo_url}
                      alt="#{brand.name} logo"
                      class="max-w-32 max-h-16"
                    />
                  </div>
                </div>
              </td>
              <td>
                <div class="flex items-center gap-3">
                  <div>
                    <div
                      phx-click={JS.navigate(~p"/brands/#{brand.slug}")}
                      class="font-bold hover:cursor-pointer"
                    >
                      {brand.name}
                    </div>
                    <div class="text-sm opacity-50">
                      <.link href={brand.website}>{brand.website}</.link>
                    </div>
                  </div>
                </div>
              </td>
              <td>
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
              </td>
            </tr>
          </tbody>
          <tfoot>
            <tr>
              <th></th>
              <th></th>
              <th><span class="sr-only">{gettext("Actions")}</span></th>
            </tr>
          </tfoot>
        </table>
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

  @impl true
  def mount(_params, _session, socket) do
    Brands.subscribe_all()

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
  def handle_info({type, %Brand{}}, socket)
      when type in [:created, :updated] do
    {:noreply,
     socket
     |> stream(
       :brands,
       Brands.filter_brands(socket.assigns.form.params |> filter_params()),
       reset: true
     )}
  end

  defp filter_params(params) do
    params
    |> Map.take(~w(q sort))
    |> Map.reject(fn {_k, v} -> v == "" end)
  end
end
