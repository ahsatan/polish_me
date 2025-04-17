defmodule PolishMe.BrandsTest do
  use PolishMe.DataCase

  alias PolishMe.Brands

  describe "brands" do
    alias PolishMe.Brands.Brand

    import PolishMe.BrandsFixtures

    @invalid_attrs %{name: nil, description: nil, slug: nil, website: nil, contact_email: nil}

    test "list_brands/0 returns all brands" do
      brand = brand_fixture()
      other_brand = brand_fixture()
      assert Brands.list_brands() == [brand, other_brand]
    end

    test "get_brand!/1 returns the brand with given slug" do
      brand = brand_fixture()
      assert Brands.get_brand!(brand.slug) == brand
      assert_raise Ecto.NoResultsError, fn -> Brands.get_brand!("x" <> brand.slug) end
    end

    test "create_brand/1 with valid data creates a brand" do
      valid_attrs = %{
        name: "some name",
        description: "some description",
        slug: "some slug",
        website: "some website",
        contact_email: "some contact_email"
      }

      assert {:ok, %Brand{} = brand} = Brands.create_brand(valid_attrs)
      assert brand.name == "some name"
      assert brand.description == "some description"
      assert brand.slug == "some slug"
      assert brand.website == "some website"
      assert brand.contact_email == "some contact_email"
    end

    test "create_brand/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Brands.create_brand(@invalid_attrs)
    end

    test "update_brand/2 with valid data updates the brand" do
      brand = brand_fixture()

      update_attrs = %{
        name: "some updated name",
        description: "some updated description",
        slug: "some updated slug",
        website: "some updated website",
        contact_email: "some updated contact_email"
      }

      assert {:ok, %Brand{} = brand} = Brands.update_brand(brand, update_attrs)
      assert brand.name == "some updated name"
      assert brand.description == "some updated description"
      assert brand.slug == "some updated slug"
      assert brand.website == "some updated website"
      assert brand.contact_email == "some updated contact_email"
    end

    test "update_brand/2 with invalid data returns error changeset" do
      brand = brand_fixture()
      assert {:error, %Ecto.Changeset{}} = Brands.update_brand(brand, @invalid_attrs)
      assert brand == Brands.get_brand!(brand.slug)
    end

    test "change_brand/1 returns a brand changeset" do
      brand = brand_fixture()
      assert %Ecto.Changeset{} = Brands.change_brand(brand)
    end
  end
end
