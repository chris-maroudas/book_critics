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