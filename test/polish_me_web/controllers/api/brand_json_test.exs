defmodule PolishMeWeb.API.BrandJSONTest do
  use PolishMe.DataCase

  import PolishMe.BrandsFixtures

  alias PolishMeWeb.API.BrandJSON

  describe "index/1" do
    test "converts list of internal brand data to user-friendly data" do
      brands = %{brands: [brand_fixture(), brand_fixture()]}

      assert %{brands: [b | _bs]} = BrandJSON.index(brands)
      assert Map.take(b, [:name, :description, :website, :contact_email]) == b
    end

    test "gracefully handles empty case" do
      brands = %{brands: []}

      assert %{brands: []} = BrandJSON.index(brands)
    end
  end
end
