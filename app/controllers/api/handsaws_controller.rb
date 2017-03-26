# frozen_string_literal: true
require 'json'
module Api
  class HandsawsController < ApplicationController
    include ActionView::Helpers::TextHelper
    protect_from_forgery with: :null_session
    def convert
      html = Handsaw::Processor.new.render(params[:handsaw])
      indent_html = Nokogiri::HTML.fragment(html.delete("\n")).to_xhtml(indent: 2)
      render json: JSON.generate(html: indent_html)
    end
  end
end
