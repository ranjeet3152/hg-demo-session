class Patient
  include Mongoid::Document
  include Mongoid::Timestamps
  field :fullname, type: String
  field :age, type: Integer
  field :phone_number, type: String
end