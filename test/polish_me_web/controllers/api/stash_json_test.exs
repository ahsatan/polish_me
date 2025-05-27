defmodule PolishMeWeb.API.StashJSONTest do
  use PolishMe.DataCase

  import PolishMe.AccountsFixtures
  import PolishMe.StashFixtures

  alias PolishMeWeb.API.StashJSON

  describe "index/1" do
    test "converts list of internal polish data to user-friendly data" do
      scope = user_scope_fixture()
      params = %{stash_polishes: [stash_polish_fixture(scope), stash_polish_fixture(scope)]}

      assert %{stash_polishes: [sp | _sps]} = StashJSON.index(params)

      assert Map.take(sp, [
               :status,
               :thoughts,
               :fill_percent,
               :purchase_price,
               :purchase_date,
               :swatched,
               :polish
             ]) == sp
    end

    test "gracefully handles empty case" do
      params = %{stash_polishes: []}

      assert %{stash_polishes: []} = StashJSON.index(params)
    end
  end
end
