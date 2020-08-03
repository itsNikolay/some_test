module Paginations
  # Paginations::SimplePagination
  class SimplePagination
    PER_PAGE = 10

    attr_reader :records, :page

    def initialize(records, page)
      @records = records
      page = page.to_i
      @page = page.positive? ? page : 1
    end

    def paged_records
      return @paged_records if @paged_records

      indexed_page = page - 1
      result = records.offset(indexed_page * PER_PAGE).limit(PER_PAGE)
      result = yield(result) if block_given?
      @paged_records = result
    end

    def pages
      Array(1..total_pages)
    end

    def total_pages
      @total_pages ||= (records.count / PER_PAGE) + 1
    end

    def next_page
      page + 1
    end

    def prev_page
      page - 1
    end
  end
end
