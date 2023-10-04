module Attachable
  extend ActiveSupport::Concern

  included do
    has_one :attachment, as: :attacheble  
    accepts_nested_attributes_for :attachment
  end
end