#require 'luarocks.loader'
local cjson = require "cjson"
local cjson2 = cjson.new()
local cjson_safe = require "cjson.safe"
json_text = '[ true, { "foo": "bar" } ]'
value = cjson.decode(json_text)
for k, v in pairs( value ) do
   print(k, v)
end
print(value)
