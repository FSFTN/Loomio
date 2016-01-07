class Attachment < ActiveRecord::Base
  belongs_to :user
  belongs_to :comment, counter_cache: true

  validates_presence_of :filename, :location, :user_id

  # before_destroy :delete_from_storage

  alias_method :author, :user
  alias_method :author=, :user=
  #alias_method :author_id, :user_id
  #alias_method :author_id=, :user_id=

  def is_an_image?
    %w[jpg jpeg png gif].include?(filetype)
  end

  def truncated_filename(length = 30)
    if filename.length > length
      filename.truncate(length) + filetype
    else
      filename
    end
  end

  def filetype
    (file_content_type.try(:split, '/') || filename.try(:split, '.')).last.downcase
  end

  def filename
    super || file_file_name
  end

  def filesize
    super || file_file_size
  end

  def location
    self[:location] || file.url(:original)
  end
  alias :original :location

end
