defmodule PolishMeWeb.API.PolishJSONTest do
  use PolishMe.DataCase

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

  test "show/1 converts internal polish data to user-friendly data" do
    params = %{polish: polish_fixture()}

    assert %{polish: %{brand: b} = p} = PolishJSON.show(params)
    assert Map.take(p, [:name, :description, :colors, :finishes, :brand]) == p
    assert Map.take(b, [:name, :website]) == b
  end
end
