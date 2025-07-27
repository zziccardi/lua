
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

StatusCode = {
  OK = 1,
  UNKNOWN = 2,
  INVALID_ARGUMENT = 3,
  FAILED_PRECONDITION = 4,
  OUT_OF_RANGE = 5,
}

--- @class Status
Status = {
  --- @param self Status
  --- @param code integer (of type StatusCode)
  --- @param message string (only used for error cases)
  Status = function (self, code, message)
    if type(code) ~= "number" or code < 1 or code > 5 then
      self._code = StatusCode.OUT_OF_RANGE
      self._message = "Invalid status code: " .. tostring(code)
    end
    self._code = code
    self._message = message
  end,

  --- @return boolean
  ok = function (self)
    return self._code == StatusCode.OK
  end,

  --- @return number
  code = function (self)
    return self._code
  end,

  --- @return string
  message = function (self)
    return self._message
  end,

  __tostring = function (self)
    return "Status(\n\tcode=" .. tostring(self._code) ..
           ",\tmessage=" .. tostring(self._message) .. "\n)"
  end,

  _code = StatusCode.OK,
  _message = "",
}

--- @return Status
function OkStatus()
  return Status(StatusCode.OK)
end

--- @param message string
--- @return Status
function InvalidArgumentError(message)
  return Status(StatusCode.INVALID_ARGUMENT, tostring(message) or "Invalid argument.")
end

--- @class StatusOr
StatusOr = {
  --- @param self StatusOr
  --- @param status_or_value Status | any
  StatusOr = function (self, status_or_value)
    if type(status_or_value) == "table" and (not status_or_value.ok or
                                             not status_or_value.ok()) then
      self._status = status_or_value
      self._value = nil
    else
      self._status = OkStatus()
      self._value = status_or_value
    end
  end,

  --- @return boolean
  ok = function (self)
    return self._status and self._status.ok() or false
  end,

  --- @return Status | nil
  status = function (self)
    return self._status
  end,

  --- @return any | nil
  value = function (self)
    return self._value
  end,

  _status = nil,  --- @type Status
  _value = nil,  --- @type any
}

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
