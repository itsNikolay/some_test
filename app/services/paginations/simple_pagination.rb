module Paginations
  # Paginations::SimplePagination
  class SimplePagination
    PER_PAGE = 10

    attr_reader :records, :page

    def initialize(records, page)
      @records = records
      @page = page.to_i
    end

    def paged_records
      records.offset(page * PER_PAGE).limit(PER_PAGE)
    end

    def pages
      Array(0..total_pages)
    end

    def total_pages
      @total_pages ||= records.count / PER_PAGE
    end

    def next_page
      page + 1
    end

    def prev_page
      page - 1
    end
  end
end
