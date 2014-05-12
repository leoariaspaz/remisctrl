require 'test_helper'

class TiposRellenoControllerTest < ActionController::TestCase
  setup do
    @tipo_relleno = tipos_relleno(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tipos_relleno)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tipo_relleno" do
    assert_difference('TipoRelleno.count') do
      post :create, tipo_relleno: { descripcion: @tipo_relleno.descripcion }
    end

    assert_redirected_to tipo_relleno_path(assigns(:tipo_relleno))
  end

  test "should show tipo_relleno" do
    get :show, id: @tipo_relleno
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tipo_relleno
    assert_response :success
  end

  test "should update tipo_relleno" do
    patch :update, id: @tipo_relleno, tipo_relleno: { descripcion: @tipo_relleno.descripcion }
    assert_redirected_to tipo_relleno_path(assigns(:tipo_relleno))
  end

  test "should destroy tipo_relleno" do
    assert_difference('TipoRelleno.count', -1) do
      delete :destroy, id: @tipo_relleno
    end

    assert_redirected_to tipos_relleno_path
  end
end
