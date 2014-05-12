require 'test_helper'

class RellenosControllerTest < ActionController::TestCase
  setup do
    @relleno = rellenos(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:rellenos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create relleno" do
    assert_difference('Relleno.count') do
      post :create, relleno: { codigo: @relleno.codigo, descripcion: @relleno.descripcion, habilitado: @relleno.habilitado, sintetico: @relleno.sintetico, tipo_relleno_id: @relleno.tipo_relleno_id }
    end

    assert_redirected_to relleno_path(assigns(:relleno))
  end

  test "should show relleno" do
    get :show, id: @relleno
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @relleno
    assert_response :success
  end

  test "should update relleno" do
    patch :update, id: @relleno, relleno: { codigo: @relleno.codigo, descripcion: @relleno.descripcion, habilitado: @relleno.habilitado, sintetico: @relleno.sintetico, tipo_relleno_id: @relleno.tipo_relleno_id }
    assert_redirected_to relleno_path(assigns(:relleno))
  end

  test "should destroy relleno" do
    assert_difference('Relleno.count', -1) do
      delete :destroy, id: @relleno
    end

    assert_redirected_to rellenos_path
  end
end
