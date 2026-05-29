# Dev Log: Caesar Cipher

## Day 1: Project Setup

### MVP Features

Behaviour:

- Input a number to a function call with shift factor parameter
- Function shifts string message characters by shift factor value
- Function prints shifted message

**Constraints:**

- Must warp z-a / Z-A
- Translation must retain case
- Must shift to the right

Numbers, symbols, special characters not listed in project objectives and will not be supported in this project.

### Tech Stack

- Ruby 3.4.6

### Progress

- [x] Initialized Git repo
- [x] Use rbenv local ruby 3.4.6 for local project
- [x] Determine project constraints

## Day 1: Determine Logic, Data

### Unicode, Right shift

[Ruby unicode](https://www.rubyguides.com/2019/05/ruby-ascii-unicode/),  
[Ascii-Code.com code charts](https://www.ascii-code.com/characters/ascii-alphabet-characters),

- A-Z: 65-90
- a-z: 97-122

### Convert int to ASCII & back

[ASCII to code StackOverflow](https://stackoverflow.com/questions/143822/ruby-character-to-ascii-from-a-string),  
[Convert ASCII to char AlvinaAlexander.com](https://alvinalexander.com/blog/post/ruby/how-convert-decimal-byte-to-ascii-char-character-ruby/),

abcdefghijklmnopqrstuvwxyz

Input string: "Abc"
Abc = 65-98-99
Shift: 5
Vwx = 86-119-120
Output string: "Vwx"

### Wrapping lower and upper-limit numbers

wrap numbers with upper limit: [modulo method StackOverflow.com](https://stackoverflow.com/questions/10927914/limit-a-number-and-rotate-it-within-a-range)

Solution incorrect (12 % 12 is 0, not 12), but I can make it work with some tweaks.  
To use a custom number, I need to subtract the `min` from the `num`, and % from the max/min number value (+1) (max - min will give one number short of the actual value), and add the min number back in.
((`num` - `min`)) % ((`max` - `min`) + 1) + `min`
so if num = 120, and max = 122 and min = 65,
((`120` - `65`)) % ((`122` - `65`) + 1) + `65`
55 % (57 + 1) + 65
55 % 58 + 65
55 + 65
120

## Day 1: Determine Flow

`create_caesar_cypher`(`original_string`) will dispatch function calls that will convert a string to ascii, right-shift the ascii code, convert ascii back to a string, then communicate the message.

1. Call `create_caesar_cypher`(`original_string`) where `original_string` is `"Abc"`
2. function call: `convert_to_ascii`(`original_string`) to convert `original_string` into corresponding ASCII numbers
   - map using `original_string.each_byte` {|`char`| puts `char`}?
   - returns to `ascii_code` in `create_caesar_cypher`
3. function call: `right_shift_ASCII`(`ascii_code`) to right-shift each `num`.
   - note: 122 wraps to 97, 90 wraps to 65
   - if `num` >= 97, `min` = 97, `max` = 122
   - if `num` >= 65 && <= 90, `min` = 65, `max` = 90
   - map modulo using: ((`num` - `min`)) % ((`max` - `min`) + 1) + `min`
   - returns to `shifted_ascii_code` in `create_caesar_cypher`
4. function call: `convert_to_string`(`shifted_ascii_code`) to convert numbers back to corresponding ASCII numbers
   - `map` using `shifted_ascii_code`.`chr`?
   - returns `converted_string` to `create_caesar_cypher`
5. function call `communicate_shifted_message`(`converted_string`)
   - `puts` `converted_string`

Basically:
`create_caesar_cypher`(`original_string`)
`"ascii_code"` = `convert_to_ascii`(`original_string`)
`"shifted_ascii_code"` = `right_shift_ASCII`(`ascii_code`)
`"converted_string"` = `convert_to_string`(`shifted_ascii_code`)
`communicate_shifted_message`(`converted_string`)
