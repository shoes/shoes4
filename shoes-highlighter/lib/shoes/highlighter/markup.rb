# syntax highlighting

class Shoes
  module Highlighter
    module Markup
      TOKENIZER = Shoes::Highlighter::Syntax.load "ruby"
      COLORS = {
        comment: { stroke: "#887" },
        keyword: { stroke: "#111" },
        method: { stroke: "#C09", weight: "bold" },
        # :class => {:stroke => "#0c4", :weight => "bold"},
        # :module => {:stroke => "#050"},
        # :punct => {:stroke => "#668", :weight => "bold"},
        symbol: { stroke: "#C30" },
        string: { stroke: "#C90" },
        number: { stroke: "#396" },
        regex: { stroke: "#000", fill: "#FFC" },
        # :char => {:stroke => "#f07"},
        attribute: { stroke: "#369" },
        # :global => {:stroke => "#7FB" },
        expr: { stroke: "#722" },
        # :escape => {:stroke => "#277" }
        ident: { stroke: "#994c99" },
        constant: { stroke: "#630", weight: "bold" },
        class: { stroke: "#630", weight: "bold" },
        matching: { stroke: "#ff0", weight: "bold" },
      }

      def highlight(str, pos = nil, colors = COLORS)
        tokens = []
        TOKENIZER.tokenize(str) do |t|
          if t.group == :punct
            # split punctuation into single characters tokens
            # TODO: to it in the parser
            tokens += t.split('').map { |s| Shoes::Highlighter::Syntax::Token.new(s, :punct) }
          else
            # add token as is
            tokens << t
          end
        end

        res = []
        tokens.each do |token|
          res <<
            if colors[token.group]
              # span(token, colors[token.group])
              tmp = fg(token, colors[token.group][:stroke])
              colors[token.group][:fill] ? bg(tmp, colors[token.group][:fill]) : tmp
            elsif colors[:any]
              # span(token, colors[:any])
              tmp = fg(token, colors[:any][:stroke])
              colors[:any][:fill] ? bg(tmp, colors[:any][:fill]) : tmp
            else
              token
            end
        end

        if pos.nil? || pos < 0
          return res
        end

        token_index, matching_index = matching_token(tokens, pos)

        if token_index
          # res[token_index] = span(tokens[token_index], colors[:matching])
          tmp = fg(tokens[token_index], colors[:matching][:stroke])
          res[token_index] = colors[:matching][:fill] ? bg(tmp, colors[:matching][:fill]) : tmp
          if matching_index
            # res[matching_index] = span(tokens[matching_index], colors[:matching])
            tmp = fg(tokens[matching_index], colors[:matching][:stroke])
            res[matching_index] = colors[:matching][:fill] ? bg(tmp, colors[:matching][:fill]) : tmp
          end
        end

        res
      end

      private

      def matching_token(tokens, pos)
        curr_pos = 0
        token_index = nil
        tokens.each_with_index do |t, i|
          curr_pos += t.size
          if token_index.nil? && curr_pos >= pos
            token_index = i
            break
          end
        end
        if token_index.nil? then return nil end

        match = matching_token_at_index(tokens, token_index)
        if match.nil? && curr_pos == pos && token_index < tokens.size - 1
          # try the token before the cursor, instead of the one after
          token_index += 1
          match = matching_token_at_index(tokens, token_index)
        end

        if match
          [token_index, match]
        else
          nil
        end
      end

      def matching_token_at_index(tokens, index)
        starts, ends, direction = matching_tokens(tokens, index)
        if starts.nil?
          return nil
        end

        stack_level = 1
        index += direction
        while index >= 0 && index < tokens.size
          # TODO separate space in the tokenizer
          t = tokens[index].gsub(/\s/, '')
          if ends.include?(t) && !as_modifier?(tokens, index)
            stack_level -= 1
            return index if stack_level == 0
          elsif starts.include?(t) && !as_modifier?(tokens, index)
            stack_level += 1
          end
          index += direction
        end
        # no matching token found
        nil
      end

      # returns an array of tokens matching and the direction
      def matching_tokens(tokens, index)
        # TODO separate space in the tokenizer
        token = tokens[index].gsub(/\s/, '')
        starts = [token]
        if OPEN_BRACKETS[token]
          direction = 1
          ends = [OPEN_BRACKETS[token]]
        elsif CLOSE_BRACKETS[token]
          direction = -1
          ends = [CLOSE_BRACKETS[token]]
        elsif OPEN_BLOCK.include?(token)
          if as_modifier?(tokens, index)
            return nil
          end
          direction = 1
          ends = ['end']
          starts = OPEN_BLOCK
        elsif token == 'end'
          direction = -1
          ends = OPEN_BLOCK
        else
          return nil
        end

        [starts, ends, direction]
      end

      def as_modifier?(tokens, index)
        unless MODIFIERS.include? tokens[index].gsub(/\s/, '')
          return false
        end

        index -= 1
        # find last index before the token that is no space
        index -= 1 while index >= 0 && tokens[index] =~ /\A[ \t]*\z/

        if index < 0
          # first character of the string
          false
        elsif tokens[index] =~ /\n[ \t]*\Z/
          # first token of the line
          false
        elsif tokens[index].group == :punct
          # preceded by a punctuation token on the same line
          i = tokens[index].rindex(/\S/)
          punc = tokens[index][i, 1]
          # true if the preceeding statement was terminating
          !NON_TERMINATING.include?(punc)
        else
          # preceded by a non punctuation token on the same line
          true
        end
      end

      OPEN_BRACKETS = {
        '{' => '}',
        '(' => ')',
        '[' => ']',
      }

      # close_bracket = {}
      # OPEN_BRACKETS.each{|open, close| opens_bracket[close] = open}
      # CLOSE_BRACKETS = opens_bracket
      # the following is more readable :)
      CLOSE_BRACKETS = {
        '}' => '{',
        ')' => '(',
        ']' => '[',
      }

      BRACKETS = CLOSE_BRACKETS.keys + OPEN_BRACKETS.keys

      OPEN_BLOCK = %w(def class module do if unless while until begin for)

      MODIFIERS = %w(if unless while until)

      NON_TERMINATING = %w{+ - * / , . = ~ < > ( [}
    end
  end
end
