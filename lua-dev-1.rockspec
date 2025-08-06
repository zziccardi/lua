package = "lua"
version = "dev-1"
source = {
   url = "git+https://github.com/zziccardi/lua.git"
}
description = {
   homepage = "https://github.com/zziccardi/lua",
   license = "*** please specify a license ***"
}
dependencies = {
   queries = {}
}
build_dependencies = {
   queries = {}
}
build = {
   type = "builtin",
   modules = {
      main = "main.lua",
      ["utils.status"] = "utils/status.lua",
      ["utils.status_test"] = "utils/status_test.lua"
   }
}
test_dependencies = {
   queries = {}
}
