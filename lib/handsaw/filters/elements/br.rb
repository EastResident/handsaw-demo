# frozen_string_literal: true
module Handsaw
  module Filters
    module Elements
      class Br < Handsaw::Filters::IndentedParagraph
        def template
          '<br>'
        end
      end
    end
  end
end
