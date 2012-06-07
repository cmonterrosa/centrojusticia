require 'test_helper'

class OrientacionsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:orientacions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create orientacion" do
    assert_difference('Orientacion.count') do
      post :create, :orientacion => { }
    end

    assert_redirected_to orientacion_path(assigns(:orientacion))
  end

  test "should show orientacion" do
    get :show, :id => orientacions(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => orientacions(:one).to_param
    assert_response :success
  end

  test "should update orientacion" do
    put :update, :id => orientacions(:one).to_param, :orientacion => { }
    assert_redirected_to orientacion_path(assigns(:orientacion))
  end

  test "should destroy orientacion" do
    assert_difference('Orientacion.count', -1) do
      delete :destroy, :id => orientacions(:one).to_param
    end

    assert_redirected_to orientacions_path
  end
end
