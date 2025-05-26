defmodule PolishMeWeb.API.BrandJSONTest do
  use PolishMe.DataCase

  import PolishMe.BrandsFixtures

  alias PolishMeWeb.API.BrandJSON

  describe "index/1" do
    test "converts list of internal brand data to user-friendly data" do
      params = %{brands: [brand_fixture(), brand_fixture()]}

      assert %{brands: [b | _bs]} = BrandJSON.index(params)
      assert Map.take(b, [:name, :description, :website, :contact_email]) == b
    end

    test "gracefully handles empty case" do
      brands = %{brands: []}

      assert %{brands: []} = BrandJSON.index(brands)
    end
  end

  test "show/1 converts internal brand data to user-friendly data" do
    params = %{brand: brand_fixture()}

    assert %{brand: b} = BrandJSON.show(params)
    assert Map.take(b, [:name, :description, :website, :contact_email]) == b
  end
end
