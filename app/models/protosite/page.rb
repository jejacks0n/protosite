module Protosite
  class Page < Protosite.configuration.parent_record.constantize
    belongs_to :parent, optional: true, class_name: "Protosite::Page"
    has_many :children, foreign_key: :parent_id, class_name: "Protosite::Page"

    validates :slug,
      presence: { message: "can't be blank -- provide a title or slug in data" },
      uniqueness: { scope: :parent_id }
    validates :sort,
      presence: true

    before_validation :set_sort, unless: :sort

    scope :roots, -> { where(parent_id: nil) }
    default_scope -> { order(:sort) }

    def self.create_from_data!(attrs)
      Page.create!(attributes_from_data(attrs[:data]).merge(attrs))
    end

    def self.attributes_from_data(data)
      data["slug"] ||= data["title"].to_s.parameterize
      {
        parent_id: data["parent_id"],
        slug: data["slug"],
        sort: data["sort"],
      }
    end

    def add_version!(data)
      update!(versions: versions.unshift(data))
    end

    def publish!
      data = versions[0] || self.data
      update!(Page.attributes_from_data(data).merge(data: data, published: true))
    end

    private

      def set_sort
        self.sort ||= begin
          self.data["sort"] ||= Page.where(parent_id: parent_id).count
        end
      end
  end
end
