defmodule PolishMeWeb.API.PolishJSONTest do
  use PolishMe.DataCase

  import PolishMe.BrandsFixtures
  import PolishMe.PolishesFixtures

  alias PolishMeWeb.API.PolishJSON

  describe "index/1" do
    test "converts list of internal polish data to user-friendly data" do
      params = %{polishes: [polish_fixture(), polish_fixture()]}

      assert %{polishes: [p | _ps]} = PolishJSON.index(params)
      assert Map.take(p, [:name, :description, :colors, :finishes, :brand]) == p
    end

    test "gracefully handles empty case" do
      params = %{polishes: []}

      assert %{polishes: []} = PolishJSON.index(params)
    end
  end

  describe "index_by_brand/1" do
    test "converts list of brand-specific internal polish data to user-friendly data" do
      brand = brand_fixture()

      params = %{
        brand: brand,
        polishes: [polish_fixture(%{brand_id: brand.id}), polish_fixture(%{brand_id: brand.id})]
      }

      assert %{brand: b, polishes: [p | _ps]} = PolishJSON.index_by_brand(params)
      assert Map.take(b, [:name, :description, :website, :contact_email]) == b
      assert Map.take(p, [:name, :description, :colors, :finishes]) == p
    end

    test "gracefully handles empty case" do
      params = %{brand: brand_fixture(), polishes: []}

      assert %{brand: _, polishes: []} = PolishJSON.index_by_brand(params)
    end
  end

  test "show/1 converts internal polish data to user-friendly data" do
    params = %{polish: polish_fixture()}

    assert %{polish: %{brand: b} = p} = PolishJSON.show(params)
    assert Map.take(p, [:name, :description, :colors, :finishes, :brand]) == p
    assert Map.take(b, [:name, :website]) == b
  end
end
