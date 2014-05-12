require 'test_helper'

class MovilesControllerTest < ActionController::TestCase
  setup do
    @movil = moviles(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:moviles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create movil" do
    assert_difference('Movil.count') do
      post :create, movil: { agencia_id: @movil.agencia_id, chofer_id: @movil.chofer_id, dominio: @movil.dominio, estado_id: @movil.estado_id, fecha_estado: @movil.fecha_estado, marca: @movil.marca, modelo: @movil.modelo, nromovil: @movil.nromovil, propietario_id: @movil.propietario_id }
    end

    assert_redirected_to movil_path(assigns(:movil))
  end

  test "should show movil" do
    get :show, id: @movil
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @movil
    assert_response :success
  end

  test "should update movil" do
    patch :update, id: @movil, movil: { agencia_id: @movil.agencia_id, chofer_id: @movil.chofer_id, dominio: @movil.dominio, estado_id: @movil.estado_id, fecha_estado: @movil.fecha_estado, marca: @movil.marca, modelo: @movil.modelo, nromovil: @movil.nromovil, propietario_id: @movil.propietario_id }
    assert_redirected_to movil_path(assigns(:movil))
  end

  test "should destroy movil" do
    assert_difference('Movil.count', -1) do
      delete :destroy, id: @movil
    end

    assert_redirected_to moviles_path
  end
end
