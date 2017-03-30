# frozen_string_literal: true

module Handsaw
  class CustomRender < Redcarpet::Render::HTML
    include ActionView::Helpers::TextHelper
    def paragraph(text)
      simple_format(text)
    end
  end
end
