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
#  approved   :boolean          default(FALSE)
#

class Review < ActiveRecord::Base

  belongs_to :user
  belongs_to :book, counter_cache: true

  validates :book_id, presence: true
  # TODO: Add unique validation to user_id, scope: book_id

  scope :approved, -> { where(approved: true) }

  after_save :recalculate_books_avg_rating, :update_books_approved_reviews_count
  after_destroy :recalculate_books_avg_rating, :update_books_approved_reviews_count

  def recalculate_books_avg_rating
    book.delay.calculate_average_rating unless book.blank?
  end

  # Update custom counter cache
  def update_books_approved_reviews_count
    unless book.blank?
      self.book.approved_reviews_count = book.reviews.approved.count
      book.save
    end
  end


end
