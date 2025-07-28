
package.path = package.path .. ";/Users/zziccardi/Desktop/lua/utils/?.lua"

require("status")

local function print_hello(...)
  print("Hello, world!")
end

print_hello()

local adder = {}

--- @param a number The first number to add.
--- @param b number The second number to add.
--- @return StatusOr (number)
function adder.add(a, b)
  if type(a) ~= "number" or type(b) ~= "number" then
    return StatusOr.init(InvalidArgumentError(
                             "Both arguments must be numbers."))
  end
  return StatusOr.init(a + b)
end

local result = adder.add(5, 3)

assert(result:ok(), "Expected result to be ok, but it was not.")
assert(result:value() == 8,
       "Expected result value to be 8, but it was " .. tostring(result:value()))
