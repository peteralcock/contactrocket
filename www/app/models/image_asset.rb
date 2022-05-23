class ImageAsset < ActiveRecord::Base
  def as_json
    {
        id: self.id,
        image_url: self.image_url
    }
  end

end
