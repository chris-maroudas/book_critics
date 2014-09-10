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
#

require 'elasticsearch/model'
require 'babosa'

class Book < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  extend FriendlyId
  friendly_id :title, use: :slugged

  belongs_to :author
  has_many :reviews

  validates :author_id, presence: true

  before_save :add_searchable_terms


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

# Index all book records from the DB to Elasticsearch
Book.import
