# == Schema Information
#
# Table name: books
#
#  id                     :integer          not null, primary key
#  title                  :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  content                :text
#  author_id              :integer
#  searchable_terms       :string(255)
#  slug                   :string(255)
#  average_rating         :float
#  reviews_count          :integer
#  approved               :boolean          default(FALSE)
#  approved_reviews_count :integer
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
  # TODO: A normal user should apply to create an author
  # TODO: Should Accept nested attributes when an author doesn't exist
  # TODO: Elastic search and autocomplete search only approved books
  # TODO: Check gem choice for tags
  # TODO: Add "Want to read" using redis(?)
  # TODO: Add methods to bring images from IMDB like in movie store

  acts_as_taggable

  # Associations
  belongs_to :author
  has_many :reviews, dependent: :destroy

  # Validations
  validates :author_id, presence: true

  # Callbacks
  before_save :add_searchable_terms

  # Scopes
  scope :approved, -> { where(approved: true) }

  # Must have at least one approved article
  scope :reviewed, -> do
    includes(:reviews).where.not(reviews: { approved: false })
  end

  scope :highest_rated, -> { reviewed.order("average_rating DESC") }


  # Methods
  def reviewed?
    reviews.approved.present?
  end

  def approved_reviews
    reviews.approved
  end

  def calculate_average_rating
    self.average_rating = (reviews.approved.pluck(:rating).sum.to_f / reviews.approved.count).round(2)
    save
  end

  # Virtual attribute, servers as a wrapper for acts_as_taggable
  def list_of_tags
    tag_list
  end

  def list_of_tags=(string)
    self.tag_list = string.downcase
  end


  # Friendly ID
  # Convert greek characters to english through babosa
  def normalize_friendly_id(input)
    input.to_s.to_slug.normalize(transliterations: :greek).to_s
  end

  # Regenerate new slug if title is changed
  def should_generate_new_friendly_id?
    title_changed?
  end

  # Autocomplete and elastic search field
  def add_searchable_terms
    self.searchable_terms = "#{title}, #{author.first_name} #{author.last_name}"
  end

  # Elastic Search customization
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
