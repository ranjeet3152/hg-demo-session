class PatientsController < ApplicationController
  def index
    @patients = Patient.all
  end

  def new
    @patient = Patient.new
  end

  def show
    @patient = Patient.find_by(id: params[:id])
  end

  def create
    @patient = Patient.new(patient_params)

    if @patient.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to patients_path, notice: "Patient created successfully." }
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("form_container", partial: "patients/form", locals: { patient: @patient }) }
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  private

  def patient_params
    params.require(:patient).permit(:fullname, :age, :phone_number)
  end
end