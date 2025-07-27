-- Utility module for handling status codes and messages.
-- Heavily inspired by absl::Status.

StatusCode = {
  OK = 1,
  UNKNOWN = 2,
  INVALID_ARGUMENT = 3,
  FAILED_PRECONDITION = 4,
  OUT_OF_RANGE = 5,
}

--- @param code integer (of type StatusCode)
--- @return string (empty string if code is invalid)
function StatusCodeToString(code)
  if code == StatusCode.OK then
    return "OK"
  elseif code == StatusCode.UNKNOWN then
    return "UNKNOWN"
  elseif code == StatusCode.INVALID_ARGUMENT then
    return "INVALID_ARGUMENT"
  elseif code == StatusCode.FAILED_PRECONDITION then
    return "FAILED_PRECONDITION"
  elseif code == StatusCode.OUT_OF_RANGE then
    return "OUT_OF_RANGE"
  end
  return ""
end

--- @class Status
--- @field ok function
--- @field code function
--- @field message function
Status = {
  --- @param code integer (of type StatusCode)
  --- @param message string? (only used for error cases)
  init = function (code, message)
    local self = setmetatable({}, Status)

    if type(code) ~= "number" or code < 1 or code > 5 then
      self._code = StatusCode.OUT_OF_RANGE
      self._message = "Invalid status code: " .. tostring(code)
      return self
    end

    self._code = code
    self._message = message or ""

    return self
  end,

  __index = {
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
  },

  __tostring = function (self)
    return "Status(\n  code=" .. StatusCodeToString(self._code) ..
           ",\n  message=" .. tostring(self._message) .. ")"
  end,
}

--- @return Status
function OkStatus()
  return Status.init(StatusCode.OK)
end

--- @param message string?
--- @return Status
function InvalidArgumentError(message)
  return Status.init(StatusCode.INVALID_ARGUMENT, message or "Invalid argument.")
end

--- @class StatusOr
--- @field ok function
--- @field status function
--- @field value function
StatusOr = {
  --- @param status_or_value Status | any
  init = function (status_or_value)
    local self = setmetatable({}, StatusOr)

    -- TODO: check for "Status" type instead
    if type(status_or_value) == "table" and (not status_or_value.ok or
                                             not status_or_value:ok()) then
      -- Error case: Save the Status object.
      self._status = status_or_value
      self._value = nil
    else
      self._status = OkStatus()
      self._value = status_or_value
    end

    return self
  end,

  __index = {
    --- @return boolean
    ok = function (self)
      return self._status and self._status:ok() or false
    end,

    --- @return Status | nil
    status = function (self)
      return self._status
    end,

    --- @return any | nil
    value = function (self)
      return self._value
    end,
  },
}
