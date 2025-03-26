class Departments::AppointmentsController < ApplicationController

	def index
		@appointments = Appointment.all
	end

	def new
		@appointment = Appointment.new
		@patient = Patient.find_by(id: params[:patient_id])
		respond_to do |format|
      format.html
      format.turbo_stream { render :new }
    end
	end

	def create
		@appointment = Appointment.new(appointment_params)
		@patient = Patient.find_by(id: params[:appointment][:patient_id])
		if @appointment.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to appintments_path, notice: "Appointment created successfully." }
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("form_container", partial: "appointments/form", locals: { appointment: @appointment }) }
        format.html { render :new, status: :unprocessable_entity }
      end
    end
	end

	private

	def appointment_params
		params.require(:appointment).permit(:patient_id, :patient_name, :status, :department_name)
	end
end