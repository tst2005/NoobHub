
local json

-- platform dependent code
if (MOAIJsonParser ~= nil) then -- looks like MoaiSDK
	json = MOAIJsonParser
else
	json = require("json")
end -- /platform dependent code

return json
