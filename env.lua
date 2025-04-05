local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local InsertService = game:GetService("InsertService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local RobloxEnvironment = table.freeze({
	["print"] = print, ["warn"] = warn, ["error"] = error, ["assert"] = assert, ["collectgarbage"] = collectgarbage, ["require"] = require,
	["select"] = select, ["tonumber"] = tonumber, ["tostring"] = tostring, ["type"] = type, ["xpcall"] = xpcall,
	["pairs"] = pairs, ["next"] = next, ["ipairs"] = ipairs, ["newproxy"] = newproxy, ["rawequal"] = rawequal, ["rawget"] = rawget,
	["rawset"] = rawset, ["rawlen"] = rawlen, ["gcinfo"] = gcinfo,

	["coroutine"] = {
		["create"] = coroutine["create"], ["resume"] = coroutine["resume"], ["running"] = coroutine["running"],
		["status"] = coroutine["status"], ["wrap"] = coroutine["wrap"], ["yield"] = coroutine["yield"],
	},

	["bit32"] = {
		["arshift"] = bit32["arshift"], ["band"] = bit32["band"], ["bnot"] = bit32["bnot"], ["bor"] = bit32["bor"], ["btest"] = bit32["btest"],
		["extract"] = bit32["extract"], ["lshift"] = bit32["lshift"], ["replace"] = bit32["replace"], ["rshift"] = bit32["rshift"], ["xor"] = bit32["xor"],
	},

	["math"] = {
		["abs"] = math["abs"], ["acos"] = math["acos"], ["asin"] = math["asin"], ["atan"] = math["atan"], ["atan2"] = math["atan2"], ["ceil"] = math["ceil"],
		["cos"] = math["cos"], ["cosh"] = math["cosh"], ["deg"] = math["deg"], ["exp"] = math["exp"], ["floor"] = math["floor"], ["fmod"] = math["fmod"],
		["frexp"] = math["frexp"], ["ldexp"] = math["ldexp"], ["log"] = math["log"], ["log10"] = math["log10"], ["max"] = math["max"], ["min"] = math["min"],
		["modf"] = math["modf"], ["pow"] = math["pow"], ["rad"] = math["rad"], ["random"] = math["random"], ["randomseed"] = math["randomseed"],
		["sin"] = math["sin"], ["sinh"] = math["sinh"], ["sqrt"] = math["sqrt"], ["tan"] = math["tan"], ["tanh"] = math["tanh"]
	},

	["string"] = {
		["byte"] = string["byte"], ["char"] = string["char"], ["find"] = string["find"], ["format"] = string["format"], ["gmatch"] = string["gmatch"],
		["gsub"] = string["gsub"], ["len"] = string["len"], ["lower"] = string["lower"], ["match"] = string["match"], ["pack"] = string["pack"],
		["packsize"] = string["packsize"], ["rep"] = string["rep"], ["reverse"] = string["reverse"], ["sub"] = string["sub"],
		["unpack"] = string["unpack"], ["upper"] = string["upper"],
	},

	["table"] = {
		["clone"] = table.clone, ["concat"] = table.concat, ["insert"] = table.insert, ["pack"] = table.pack, ["remove"] = table.remove, ["sort"] = table.sort,
		["unpack"] = table.unpack,
	},

	["utf8"] = {
		["char"] = utf8["char"], ["charpattern"] = utf8["charpattern"], ["codepoint"] = utf8["codepoint"], ["codes"] = utf8["codes"],
		["len"] = utf8["len"], ["nfdnormalize"] = utf8["nfdnormalize"], ["nfcnormalize"] = utf8["nfcnormalize"],
	},

	["os"] = {
		["clock"] = os["clock"], ["date"] = os["date"], ["difftime"] = os["difftime"], ["time"] = os["time"],
	},

	["delay"] = delay, ["elapsedTime"] = elapsedTime, ["spawn"] = spawn, ["tick"] = tick, ["time"] = time, ["typeof"] = typeof,
	["UserSettings"] = UserSettings, ["version"] = version, ["wait"] = wait, ["_VERSION"] = _VERSION,

	["task"] = {
		["defer"] = task["defer"], ["delay"] = task["delay"], ["spawn"] = task["spawn"], ["wait"] = task["wait"], ["cancel"] = task["cancel"]
	},

	["debug"] = {
		["traceback"] = debug["traceback"], ["profilebegin"] = debug["profilebegin"], ["profileend"] = debug["profileend"],
	},

	["game"] = game, ["workspace"] = workspace, ["Game"] = game, ["Workspace"] = workspace,

	["getmetatable"] = getmetatable, ["setmetatable"] = setmetatable
})

