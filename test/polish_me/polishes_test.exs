defmodule PolishMe.PolishesTest do
  use PolishMe.DataCase

  import PolishMe.AccountsFixtures
  import PolishMe.BrandsFixtures
  import PolishMe.PolishesFixtures
  import PolishMe.StashFixtures

  alias PolishMe.Polishes
  alias PolishMe.Polishes.Polish

  @valid_attrs %{
    name: "some name",
    slug: "some-slug",
    description: "some description",
    topper: true,
    colors: [:red, :gold],
    finishes: [:flake, :shimmer],
    image_url: "/uploads/polish/some-brand__some-name"
  }

  @invalid_attrs %{
    name: nil,
    slug: nil,
    description: nil,
    topper: nil,
    colors: nil,
    finishes: nil,
    image_url: nil
  }

  defp add_brand(attrs) do
    brand = brand_fixture()
    Map.put(attrs, :brand_id, brand.id)
  end

  test "list_polishes/0 returns all polishes" do
    polish = polish_fixture(%{name: "first name"})
    other_polish = polish_fixture(%{name: "second name"})
    assert Polishes.list_polishes() == [polish, other_polish]
  end

  describe "filter_polishes/1" do
    test "returns only brand's polishes" do
      brand = brand_fixture()
      polish_fixture()
      polish = polish_fixture(%{name: "First name", brand_id: brand.id})
      other_polish = polish_fixture(%{name: "Second name", brand_id: brand.id})

      assert Polishes.filter_polishes(%{"brand_id" => brand.id}) == [polish, other_polish]
    end

    test "returns polishes with name and descriptions that match query" do
      brand = brand_fixture()
      polish_fixture(%{name: "Not name", description: "Not description"})
      polish = polish_fixture(%{name: "Match name", brand_id: brand.id})
      other_polish = polish_fixture(%{description: "Description match", brand_id: brand.id})

      assert Polishes.filter_polishes(%{"q" => "match"}) == [polish, other_polish]
    end

    test "returns polishes filtered by color" do
      brand = brand_fixture(%{name: "First name"})
      other_brand = brand_fixture(%{name: "Second name"})
      polish_fixture(%{colors: [:blue]})
      polish = polish_fixture(%{colors: [:red, :gold], brand_id: brand.id})
      other_polish = polish_fixture(%{colors: [:gold, :green], brand_id: other_brand.id})

      assert Polishes.filter_polishes(%{"colors" => ["gold"]}) == [polish, other_polish]
      assert Polishes.filter_polishes(%{"colors" => ["gold", "green"]}) == [other_polish]
    end

    test "returns polishes filtered by finish" do
      brand = brand_fixture()
      polish_fixture(%{finishes: [:creme]})

      polish =
        polish_fixture(%{name: "First name", finishes: [:jelly, :flake], brand_id: brand.id})

      other_polish =
        polish_fixture(%{name: "Second name", finishes: [:shimmer, :flake], brand_id: brand.id})

      assert Polishes.filter_polishes(%{"finishes" => ["flake"]}) == [polish, other_polish]
      assert Polishes.filter_polishes(%{"finishes" => ["shimmer", "flake"]}) == [other_polish]
    end

    test "returns polishes sorted by brand name" do
      first_brand = brand_fixture(%{name: "First brand"})
      second_brand = brand_fixture(%{name: "Second brand"})
      fb_polish = polish_fixture(%{name: "First name", brand_id: first_brand.id})
      fb_other_polish = polish_fixture(%{name: "Second name", brand_id: first_brand.id})
      sb_polish = polish_fixture(%{brand_id: second_brand.id})

      assert Polishes.filter_polishes(%{"sort" => "brand_asc"}) == [
               fb_polish,
               fb_other_polish,
               sb_polish
             ]

      assert Polishes.filter_polishes(%{"sort" => "brand_desc"}) == [
               sb_polish,
               fb_polish,
               fb_other_polish
             ]
    end

    test "returns polishes sorted by name" do
      polish = polish_fixture(%{name: "First name"})
      other_polish = polish_fixture(%{name: "Second name"})
      another_polish = polish_fixture(%{name: "Middle name"})

      assert Polishes.filter_polishes(%{"sort" => "name_asc"}) == [
               polish,
               another_polish,
               other_polish
             ]

      assert Polishes.filter_polishes(%{"sort" => "name_desc"}) == [
               other_polish,
               another_polish,
               polish
             ]
    end

    test "returns polishes sorted by popularity" do
      first_user_scope = PolishMe.Accounts.Scope.for_user(user_fixture())
      second_user_scope = PolishMe.Accounts.Scope.for_user(user_fixture())
      first_polish = polish_fixture()
      second_polish = polish_fixture()
      stash_polish_fixture(first_user_scope, %{polish_id: first_polish.id})
      stash_polish_fixture(second_user_scope, %{polish_id: first_polish.id})
      stash_polish_fixture(first_user_scope, %{polish_id: second_polish.id})

      assert Polishes.filter_polishes(%{"sort" => "popularity_asc"}) == [
               second_polish,
               first_polish
             ]

      assert Polishes.filter_polishes(%{"sort" => "popularity_desc"}) == [
               first_polish,
               second_polish
             ]
    end

    test "filters on multiple inputs" do
      first_brand = brand_fixture(%{name: "First brand"})
      second_brand = brand_fixture(%{name: "Second brand"})
      fb_polish = polish_fixture(%{name: "First name", brand_id: first_brand.id})
      sb_polish = polish_fixture(%{name: "First name", brand_id: second_brand.id})
      polish_fixture(%{name: "Second name", brand_id: second_brand.id})

      assert Polishes.filter_polishes(%{"q" => "first", "sort" => "brand_asc"}) == [
               fb_polish,
               sb_polish
             ]
    end
  end

  describe "get_polish!/2" do
    test "returns the polish with given slugs" do
      polish = polish_fixture()

      assert Polishes.get_polish!(polish.brand.slug, polish.slug) == polish
    end

    test "errors when the polish does not exist" do
      polish = polish_fixture()

      assert_raise Ecto.NoResultsError, fn ->
        Polishes.get_polish!("!" <> polish.brand.slug, polish.slug)
      end

      assert_raise Ecto.NoResultsError, fn ->
        Polishes.get_polish!(polish.brand.slug, "!" <> polish.slug)
      end
    end
  end

  describe "get_polish/2" do
    test "returns the polish with given slugs" do
      polish = polish_fixture()

      assert {:ok, ^polish} = Polishes.get_polish(polish.brand.slug, polish.slug)
    end

    test "returns an error tuple when the polish does not exist" do
      polish = polish_fixture()

      assert {:error, :not_found} = Polishes.get_polish("!" <> polish.brand.slug, polish.slug)
      assert {:error, :not_found} = Polishes.get_polish(polish.brand.slug, "!" <> polish.slug)
    end
  end

  describe "create_polish/1" do
    test "with valid data creates a polish" do
      assert {:ok, %Polish{} = polish} = Polishes.create_polish(add_brand(@valid_attrs))
      assert polish.name == "some name"
      assert polish.slug == "some-slug"
      assert polish.description == "some description"
      assert polish.topper
      assert polish.colors == [:red, :gold]
      assert polish.finishes == [:flake, :shimmer]
      assert polish.image_url == "/uploads/polish/some-brand__some-name"
      assert polish.brand_id
    end

    test "trims whitespace from name" do
      attrs = %{@valid_attrs | name: "  whitespace name  "} |> add_brand()

      assert {:ok, %Polish{} = polish} = Polishes.create_polish(attrs)
      assert polish.name == "whitespace name"
    end

    test "with same name and slug in different brands creates separate polishes" do
      assert {:ok, %Polish{} = polish1} = Polishes.create_polish(add_brand(@valid_attrs))
      assert {:ok, %Polish{} = polish2} = Polishes.create_polish(add_brand(@valid_attrs))
      assert polish1.name == polish2.name
      assert polish1.slug == polish2.slug
      refute polish1.id == polish2.id
      refute polish1.brand_id == polish2.brand_id
    end

    test "without name returns error changeset" do
      invalid_attrs = @valid_attrs |> Map.delete(:name) |> add_brand()

      assert {:error, %Ecto.Changeset{errors: [name: {"can't be blank", _}]}} =
               Polishes.create_polish(invalid_attrs)
    end

    test "with too long name returns error changeset" do
      invalid_attrs = %{@valid_attrs | name: String.duplicate("a", 61)} |> add_brand()

      assert {:error,
              %Ecto.Changeset{errors: [name: {"should be at most %{count} character(s)", _}]}} =
               Polishes.create_polish(invalid_attrs)
    end

    test "with same name and slug in same brand returns error changeset" do
      brand = brand_fixture()
      attrs = @valid_attrs |> Map.put(:brand_id, brand.id)
      Polishes.create_polish(attrs)

      assert {:error,
              %Ecto.Changeset{
                errors: [
                  slug: {"must be unique within brand", _},
                  name: {"must be unique within brand", _}
                ]
              }} = Polishes.create_polish(attrs)
    end

    test "without slug returns error changeset" do
      invalid_attrs = @valid_attrs |> Map.delete(:slug) |> add_brand()

      assert {:error, %Ecto.Changeset{errors: [slug: {"can't be blank", _}]}} =
               Polishes.create_polish(invalid_attrs)
    end

    test "with invalid slug returns error changeset" do
      invalid_attrs = %{@valid_attrs | slug: "some slug"} |> add_brand()

      assert {:error,
              %Ecto.Changeset{errors: [slug: {"must use only letters, numbers, and dash", _}]}} =
               Polishes.create_polish(invalid_attrs)
    end

    test "with too long slug returns error changeset" do
      invalid_attrs = %{@valid_attrs | slug: String.duplicate("a", 61)} |> add_brand()

      assert {:error,
              %Ecto.Changeset{errors: [slug: {"should be at most %{count} character(s)", _}]}} =
               Polishes.create_polish(invalid_attrs)
    end

    test "trims whitespace from description" do
      attrs = %{@valid_attrs | description: "  whitespace description  "} |> add_brand()

      assert {:ok, %Polish{} = polish} = Polishes.create_polish(attrs)
      assert polish.description == "whitespace description"
    end

    test "with too long description returns error changeset" do
      invalid_attrs = %{@valid_attrs | description: String.duplicate("a", 1025)} |> add_brand()

      assert {:error,
              %Ecto.Changeset{
                errors: [description: {"should be at most %{count} character(s)", _}]
              }} = Polishes.create_polish(invalid_attrs)
    end

    test "without brand returns error changeset" do
      invalid_attrs = @valid_attrs

      assert {:error, %Ecto.Changeset{errors: [brand_id: {"can't be blank", _}]}} =
               Polishes.create_polish(invalid_attrs)
    end
  end

  describe "update_polish/2" do
    test "with valid data updates the polish" do
      polish = polish_fixture()

      update_attrs = %{
        name: "update name",
        slug: "update-slug",
        description: "update description",
        topper: false,
        colors: [:yellow],
        finishes: [:shimmer],
        image_url: "/uploads/polish/some-brand__update-name"
      }

      assert {:ok, %Polish{} = polish} = Polishes.update_polish(polish, update_attrs)
      assert polish.name == "update name"
      assert polish.slug == "update-slug"
      assert polish.description == "update description"
      assert polish.topper == false
      assert polish.colors == [:yellow]
      assert polish.finishes == [:shimmer]
    end

    test "with brand update does not update polish" do
      polish = polish_fixture()
      brand = brand_fixture()
      invalid_attrs = %{brand_id: brand.id}

      # Ecto intentionally doesn't error when updating :insert only :writable field, instead discards change
      assert {:ok, %Polish{} = ^polish} = Polishes.update_polish(polish, invalid_attrs)
    end

    test "with invalid data returns error changeset" do
      polish = polish_fixture()

      assert {:error, %Ecto.Changeset{}} = Polishes.update_polish(polish, @invalid_attrs)
      assert polish == Polishes.get_polish!(polish.brand.slug, polish.slug)
    end
  end

  test "change_polish/2 returns a polish changeset" do
    polish = polish_fixture()

    assert %Ecto.Changeset{} = Polishes.change_polish(polish)
  end

  test "get_colors/0 returns array of accepted values" do
    assert [:red | _] = Polishes.get_colors()
  end

  test "get_finishes/0 returns array of accepted values" do
    assert [:blacklight | _] = Polishes.get_finishes()
  end
end
