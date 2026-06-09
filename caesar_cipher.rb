ASCII_BOUNDS = {
  min_lowercase: 97,
  max_lowercase: 122,
  min_uppercase: 65,
  max_uppercase: 90,
  space_character: 32,
}

# + + + HELPER + + +
def convert_to_ascii(original_string)
  ascii_array = original_string.each_byte.to_a do |char|
    ascii_array
  end
end

# + + + HELPER for right_shift_ASCII HELPER: Wrapping lower/upper-limit numbers + + +
# wrap_adjust needs to subtract 1 from its value to count down from upper bound correctly

def wrap_ascii_code_uppercase(shifted_num)
    wrap_adjust = ASCII_BOUNDS[:min_uppercase] - shifted_num
    adjusted_shift = ASCII_BOUNDS[:max_uppercase] - (wrap_adjust - 1)
    adjusted_shift
end

def wrap_ascii_code_lowercase(shifted_num)
    wrap_adjust = ASCII_BOUNDS[:min_lowercase] - shifted_num
    adjusted_shift = ASCII_BOUNDS[:max_lowercase] - (wrap_adjust - 1)
    adjusted_shift
end


# + + + Right-shift message characters num times + + +
def right_shift_ascii(ascii_code, shift_value)

  shifted_ascii_code = ascii_code.map do |num|
      
      shifted_ascii_byte = num - shift_value

      case
        when num == ASCII_BOUNDS[:space_character]
          num
        when num >= ASCII_BOUNDS[:min_uppercase] && num <= ASCII_BOUNDS[:max_uppercase]
          if shifted_ascii_byte < ASCII_BOUNDS[:min_uppercase]
            wrapped_ascii_byte = wrap_ascii_code_uppercase(shifted_ascii_byte)
            wrapped_ascii_byte
          else
            shifted_ascii_byte
          end

        when num >= ASCII_BOUNDS[:min_lowercase] && num <= ASCII_BOUNDS[:max_lowercase]
          if shifted_ascii_byte < ASCII_BOUNDS[:min_lowercase]
            wrapped_ascii_byte = wrap_ascii_code_lowercase(shifted_ascii_byte)
            wrapped_ascii_byte
          else
            shifted_ascii_byte
          end
      
      end #case block
  end #map block
  shifted_ascii_code
end

# + + + Convert numbers back to letters + + +
def convert_to_string(received_code)
  translated_code = received_code.map do |num|
    num.chr
  end
  translated_code.join()
end

# + + + BREAK CONDITION + + +
# Short-circuit if character is invalid
def invalid_character(received_code)
  received_code.each do |num|
    if ASCII_BOUNDS[:space_character] == num || (ASCII_BOUNDS[:min_uppercase]..ASCII_BOUNDS[:max_uppercase]) === num || (ASCII_BOUNDS[:min_lowercase]..ASCII_BOUNDS[:max_lowercase]) === num
      false
    else
      puts "Characters outside of space, a-z, or A-Z are not accepted. Please try again."
      return true
    end
  end
end

# + + + + + + + PROGRAM + + + + + + + +
def create_caesar_cypher(string, shift_by)
  ascii_code = convert_to_ascii(string)
  return if invalid_character(ascii_code) == true
  shifted_ascii_code = right_shift_ascii(ascii_code, shift_by)
  converted_string = convert_to_string(shifted_ascii_code)
  p converted_string
end

# + + + + + + + EXECUTE PROGRAM + + + + + + + +
# output for "Abc def" must be [86, 119, 120, 32, 121, 122, 97] for shifted numbers, and "Vwx yza" for final shifted string

create_caesar_cypher("Abc def", 5)