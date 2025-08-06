
-- package.path = package.path .. ";/Users/zziccardi/Desktop/lua/utils/?.lua"

require("utils.status")

local lu = require("luaunit")

local StatusTest = {}

function StatusTest:test_status_code_to_string()
  lu.assertEquals(StatusCodeToString(0), "")
  lu.assertEquals(StatusCodeToString(1), "OK")
end

function StatusTest:test_status_invalid_code()
  local status = Status.init(6, "Invalid code")
  lu.assertFalse(status:ok())
  lu.assertEquals(status:code(), StatusCode.OUT_OF_RANGE)
  lu.assertEquals(status:message(), "Invalid status code: 6")
end

function StatusTest:test_status_valid_params()
  local status = Status.init(StatusCode.FAILED_PRECONDITION,
                             "Precondition failed")
  lu.assertFalse(status:ok())
  lu.assertEquals(status:code(), StatusCode.FAILED_PRECONDITION)
  lu.assertEquals(status:message(), "Precondition failed")
end

function StatusTest:test_status_to_string()
  local status = Status.init(StatusCode.UNKNOWN, "An unknown error occurred")
  lu.assertEquals(tostring(status),
                  "Status(code=UNKNOWN, message=An unknown error occurred)")
end

function StatusTest:test_ok_status()
  local status = OkStatus()
  lu.assertTrue(status:ok())
  lu.assertEquals(status:code(), StatusCode.OK)
  lu.assertEquals(status:message(), "")
end

function StatusTest:test_invalid_argument_error()
  local status = InvalidArgumentError()
  lu.assertFalse(status:ok())
  lu.assertEquals(status:code(), StatusCode.INVALID_ARGUMENT)
  lu.assertEquals(status:message(), "Invalid argument.")
end

function StatusTest:test_status_or_with_ok_status()
  local status_or = StatusOr.init(OkStatus())
  lu.assertTrue(status_or:ok())
  lu.assertEquals(status_or:status():code(), StatusCode.OK)
  lu.assertNil(status_or:value(), "Expected value to be nil for ok status.")
end

function StatusTest:test_status_or_with_not_ok_status()
  local status_or = StatusOr.init(InvalidArgumentError())
  lu.assertFalse(status_or:ok())
  lu.assertEquals(status_or:status():code(), StatusCode.INVALID_ARGUMENT)
  lu.assertNil(status_or:value(), "Expected value to be nil for error status.")
end

function StatusTest:test_status_or_with_value()
  local status_or = StatusOr.init("foo")
  lu.assertTrue(status_or:ok())
  lu.assertEquals(status_or:status():code(), StatusCode.OK)
  lu.assertEquals(status_or:value(), "foo")
end

function StatusTest:test_status_or_to_string()
  local status_or = StatusOr.init(InvalidArgumentError("Bad input"))
  local expected =
      "StatusOr(status=Status(code=INVALID_ARGUMENT, message=Bad input), "
                .. "value=nil)"
  lu.assertEquals(tostring(status_or), expected)
end

os.exit(lu.LuaUnit.run())