-- Returns the script responsible for the currently running function.
getgenv()["getcallingscript"] = (function() return getgenv(0)["script"] end)
getgenv()["get_calling_script"] = getcallingscript
getgenv()["GetCallingScript"] = getcallingscript

-- Generates a new closure using the bytecode of script.
getgenv()["getscriptclosure"] = (function(script)
	return function()
		return getrenv()["table"].clone(getrenv().require(script))
	end
end)

getgenv()["get_script_closure"] = getscriptclosure
getgenv()["GetScriptClosure"] = getscriptclosure

getgenv()["getscriptfunction"] = getscriptclosure
getgenv()["get_script_function"] = getscriptclosure
getgenv()["GetScriptFunction"] = getscriptclosure

local function RobloxConsoleHandler(...)
	warn("Disabled \"rconsole\" library.")
end

getgenv()["rconsoleclear"] = newcclosure(RobloxConsoleHandler)
getgenv()["consoleclear"] = rconsoleclear
getgenv()["console_clear"] = rconsoleclear
getgenv()["ConsoleClear"] = rconsoleclear

getgenv()["rconsolecreate"] = newcclosure(RobloxConsoleHandler)
getgenv()["consolecreate"] = rconsolecreate
getgenv()["console_create"] = rconsolecreate
getgenv()["ConsoleCreate"] = rconsolecreate

getgenv()["rconsoledestroy"] = newcclosure(RobloxConsoleHandler)
getgenv()["consoledestroy"] = rconsoledestroy
getgenv()["console_destroy"] = rconsoledestroy
getgenv()["ConsoleDestroy"] = rconsoledestroy

getgenv()["rconsoleinput"] = newcclosure(RobloxConsoleHandler)
getgenv()["consoleinput"] = rconsoleinput
getgenv()["console_input"] = rconsoleinput
getgenv()["ConsoleInput"] = rconsoleinput

getgenv()["rconsoleprint"] = newcclosure(RobloxConsoleHandler)
getgenv()["consoleprint"] = rconsoleprint
getgenv()["console_print"] = rconsoleprint
getgenv()["ConsolePrint"] = rconsoleprint

getgenv()["rconsolesettitle"] = newcclosure(RobloxConsoleHandler)
getgenv()["rconsolename"] = rconsolesettitle
getgenv()["consolesettitle"] = rconsolesettitle
getgenv()["console_set_title"] = rconsolesettitle
getgenv()["ConsoleSetTitle"] = rconsolesettitle

getgenv()["getloadedmodules"] = newcclosure(function()
    local LoadedModules = {}
    for _, v in pairs(getrenv()["game"]:GetDescendants()) do
        if typeof(v) == "Instance" and v:IsA("ModuleScript") then getrenv()["table"].insert(LoadedModules, v) end
    end
    return LoadedModules
end)

getgenv()["get_loaded_modules"] = getloadedmodules
getgenv()["GetLoadedModules"] = getloadedmodules

