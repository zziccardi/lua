rockspec_format = "3.1"
package = "lua"
version = "dev-1"
source = {
   url = "git+https://github.com/zziccardi/lua.git"
}
description = {
   homepage = "https://github.com/zziccardi/lua",
   license = "*** please specify a license ***"
}
dependencies = {}
build = {
   type = "builtin",
   modules = {
      main = "main.lua",
      ["utils.status"] = "utils/status.lua",
      ["utils.status_test"] = "utils/status_test.lua"
   }
}
test_dependencies = {
   "luaunit >= 3.4-1"
}
test = {
  type = "command",
  script = "utils/status_test.lua"
}
