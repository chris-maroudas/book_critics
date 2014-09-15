# == Schema Information
#
# Table name: books
#
#  id               :integer          not null, primary key
#  title            :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  content          :text
#  author_id        :integer
#  searchable_terms :string(255)
#  slug             :string(255)
#

require 'elasticsearch/model'
require 'babosa'

class Book < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  extend FriendlyId
  friendly_id :title, use: :slugged

  # TODO:  Add skroutz API and get lower price
  # TODO: Add image and carrierwave
  # TODO: Active admin from Sitepoint
  # TODO: Add breacrumbs with Gretel
  # TODO: Add Smart listing  gem
  # TODO: Add pagination
  # TODO: Counter cache to books-authors
  # TODO: A normal user should apply to create an author
  # TODO: Should Accept nested attributes when an author doesn't exist
  # OPTIMIZE: Average rating to be stored in a DB field and be updated once a new review is posted

  acts_as_taggable

  belongs_to :author

  has_many :reviews, dependent: :destroy

  validates :author_id, presence: true

  before_save :add_searchable_terms

  scope :approved, -> { where(approved: true) }

  def self.reviewed
    all.select{ |book| book.reviews.approved.present? }
  end

  def calculate_average_rating
    self.average_rating = (reviews.approved.pluck(:rating).sum.to_f / reviews.approved.count).round(2)
    save
  end

  def self.highest_rated

  end

  def list_of_tags
    tag_list
  end

  def list_of_tags=(string)
    self.tag_list = string.downcase
  end

  def normalize_friendly_id(input)
    input.to_s.to_slug.normalize(transliterations: :greek).to_s
  end

  def should_generate_new_friendly_id?
    title_changed?
  end

  def add_searchable_terms
    self.searchable_terms = "#{title}, #{author.first_name} #{author.last_name}"
  end

  def self.search(query)
    __elasticsearch__.search(
      {
        query: {
          multi_match: {
            query: query,
            fields: ['searchable_terms']
          }
        },
        highlight: {
          pre_tags: ['<em><strong>'],
          post_tags: ['</em></strong>'],
          fields: {
            searchable_terms: {}
          }
        }
      }
    )
  end

end

# Index all book  from the DB to Elasticsearch
Book.import
