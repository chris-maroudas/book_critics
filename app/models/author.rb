# == Schema Information
#
# Table name: authors
#
#  id         :integer          not null, primary key
#  first_name :string(255)
#  last_name  :string(255)
#  age        :integer
#  bio        :text
#  created_at :datetime
#  updated_at :datetime
#  approved   :boolean          default(FALSE)
#

class Author < ActiveRecord::Base

  has_many :books, dependent: :destroy

  # TODO: Add friendly_id
  # TODO: Add image with carrierwave

  scope :approved, -> { where(approved: true) }


  def full_name
    "#{first_name} #{last_name}"
  end

  alias :to_s :full_name
end
