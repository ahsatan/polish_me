defmodule PolishMe.StashTest do
  use PolishMe.DataCase

  import PolishMe.AccountsFixtures, only: [user_scope_fixture: 0]
  import PolishMe.PolishesFixtures
  import PolishMe.StashFixtures

  alias PolishMe.Stash
  alias PolishMe.Stash.StashPolish

  @valid_attrs %{
    status: :panned,
    thoughts: "some thoughts",
    fill_percent: 42,
    purchase_price: 42,
    purchase_date: ~D[2025-05-02],
    swatched: true
  }

  @invalid_attrs %{
    status: nil,
    thoughts: nil,
    fill_percent: nil,
    purchase_price: nil,
    purchase_date: nil,
    swatched: nil
  }

  defp add_polish(attrs) do
    polish = polish_fixture()
    Map.put(attrs, :polish_id, polish.id)
  end

  test "list_stash_polishes/1 returns all scoped stash_polishes" do
    scope = user_scope_fixture()
    other_scope = user_scope_fixture()
    stash_polish = stash_polish_fixture(scope)
    other_stash_polish = stash_polish_fixture(other_scope)

    assert Stash.list_stash_polishes(scope) == [stash_polish]
    assert Stash.list_stash_polishes(other_scope) == [other_stash_polish]
  end

  test "get_stash_polish!/2 returns the stash_polish with given slugs" do
    scope = user_scope_fixture()
    stash_polish = stash_polish_fixture(scope)
    other_scope = user_scope_fixture()

    assert Stash.get_stash_polish!(
             scope,
             stash_polish.polish.brand.slug,
             stash_polish.polish.slug
           ) == stash_polish

    assert_raise Ecto.NoResultsError, fn ->
      Stash.get_stash_polish!(
        other_scope,
        stash_polish.polish.brand.slug,
        stash_polish.polish.slug
      )
    end
  end

  describe "create_stash_polish/2" do
    test "with valid data creates a stash_polish" do
      scope = user_scope_fixture()

      assert {:ok, %StashPolish{} = stash_polish} =
               Stash.create_stash_polish(scope, add_polish(@valid_attrs))

      assert stash_polish.status == :panned
      assert stash_polish.thoughts == "some thoughts"
      assert stash_polish.fill_percent == 42
      assert %Money{amount: 42} == stash_polish.purchase_price
      assert stash_polish.purchase_date == ~D[2025-05-02]
      assert stash_polish.swatched == true
      assert stash_polish.user_id == scope.user.id
      assert stash_polish.polish_id
    end

    test "with same user and polish returns error changeset" do
      scope = user_scope_fixture()
      polish = polish_fixture()
      attrs = @valid_attrs |> Map.put(:polish_id, polish.id)

      Stash.create_stash_polish(scope, attrs)

      assert {:error,
              %Ecto.Changeset{
                errors: [
                  polish_id: {"stashed polish must be unique per user", _}
                ]
              }} = Stash.create_stash_polish(scope, attrs)
    end

    test "without status defaults to :in_stash" do
      invalid_attrs = @valid_attrs |> Map.delete(:status) |> add_polish()

      assert {:ok, %StashPolish{} = stash_polish} =
               Stash.create_stash_polish(user_scope_fixture(), invalid_attrs)

      assert stash_polish.status == :in_stash
    end

    test "trims whitespace from thoughts" do
      attrs = %{@valid_attrs | thoughts: "  whitespace thoughts  "} |> add_polish()

      assert {:ok, %StashPolish{} = stash_polish} =
               Stash.create_stash_polish(user_scope_fixture(), attrs)

      assert stash_polish.thoughts == "whitespace thoughts"
    end

    test "with too long thoughts returns error changeset" do
      invalid_attrs = %{@valid_attrs | thoughts: String.duplicate("a", 1025)} |> add_polish()

      assert {:error,
              %Ecto.Changeset{
                errors: [thoughts: {"should be at most %{count} character(s)", _}]
              }} = Stash.create_stash_polish(user_scope_fixture(), invalid_attrs)
    end

    test "without fill_percent defaults to 100" do
      invalid_attrs = @valid_attrs |> Map.delete(:fill_percent) |> add_polish()

      assert {:ok, %StashPolish{} = stash_polish} =
               Stash.create_stash_polish(user_scope_fixture(), invalid_attrs)

      assert stash_polish.fill_percent == 100
    end

    test "with fill_percent < 0 returns error changeset" do
      invalid_attrs = @valid_attrs |> Map.put(:fill_percent, -1) |> add_polish()

      assert {:error,
              %Ecto.Changeset{
                errors: [fill_percent: {"must be greater than or equal to %{number}", _}]
              }} =
               Stash.create_stash_polish(user_scope_fixture(), invalid_attrs)
    end

    test "with fill_percent > 100 returns error changeset" do
      invalid_attrs = @valid_attrs |> Map.put(:fill_percent, 101) |> add_polish()

      assert {:error,
              %Ecto.Changeset{
                errors: [fill_percent: {"must be less than or equal to %{number}", _}]
              }} =
               Stash.create_stash_polish(user_scope_fixture(), invalid_attrs)
    end

    test "without swatched status defaults to false" do
      invalid_attrs = @valid_attrs |> Map.delete(:swatched) |> add_polish()

      assert {:ok, %StashPolish{} = stash_polish} =
               Stash.create_stash_polish(user_scope_fixture(), invalid_attrs)

      assert stash_polish.swatched == false
    end

    test "without polish returns error changeset" do
      assert {:error, %Ecto.Changeset{errors: [polish_id: {"can't be blank", _}]}} =
               Stash.create_stash_polish(user_scope_fixture(), @valid_attrs)
    end
  end

  describe "update_stash_polish/3" do
    test "with valid data updates the stash_polish" do
      scope = user_scope_fixture()
      stash_polish = stash_polish_fixture(scope)

      update_attrs = %{
        status: :destashed,
        thoughts: "update thoughts",
        fill_percent: 43,
        purchase_price: 43,
        purchase_date: ~D[2025-05-04],
        swatched: false
      }

      assert {:ok, %StashPolish{} = stash_polish} =
               Stash.update_stash_polish(scope, stash_polish, update_attrs)

      assert stash_polish.status == :destashed
      assert stash_polish.thoughts == "update thoughts"
      assert stash_polish.fill_percent == 43
      assert assert %Money{amount: 43} == stash_polish.purchase_price
      assert stash_polish.purchase_date == ~D[2025-05-04]
      assert stash_polish.swatched == false
    end

    test "with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      stash_polish = stash_polish_fixture(scope)

      assert_raise MatchError, fn ->
        Stash.update_stash_polish(other_scope, stash_polish, %{})
      end
    end

    test "with polish update does not update stash_polish" do
      scope = user_scope_fixture()
      stash_polish = stash_polish_fixture(scope)
      polish = polish_fixture()
      invalid_attrs = %{polish_id: polish.id}

      # Ecto intentionally doesn't error when updating :insert only :writable field, instead discards change
      assert {:ok, %StashPolish{} = ^stash_polish} =
               Stash.update_stash_polish(scope, stash_polish, invalid_attrs)
    end

    test "with invalid data returns error changeset" do
      scope = user_scope_fixture()
      stash_polish = stash_polish_fixture(scope)

      assert {:error, %Ecto.Changeset{}} =
               Stash.update_stash_polish(scope, stash_polish, @invalid_attrs)

      assert stash_polish ==
               Stash.get_stash_polish!(
                 scope,
                 stash_polish.polish.brand.slug,
                 stash_polish.polish.slug
               )
    end
  end

  describe "delete_stash_polish/2" do
    test "deletes the stash_polish" do
      scope = user_scope_fixture()
      stash_polish = stash_polish_fixture(scope)

      assert {:ok, %StashPolish{}} = Stash.delete_stash_polish(scope, stash_polish)

      assert_raise Ecto.NoResultsError, fn ->
        Stash.get_stash_polish!(scope, stash_polish.polish.brand.slug, stash_polish.polish.slug)
      end
    end

    test "with invalid scope raises" do
      scope = user_scope_fixture()
      other_scope = user_scope_fixture()
      stash_polish = stash_polish_fixture(scope)

      assert_raise MatchError, fn -> Stash.delete_stash_polish(other_scope, stash_polish) end
    end
  end

  test "change_stash_polish/2 returns a stash_polish changeset" do
    scope = user_scope_fixture()
    stash_polish = stash_polish_fixture(scope)

    assert %Ecto.Changeset{} = Stash.change_stash_polish(scope, stash_polish)
  end
end
