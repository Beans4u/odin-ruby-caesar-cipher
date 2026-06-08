require 'pry-byebug'

ASCII_BOUNDS = {
  min_lowercase: 97,
  max_lowercase: 122,
  min_uppercase: 65,
  max_uppercase: 90
}

# + + + HELPER + + +
def convert_to_ascii(original_string)

  ascii_array = original_string.each_byte.to_a do |char|

    # Short-circuit if character is invalid
    unless (char >= ASCII_BOUNDS[:min_uppercase] && char <= ASCII_BOUNDS[:max_uppercase]) || (char >= ASCII_BOUNDS[:min_lowercase] && char <= ASCII_BOUNDS[:max_lowercase])
      return puts "Characters outside of a-z or A-Z are not accepted. Please try again."
    end

    ascii_array

  end
end

# + + + HELPER for right_shift_ASCII HELPER: Wrapping lower/upper-limit numbers + + +
def wrap_ascii_code_uppercase(shifted_num)

    wrap_adjust = ASCII_BOUNDS[:min_uppercase] - shifted_num
    adjusted_shift = ASCII_BOUNDS[:max_uppercase] - wrap_adjust
    adjusted_shift

end

def wrap_ascii_code_lowercase(shifted_num)

    wrap_adjust = ASCII_BOUNDS[:min_lowercase] - shifted_num
    adjusted_shift = ASCII_BOUNDS[:max_lowercase] - wrap_adjust
    adjusted_shift

end


# + + + Right-shift message characters num times + + +
def right_shift_ascii(ascii_code, shift_value)

  shifted_ascii_code = ascii_code.map do |num|

    shifted_ascii_byte = num - shift_value

    case
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
    
    end

  end

  p "shifted ascii code: #{shifted_ascii_code}"
  shifted_ascii_code 
end