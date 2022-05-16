class CompanyAnalysisWorker
  include Sidekiq::Worker
  sidekiq_options :retry => false, :backtrace => true

  def perform(id)
    company = Company.find(id)
    if company
      meta = MetaInspector.new(company.website, :allow_redirections => false, faraday_options: { ssl: { verify: false } }, :connection_timeout => 5, :read_timeout => 5, :retries => 0)
      if meta and meta.images and meta.images.best
        company.image_url = meta.images.best
        company.save
      end
    end
  end

  def scrape(id)
    company = Company.find(id)
    if company
        job_id = ["scrape_company_", company.id, "_job_", SecureRandom.hex(8)].join
        SpiderWorker.perform_async(company.website, 1, job_id)
    end
  end

end

