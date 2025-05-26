defmodule PolishMe.BrandsTest do
  use PolishMe.DataCase

  import PolishMe.BrandsFixtures
  import PolishMe.PolishesFixtures

  alias PolishMe.Brands
  alias PolishMe.Brands.Brand

  @valid_attrs %{
    name: "some name",
    slug: "some-slug",
    description: "some description",
    website: "https://some.com",
    contact_email: "some@email.com",
    logo_url: "/uploads/brand/logo/some.svg"
  }
  @invalid_attrs %{name: nil, description: nil, slug: nil, website: nil, contact_email: nil}

  defp assert_equal(%Brand{} = a, %Brand{} = b) do
    attrs = [:name, :slug, :description, :website, :contact_email, :logo_url]
    assert Map.take(a, attrs) == Map.take(b, attrs)
  end

  test "list_brands/0 returns all brands" do
    brand = brand_fixture(%{name: "First name"})
    other_brand = brand_fixture(%{name: "Second name"})
    assert Brands.list_brands() == [brand, other_brand]
  end

  describe "filter_brands/1" do
    test "with no filters returns all brands with default sorting (name_asc)" do
      brand = brand_fixture(%{name: "abc"})
      other_brand = brand_fixture(%{name: "def"})
      assert Brands.filter_brands(%{}) == [brand, other_brand]
    end

    test "with query returns brands with matching names" do
      matching_brand = brand_fixture(%{name: "1match1"})
      brand_fixture()
      other_matching_brand = brand_fixture(%{name: "2match2"})
      assert Brands.filter_brands(%{"q" => "match"}) == [matching_brand, other_matching_brand]
    end

    test "with query returns brands with matching descriptions" do
      matching_brand = brand_fixture(%{name: "abc", description: "1match1"})
      brand_fixture()
      other_matching_brand = brand_fixture(%{name: "def", description: "2match2"})
      assert Brands.filter_brands(%{"q" => "match"}) == [matching_brand, other_matching_brand]
    end

    test "with query returns brands matching either name or description" do
      matching_brand = brand_fixture(%{name: "1match1"})
      brand_fixture()
      other_matching_brand = brand_fixture(%{description: "2match2"})
      assert Brands.filter_brands(%{"q" => "match"}) == [matching_brand, other_matching_brand]
    end

    test "with query returns no matching results" do
      brand_fixture()
      brand_fixture()
      assert Brands.filter_brands(%{"q" => "match"}) == []
    end

    test "with sort name_desc returns ordered brands" do
      brand = brand_fixture(%{name: "abc"})
      other_brand = brand_fixture(%{name: "def"})
      assert Brands.filter_brands(%{"sort" => "name_desc"}) == [other_brand, brand]
    end

    test "with sort name_asc returns ordered brands" do
      brand = brand_fixture(%{name: "def"})
      other_brand = brand_fixture(%{name: "abc"})
      assert Brands.filter_brands(%{"sort" => "name_asc"}) == [other_brand, brand]
    end

    test "with query and sort returns brands matching both" do
      matching_brand = brand_fixture(%{name: "1match1"})
      brand_fixture()
      other_matching_brand = brand_fixture(%{name: "2match2"})

      assert Brands.filter_brands(%{"q" => "match", "sort" => "name_desc"}) == [
               other_matching_brand,
               matching_brand
             ]
    end
  end

  describe "get_brand!/1" do
    test "returns the brand with given slug" do
      brand = brand_fixture()

      assert_equal(Brands.get_brand!(brand.slug), brand)
    end

    test "errors when the brand does not exist" do
      brand = brand_fixture()

      assert_raise Ecto.NoResultsError, fn -> Brands.get_brand!("!" <> brand.slug) end
    end

    test "counts brand's polishes" do
      brand = brand_fixture()

      assert Brands.get_brand!(brand.slug).polish_count == 0

      polish_fixture(%{brand_id: brand.id})
      assert Brands.get_brand!(brand.slug).polish_count == 1

      polish_fixture(%{brand_id: brand.id})
      assert Brands.get_brand!(brand.slug).polish_count == 2
    end
  end

  describe "get_brand/1" do
    test "returns the brand with given slug" do
      brand = brand_fixture()

      assert {:ok, ^brand} = Brands.get_brand(brand.slug)
    end

    test "returns an error tuple when the brand does not exist" do
      brand = brand_fixture()

      assert {:error, :not_found} = Brands.get_brand("!" <> brand.slug)
    end
  end

  describe "create_brand/1" do
    test "with valid data creates a brand" do
      assert {:ok, %Brand{} = brand} = Brands.create_brand(@valid_attrs)
      assert brand.name == "some name"
      assert brand.slug == "some-slug"
      assert brand.description == "some description"
      assert brand.website == "https://some.com"
      assert brand.contact_email == "some@email.com"
      assert brand.logo_url == "/uploads/brand/logo/some.svg"
    end

    test "trims whitespace from name" do
      attrs = %{@valid_attrs | name: "  whitespace name  "}

      assert {:ok, %Brand{} = brand} = Brands.create_brand(attrs)
      assert brand.name == "whitespace name"
    end

    test "without name returns error changeset" do
      invalid_attrs = Map.delete(@valid_attrs, :name)

      assert {:error, %Ecto.Changeset{errors: [name: {"can't be blank", _}]}} =
               Brands.create_brand(invalid_attrs)
    end

    test "with too long name returns error changeset" do
      invalid_attrs = %{@valid_attrs | name: String.duplicate("a", 61)}

      assert {:error,
              %Ecto.Changeset{errors: [name: {"should be at most %{count} character(s)", _}]}} =
               Brands.create_brand(invalid_attrs)
    end

    test "with same name and slug returns error changeset" do
      Brands.create_brand(@valid_attrs)

      assert {:error,
              %Ecto.Changeset{
                errors: [slug: {"has already been taken", _}, name: {"has already been taken", _}]
              }} =
               Brands.create_brand(@valid_attrs)
    end

    test "without slug returns error changeset" do
      invalid_attrs = Map.delete(@valid_attrs, :slug)

      assert {:error, %Ecto.Changeset{errors: [slug: {"can't be blank", _}]}} =
               Brands.create_brand(invalid_attrs)
    end

    test "with invalid slug returns error changeset" do
      invalid_attrs = %{@valid_attrs | slug: "some slug"}

      assert {:error,
              %Ecto.Changeset{errors: [slug: {"must use only letters, numbers, and dash", _}]}} =
               Brands.create_brand(invalid_attrs)
    end

    test "with too long slug returns error changeset" do
      invalid_attrs = %{@valid_attrs | slug: String.duplicate("a", 61)}

      assert {:error,
              %Ecto.Changeset{errors: [slug: {"should be at most %{count} character(s)", _}]}} =
               Brands.create_brand(invalid_attrs)
    end

    test "trims whitespace from description" do
      attrs = %{@valid_attrs | description: "  whitespace description \n this too  "}

      assert {:ok, %Brand{} = brand} = Brands.create_brand(attrs)
      assert brand.description == "whitespace description \n this too"
    end

    test "with too long description returns error changeset" do
      invalid_attrs = %{@valid_attrs | description: String.duplicate("a", 1025)}

      assert {:error,
              %Ecto.Changeset{
                errors: [description: {"should be at most %{count} character(s)", _}]
              }} =
               Brands.create_brand(invalid_attrs)
    end

    test "with website without scheme returns error changeset" do
      invalid_attrs = %{@valid_attrs | website: "//some.com"}

      assert {:error,
              %Ecto.Changeset{errors: [website: {"must include a scheme (e.g. https)", _}]}} =
               Brands.create_brand(invalid_attrs)
    end

    test "with website without host returns error changeset" do
      invalid_attrs = %{@valid_attrs | website: "https:"}

      assert {:error, %Ecto.Changeset{errors: [website: {"must include a host", _}]}} =
               Brands.create_brand(invalid_attrs)
    end

    test "with website with invalid host returns error changeset" do
      invalid_attrs = %{@valid_attrs | website: "https://a"}

      assert {:error, %Ecto.Changeset{errors: [website: {"invalid host", _}]}} =
               Brands.create_brand(invalid_attrs)
    end

    test "with website with an invalid format returns error changeset" do
      invalid_attrs = %{@valid_attrs | website: "https://some.com/>"}

      assert {:error, %Ecto.Changeset{errors: [website: {"invalid format", _}]}} =
               Brands.create_brand(invalid_attrs)
    end

    test "with invalid website returns error changeset" do
      invalid_attrs = %{@valid_attrs | website: "some"}

      assert {:error,
              %Ecto.Changeset{errors: [website: {"must include a scheme (e.g. https)", _}]}} =
               Brands.create_brand(invalid_attrs)
    end

    test "with too long website returns error changeset" do
      invalid_attrs = %{@valid_attrs | website: "https://some.com/" <> String.duplicate("a", 64)}

      assert {:error,
              %Ecto.Changeset{errors: [website: {"should be at most %{count} character(s)", _}]}} =
               Brands.create_brand(invalid_attrs)
    end

    test "with invalid contact email returns error changeset" do
      invalid_attrs = %{@valid_attrs | contact_email: "some.email.com"}

      assert {:error,
              %Ecto.Changeset{errors: [contact_email: {"must have the @ sign and no spaces", _}]}} =
               Brands.create_brand(invalid_attrs)
    end

    test "with too long contact email returns error changeset" do
      invalid_attrs = %{@valid_attrs | contact_email: String.duplicate("a", 71) <> "@email.com"}

      assert {:error,
              %Ecto.Changeset{
                errors: [contact_email: {"should be at most %{count} character(s)", _}]
              }} = Brands.create_brand(invalid_attrs)
    end
  end

  describe "update_brand/2" do
    test "with valid data updates the brand" do
      brand = brand_fixture()

      update_attrs = %{
        name: "some update name",
        slug: "update-slug",
        description: "some update description",
        website: "https://update.com",
        contact_email: "update@email.com"
      }

      assert {:ok, %Brand{} = brand} = Brands.update_brand(brand, update_attrs)
      assert brand.name == "some update name"
      assert brand.slug == "update-slug"
      assert brand.description == "some update description"
      assert brand.website == "https://update.com"
      assert brand.contact_email == "update@email.com"
    end

    test "with invalid data returns error changeset" do
      brand = brand_fixture()
      assert {:error, %Ecto.Changeset{}} = Brands.update_brand(brand, @invalid_attrs)
      assert_equal(brand, Brands.get_brand!(brand.slug))
    end
  end

  test "change_brand/1 returns a brand changeset" do
    brand = brand_fixture()
    assert %Ecto.Changeset{} = Brands.change_brand(brand)
  end
end
