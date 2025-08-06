
package.path = package.path .. ";/Users/zziccardi/Desktop/lua/utils/?.lua"

require("utils.status")

local tests = {
  test_status_code_to_string = function ()
    assert(StatusCodeToString(0) == "",
           "Expected empty string for invalid code.")
    assert(StatusCodeToString(1) == "OK")
  end,

  test_status_invalid_code = function ()
    local status = Status.init(6, "Invalid code")
    assert(not status:ok(), "Expected status to not be ok for invalid code.")
    assert(status:code() == StatusCode.OUT_OF_RANGE)
    assert(status:message() == "Invalid status code: 6")
  end,

  test_status_valid_params = function ()
    local status = Status.init(StatusCode.FAILED_PRECONDITION,
                               "Precondition failed")
    assert(not status:ok())
    assert(status:code() == StatusCode.FAILED_PRECONDITION)
    assert(status:message() == "Precondition failed")
  end,

  test_status_to_string = function ()
    local status = Status.init(StatusCode.UNKNOWN, "An unknown error occurred")
    local expected = "Status(code=UNKNOWN, message=An unknown error occurred)"
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
    assert(not status:ok(),
           "Expected status to not be ok for invalid argument.")
    assert(status:code() == StatusCode.INVALID_ARGUMENT)
    assert(status:message() == "Invalid argument.")
  end,

  test_status_or_with_ok_status = function ()
    local status_or = StatusOr.init(OkStatus())
    assert(status_or:ok())
    assert(status_or:status():code() == StatusCode.OK)
    assert(status_or:value() == nil,
           "Expected value to be nil for ok status.")
  end,

  test_status_or_with_not_ok_status = function ()
    local status_or = StatusOr.init(InvalidArgumentError())
    assert(not status_or:ok())
    assert(status_or:status():code() == StatusCode.INVALID_ARGUMENT)
    assert(status_or:value() == nil,
           "Expected value to be nil for error status.")
  end,

  test_status_or_with_value = function ()
    local status_or = StatusOr.init("foo")
    assert(status_or:ok())
    assert(status_or:status():code() == StatusCode.OK)
    assert(status_or:value() == "foo")
  end,

  test_status_or_to_string = function ()
    local status_or = StatusOr.init(InvalidArgumentError("Bad input"))
    local expected =
        "StatusOr(status=Status(code=INVALID_ARGUMENT, message=Bad input), "
                  .. "value=nil)"
    assert(tostring(status_or) == expected)
  end,
}

for name, test in pairs(tests) do
  local success, err = pcall(test)
  if not success then
    print("FAILED: " .. name .. "\n\t" .. tostring(err))
  else
    print("PASSED: " .. name)
  end
end
