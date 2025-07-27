
require("utils.status")

local function print_hello(...)
  -- `arg` is a hidden param.
  if #arg == 0 then
    print("Hello, world!")
  end

  for i, v in ipairs(arg) do
    print("Hello, " .. tostring(v) .. "!\n")
  end
end

print_hello("Zach", "Sam", "Matt")

local adder = {}

--- @param a number The first number to add.
--- @param b number The second number to add.
--- @return StatusOr
function adder.add(a, b)
  if type(a) ~= "number" or type(b) ~= "number" then
    return StatusOr(InvalidArgumentError("Both arguments must be numbers."))
  end
  return StatusOr(a + b)
end

local result = adder.add(5, 3)

assert(result.ok(), "Expected result to be ok, but it was not.")
assert(result.value() == 8,
       "Expected result value to be 8, but it was " .. tostring(result.value()))
