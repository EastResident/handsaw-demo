# frozen_string_literal: true

module Handsaw
  class CustomRender < Redcarpet::Render::HTML
    include ActionView::Helpers::TextHelper
    # def paragraph(text)
    #   simple_format(text, sanitize: false)
    # end
  end
end
