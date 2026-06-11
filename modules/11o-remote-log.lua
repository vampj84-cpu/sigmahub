-- ============================================
-- MODULE 11o: Remote Error Logging
-- Logs errors as GitHub Issues on vampj84-cpu/sigmahub
-- Debounced to max 1 issue per 30 seconds.
-- ============================================

local GITHUB_TOKEN = "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"
local REPO = "vampj84-cpu/sigmahub"
local MIN_INTERVAL = 30
local lastIssueTime = 0
local errCount = 0
local logCache = {}
local httpReq = nil

-- Detect available HTTP request function
do
    local tries = {request, syn and syn.request, http_request}
    for _, fn in ipairs(tries) do
        if type(fn) == "function" then
            httpReq = fn
            break
        end
    end
end

local function githubRequest(endpoint, method, body)
    if not httpReq then return nil end
    local http = game:GetService("HttpService")
    local url = "https://api.github.com/repos/" .. REPO .. "/" .. endpoint
    local headers = {
        ["Authorization"] = "token " .. GITHUB_TOKEN,
        ["Content-Type"] = "application/json",
        ["User-Agent"] = "Kaitun/1.0"
    }
    return httpReq({
        Url = url,
        Method = method or "POST",
        Headers = headers,
        Body = body and http:JSONEncode(body) or nil
    })
end

local function flushLog()
    if tick() - lastIssueTime < MIN_INTERVAL then return end
    if #logCache == 0 then return end
    pcall(function()
        local entry = table.remove(logCache, 1)
        local body = string.format(
            "**Error:** `%s`\n\n**Context:** %s\n**Player:** %s\n**Level:** %d\n**Sea:** %s\n**Time:** %s\n**Error #:** %d",
            tostring(entry.err):gsub("`", ""),
            entry.context,
            plr.Name,
            plr and plr.Data and plr.Data.Level and plr.Data.Level.Value or 0,
            (World1 and "1" or World2 and "2" or World3 and "3" or "?"),
            os.date("%Y-%m-%d %H:%M:%S"),
            errCount
        )
        local resp = githubRequest("issues", "POST", {
            title = "Kaitun: " .. entry.context,
            body = body,
            labels = {"bug", "kaitun"}
        })
        if resp and resp.StatusCode == 201 then
            lastIssueTime = tick()
        end
    end)
end

task.spawn(function()
    while task.wait(15) do
        if #logCache > 0 then flushLog() end
    end
end)

-- Sanity test: create a startup issue to confirm logging works
task.spawn(function()
    task.wait(5)
    if httpReq then
        RemoteLog:info("Startup", "Kaitun v2 started — logging online")
    else
        warn("[RemoteLog] No HTTP request function available — errors will not reach GitHub")
    end
end)

RemoteLog = {
    ready = httpReq ~= nil,

    log = function(self, context, err)
        errCount = errCount + 1
        local key = tostring(err) .. context
        local now = tick()
        for i, entry in ipairs(logCache) do
            if entry.key == key and now - entry.time < 60 then
                return
            end
        end
        table.insert(logCache, {
            key = key,
            err = tostring(err),
            context = context,
            time = now
        })
    end,

    info = function(self, context, message)
        if not httpReq then return end
        errCount = errCount + 1
        pcall(function()
            local body = string.format(
                "**Info:** %s\n\n**Context:** %s\n**Player:** %s\n**Level:** %d\n**Sea:** %s\n**Time:** %s",
                message:gsub("`", ""),
                context,
                plr.Name,
                plr.Data.Level.Value,
                (World1 and "1" or World2 and "2" or World3 and "3" or "?"),
                os.date("%Y-%m-%d %H:%M:%S")
            )
            githubRequest("issues", "POST", {
                title = "Kaitun Info: " .. context,
                body = body,
                labels = {"info", "kaitun"}
            })
        end)
    end,

    wrap = function(self, context, fn)
        return function(...)
            local ok, err = pcall(fn, ...)
            if not ok then
                self:log(context, err)
            end
        end
    end
}
