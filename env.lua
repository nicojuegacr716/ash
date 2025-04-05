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
