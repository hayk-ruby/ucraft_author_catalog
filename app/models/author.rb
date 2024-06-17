class Author < ApplicationRecord
    validates :full_name, presence: true, uniqueness: true

    def self.paginate_data(params)
      authors = self
      
      count = authors.count
      authors = authors.order("#{params[:sort_by] || :id} #{params[:sort_type] || :DESC}")
      authors = authors.page(params[:page] || 1).per_page(params[:per_page] || 20) unless ActiveModel::Type::Boolean.new.cast(params[:all]).present?
      authors = { count: count, result: authors }
      authors 
    end

end