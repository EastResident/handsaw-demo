# frozen_string_literal: true
module Handsaw
  module HtmlRender
    refine String do
      def to_html
        Redcarpet::Markdown.new(
          Handsaw::CustomRender,
          tables: true, disable_indented_code_blocks: true, fenced_code_blocks: true
        ).render self
      end
    end
    def markup(tag_name = nil, **options)
      root = Nokogiri::HTML.fragment ''
      Nokogiri::HTML::Builder.with(root) do |doc|
        if tag_name
          doc.send(tag_name, options) do
            yield doc if block_given?
          end
        else
          yield doc
        end
      end
      root.to_html.html_safe
    end

    # 必要になったら汎用的に
    def html_with_target_blank_link(text)
      text_value = Nokogiri::HTML(text)
      text_value.css('a').each { |a| a[:target] = '_blank' }
      text_value.to_html.html_safe
    end
  end
end
