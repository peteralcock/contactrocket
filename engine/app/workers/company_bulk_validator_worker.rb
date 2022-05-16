class CompanyBulkValidatorWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false, :backtrace => true, :queue => 'evil'

  def perform(domain)
    companies = Company.where(:domain => domain)
    if companies
        companies.each do |company|
          company.update(:note => "IAMOK")
      end
    end
    end
end



