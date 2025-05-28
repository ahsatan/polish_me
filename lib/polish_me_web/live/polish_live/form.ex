defmodule PolishMeWeb.PolishLive.Form do
  use PolishMeWeb, :live_view

  alias PolishMe.Brands
  alias PolishMe.Polishes
  alias PolishMe.Polishes.Polish
  alias PolishMeWeb.Helpers.TextHelpers

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} title={@page_title}>
      <.form for={@form} id="polish-form" phx-change="validate" phx-submit="save">
        <%= if @polish.brand_id do %>
          <.input
            field={@form[:brand_id]}
            id="brand-input"
            type="text"
            label="Brand"
            value={@polish.brand.name}
            disabled
          />
        <% else %>
          <.input
            field={@form[:brand_id]}
            id="brand-input"
            type="select"
            label="Brand"
            options={@brand_options}
            required
          />
        <% end %>
        <.input field={@form[:name]} id="name-input" type="text" label="Name" maxlength="60" required />
        <.input
          field={@form[:slug]}
          id="slug-input"
          type="text"
          label="Slug"
          maxlength="60"
          value={TextHelpers.name_to_slug(@form[:name].value)}
          disabled
        />
        <.input
          field={@form[:description]}
          id="description-input"
          type="textarea"
          label="Description"
          maxlength="1024"
          phx-debounce="blur"
        />
        <.input
          field={@form[:colors]}
          id="colors-input"
          type="select"
          multiple
          label="Colors"
          class="h-22"
          options={Polishes.get_colors() |> TextHelpers.enums_to_string_map()}
        />
        <.input
          field={@form[:finishes]}
          id="finishes-input"
          type="select"
          multiple
          label="Finishes"
          class="h-22"
          options={Polishes.get_finishes() |> TextHelpers.enums_to_string_map()}
        />
        <.input field={@form[:topper]} id="topper-input" type="checkbox" label="Topper" />

        <fieldset class="fieldset mb-2">
          <label class="fieldset-label">Image</label>
          <.live_file_input class="file-input" upload={@uploads.image} />

          <section phx-drop-target={@uploads.image.ref}>
            <article :for={entry <- @uploads.image.entries} class="upload-entry">
              <div :if={@uploads.image.errors == []}>
                <figure>
                  <.live_img_preview width="320" entry={entry} />
                </figure>

                <progress value={entry.progress} max="100" class="w-80">{entry.progress}%</progress>

                <button
                  type="button"
                  phx-click="cancel-upload"
                  phx-value-ref={entry.ref}
                  aria-label="cancel"
                >
                  &times;
                </button>
              </div>

              <p :for={err <- upload_errors(@uploads.image, entry)} class="alert text-error">
                {error_to_string(err)}
              </p>
            </article>

            <p :for={err <- upload_errors(@uploads.image)} class="alert text-error">
              {error_to_string(err)}
            </p>
          </section>
        </fieldset>

        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save</.button>
          <.button navigate={return_path(@return_to, @polish)}>Cancel</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  defp error_to_string(:not_accepted), do: "Accepts only .jpg, .jpeg, .png, and .webp filetypes"
  defp error_to_string(:too_many_files), do: "You have selected too many files"
  defp error_to_string(:too_large), do: "The image is too large"
  defp error_to_string(:external_client_failure), do: "Something went terribly wrong"

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> allow_upload(:image, accept: ~w(.jpg .jpeg .png .webp), max_entries: 1)
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    polish = %Polish{}

    socket
    |> assign(:return_to, "index")
    |> assign(:page_title, "New Polish")
    |> assign(:uploaded_image, nil)
    |> assign(:brand_options, Brands.list_brands() |> Enum.map(&{&1.name, &1.id}))
    |> assign(:polish, polish)
    |> assign(:form, to_form(Polishes.change_polish(polish)))
  end

  defp apply_action(socket, :new_by_brand, %{"brand_slug" => brand_slug}) do
    brand = Brands.get_brand!(brand_slug)
    polish = %Polish{brand_id: brand.id, brand: brand}

    socket
    |> assign(:return_to, "brand")
    |> assign(:page_title, "New #{brand.name} Polish")
    |> assign(:uploaded_image, polish.image_url)
    |> assign(:polish, polish)
    |> assign(:form, to_form(Polishes.change_polish(polish)))
  end

  defp apply_action(
         socket,
         :edit,
         %{"brand_slug" => brand_slug, "polish_slug" => polish_slug} = params
       ) do
    polish = Polishes.get_polish!(brand_slug, polish_slug)

    socket
    |> assign(:return_to, return_to(params["return_to"]))
    |> assign(:page_title, "Edit Polish")
    |> assign(:uploaded_image, polish.image_url)
    |> assign(:polish, polish)
    |> assign(:form, to_form(Polishes.change_polish(polish)))
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  @impl true
  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :image, ref)}
  end

  def handle_event("validate", %{"polish" => polish_params}, socket) do
    changeset =
      Polishes.change_polish(socket.assigns.polish, polish_params)

    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"polish" => %{"name" => name} = polish_params}, socket) do
    brand_slug = get_brand_slug(socket.assigns.polish, polish_params)
    polish_slug = TextHelpers.name_to_slug(name)

    {:noreply, socket} =
      case uploaded_entries(socket, :image) do
        {[%{client_type: type} = entry | _], _} ->
          image_url =
            consume_uploaded_entry(socket, entry, fn %{path: path} ->
              dest =
                Path.join(
                  Application.app_dir(:polish_me, "priv/static/uploads/polish"),
                  "#{brand_slug}__#{polish_slug}#{type_to_extension(type)}"
                )

              File.cp!(path, dest)
              {:ok, ~p"/uploads/polish/#{Path.basename(dest)}"}
            end)

          {:noreply, socket |> assign(:uploaded_image, image_url)}

        _ ->
          {:noreply, socket}
      end

    polish_params =
      polish_params
      |> Map.put("slug", polish_slug)
      |> Map.put("image_url", socket.assigns.uploaded_image)

    save_polish(socket, socket.assigns.live_action, polish_params)
  end

  defp get_brand_slug(%{brand: %{slug: slug}}, _polish_params), do: slug

  defp get_brand_slug(_polish, %{"brand_id" => brand_id}) do
    Brands.get_brand_by_id!(brand_id).slug
  end

  defp type_to_extension("image/jpeg"), do: ".jpg"
  defp type_to_extension("image/png"), do: ".png"
  defp type_to_extension("image/webp"), do: ".webp"

  defp save_polish(socket, :edit, polish_params) do
    case Polishes.update_polish(socket.assigns.polish, polish_params) do
      {:ok, polish} ->
        {:noreply,
         socket
         |> put_flash(:info, "Polish #{polish.name} updated successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, polish))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_polish(socket, :new, polish_params) do
    save_new_polish(socket, polish_params)
  end

  defp save_polish(socket, :new_by_brand, polish_params) do
    save_new_polish(socket, polish_params |> Map.put("brand_id", socket.assigns.polish.brand_id))
  end

  defp save_new_polish(socket, polish_params) do
    case Polishes.create_polish(polish_params) do
      {:ok, polish} ->
        {:noreply,
         socket
         |> put_flash(:info, "Polish #{polish.name} created successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, polish))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path("index", _polish), do: ~p"/polishes"
  defp return_path("show", polish), do: ~p"/polishes/#{polish.brand.slug}/#{polish.slug}"
  defp return_path("brand", polish), do: ~p"/brands/#{polish.brand.slug}"
end
