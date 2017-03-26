# frozen_string_literal: true
require 'json'
module Api
  class HandsawsController < ApplicationController
    def convert
      html = Handsaw::Processor.new.render(params[:handsaw])
      indent_html = Nokogiri::HTML.fragment(html.delete("\n")).to_xhtml(indent: 2)
      # indent_html = CGI::pretty(html.delete("\n"))
      render json: JSON.generate(html: indent_html)
    end
  end
end
