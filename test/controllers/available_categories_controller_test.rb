require 'test_helper'

class AvailableCategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @available_category = available_categories(:one)
  end

  test "should get index" do
    get available_categories_url
    assert_response :success
  end

  test "should get new" do
    get new_available_category_url
    assert_response :success
  end

  test "should create available_category" do
    assert_difference('AvailableCategory.count') do
      post available_categories_url, params: { available_category: { color: @available_category.color, icon: @available_category.icon, name: @available_category.name } }
    end

    assert_redirected_to available_category_url(AvailableCategory.last)
  end

  test "should show available_category" do
    get available_category_url(@available_category)
    assert_response :success
  end

  test "should get edit" do
    get edit_available_category_url(@available_category)
    assert_response :success
  end

  test "should update available_category" do
    patch available_category_url(@available_category), params: { available_category: { color: @available_category.color, icon: @available_category.icon, name: @available_category.name } }
    assert_redirected_to available_category_url(@available_category)
  end

  test "should destroy available_category" do
    assert_difference('AvailableCategory.count', -1) do
      delete available_category_url(@available_category)
    end

    assert_redirected_to available_categories_url
  end
end
