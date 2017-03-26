# frozen_string_literal: true
require 'json'
module Api
  class HandsawsController < ApplicationController
    protect_from_forgery with: :null_session
    def convert
      html = Handsaw::Processor.new.render(params[:handsaw]).html_safe
      render json: JSON.generate(html: html)
    end
  end
end
