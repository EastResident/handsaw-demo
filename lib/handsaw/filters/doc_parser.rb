# frozen_string_literal: true
require 'cgi'

module Handsaw
  module Filters
    class DocParser < HTML::Pipeline::MarkdownFilter
      def call
        Nokogiri::HTML.fragment(
          @text.gsub(/^[ |　|\t]+$/, '').split("\n\n").reduce([]) do |html, block|
            html << block.indents.to_div
          end.join("\n")
        )
      end

      String.class_eval do
        def indents # rubocop:disable all
          blocks = []
          count = 0
          each_line.with_index do |line, index|
            if key = line.rstrip.match(/^(\S+):$/).to_a[1]
              count += 1 if index != 0
              blocks[count] = { key: key, value: [] }
            elsif hash_item = line.rstrip.match(/^(\w+[ \t\r\f]?:[ \t\r\f]?\S+)$/).to_a[1]
              key, value = hash_item.split(':', 2).map(&:strip)
              count += 1 if index != 0
              blocks[count] = { key: 'option', value: ["#{key}:#{value}"] }
            elsif value = line.rstrip.match(/^\s{2}(.+)$/).to_a[1]
              blocks[count][:value] << value
            else
              count += 1 if index != 0
              blocks[count] = { key: key, value: [line] }
            end
          end
          blocks.each_with_index do |block, index|
            if block[:key] && (block[:key] != 'option')
              blocks[index][:value] = block[:value].join("\n").indents
            else blocks[index] = block[:value].join
            end
          end
        end
      end

      Array.class_eval do
        include Handsaw::HtmlRender
        using Handsaw::HtmlRender
        def to_div
          markup do |t|
            if all? { |s| s.is_a?(String) && (s !~ /^\w+:\S+$/) }
              t << join.to_html
            else
              each do |block|
                if block.is_a?(Hash)
                  t.div class: block[:key].to_s do
                    t << block[:value].to_div
                  end
                else
                  t.div block, class: 'option'
                end
              end
            end
          end
        end
      end
    end
  end
end
