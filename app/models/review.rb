# == Schema Information
#
# Table name: reviews
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  content    :text
#  created_at :datetime
#  updated_at :datetime
#  rating     :integer
#  book_id    :integer
#  user_id    :integer
#

class Review < ActiveRecord::Base

  belongs_to :user
  belongs_to :review

end
