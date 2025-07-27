
require("utils.status")

local tests = {
  test_status_code_to_string = function ()
    assert(StatusCodeToString(0) == "", "Expected empty string for invalid code.")
    assert(StatusCodeToString(1) == "OK")
  end,

  test_status_empty_constructor = function ()
    local status = Status()
    assert(status.ok())
    assert(status.code() == StatusCode.OK)
    assert(status.message() == "")
  end,

  test_status_invalid_code = function ()
    local status = Status(6, "Invalid code")
    assert(not status.ok(), "Expected status to not be ok for invalid code.")
    assert(status.code() == StatusCode.OUT_OF_RANGE)
    assert(status.message() == "Invalid status code: 6")
  end,

  test_status_valid_params = function ()
    local status = Status(StatusCode.FAILED_PRECONDITION, "Precondition failed")
    assert(not status.ok())
    assert(status.code() == StatusCode.FAILED_PRECONDITION)
    assert(status.message() == "Precondition failed")
  end,

  test_status_to_string = function ()
    local status = Status(StatusCode.UNKNOWN, "An unknown error occurred")
    local expected = "Status(\n\tcode=UNKNOWN,\n\tmessage=An unknown error occurred\n)"
    assert(tostring(status) == expected)
  end,

  -- TODO(zziccardi): Add more tests for StatusOr and other utilities.
}

for name, test in pairs(tests) do
  local success, err = pcall(test)
  if not success then
    print("Test '" .. name .. "' FAILED: " .. tostring(err))
  else
    print("Test '" .. name .. "' PASSED.")
  end
end
