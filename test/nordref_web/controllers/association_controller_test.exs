defmodule NordrefWeb.AssociationControllerTest do
  use NordrefWeb.ConnCase

  alias Nordref.Associations

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  def fixture(:association) do
    {:ok, association} = Associations.create_association(@create_attrs)
    association
  end

  describe "index" do
    test "lists all associations", %{conn: conn} do
      conn = get(conn, Routes.association_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Associations"
    end
  end

  describe "new association" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.association_path(conn, :new))
      assert html_response(conn, 200) =~ "New Association"
    end
  end

  describe "create association" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.association_path(conn, :create), association: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.association_path(conn, :show, id)

      conn = get(conn, Routes.association_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Association"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.association_path(conn, :create), association: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Association"
    end
  end

  describe "edit association" do
    setup [:create_association]

    test "renders form for editing chosen association", %{conn: conn, association: association} do
      conn = get(conn, Routes.association_path(conn, :edit, association))
      assert html_response(conn, 200) =~ "Edit Association"
    end
  end

  describe "update association" do
    setup [:create_association]

    test "redirects when data is valid", %{conn: conn, association: association} do
      conn = put(conn, Routes.association_path(conn, :update, association), association: @update_attrs)
      assert redirected_to(conn) == Routes.association_path(conn, :show, association)

      conn = get(conn, Routes.association_path(conn, :show, association))
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, association: association} do
      conn = put(conn, Routes.association_path(conn, :update, association), association: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Association"
    end
  end

  describe "delete association" do
    setup [:create_association]

    test "deletes chosen association", %{conn: conn, association: association} do
      conn = delete(conn, Routes.association_path(conn, :delete, association))
      assert redirected_to(conn) == Routes.association_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.association_path(conn, :show, association))
      end
    end
  end

  defp create_association(_) do
    association = fixture(:association)
    %{association: association}
  end
end
