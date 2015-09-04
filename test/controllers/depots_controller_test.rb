require 'test_helper'

class DepotsControllerTest < ActionController::TestCase
  setup do
    @depot = depots(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:depots)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create depot" do
    assert_difference('Depot.count') do
      post :create, depot: { address: @depot.address, company_id: @depot.company_id, duration: @depot.duration, user_id: @depot.user_id }
    end

    assert_redirected_to depot_path(assigns(:depot))
  end

  test "should show depot" do
    get :show, id: @depot
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @depot
    assert_response :success
  end

  test "should update depot" do
    patch :update, id: @depot, depot: { address: @depot.address, company_id: @depot.company_id, duration: @depot.duration, user_id: @depot.user_id }
    assert_redirected_to depot_path(assigns(:depot))
  end

  test "should destroy depot" do
    assert_difference('Depot.count', -1) do
      delete :destroy, id: @depot
    end

    assert_redirected_to depots_path
  end
end
