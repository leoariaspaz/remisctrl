class LogsEstadoController < ApplicationController
	def index
		params.permit(:model_name, :id, :page)
		t = params[:model_name].classify.constantize.find(params[:id]).logs.paginate(page: params[:page], per_page: 5)
		render partial: 'list', locals: {logs: t, model_name: params[:model_name]}
	end
end