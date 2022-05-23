require 'rails_helper'

describe Company do
  before(:all) { @record = Company.new }
  subject { @record }
  it { should respond_to(:city) }
  it { should respond_to(:state) }
  it { should respond_to(:address) }
  it { should respond_to(:country) }
  it { should respond_to(:website) }
  it { should respond_to(:industry) }
  it { should respond_to(:tags) }
  it { should respond_to(:score) }
  it { should respond_to(:company_name) }
  it { should respond_to(:contact_person) }
  it { should respond_to(:contact_person_title) }
end
