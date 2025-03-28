class Departments::Cardiology::AdmissionsController < ApplicationController

	def index
		@admissions = Admission.all
	end
end