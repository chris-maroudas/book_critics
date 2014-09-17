# == Schema Information
#
# Table name: likes
#
#  id         :integer          not null, primary key
#  book_id    :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Like < ActiveRecord::Base

  belongs_to :book
  belongs_to :user

  validates_uniqueness_of :book_id, scope: :user_id
end
