defmodule PolishMe.TextHelpersTest do
  use PolishMe.DataCase

  alias PolishMeWeb.Helpers.TextHelpers

  describe "name_to_slug/1" do
    test "handles nil" do
      assert TextHelpers.name_to_slug(nil) == nil
    end

    test "handles empty string" do
      assert TextHelpers.name_to_slug("") == nil
    end

    test "lowercases entire string" do
      assert TextHelpers.name_to_slug("ABcD") == "abcd"
    end

    test "removes '" do
      assert TextHelpers.name_to_slug("A's") == "as"
    end

    test "replaces & with n" do
      assert TextHelpers.name_to_slug("&") == "n"
    end

    test "replaces all other symbols and whitespace with -" do
      assert TextHelpers.name_to_slug("A;-;b#$--c") == "a-b-c"
    end

    test "trims surrounding dashes" do
      assert TextHelpers.name_to_slug("-a-;_;") == "a"
    end
  end

  describe "enums_to_string/2" do
    test "handles nil" do
      assert TextHelpers.enums_to_string(nil) == nil
    end

    test "handles empty list" do
      assert TextHelpers.enums_to_string([]) == ""
    end

    test "converts atoms to capitalized words" do
      assert TextHelpers.enums_to_string([:ab_cd]) == "Ab Cd"
    end

    test "converts enum list to comma-delimited string by default" do
      assert TextHelpers.enums_to_string([:a, :bc]) == "A, Bc"
    end

    test "converts enum list to string with given delimiter" do
      assert TextHelpers.enums_to_string([:a, :bc], "<br />") == "A<br />Bc"
    end
  end

  describe "enums_to_string_map/1" do
    test "handles nil" do
      assert TextHelpers.enums_to_string_map(nil) == nil
    end

    test "handles empty list" do
      assert TextHelpers.enums_to_string_map([]) == []
    end

    test "converts enum list to name-atom map" do
      assert TextHelpers.enums_to_string_map([:a, :bc]) == [{"A", :a}, {"Bc", :bc}]
    end
  end

  describe "atom_to_string/1" do
    test "handles nil" do
      assert TextHelpers.atom_to_string(nil) == nil
    end

    test "converts atom to formatted string" do
      assert TextHelpers.atom_to_string(:ab_cd) == "Ab Cd"
    end
  end
end