-- Returns a list of scripts that are currently running.
getgenv()["getrunningscripts"] = newcclosure(function()
    local RunningScripts = {}
    for _, v in ipairs(Players["LocalPlayer"]:GetDescendants()) do
        if v:IsA("LocalScript") or v:IsA("ModuleScript") then
            RunningScripts[#RunningScripts + 1] = v
        end
    end
    return RunningScripts
end)

getgenv()["get_running_scripts"] = getrunningscripts
getgenv()["GetRunningScripts"] = getrunningscripts

getgenv()["getscripts"] = getrunningscripts
getgenv()["get_scripts"] = getrunningscripts
getgenv()["GetScripts"] = getrunningscripts

-- Returns a SHA384 hash of the script's bytecode. This is useful for detecting changes to a script's source code.
getgenv()["getscripthash"] = newcclosure(function(Inst)
    assert(typeof(Inst) == "Instance", "invalid argument #1 to 'getscripthash' (Instance expected, got " .. typeof(Inst) .. ") ", 2)
	assert(Inst:IsA("LuaSourceContainer"), "invalid argument #1 to 'getscripthash' (LuaSourceContainer expected, got " .. Inst["ClassName"] .. ") ", 2)
	return Inst:GetHash()
end)

-- Returns the global environment of the given script. It can be used to access variables and functions that are not defined as local.
getgenv()["getsenv"] = newcclosure(function(script)
    assert(typeof(script) == "Instance", "invalid argument #1 to 'getsenv' [ModuleScript or LocalScript expected]", 2);
	assert((script:IsA("LocalScript") or script:IsA("ModuleScript")), "invalid argument #1 to 'getsenv' [ModuleScript or LocalScript expected]", 2)
	if (script:IsA("LocalScript") == true) then 
		for _, v in getreg() do
			if (type(v) == "function") then
				if getfenv(v)["script"] then
					if getfenv(v)["script"] == script then
						return getfenv(v)
					end
				end
			end
		end
	else
		local Reg = getreg()
		local Senv = {}

		if #Reg == 0 then
			return require(script)
		end

		for _, v in next, Reg do
			if type(v) == "function" and islclosure(v) then
				local Fenv = getfenv(v)
				local Raw = rawget(Fenv, "script")
				if Raw and Raw == script then
					for i, k in next, Fenv do
						if i ~= "script" then
							rawset(Senv, i, k)
						end
					end
				end
			end
		end
		return Senv
	end
end)

getgenv()["lz4compress"] = newcclosure(function(Data)
    local Out, i, DataLen = {}, 1, #Data

    while i <= DataLen do
        local BestLen, BestDist = 0, 0

        for Dist = 1, math.min(i - 1, 65535) do
            local MatchStart, Len = i - Dist, 0

            while i + Len <= DataLen and Data:sub(MatchStart + Len, MatchStart + Len) == Data:sub(i + Len, i + Len) do
                Len += 1
                if Len == 65535 then break end
            end

            if Len > BestLen then BestLen, BestDist = Len, Dist end
        end

        if BestLen >= 4 then
            getrenv()["table"].insert(Out, getrenv()["string"].char(0) .. getrenv()["string"].pack(">I2I2", BestDist - 1, BestLen - 4))
            i += BestLen
        else
            local LitStart = i

            while i <= DataLen and (i - LitStart < 15 or i == DataLen) do i += 1 end
            getrenv()["table"].insert(Out, getrenv()["string"].char(i - LitStart) .. Data:sub(LitStart, i - 1))
        end
    end
    return getrenv()["table"].concat(Out)
end)

getgenv()["lz4_compress"] = lz4compress
getgenv()["Lz4Compress"] = lz4compress

-- Decompresses `data` using LZ4 compression, with the decompressed size specified by `size`.
getgenv()["lz4decompress"] = newcclosure(function(Data, Size)
    local Out, i, DataLen = {}, 1, #Data

    while i <= DataLen and #getrenv()["table"].concat(Out) < Size do
        local Token = Data:byte(i)
        i = i + 1

        if Token == 0 then
            local Dist, Len = getrenv()["string"].unpack(">I2I2", Data:sub(i, i + 3))

            i = i + 4
            Dist = Dist + 1
            Len = Len + 4

            local Start = #getrenv()["table"].concat(Out) - Dist + 1
            local Match = getrenv()["table"].concat(Out):sub(Start, Start + Len - 1)

            while #Match < Len do
                Match = Match .. Match
            end

            getrenv()["table"].insert(Out, Match:sub(1, Len))
        else
            getrenv()["table"].insert(Out, Data:sub(i, i + Token - 1))
            i = i + Token
        end
    end

    return getrenv()["table"].concat(Out):sub(1, Size)
end)

getgenv()["lz4_decompress"] = lz4decompress
getgenv()["Lz4Decompress"] = lz4decompress

getgenv()["getrenv"] = newcclosure(function() return RobloxEnvironment end)
