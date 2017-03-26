# frozen_string_literal: true
module Handsaw
  module Filters
    class BlockQuoteParser < HTML::Pipeline::Filter
      include HtmlBuilder
      def call
        doc.search('blockquote').each do |b|
          html = markup(:div, class: 'pa-editerBox') do |t|
            t.pre do
              b.text.each_line do |line|
                t.code line if line.present?
              end
            end
          end
          b.replace Nokogiri::HTML.fragment(html)
        end
        doc
      end
    end
  end
end
