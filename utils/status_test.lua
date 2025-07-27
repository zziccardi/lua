
package.path = package.path .. ";/Users/zziccardi/Desktop/lua/utils/?.lua"

require("status")

local tests = {
  test_status_code_to_string = function ()
    assert(StatusCodeToString(0) == "", "Expected empty string for invalid code.")
    assert(StatusCodeToString(1) == "OK")
  end,

  test_status_invalid_code = function ()
    local status = Status.init(6, "Invalid code")
    assert(not status:ok(), "Expected status to not be ok for invalid code.")
    assert(status:code() == StatusCode.OUT_OF_RANGE)
    assert(status:message() == "Invalid status code: 6")
  end,

  test_status_valid_params = function ()
    local status = Status.init(StatusCode.FAILED_PRECONDITION, "Precondition failed")
    assert(not status:ok())
    assert(status:code() == StatusCode.FAILED_PRECONDITION)
    assert(status:message() == "Precondition failed")
  end,

  test_status_to_string = function ()
    local status = Status.init(StatusCode.UNKNOWN, "An unknown error occurred")
    local expected = "Status(\n  code=UNKNOWN,\n  message=An unknown error occurred)"
    assert(tostring(status) == expected,
           "The following does not match expected:\n" .. tostring(status) ..
           "\nExpected:\n" .. expected)
  end,

  test_ok_status = function ()
    local status = OkStatus()
    assert(status:ok(), "Expected status to be ok.")
    assert(status:code() == StatusCode.OK)
    assert(status:message() == "")
  end,

  test_invalid_argument_error = function ()
    local status = InvalidArgumentError()
    assert(not status:ok(), "Expected status to not be ok for invalid argument.")
    assert(status:code() == StatusCode.INVALID_ARGUMENT)
    assert(status:message() == "Invalid argument.")
  end,

  -- TODO(zziccardi): Add more tests for StatusOr and other utilities.
}

for name, test in pairs(tests) do
  local success, err = pcall(test)
  if not success then
    print("FAILED: " .. name .. "\n\t" .. tostring(err))
  else
    print("PASSED: " .. name)
  end
end
