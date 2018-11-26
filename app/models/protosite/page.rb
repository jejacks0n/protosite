module Protosite
  class Page < Protosite.configuration.parent_record.constantize
    belongs_to :parent, optional: true, class_name: "Protosite::Page"
    has_many :children, foreign_key: :parent_id, class_name: "Protosite::Page", dependent: :destroy

    before_create :set_sort, :set_id

    validates :slug,
      presence: { message: "can't be blank -- provide a title or slug in data" },
      unless: -> { parent_id.nil? }

    validates :slug,
      uniqueness: { scope: :parent_id }

    scope :roots, -> { where(parent_id: nil) }
    default_scope -> { order(:sort).order(created_at: :desc) }

    def self.build_pages(array, parent = nil)
      array.each do |data|
        children = data.delete(:children) || []
        page = create_from_data!(parent: parent, data: data)
        build_pages(children, page)
      end
    end

    def self.create_from_data!(attrs)
      create!(attributes_from_data(attrs[:data], true).merge(attrs))
    end

    def self.attributes_from_data(data, create = false)
      data.stringify_keys!
      data["slug"] ||= data["title"].to_s.parameterize if create
      {
        parent_id: data["parent_id"],
        slug: data["slug"],
        sort: data["sort"],
      }.compact
    end

    def add_version!(data)
      data.stringify_keys!
      data.delete("id")
      update!(versions: versions.unshift(data))
    end

    def publish!
      version = versions.shift || data
      update!(self.class.attributes_from_data(version).merge(data: version, versions: versions, published: true))
    end

    private

      def set_id
        self.id ||= data["id"] || SecureRandom.hex(8)
      end

      def set_sort
        self.sort ||= data["sort"] ||= Page.where(parent_id: parent_id).count
      end
  end
end
