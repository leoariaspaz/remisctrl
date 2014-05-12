require 'test_helper'

class ConfiguracionesControllerTest < ActionController::TestCase
  setup do
    @configuracion = configuraciones(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:configuraciones)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create configuracion" do
    assert_difference('Configuracion.count') do
      post :create, configuracion: { fecha_proceso: @configuracion.fecha_proceso }
    end

    assert_redirected_to configuracion_path(assigns(:configuracion))
  end

  test "should show configuracion" do
    get :show, id: @configuracion
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @configuracion
    assert_response :success
  end

  test "should update configuracion" do
    patch :update, id: @configuracion, configuracion: { fecha_proceso: @configuracion.fecha_proceso }
    assert_redirected_to configuracion_path(assigns(:configuracion))
  end

  test "should destroy configuracion" do
    assert_difference('Configuracion.count', -1) do
      delete :destroy, id: @configuracion
    end

    assert_redirected_to configuraciones_path
  end
end
