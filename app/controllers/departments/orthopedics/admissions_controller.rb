class Departments::Orthopedics::AdmissionsController < ApplicationController

	def index
		@admissions = Admission.all
	end
end