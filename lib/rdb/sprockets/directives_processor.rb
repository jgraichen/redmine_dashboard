module Rdb
  module Sprockets
    # The `DirectiveProcessor` is responsible for parsing and evaluating
    # directive comments in a source file.
    class DirectiveProcessor < ::Sprockets::DirectiveProcessor
      # Matches the entire header/directive block. This is everything from the
      # top of the file, enclosed in html comments.
      HEADER_PATTERN = /\A((?m:\s*)(<!--(?m:.*?)-->))+/

      # Implement `render` so that it uses our own header pattern.
      def render(context, locals)
        @context = context
        @pathname = context.pathname
        @directory = File.dirname(@pathname)

        if (header = data[HEADER_PATTERN, 0])
          @body   = $' || data
          @header = header.gsub(/<!--(.*?)-->/, "\\1\n")
        else
          @body   = $' || data
          @header = ''
        end

        # Ensure body ends in a new line
        @body += "\n" if @body != '' && @body !~ /\n\Z/m

        @included_pathnames = []

        @result = ''
        @result.force_encoding(body.encoding)

        @has_written_body = false

        process_directives
        process_source

        @result
      end
    end
  end
end
