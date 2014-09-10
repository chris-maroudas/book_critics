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
#

class Author < ActiveRecord::Base
  has_many :books
end
