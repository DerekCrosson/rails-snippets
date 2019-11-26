# Get single attachment URL
def avatar_url
  if self.avatar.attached?
    Rails.application.routes.url_helpers.rails_blob_path(self.avatar, only_path: true)
  else
    nil
  end
end

# The above assumes you have a single attachment in your model like this: has_one_attached :avatar (change attachment name accordingly).
# Put this method in the model which has the attachment.
# Usage (in controller): render json: @user, methods: :avatar_url, status: :ok

# Get multiple attachment URLs
def photos
  if self.images.attached?
    self.images.collect { |image| [ "url", Rails.application.routes.url_helpers.rails_blob_path(image, only_path: true) ] }
  else
    nil
  end
end

# The above assumes you have multiple attachments in your model like this: has_many_attached :images (change attachment name accordingly).
# Put this method in the model which has the attachments.
# Usage (in controller): render json: @business, methods: :photos, status: :ok
