# == Schema Information
#
# Table name: search_data
#
#  id          :integer          not null, primary key
#  book_id     :integer
#  title       :string(255)
#  author_name :string(255)
#  tags        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

require 'elasticsearch/model'

class SearchData < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  belongs_to :book


  def self.search(query)
    __elasticsearch__.search(
      {
        query: {
          multi_match: {
            query: query,
            fields: ['title^6', 'author_name^2', 'tags']
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

SearchData.import
