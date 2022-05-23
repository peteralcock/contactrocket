module Api::V1
  class TargetsController < ApiController

      def create
          url = params[:url]
          unless url.match(/https?:\/\/.*$/i) or url.match(/http?:\/\/.*$/i) or url.match("http")
            url = "http://#{url}"
          end
          job_id = SecureRandom.hex(12)
          user_id = target_params[:user_id] || 1
          qid = SpiderWorker.perform_async(url, user_id, job_id, 150, 2200, false)
          if qid
            render :json => {:qid => qid, :url => url}
          else
            render status: :unprocessable_entity
          end
      end

  def target_params
    params.permit(:url)
  end

  end
end

