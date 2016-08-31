local validation = require "resty.validation"

local valid, e = validation.number:between(0, 9)(5)  -- valid = true,  e = 5
local valid, e = validation.number:between(0, 9)(50) -- valid = false, e = "between"

-- Validators can be reused
local smallnumber = validation.number:between(0, 9)
local valid, e = smallnumber(5)  -- valid = true,  e = 5
local valid, e = smallnumber(50) -- valid = false, e = "between"

-- Validators can do filtering (i.e. modify the value being validated)
-- valid = true, s = "HELLO WORLD!"
local valid, s = validation.string.upper("hello world!")

-- You may extend the validation library with your own validators and filters...
validation.validators.capitalize = function(value) 
    return true, value:gsub("^%l", string.upper)
end

-- ... and then use it
local valid, e = validation.capitalize("abc") -- valid = true,  e = "Abc"

-- You can also group validate many values
local group = validation.new{
    artist = validation.string:minlen(5),
    number = validation.tonumber:equal(10)
}

local valid, fields, errors = group{ artist = "Eddie Vedder", number = "10" }

if valid then
  print("all the group fields are valid")
else
  print(fields.artist.name,      fields.artist.error,
        fields.artist.valid,     fields.artist.invalid,
        fields.artist.input,     fields.artist.value ,
        fields.artist.validated, fields.artist.unvalidated)
end

-- You can even call fields to get simple name, value table
-- (in that case all the `nil`s are removed as well)

-- By default this returns only the valid fields' names and values:
local data = fields()
local data = fields("valid")

-- To get only the invalid fields' names and values call:
local data = fields("invalid")

-- To get only the validated fields' names and values call (whether or not they are valid):
local data = fields("validated")

-- To get only the unvalidated fields' names and values call (whether or not they are valid):
local data = fields("unvalidated")

-- To get all, call:
local data = fields("all")

-- Or combine:
local data = fields("valid", "invalid")

-- This doesn't stop here. You may also want to get only some fields by their name.
-- You can do that by calling (returns a table):
local data = data{ "artist" }
