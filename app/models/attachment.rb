class Attachment < ApplicationRecord
  belongs_to :attacheble, polymorphic: true
  has_one_attached :file 
end
