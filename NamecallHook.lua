--!native
--!optimize 2
if not game:IsLoaded() then game.Loaded:Wait() end

local BlacklistedFunctions = {
    "OpenVideosFolder",
    "OpenScreenshotsFolder",
    "GetRobuxBalance",
    "PerformPurchase",
    "PromptBundlePurchase",
    "PromptNativePurchase",
    "PromptProductPurchase",
    "PromptPurchase",
    "PromptGamePassPurchase",
    "PromptRobloxPurchase",
    "PromptThirdPartyPurchase",
    "Publish",
    "GetMessageId",
    "OpenBrowserWindow",
    "OpenNativeOverlay",
    "RequestInternal",
    "ExecuteJavaScript",
    "EmitHybridEvent",
    "AddCoreScriptLocal",
    "HttpRequestAsync",
    "ReportAbuse",
    "SaveScriptProfilingData",
    "OpenUrl",
    "DeleteCapture",
    "DeleteCapturesAsync"
}

local Metatable = getrawmetatable(game)
local OldMetatable = Metatable.__namecall

setreadonly(Metatable, false)
Metatable.__namecall = function(Self, ...)
    local Method = getnamecallmethod()
   
    if table.find(BlacklistedFunctions, Method) then
        warn("Attempt to call dangerous function.")
        return nil
    end

    if Method == "HttpGet" or Method == "HttpGetAsync" or Method == "httpget" or Method == "http_get" or Method == "httpgetAsync" or Method == "httpGetAsync" or Method == "HttpgetAsync" then
            return HttpGet(...)
    elseif Method == "GetObjects" then 
            return GetObjects(...)
    end

    return OldMetatable(Self, ...)
end

local OldIndex = Metatable.__index

setreadonly(Metatable, false)
Metatable.__index = function(Self, i)
    if table.find(BlacklistedFunctions, i) then
        warn("Attempt to call dangerous function.")
        return nil
    end

    if Self == game then
        if i == "HttpGet" or i == "HttpGetAsync" or i == "httpget" or i == "httpgetasync" or i == "HttpGetAsync" or i == "httpGetAsync" or i == "HttpgetAsync" then 
            return HttpGet
        elseif i == "GetObjects" then 
            return GetObjects
        end
    end
    return OldIndex(Self, i)
end
