class Appointment
  include Mongoid::Document
  include Mongoid::Timestamps
  field :patient_name, type: String
  field :patient_id, type: BSON::ObjectId
  field :status, type: String
  field :doctor_name, type: String
  field :doctor_id, type: BSON::ObjectId
  field :department_id, type: BSON::ObjectId
  field :department_name, type: String
end