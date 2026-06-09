# odin-ruby-caesar-cipher

# Caesar Cipher

A simple Ruby implementation of the classic Caesar cipher encryption technique, completed as part of The Odin Project Ruby curriculum.

## About

The Caesar cipher is one of the oldest and simplest encryption methods. Each letter in a message is shifted a fixed number of positions through the alphabet.

Example with a shift of `5`:

```ruby
caesar_cipher("What a string!", 5)
# => "Bmfy f xywnsl!"
```

## Features

- Preserves uppercase and lowercase letters
- Wraps around the alphabet (`z -> a`)
- Leaves punctuation and spaces unchanged

## Running the Program

Run the Ruby file from the project directory:

```bash
ruby caesar_cipher.rb
```

## Project Source

[Assignment](https://www.theodinproject.com/lessons/ruby-caesar-cipher) from The Odin Project [Full Stack Ruby on Rails](https://www.theodinproject.com/paths/full-stack-ruby-on-rails) open-source curriculum.

## Dev log & Code

Thinking through problems and documenting lessons learned in my [dev log](https://github.com/Beans4u/odin-ruby-caesar-cipher/blob/main/DEV_LOG.md). I found this to be invaluable since I had to step away from this for a few days - multiple times.

Run it yourself: [caesar_cipher.rb](https://github.com/Beans4u/odin-ruby-caesar-cipher/blob/main/caesar_cipher.rb)
