# Dev Log: Caesar Cipher

## Project Setup

### MVP Features

**Behaviour:**

- Input a number to a function call with shift factor parameter
- Function shifts message characters by shift factor value
- Function prints shifted message

**Constraints:**

- Must warp z-a / Z-A
- Translation must retain case
- Must shift to the right

Numbers, symbols, special characters not listed in assignment objectives and will not be supported in this project.

### Tech Stack

- Ruby 3.4.6

### Progress

- [x] Initialized Git repo
- [x] Use rbenv local ruby 3.4.6 for local project
- [x] Determine project constraints
- [x] Create `.gitignore` for workspace and future 'scratch' docs
- [x] Create `caesar_cipher.rb` doc
- [x] Flesh out `README.doc`

## Determine Logic, Data

### Unicode

[Ruby unicode](https://www.rubyguides.com/2019/05/ruby-ascii-unicode/),  
[Ascii-Code.com code charts](https://www.ascii-code.com/characters/ascii-alphabet-characters),

- A-Z: 65-90
- a-z: 97-122

```ruby
ASCII_BOUNDS = {
  min_lowercase: 97,
  max_lowercase: 122,
  min_uppercase: 65,
  max_uppercase: 90
}
```

### Convert int to ASCII, save as array

I'll need a helper that converts the string to ASCII and hand it off to another helper that will right-shift the result.  
I'll want to right-shift the result in an array, so I'll convert it here as well.

[ASCII to code StackOverflow](https://stackoverflow.com/questions/143822/ruby-character-to-ascii-from-a-string),  
[Convert ASCII to char AlvinaAlexander.com](https://alvinalexander.com/blog/post/ruby/how-convert-decimal-byte-to-ascii-char-character-ruby/),

Reference: abcdefghijklmnopqrstuvwxyz

Input string: "Abc" ([A, b, c])
Abc in ASCII: 65, 98, 99
Shift: 5
Vwx in ASCII: 86, 119, 120
Output string: "Vwx" ([V, w, x])

```ruby
def convert_to_ascii(original_string)

  ascii_array = original_string.each_byte.to_a do |char|

    # Short-circuit if character is invalid
    unless (char >= ASCII_BOUNDS[:min_uppercase] && char <= ASCII_BOUNDS[:max_uppercase]) || (char >= ASCII_BOUNDS[:min_lowercase] && char <= ASCII_BOUNDS[:max_lowercase])
      return puts "Characters outside of a-z or A-Z are not accepted. Please try again."
    end

    ascii_array

  end
end

# TESTING PLAYGROUND: Expected output for "Abc": [65 98 99]
# p convert_to_ascii("Abc")
```

This function call will assign the result to `ascii_code`:  
`ascii_code` = `convert_to_ascii`(`"Abc"`)

### Wrapping lower/upper-limit numbers

In order for A to wrap back to Z (and a to z), I need to reset the shift count from the top of the range of allowed ASCII numbers once it exceeds the minimum ASCII number.

~~Wrap numbers with upper limit: [modulo method StackOverflow.com](https://stackoverflow.com/questions/10927914/limit-a-number-and-rotate-it-within-a-range)~~

~~Linked solution is incorrect (12 % 12 is 0, not 12), but I can make it work by adding +1 to the formula.~~  
~~To use a custom number, I need to subtract the `min` from the `num`, and % from the `max`/`min` number value (+1) (`max` - `min` will give one number short of the actual value), and add the `min` number back in.~~

**Note:** Numbers outside these ranges will be invalid and trigger an error message.

~~((`num` - `min`)) % ((`max` - `min`) + 1) + `min`~~  
~~so if `num` = `120`, and `max` = `122` and `min` = `65`,~~  
~~((`120` - `65`)) % ((`122` - `65`) + 1) + `65`~~  
~~55 % (57 + 1) + 65~~  
~~55 % 58 + 65~~  
~~55 + 65~~  
~~120~~

~~**note: **122 wraps to 97, 90 wraps to 65~~

~~def wrap_range_of_nums(num)~~  
~~if num >= 97 && num <= 122 do~~  
~~min = 97~~  
~~max = 122~~

~~elsif num >= 65 && num <= 90 do~~  
~~min = 65~~  
~~max = 90~~

~~else return puts "error message"~~  
~~end~~  
~~end~~

For the life of me, I can't figure out why I was thinking about wrapping the numbers in such a literal way. I can just use simple math:  
When the right-shift takes us below `min_uppercase`/`min_lowercase`, I'll just subtract from `max_uppercase`/`max_lowercase`.

abcdefghijklmnopqrstuvwxyz

Input string: `"Abc"`  
`[A, b, c]` in ASCII is [65, 98, 99]  
`shift_value`: 5  
`[V, w, x]` in ASCII is [86, 119, 120]  
Output string: `"Vwx"`

**Tracing my logic:**  
Note: _Allowed range_ is the difference between `shifted_num` and `min_uppercase`/`min_lowercase` which **must be** a non-negative number between and `max_uppercase` (90) / `max_lowercase` (122) after right-shifting a character. Negative numbers exceed the _allowed range_.

So char "A" (65) - `shift_value` (5) is `shifted_num` (60)  
`min_uppercase` (65) - `shifted_num` (60) is `wrap_adjust` (5), which means we exceeded _allowed range_.  
So we take `wrap_adjust` (5) from `max_uppercase` (90) to get `adjusted_shift` (85), which will later convert to a "V".  
We return `adjusted_shift` (85) to `shifted_ascii_code`

So `char` "b" (98) - `shift_value` (5) is `shifted_num` (93)  
`min_lowercase` (97) - `shifted_num` (93) is `wrap_adjust` (4), which means we exceeded _allowed range_.  
So we take `wrap_adjust` (4) from `max_lowercase` (122) to get `adjusted_shift` (118), which will later convert to a "w".  
We return `adjusted_shift` (118) to `shifted_ascii_code`

So `char` "c" (99) - `shift_value` (5) is `shifted_num` (94)  
`min_lowercase` (97) - `shifted_num` (94) is `wrap_adjust` (3), which means we exceeded _allowed range_.  
So we take `wrap_adjust` (3) from `max_lowercase` (122) to get `adjusted_shift` (119), which will later convert to a "x".  
We return `adjusted_shift` (119) to `shifted_ascii_code`

Looks good to me. So I should do something like this:

**Note:** This would be done outside the helper:
`shifted_num = char - shift_value`

**AHA moment:** JavaScript and Ruby handle if statements differently. In Ruby, the last one evaluated returns false if the conditions aren't met, which caused me to return [nil, 118, 119] instead of [65,118, 119]. That took me an hour of debugging and finally trying a switch case instead of and if statement, which of course worked beautifully. Two independent if blocks do not work in Ruby, use case statements instead.

```ruby
def wrap_ascii_code_uppercase(shifted_num)

    wrap_adjust = ASCII_BOUNDS[:min_uppercase] - shifted_num
    adjusted_shift = ASCII_BOUNDS[:max_uppercase] - wrap_adjust
    adjusted_shift

end
```

```ruby
def wrap_ascii_code_lowercase(shifted_num)

    wrap_adjust = ASCII_BOUNDS[:min_lowercase] - shifted_num
    adjusted_shift = ASCII_BOUNDS[:max_lowercase] - wrap_adjust
    adjusted_shift

end
```

called with

### Right-shift message characters `num` times

```ruby
def right_shift_ascii(ascii_code, shift_value)



  # I used map from memory, need to check my work
  shifted_ascii_code = ascii_code.map do |num|
#binding.pry
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
```

TESTING PLAYGROUND: Result for right_shift_ascii([65, 98, 99], 5) should be [85, 119, 120]
right_shift_ascii([65, 98, 99], 5)

## Determine Flow

[Array methods, Ruby Docs](https://docs.ruby-lang.org/en/3.4/Array.html)

`create_caesar_cypher`(`original_string`) will dispatch function calls that will convert a string to ascii, right-shift the ascii code, convert ascii back to a string, then communicate the message.

1. Call `create_caesar_cypher`(`original_string`, `shift_value`) where `original_string` is `"Abc"` and `shift_value` is 5
2. function call: `convert_to_ascii`(`original_string`) to convert `original_string` into corresponding ASCII numbers
   - use `original_string`#`each_byte`
   - returns to `ascii_code` array in `create_caesar_cypher`
3. function call: `right_shift_ascii`(`ascii_code`) to right-shift each `num`.
   - function call: `wrap_range_of_nums`(`num`)
   - **note: **122 wraps to 97, 90 wraps to 65
   - if `num` is outside the bounds of uppercase and lowercase ascii numbers, return #`puts` `"only uppercase and lowercase alphabet glyphs are permitted"`
   - **shifting:**
   - `ascii_code`#`map` the array, reduce each number by `num` on each loop
   - case: determine is uppercase or lowercase number range
   - case -> if: when outside the lower bounds of uppercase or lowercase ascii numbers, continue subtracting from the top bounds.
   - returns to `shifted_ascii_code` array in `create_caesar_cypher`

4. function call: `convert_to_string`(`shifted_ascii_code`) to convert numbers back to corresponding ASCII numbers
   - #`map` using `shifted_ascii_code`#`chr`?
   - returns `converted_string` to `create_caesar_cypher`
5. function call `communicate_shifted_message`(`converted_string`)
   - `#puts` `converted_string`

Basically:  
def `create_caesar_cypher`(`original_string`)

`"ascii_code"` = `convert_to_ascii`(`original_string`)  
`"shifted_ascii_code"` = `right_shift_ascii`(`ascii_code`) <= goes to `wrap_ascii_code` helper
`"converted_string"` = `convert_to_string`(`shifted_ascii_code`)  
`communicate_shifted_message`(`converted_string`)  
end

def `wrap_ascii_code_uppercase`(`shifted_num`)
wraps code if exceeds lower bounds to continue subtracting from upperbound ascii numbers
returns `adjusted_shift` to `shifted_ascii_code`
end

lowercase wrap equivalent to uppercase code above.

## Code Graveyard

I don't remember why I thought I needed this, but it's here just in case:

#### + + + Determine case of string characters + + +

Whoops. My helper function needs a helper function.

To check if the character is uppercase or lowercase, I decided to monkey patch the String class as per this [Stack Overflow solution](https://stackoverflow.com/questions/12713251/ruby-how-to-tell-if-character-is-upper-lowercase).

```ruby
class String
  def is_uppercase?
    !!self.match(/\p{Upper}/)
  end

  def is_lowercase?
    !!self.match(/\p{Lower}/)
  end
end
```
