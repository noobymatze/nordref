defmodule NordrefWeb.CourseRegistrationLiveTest do
  use NordrefWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Nordref.Courses

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp fixture(:course_registration) do
    {:ok, course_registration} = Courses.create_course_registration(@create_attrs)
    course_registration
  end

  defp create_course_registration(_) do
    course_registration = fixture(:course_registration)
    %{course_registration: course_registration}
  end

  describe "Index" do
    setup [:create_course_registration]

    test "lists all courses", %{conn: conn, course_registration: course_registration} do
      {:ok, _index_live, html} = live(conn, Routes.course_registration_index_path(conn, :index))

      assert html =~ "Listing Courses"
    end

    test "saves new course_registration", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.course_registration_index_path(conn, :index))

      assert index_live |> element("a", "New Course registration") |> render_click() =~
        "New Course registration"

      assert_patch(index_live, Routes.course_registration_index_path(conn, :new))

      assert index_live
             |> form("#course_registration-form", course_registration: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#course_registration-form", course_registration: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.course_registration_index_path(conn, :index))

      assert html =~ "Course registration created successfully"
    end

    test "updates course_registration in listing", %{conn: conn, course_registration: course_registration} do
      {:ok, index_live, _html} = live(conn, Routes.course_registration_index_path(conn, :index))

      assert index_live |> element("#course_registration-#{course_registration.id} a", "Edit") |> render_click() =~
        "Edit Course registration"

      assert_patch(index_live, Routes.course_registration_index_path(conn, :edit, course_registration))

      assert index_live
             |> form("#course_registration-form", course_registration: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#course_registration-form", course_registration: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.course_registration_index_path(conn, :index))

      assert html =~ "Course registration updated successfully"
    end

    test "deletes course_registration in listing", %{conn: conn, course_registration: course_registration} do
      {:ok, index_live, _html} = live(conn, Routes.course_registration_index_path(conn, :index))

      assert index_live |> element("#course_registration-#{course_registration.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#course_registration-#{course_registration.id}")
    end
  end

  describe "Show" do
    setup [:create_course_registration]

    test "displays course_registration", %{conn: conn, course_registration: course_registration} do
      {:ok, _show_live, html} = live(conn, Routes.course_registration_show_path(conn, :show, course_registration))

      assert html =~ "Show Course registration"
    end

    test "updates course_registration within modal", %{conn: conn, course_registration: course_registration} do
      {:ok, show_live, _html} = live(conn, Routes.course_registration_show_path(conn, :show, course_registration))

      assert show_live |> element("a", "Edit") |> render_click() =~
        "Edit Course registration"

      assert_patch(show_live, Routes.course_registration_show_path(conn, :edit, course_registration))

      assert show_live
             |> form("#course_registration-form", course_registration: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#course_registration-form", course_registration: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.course_registration_show_path(conn, :show, course_registration))

      assert html =~ "Course registration updated successfully"
    end
  end
end
