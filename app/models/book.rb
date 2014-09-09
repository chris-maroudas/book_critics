# == Schema Information
#
# Table name: books
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  created_at :datetime
#  updated_at :datetime
#  content    :text
#  author     :string(255)
#

require 'elasticsearch/model'

class Book < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  has_many :reviews


  def self.search(query)
    __elasticsearch__.search(
      {
        query: {
          multi_match: {
            query: query,
            fields: ['title^6', 'author^5', 'content']
          }
        },
        highlight: {
          pre_tags: ['<em><strong>'],
          post_tags: ['</em></strong>'],
          fields: {
            title: {},
            author: {},
            content: {}
          }
        }
      }
    )
  end

end

# Index all book records from the DB to Elasticsearch
Book.import
