# frozen_string_literal: true
module Handsaw
  class Processor
    # そろそろ一括呼び出ししたい
    DEFAULT_FILTERS = [
      Handsaw::Filters::DocParser,
      # Handsaw::Filters::Elements::Br,
      # Handsaw::Filters::BlockQuoteParser,
      # Handsaw::Filters::SpanParser,
      # Handsaw::Filters::LinkParser,
      Handsaw::Filters::Sanitizer
    ].freeze
    attr_accessor :context
    def initialize(**context)
      @context = context
    end

    def render(text, **context)
      @pipe = HTML::Pipeline.new(filters, @context)
      @pipe.call(text, **context)[:output]
    end

    def filters
      @filters ||= DEFAULT_FILTERS
    end
  end
end
