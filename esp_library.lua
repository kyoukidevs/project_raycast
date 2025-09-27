-- FABRICATED VALUES!!!
local type_custom = typeof
if not LPH_OBFUSCATED then
	LPH_JIT = function(...)
		return ...;
	end;
	LPH_JIT_MAX = function(...)
		return ...;
	end;
	LPH_NO_VIRTUALIZE = function(...)
		return ...;
	end;
	LPH_NO_UPVALUES = function(f)
		return (function(...)
			return f(...);
		end);
	end;
	LPH_ENCSTR = function(...)
		return ...;
	end;
	LPH_ENCNUM = function(...)
		return ...;
	end;
	LPH_ENCFUNC = function(func, key1, key2)
		if key1 ~= key2 then return print("LPH_ENCFUNC mismatch") end
		return func
	end
	LPH_CRASH = function()
		return print(debug.traceback());
	end;
    SWG_DiscordUser = "swim"
    SWG_DiscordID = 1337
    SWG_Private = true
    SWG_Dev = false
    SWG_Version = "dev"
    SWG_Title = 'roblox gay sex gui %s - %s'--'$$$  swimhub<font color="rgb(166, 0, 255)">.xyz</font> %s - %s  $$$'
    SWG_ShortName = 'dev'
    SWG_FullName = 'indev build'
    SWG_FFA = false
end;
--- FABRICATED VALUES END!!!

local workspace = cloneref(game:GetService("Workspace"))
local Players = cloneref(game:GetService("Players"))
local RunService = cloneref(game:GetService("RunService"))
local Lighting = cloneref(game:GetService("Lighting"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local HttpService = cloneref(game:GetService("HttpService"))
local GuiInset = cloneref(game:GetService("GuiService")):GetGuiInset()
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

local function getfile(name)
    local repo = "https://raw.githubusercontent.com/SWIMHUBISWIMMING/swimhub/main/"
    local success, content = pcall(request, {Url = repo..name, Method = "GET"})
    if success and content.StatusCode == 200 then
        return content.Body
    else
        return print("getfile returned error \""..content.."\"")
    end
end
local function isswimhubfile(file)
    return isfile("swimhub/new/files/"..file)
end
local function readswimhubfile(file)
    if not isswimhubfile(file) then return false end
    local success, returns = pcall(readfile, "swimhub/new/files/"..file)
    if success then return returns else return print(returns) end
end
local function loadswimhubfile(file)
    if not isswimhubfile(file) then return false end
    local success, returns = pcall(loadstring, readswimhubfile(file))
    if success then return returns else return print(returns) end
end
local function getswimhubasset(file)
    if isswimhubfile(file) then return false end
    local success, returns = pcall(getcustomasset, "swimhub/new/files/"..file)
    if success then return returns else return print(returns) end
end
do
    if not isfolder("swimhub") then makefolder("swimhub") end
    if not isfolder("swimhub/new") then makefolder("swimhub/new") end
    if not isfolder("swimhub/new/files") then makefolder("swimhub/new/files") end
    local function getfiles(force, list)
        for _, file in list do
            if (force or not force and not isswimhubfile(file)) then
                writefile("swimhub/new/files/"..file, getfile(file))
            end
        end
    end
    local gotassets = getfile("assets.json")
    local assets = HttpService:JSONDecode(gotassets)
    local localassets = readswimhubfile("assets.json")
    if localassets then
        localassets = HttpService:JSONDecode(localassets)
        if localassets.version ~= assets.version then
            writefile("swimhub/new/files/assets.json", gotassets)
            getfiles(true, assets.list)
        end
    else
        writefile("swimhub/new/files/assets.json", gotassets)
    end
    getfiles(false, assets.list)
end

-- swimhub main

local cheat = {
    Library = nil,
    Toggles = nil,
    Options = nil,
    ThemeManager = nil,
    SaveManager = nil,
    connections = {
        heartbeats = {},
        renderstepped = {}
    },
    drawings = {},
    hooks = {}
}
cheat.utility = {} do
    cheat.utility.new_heartbeat = function(func)
        local obj = {}
        cheat.connections.heartbeats[func] = func
        function obj:Disconnect()
            if func then
                cheat.connections.heartbeats[func] = nil
                func = nil
            end
        end
        return obj
    end
    cheat.utility.new_renderstepped = function(func)
        local obj = {}
        cheat.connections.renderstepped[func] = func
        function obj:Disconnect()
            if func then
                cheat.connections.renderstepped[func] = nil
                func = nil
            end
        end
        return obj
    end
    cheat.utility.new_drawing = function(drawobj, args)
        local obj = Drawing.new(drawobj)
        for i, v in pairs(args) do
            obj[i] = v
        end
        cheat.drawings[obj] = obj
        return obj
    end
    cheat.utility.new_hook = function(f, newf, usecclosure) LPH_NO_VIRTUALIZE(function()
        if usecclosure then
            local old; old = hookfunction(f, newcclosure(function(...)
                return newf(old, ...)
            end))
            cheat.hooks[f] = old
            return old
        else
            local old; old = hookfunction(f, function(...)
                return newf(old, ...)
            end)
            cheat.hooks[f] = old
            return old
        end
    end)() end
    local connection; connection = RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function(delta)
        for _, func in pairs(cheat.connections.heartbeats) do
            func(delta)
        end
    end))
    local connection1; connection1 = RunService.RenderStepped:Connect(LPH_NO_VIRTUALIZE(function(delta)
        for _, func in pairs(cheat.connections.renderstepped) do
            func(delta)
        end
    end))
    cheat.utility.unload = function()
        connection:Disconnect()
        connection1:Disconnect()
        for key, _ in pairs(cheat.connections.heartbeats) do
            cheat.connections.heartbeats[key] = nil
        end
        for key, _ in pairs(cheat.connections.renderstepped) do
            cheat.connections.heartbeats[key] = nil
        end
        for _, drawing in pairs(cheat.drawings) do
            drawing:Remove()
            cheat.drawings[_] = nil
        end
        for hooked, original in pairs(cheat.hooks) do
            if type(original) == "function" then
                hookfunction(hooked, clonefunction(original))
            else
                hookmetamethod(original["instance"], original["metamethod"], clonefunction(original["func"]))
            end
        end
    end
end
-- [version:ls]
-- [translation:lone survival]
-- [scriptid:lonesurvival]
local lone = {
    projectile_spoof = {},
}
lone.remote_event = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteEvent")
function lone:fire_server(real, ...)
    local args = {real, false, ...}
    LPH_NO_VIRTUALIZE(function()
        local random = Random.new(os.time() + os.clock())
        local numarg = #args - 2
        for i = #args + 1, #args + random:NextInteger(random:NextInteger(1, 5), random:NextInteger(5, 10)) do
            args[i] = random:NextInteger(1, 50)
        end
        args[#args + 1] = numarg
        lone.remote_event:FireServer(unpack(args))
    end)();
end

for _, gc in getgc(true) do
    if type(gc) == "table" then
        if rawget(gc, "CurrentSlot") and rawget(gc, "ScrollSlot") then
            lone.hotbar = gc
        end
        if rawget(gc, "RecoilSpring") then
            lone.recoilspring = rawget(gc, "RecoilSpring")
        end
        if rawget(gc, "TargetImpulse") and rawget(gc, "Impulse") then
            lone.spring = gc
        end
    end
end

if not (lone.recoilspring and lone.hotbar and lone.spring) then
    local holyshit = {
        ['hotbar'] = not not lone.hotbar,
        ['recoilspring'] = not not lone.hotbar,
        ['spring'] = not not lone.hotbar
    }
    local computed = ""
    for k, v in holyshit do
        if not v then computed = computed .. k .. " " end
    end
    return LocalPlayer:Kick("failed to get -> "..computed)
end

cheat.Library, cheat.Toggles, cheat.Options = loadswimhubfile("library_main.lua")()
cheat.ThemeManager = loadswimhubfile("library_theme.lua")()
cheat.SaveManager = loadswimhubfile("library_save.lua")()
local ui = {
    window = cheat.Library:CreateWindow({
        Title=string.format(
            SWG_Title,
            SWG_Version,
            SWG_FullName
        ),
    Center=true,AutoShow=true,TabPadding=8})
}
local _CFramenew = CFrame.new
local _Vector2new = Vector2.new
local _Vector3new = Vector3.new
local _IsDescendantOf = game.IsDescendantOf
local _FindFirstChild = game.FindFirstChild
local _FindFirstChildOfClass = game.FindFirstChildOfClass
local _Raycast = workspace.Raycast
local _IsKeyDown = UserInputService.IsKeyDown
local _WorldToViewportPoint = Camera.WorldToViewportPoint
local _Vector3zeromin = Vector3.zero.Min
local _Vector2zeromin = Vector2.zero.Min
local _Vector3zeromax = Vector3.zero.Max
local _Vector2zeromax = Vector2.zero.Max
local _IsA = game.IsA
local tablecreate = table.create
local mathfloor = math.floor
local mathround = math.round
local tostring = tostring
local unpack = unpack
local getupvalues = debug.getupvalues
local getupvalue = debug.getupvalue
local setupvalue = debug.setupvalue
local getconstants = debug.getconstants
local getconstant = debug.getconstant
local setconstant = debug.setconstant
local getstack = debug.getstack
local setstack = debug.setstack
local getinfo = debug.getinfo
local rawget = rawget

ui.tabs = {
    combat = ui.window:AddTab('combat'),
    visuals = ui.window:AddTab('visuals'),
    world = ui.window:AddTab('world'),
    misc = ui.window:AddTab('misc'),
    config = ui.window:AddTab('config'),
}
ui.box = {
    aim = ui.tabs.combat:AddLeftTabbox(),
    fov = ui.tabs.combat:AddRightTabbox(),
    gunmods = ui.tabs.combat:AddRightTabbox(),
    esp = ui.tabs.visuals:AddLeftTabbox(),
    espsets = ui.tabs.visuals:AddRightTabbox(),
    world1 = ui.tabs.world:AddLeftTabbox(),
    world2 = ui.tabs.world:AddRightTabbox(),
    move = ui.tabs.misc:AddLeftTabbox(),
    misc = ui.tabs.misc:AddRightTabbox(),
    themeconfig = ui.tabs.config:AddLeftGroupbox('theme config'),
}


local vectors = {
    Vector3.zero, -- none
    _Vector3new(1, 0, 0), -- big right
    _Vector3new(-1, 0, 0), -- big left
    _Vector3new(0, 0, 1), -- big forward
    _Vector3new(0, 0, -1), -- big backward
    _Vector3new(0, 1, 0), -- big up
    _Vector3new(0, -1, 0), -- big down
    
    _Vector3new(1 / 2, 0, 0), -- small right
    _Vector3new(-1 / 2, 0, 0), -- small left
    _Vector3new(0, 0, 1 / 2), -- small forward
    _Vector3new(0, 0, -1 / 2), -- small backward
    _Vector3new(0, 1 / 2, 0), -- small up
    _Vector3new(0, -1 / 2, 0), -- small down

    _Vector3new(1 / 2, 1 / 2, 0), -- small right up
    _Vector3new(1 / 2, -1 / 2, 0), -- small right down
    _Vector3new(-1 / 2, 1 / 2, 0), -- small left up
    _Vector3new(-1 / 2, -1 / 2, 0), -- small left down
    _Vector3new(0, 1 / 2, 1 / 2), -- small forward up
    _Vector3new(0, -1 / 2, 1 / 2), -- small forward down
    _Vector3new(0, 1 / 2, -1 / 2), -- small backward up
    _Vector3new(0, -1 / 2, -1 / 2), -- small backward down
}

local vischeck_params = RaycastParams.new()
vischeck_params.FilterDescendantsInstances = { workspace.Ignored, Camera }
vischeck_params.FilterType = Enum.RaycastFilterType.Exclude
vischeck_params.IgnoreWater = true

cheat.quartic = (function()
    local pi=math.pi;
    local c=math.abs;local d=math.sqrt;local e=math.acos;local f=math.cos;local g=1e-9;
    local function h(i)return i>-g and i<g end;
    local function j(k)return k>0 and k^(1/3)or-c(k)^(1/3)end;
    local function l(m,n,o)local p,q;local r,s,t;r=n/(2*m)s=o/m;t=r*r-s;if h(t)then p=-r;return p elseif t<0 then return else local u=d(t)p=u-r;q=-u-r;return p,q end end;
    local function v(m,n,o,w)local p,q,x;local y,z;local A,B,C;local D,r,s;local E,t;A=n/m;B=o/m;C=w/m;D=A*A;r=1/3*(-(1/3)*D+B)s=0.5*(2/27*A*D-1/3*A*B+C)E=r*r*r;t=s*s+E;if h(t)then if h(s)then p=0;y=1 else local F=j(-s)p=2*F;q=-F;y=2 end elseif t<0 then local G=1/3*e(-s/d(-E))local H=2*d(-r)p=H*f(G)q=-H*f(G+pi/3)x=-H*f(G-pi/3)y=3 else local u=d(t)local F=j(u-s)local I=-j(u+s)p=F+I;y=1 end;z=1/3*A;if y>0 then p=p-z end;if y>1 then q=q-z end;if y>2 then x=x-z end;return p,q,x;end;
    local function J(m,n,o,w,K)local p,q,x,L;local M={}local N,F,I,z;local A,B,C,t;local D,r,s,O;local y;A=n/m;B=o/m;C=w/m;t=K/m;D=A*A;r=-0.375*D+B;s=0.125*D*A-0.5*A*B+C;O=-(3/256)*D*D+0.0625*D*B-0.25*A*C+t;if h(O)then M[3]=s;M[2]=r;M[1]=0;M[0]=1;local P={v(M[0],M[1],M[2],M[3])}y=#P;p,q,x=P[1],P[2],P[3]else M[3]=0.5*O*r-0.125*s*s;M[2]=-O;M[1]=-0.5*r;M[0]=1;p,q,x=v(M[0],M[1],M[2],M[3])N=p;F=N*N-O;I=2*N-r;if h(F)then F=0 elseif F>0 then F=d(F)else return end;if h(I)then I=0 elseif I>0 then I=d(I)else return end;M[2]=N-F;M[1]=s<0 and-I or I;M[0]=1;do local P={l(M[0],M[1],M[2])}y=#P;p,q=P[1],P[2]end;M[2]=N+F;M[1]=s<0 and I or-I;M[0]=1;if y==0 then local P={l(M[0],M[1],M[2])}y=y+#P;p,q=P[1],P[2]end;if y==1 then local P={l(M[0],M[1],M[2])}y=y+#P;q,x=P[1],P[2]end;if y==2 then local P={l(M[0],M[1],M[2])}y=y+#P;x,L=P[1],P[2]end end;z=0.25*A;if y>0 then p=p-z end;if y>1 then q=q-z end;if y>2 then x=x-z end;if y>3 then L=L-z end;return{L,x,q,p}end;
    return J
end)();

cheat.trajectory = function(origin, projectileSpeed, targetPos, targetVelocity, pickLongest, gravity)
	local g = gravity or workspace.Gravity

	local disp = targetPos - origin
	local p, q, r = targetVelocity.X, targetVelocity.Y, targetVelocity.Z
	local h, j, k = disp.X, disp.Y, disp.Z
	local l = -.5 * g 

	local solutions = cheat.quartic(
		l*l,
		-2*q*l,
		q*q - 2*j*l - projectileSpeed*projectileSpeed + p*p + r*r,
		2*j*q + 2*h*p + 2*k*r,
		j*j + h*h + k*k
	)
	if solutions then
		local posRoots = table.create(2)
		for _, v in solutions do
			if v > 0 then
				posRoots[#posRoots + 1] = v
			end
		end
		if posRoots[1] then
			local t = posRoots[pickLongest and 2 or 1]
			local d = (h + p*t)/t
			local e = (j + q*t - l*t*t)/t
			local f = (k + r*t)/t
			return origin + _Vector3new(d, e, f)
		end
	end
	return
end

--[[
cheat.trajectory = function(origin, projectileSpeed, targetPos, targetVelocity, pickLongest, gravity)
    local g = gravity * .5
    local d = (targetPos - origin).Magnitude
    local t = (d / projectileSpeed)
    local p = targetPos + targetVelocity * t
    t = t + ((p - targetPos).Magnitude / projectileSpeed)
    local x = g * t ^ 2
    x = x == x and x or 0
    return p + _Vector3new(0, x, 0)
end;
]]

local get_character do
    local player_folder = workspace.Players
    get_character = function(player)
        if not player then return end
        return _FindFirstChild(player_folder, player.Name)
    end
end

local function is_visible(position, target, target_part)
    if not (target and target_part and position) then return false end
    local castresults = _Raycast(workspace, position, target_part.CFrame.p - position, vischeck_params)
    return castresults and castresults.Instance and castresults.Instance.Parent == target
end

local function is_position_visible(pos_from, pos_to)
    if not (pos_to and pos_from) then return false end
    local castresults = _Raycast(workspace, pos_from, pos_to - pos_from, vischeck_params)
    return not castresults
end

local function get_manipulation_pos(origin_pos, target, target_part, range, enabled, thruwalls)
    local final, maxmag = nil, math.huge;
    if not enabled then return nil end
    for _, vector in vectors do
        local curvector = (vector * range)
        local modified = origin_pos + curvector
        local posvisible, visible = thruwalls or is_position_visible(origin_pos, modified), is_visible(modified, target, target_part)
        if curvector.Magnitude <= maxmag and posvisible and visible then
            final = curvector
            maxmag = curvector.Magnitude
        end
    end
    return final
end

local get_closests = function(maxdist)
    local maxdist, chars = maxdist or 15, {}
    local myhrp = LocalPlayer.Character and _FindFirstChild(LocalPlayer.Character, "HumanoidRootPart")
    if not myhrp then return end
    LPH_NO_VIRTUALIZE(function()
        for _, player in Players:GetPlayers() do
            if (player == LocalPlayer) then continue end
            local plrchar = get_character(player)
            if not (plrchar) then continue end
            local hrp, hum = _FindFirstChild(plrchar, "HumanoidRootPart"), _FindFirstChildOfClass(plrchar, "Humanoid")
            if not (hrp and hum) then continue end
            if not (_FindFirstChild(plrchar, "Head")) then continue end
            local dist = (hrp.Position - myhrp.Position).Magnitude
            if dist < maxdist then
                chars[#chars + 1] = plrchar
            end
        end
    end)();
    return chars
end

local get_closest_target = function(fov_size, aimpart)
    local ermm_part, isnpc = nil, false
    local maximum_distance = fov_size
    local mousepos = _Vector2new(Mouse.X, Mouse.Y)
    LPH_NO_VIRTUALIZE(function()
        for _, player in Players:GetPlayers() do
            local character = get_character(player)
            if not (player ~= LocalPlayer and character) then continue end
            local part = _FindFirstChild(character, aimpart)
            local humanoid = _FindFirstChildOfClass(character, "Humanoid")
            if not (part and humanoid and humanoid.Health > 0) then continue end
            local position, onscreen = _WorldToViewportPoint(Camera, part.Position)
            local distance = (_Vector2new(position.X, position.Y - GuiInset.Y) - mousepos).Magnitude
            if onscreen and distance <= maximum_distance then
                ermm_part = part
                maximum_distance = distance
                isnpc = false
            end
        end
        for _, npc in workspace.AI:GetChildren() do
            local part = _FindFirstChild(npc, aimpart)
            local humanoid = _FindFirstChildOfClass(npc, "Humanoid")
            if not (part and humanoid and humanoid.Health > 0) then continue end
            local position, onscreen = _WorldToViewportPoint(Camera, part.Position)
            local distance = (_Vector2new(position.X, position.Y - GuiInset.Y) - mousepos).Magnitude
            if onscreen and distance <= maximum_distance then
                ermm_part = part
                maximum_distance = distance
                isnpc = true
            end
        end
    end)();
    return ermm_part, isnpc
end

--// ESP LIBRARY
LPH_NO_VIRTUALIZE(function()
    local esp_table = {}
    local workspace = cloneref and cloneref(game:GetService("Workspace")) or game:GetService("Workspace")
    local rservice = cloneref and cloneref(game:GetService("RunService")) or game:GetService("RunService")
    local plrs = cloneref and cloneref(game:GetService("Players")) or game:GetService("Players")
    local lplr = plrs.LocalPlayer
    local container = Instance.new("Folder", game:GetService("CoreGui").RobloxGui)

    esp_table = {
        __loaded = false,
        main_settings = {
            textSize = 15,
            textFont = Drawing.Fonts.Monospace,
            distancelimit = false,
            maxdistance = 200,
            boxStatic = false,
            boxStaticX = 3.5,
            boxStaticY = 5,
            fadetime = 1,
        },
        settings = {
            enemy = {
                enabled = false,
    
                box = false,
                box_fill = false,
                realname = false,
                displayname = false,
                health = false,
                dist = false,
                weapon = false,
                skeleton = false,
    
                box_outline = false,
                realname_outline = false,
                displayname_outline = false,
                health_outline = false,
                dist_outline = false,
                weapon_outline = false,
    
                box_color = { Color3.new(1, 1, 1), 1 },
                box_fill_color = { Color3.new(1, 0, 0), 0.5 },
                realname_color = { Color3.new(1, 1, 1), 1 },
                displayname_color = { Color3.new(1, 1, 1), 1 },
                health_color = { Color3.new(1, 1, 1), 1 },
                dist_color = { Color3.new(1, 1, 1), 1 },
                weapon_color = { Color3.new(1, 1, 1), 1 },
                skeleton_color = { Color3.new(1, 1, 1), 1 },
    
                box_outline_color = { Color3.new(), 1 },
                realname_outline_color = Color3.new(),
                displayname_outline_color = Color3.new(),
                health_outline_color = Color3.new(),
                dist_outline_color = Color3.new(),
                weapon_outline_color = Color3.new(),
    
                chams = false,
                chams_visible_only = false,
                chams_fill_color = { Color3.new(1, 1, 1), 0.5 },
                chamsoutline_color = { Color3.new(1, 1, 1), 0 }
            }
        }
    }

    local loaded_plrs = {}

    local camera = workspace.CurrentCamera
    local viewportsize = camera.ViewportSize

    local VERTICES = {
        _Vector3new(-1, -1, -1),
        _Vector3new(-1, 1, -1),
        _Vector3new(-1, 1, 1),
        _Vector3new(-1, -1, 1),
        _Vector3new(1, -1, -1),
        _Vector3new(1, 1, -1),
        _Vector3new(1, 1, 1),
        _Vector3new(1, -1, 1)
    }
    local skeleton_order = {
        ["LeftFoot"] = "LeftLowerLeg",
        ["LeftLowerLeg"] = "LeftUpperLeg",
        ["LeftUpperLeg"] = "LowerTorso",
    
        ["RightFoot"] = "RightLowerLeg",
        ["RightLowerLeg"] = "RightUpperLeg",
        ["RightUpperLeg"] = "LowerTorso",
    
        ["LeftHand"] = "LeftLowerArm",
        ["LeftLowerArm"] = "LeftUpperArm",
        ["LeftUpperArm"] = "UpperTorso",
    
        ["RightHand"] = "RightLowerArm",
        ["RightLowerArm"] = "RightUpperArm",
        ["RightUpperArm"] = "UpperTorso",
    
        ["LowerTorso"] = "UpperTorso",
        ["UpperTorso"] = "Head"
    }
    local esp = {}
    esp.create_obj = function(type, args)
        local obj = Drawing.new(type)
        for i, v in args do
            obj[i] = v
        end
        return obj
    end
    
    local function isBodyPart(name)
        return name == "Head" or name:find("Torso") or name:find("Leg") or name:find("Arm")
    end

    local function getBoundingBox(parts)
        local min, max
        for i, part in parts do
            local cframe, size = part.CFrame, part.Size
    
            min = _Vector3zeromin(min or cframe.Position, (cframe - size * 0.5).Position)
            max = _Vector3zeromax(max or cframe.Position, (cframe + size * 0.5).Position)
        end

        local center = (min + max) * 0.5
        local front = _Vector3new(center.X, center.Y, max.Z)
        return _CFramenew(center, front), max - min
    end

    local function getStaticBoundingBox(part, size)
        return part.CFrame, size
    end
    
    local function worldToScreen(world)
        local screen, inBounds = _WorldToViewportPoint(camera, world)
        return _Vector2new(screen.X, screen.Y), inBounds, screen.Z
    end
    
    local function calculateCorners(cframe, size)
        local corners = table.create(#VERTICES)
        for i = 1, #VERTICES do
            corners[i] = worldToScreen((cframe + size * 0.5 * VERTICES[i]).Position)
        end
    
        local min = _Vector2zeromin(camera.ViewportSize, unpack(corners))
        local max = _Vector2zeromax(Vector2.zero, unpack(corners))
        return {
            corners = corners,
            topLeft = _Vector2new(mathfloor(min.X), mathfloor(min.Y)),
            topRight = _Vector2new(mathfloor(max.X), mathfloor(min.Y)),
            bottomLeft = _Vector2new(mathfloor(min.X), mathfloor(max.Y)),
            bottomRight = _Vector2new(mathfloor(max.X), mathfloor(max.Y))
        }
    end

    local function create_esp(player)
        if not player then return end
        
        local isnpc = player.ClassName == "Model"

        loaded_plrs[player] = {
            obj = {
                box_fill = esp.create_obj("Square", { Filled = true, Visible = false }),
                box_outline = esp.create_obj("Square", { Filled = false, Thickness = 3, Visible = false, ZIndex = -1 }),
                box = esp.create_obj("Square", { Filled = false, Thickness = 1, Visible = false }),
                realname = esp.create_obj("Text", { Center = true, Visible = false, Text = player.Name }),
                displayname = esp.create_obj("Text", { Center = true, Visible = false, Text = isnpc and "" or (player.Name == player.DisplayName and "" or player.DisplayName) }),
                healthtext = esp.create_obj("Text", { Center = false, Visible = false }),
                dist = esp.create_obj("Text", { Center = true, Visible = false }),
                weapon = esp.create_obj("Text", { Center = true, Visible = false }),
            },
            chams_object = Instance.new("Highlight", container),
            plr_instance = player
        }

        for required, _ in next, skeleton_order do
            loaded_plrs[player].obj["skeleton_" .. required] = esp.create_obj("Line", { Visible = false })
        end

        local plr = loaded_plrs[player]
        local obj = plr.obj
        local esp = plr.esp

        local box = obj.box
        local box_outline = obj.box_outline
        local box_fill = obj.box_fill
        local healthtext = obj.healthtext
        local realname = obj.realname
        local displayname = obj.displayname
        local dist = obj.dist
        local weapon = obj.weapon
        local cham = plr.chams_object

        local settings = esp_table.settings.enemy
        local main_settings = esp_table.main_settings

        local character = get_character(player)
        local head = character and _FindFirstChild(character, "Head")
        local humanoid = character and _FindFirstChildOfClass(character, "Humanoid")

        local setvis_cache = false
        local fadetime = main_settings.fadetime
        local staticbox = false
        local staticbox_size = _Vector3new(main_settings.boxStaticX, main_settings.boxStaticY, main_settings.boxStaticX)
        local fadethread

        function plr:forceupdate()
            fadetime = main_settings.fadetime
            staticbox = main_settings.boxStatic
            staticbox_size = _Vector3new(main_settings.boxStaticX, main_settings.boxStaticY, main_settings.boxStaticX)

            cham.DepthMode = settings.chams_visible_only and 1 or 0
            cham.FillColor = settings.chams_fill_color[1]
            cham.OutlineColor = settings.chamsoutline_color[1]
            cham.FillTransparency = settings.chams_fill_color[2]
            cham.OutlineTransparency = settings.chamsoutline_color[2]

            box.Color = settings.box_color[1]
            box_outline.Color = settings.box_outline_color[1]
            box_fill.Color = settings.box_fill_color[1]

            realname.Size = main_settings.textSize
            realname.Font = main_settings.textFont
            realname.Color = settings.realname_color[1]
            realname.Outline = settings.realname_outline
            realname.OutlineColor = settings.realname_outline_color

            displayname.Size = main_settings.textSize
            displayname.Font = main_settings.textFont
            displayname.Color = settings.displayname_color[1]
            displayname.Outline = settings.displayname_outline
            displayname.OutlineColor = settings.displayname_outline_color

            healthtext.Size = main_settings.textSize
            healthtext.Font = main_settings.textFont
            healthtext.Color = settings.health_color[1]
            healthtext.Outline = settings.health_outline
            healthtext.OutlineColor = settings.health_outline_color

            dist.Size = main_settings.textSize
            dist.Font = main_settings.textFont
            dist.Color = settings.dist_color[1]
            dist.Outline = settings.dist_outline
            dist.OutlineColor = settings.dist_outline_color

            weapon.Size = main_settings.textSize
            weapon.Font = main_settings.textFont
            weapon.Color = settings.weapon_color[1]
            weapon.Outline = settings.weapon_outline
            weapon.OutlineColor = settings.weapon_outline_color

            for required, _ in next, skeleton_order do
                local skeletonobj = obj["skeleton_" .. required]
                if skeletonobj then
                    skeletonobj.Color = settings.skeleton_color[1]
                end
            end

            box.Transparency = settings.box_color[2]
            box_outline.Transparency = settings.box_outline_color[2]
            box_fill.Transparency = settings.box_fill_color[2]
            realname.Transparency = settings.realname_color[2]
            displayname.Transparency = settings.displayname_color[2]
            healthtext.Transparency = settings.health_color[2]
            dist.Transparency = settings.dist_color[2]
            weapon.Transparency = settings.weapon_color[2]
            for required, _ in next, skeleton_order do
                obj["skeleton_" .. required].Transparency = settings.skeleton_color[2]
            end

            if setvis_cache then
                cham.Enabled = settings.chams
                box.Visible = settings.box
                box_outline.Visible = settings.box_outline
                box_fill.Visible = settings.box_fill
                realname.Visible = settings.realname
                displayname.Visible = settings.displayname
                healthtext.Visible = settings.health
                dist.Visible = settings.dist
                weapon.Visible = settings.weapon
                for required, _ in next, skeleton_order do
                    local skeletonobj = obj["skeleton_" .. required]
                    if (skeletonobj) then
                        skeletonobj.Visible = settings.skeleton
                    end
                end
            end
        end

        function plr:togglevis(bool, fade)
            if setvis_cache ~= bool then
                setvis_cache = bool
                if not bool then
                    for _, v in obj do v.Visible = false end
                    cham.Enabled = false
                else
                    cham.Enabled = settings.chams
                    box.Visible = settings.box
                    box_outline.Visible = settings.box_outline
                    box_fill.Visible = settings.box_fill
                    realname.Visible = settings.realname
                    displayname.Visible = settings.displayname
                    healthtext.Visible = settings.health
                    dist.Visible = settings.dist
                    weapon.Visible = settings.weapon
                    for required, _ in next, skeleton_order do
                        local skeletonobj = obj["skeleton_" .. required]
                        if (skeletonobj) then
                            skeletonobj.Visible = settings.skeleton
                        end
                    end
                end
            end
        end

        plr.connection = cheat.utility.new_renderstepped(function(delta)
            local plr = loaded_plrs[player]
            if not settings.enabled then
                return plr:togglevis(false)
            end

            character = isnpc and player or get_character(player)
            humanoid = character and _FindFirstChildOfClass(character, "Humanoid")
            head = character and _FindFirstChild(character, "Head")

            if not (character and humanoid and head) then
                return plr:togglevis(false)
            end

            local _, onScreen = _WorldToViewportPoint(camera, head.Position)
            if not onScreen then
                return plr:togglevis(false)
            end

            local humanoid_distance = (camera.CFrame.p - head.Position).Magnitude
            local humanoid_health = humanoid.Health
            local humanoid_max_health = humanoid.MaxHealth

            local corners, boundingcenter, boundingsize do
                
                if staticbox then
                    boundingcenter, boundingsize = getStaticBoundingBox(_FindFirstChild(character, "HumanoidRootPart") or head, staticbox_size)
                else
                    local cache = {}
                    for _, part in character:GetChildren() do
                        if _IsA(part, "BasePart") and isBodyPart(part.Name) then
                            cache[#cache + 1] = part
                        end
                    end
                    if #cache <= 0 then return plr:togglevis(false) end
                    boundingcenter, boundingsize = getBoundingBox(cache)
                end

                corners = calculateCorners(boundingcenter, boundingsize)
            end

            plr:togglevis(true)

            cham.Adornee = character
            do
                local pos = corners.topLeft
                local size = corners.bottomRight - corners.topLeft
                box.Position = pos
                box.Size = size
                if getgenv().DrawingFix then
                    box_outline.Position = pos - _Vector2new(1, 1)
                    box_outline.Size = size + _Vector2new(2, 2)
                else
                    box_outline.Position = pos
                    box_outline.Size = size
                end
                box_fill.Position = pos
                box_fill.Size = size
            end
            do
                local pos = (corners.topLeft + corners.topRight) * 0.5 - Vector2.yAxis
                realname.Position = pos - (Vector2.yAxis * realname.TextBounds.Y) - _Vector2new(0, 2)
                displayname.Position = pos -
                Vector2.yAxis * displayname.TextBounds.Y -
                (realname.Visible and Vector2.yAxis * realname.TextBounds.Y or Vector2.zero)
            end
            do
                local pos = (corners.bottomLeft + corners.bottomRight) * 0.5
                dist.Text = mathround(humanoid_distance) .. " meters"
                dist.Position = pos
                weapon.Text = esp_table.get_gun(player)
                weapon.Position = pos + (dist.Visible and Vector2.yAxis * dist.TextBounds.Y - _Vector2new(0, 2) or Vector2.zero)
            end

            healthtext.Text = tostring(mathfloor(humanoid_health))
            healthtext.Position = corners.topLeft - _Vector2new(2, 0) - Vector2.yAxis * (healthtext.TextBounds.Y * 0.25) - Vector2.xAxis * healthtext.TextBounds.X

            if settings.skeleton then
                for _, part in next, character:GetChildren() do
                    local name = part.Name
                    local parent_part = skeleton_order[name]
                    local parent_instance = parent_part and _FindFirstChild(character, skeleton_order[name])
                    local line = obj["skeleton_" .. name]
                    if parent_instance and line then
                        local part_position, _ = _WorldToViewportPoint(camera, part.Position)
                        local parent_part_position, _ = _WorldToViewportPoint(camera, parent_instance.Position)
                        line.From = _Vector2new(part_position.X, part_position.Y)
                        line.To = _Vector2new(parent_part_position.X, parent_part_position.Y)
                    end
                end
            end
        end)

        plr:forceupdate()
    end
    local function destroy_esp(player)
        if not loaded_plrs[player] then return end
        loaded_plrs[player].connection:Disconnect()
        for i,v in loaded_plrs[player].obj do
            v:Remove()
        end
        if loaded_plrs[player].chams_object then
            loaded_plrs[player].chams_object:Destroy()
        end
        loaded_plrs[player] = nil
    end
    
    function esp_table.load()
        assert(not esp_table.__loaded, "[ESP] already loaded")

        local shortcut = function(is_obj, remove, name)
            return function(model)(remove and destroy_esp or (is_obj and create_object_esp or create_esp))(model, is_obj and name or nil) end
        end
    
        for i, v in next, plrs:GetPlayers() do
            if v ~= lplr then create_esp(v) end
        end
        for _, v in next, workspace.AI:GetChildren() do
            create_esp(v)
        end
    
        esp_table.objectAdded = {
            plrs.PlayerAdded:Connect(create_esp),
            workspace.AI.ChildAdded:Connect(create_esp)
        };
        esp_table.objectRemoving = {
            plrs.PlayerRemoving:Connect(destroy_esp),
            workspace.AI.ChildRemoved:Connect(destroy_esp)
        };

        esp_table.__loaded = true;
    end
    
    function esp_table.unload()
        assert(esp_table.__loaded, "[ESP] not loaded yet");
    
        for player, _ in next, loaded_plrs do
            destroy_esp(player)
        end
    
        for _, connection in next, esp_table.objectAdded do
            connection:Disconnect()
        end
        for _, connection in next, esp_table.objectRemoving do
            connection:Disconnect()
        end
        esp_table.__loaded = false;
    end
    
    function esp_table.get_gun(player)
        local character = get_character(player)
        local tool = character and _FindFirstChildOfClass(character, "Tool")
        return tool and tool.Name or "none";
    end

    function esp_table.icaca()
        for _, v in loaded_plrs do
            task.spawn(function() v:forceupdate() end)
        end
    end

    cheat.EspLibrary = esp_table
end)();
--// INDICATOR LIBRARY
LPH_NO_VIRTUALIZE(function()

    local camera = workspace.CurrentCamera

    local indicatorlib = {
        indicators = {}
    }

    function indicatorlib:new_indicator()
        local indicator = {
            enabled = false,

            followpart = false,
            target_part = nil,
    
            scale_x = 0.5,
            scale_y = 0.5,
            offset_x = 0,
            offset_y = 0,
    
            blink = false,
            blink_speed = 1, -- transparency revolution per second [[ 0 -> 1 -> 0 ]]
            blink_cycle = false,

            text = "",
            transparency = 1
        }

        indicator.drawing = cheat.utility.new_drawing("Text", { Visible = false })
        indicator.text = `indicator {tostring(indicator)}`

        indicatorlib.indicators[indicator] = indicator

        return indicator 
    end


    cheat.utility.new_renderstepped(function(delta)
        local viewportsize = camera and camera.ViewportSize
        if not viewportsize then
            camera = workspace.CurrentCamera;
            for _, indicator in indicatorlib.indicators do
                local drawing = indicator.drawing
                if not drawing then continue end
                
                drawing.Visible = false
            end
            return
        end
        local viewport_x = viewportsize.X
        local viewport_y = viewportsize.Y
        for _, indicator in indicatorlib.indicators do

            local drawing = indicator.drawing
            if not drawing then continue end
            
            if not indicator.enabled then
                drawing.Visible = false
                continue
            end

            drawing.Visible = true
            drawing.Text = indicator.text

            if indicator.followpart then
                local target_part = indicator.target_part
                if not target_part then
                    drawing.Visible = false
                    continue
                end
                local pos, onscreen = _WorldToViewportPoint(camera, target_part.Position)
                if not onscreen then
                    drawing.Visible = false
                    continue
                end
                drawing.Position = _Vector2new(pos.X + indicator.offset_x, pos.Y + indicator.offset_y)
            else
                local calculated_x = viewport_x * indicator.scale_x + indicator.offset_x
                local calculated_y = viewport_y * indicator.scale_y + indicator.offset_y
                drawing.Position = _Vector2new(calculated_x, calculated_y)
            end

            if not indicator.blink then
                drawing.Transparency = indicator.transparency
                continue
            end

            local blink_speed = indicator.blink_speed

            if drawing.Transparency <= 0 then
                indicator.blink_cycle = true
            elseif drawing.Transparency >= 1 then
                indicator.blink_cycle = false
            end

            drawing.Transparency = drawing.Transparency + (blink_speed * (indicator.blink_cycle and 1 or -1)) * delta
        end
    end)


    cheat.IndicatorLibrary = indicatorlib
end)();

local global_vars = {
    target_part = nil,
    wallbang = false
}

do
    local aim_enabled, aim_part, aim_mode, aim_predict = false, "Head", "camera", false
    local aim_smoothing = 0
    local aim_bind_enabled = false

    local manipulation, manip_range, manip_thruwalls = false, 5, false

    local fov_show, fov_color, fov_outline, fov_size = false, Color3.new(1,1,1), false, 100

    local norecoil, nospread, rapidfire_mult = false, false, 1

    local indicator = cheat.IndicatorLibrary:new_indicator()
    
    do
        local modbox = ui.box.gunmods:AddTab('gun mods')
        modbox:AddToggle('gunmods_norecoil', {Text = 'no recoil',Default = false,Callback = function(Value)
            norecoil = Value
        end})
        --[[modbox:AddToggle('gunmods_nospread', {Text = 'no spread',Default = false,Callback = function(Value)
            nospread = Value
        end})
        modbox:AddSlider('gunmods_rapidfire',{Text = 'rapid fire',Default = 1,Min = 1,Max = 5,Rounding = 1,Compact = true, Suffix = "x", Callback = function(State)
            rapidfire_mult = State
        end})]]
    end
    
    do
        local fovbox = ui.box.fov:AddTab('fov circle')
        fovbox:AddToggle('fov_show', {Text = 'show fov',Default = false,Callback = function(Value)
            fov_show = Value
        end}):AddColorPicker('fov_color',{Default = Color3.new(1, 1, 1),Title = 'fov color',Transparency = 0,Callback = function(Value)
            fov_color = Value
        end})
        fovbox:AddToggle('fov_outline', {Text = 'fov outline',Default = false,Callback = function(Value)
            fov_outline = Value
        end})
        fovbox:AddSlider('fov_size',{Text = 'target fov',Default = 100,Min = 10,Max = 1000,Rounding = 0,Compact = true,Callback = function(State)
            fov_size = State
        end})
        local CircleOutline = cheat.utility.new_drawing("Circle", {
            Thickness = 3,
            Color = Color3.new(),
            ZIndex = 1
        })
        local CircleInline = cheat.utility.new_drawing("Circle", {
            Transparency = 1,
            Thickness = 1,
            ZIndex = 2
        })
        cheat.utility.new_renderstepped(LPH_NO_VIRTUALIZE(function()
            CircleInline.Position = (_Vector2new(Mouse.X, Mouse.Y + GuiInset.Y))
            CircleInline.Radius = fov_size
            CircleInline.Color = fov_color
            CircleInline.Visible = fov_show
            CircleOutline.Position = (_Vector2new(Mouse.X, Mouse.Y + GuiInset.Y))
            CircleOutline.Radius = fov_size
            CircleOutline.Visible = (fov_show and fov_outline)
        end))
    end

    local target_part, is_npc, isvisible;
    do
        local aimbox = ui.box.aim:AddTab('aimbot')
        aimbox:AddToggle('aim_enabled', {Text = 'aim',Default = false,Callback = function(first)
            aim_enabled = first
        end}):AddKeyPicker('aim_bind', {Default = 'MB2',SyncToggleState = false,Mode = 'Hold',Text = 'aim',NoUI = false,Callback = function(Value)
            aim_bind_enabled = Value
        end})
        aimbox:AddToggle('aim_predict', {Text = 'predict target',Default = false,Callback = function(first)
            aim_predict = first
        end})
        aimbox:AddDropdown('aim_mode', {Values = {"camera", "mouse", "silent"},Default = 1,Multi = false,Text = 'aim mode',Callback = function(Value)
            aim_mode = Value
        end})
        aimbox:AddDropdown('silentaim_method', {Values = {"normal", "instant hit"}, Default = 1,Multi = false,Text = 'silent method',Callback = function(Value)
            global_vars.silent_method = Value
        end})
        aimbox:AddDropdown('aim_part', {Values = {'Head','UpperTorso','LowerTorso','HumanoidRootPart','LeftFoot','LeftLowerLeg','LeftUpperLeg','LeftHand','LeftLowerArm','LeftUpperArm','RightFoot','RightLowerLeg','RightUpperLeg','RightHand','RightLowerArm','RightUpperArm'},Default = 1,Multi = false,Text = 'aim part',Callback = function(Value)
            aim_part = Value
        end})
        aimbox:AddSlider('aim_smoothing', { Text = 'smoothing', Default = 0, Min = 0, Max = 100, Rounding = 0, Compact = false, Prefix = "%" }):OnChanged(function(b)
            aim_smoothing = (100 - b) / 100
        end)
        aimbox:AddToggle('silentaim_manipulation', {Text = 'silent manipulation',Default = false,Callback = function(Value)
            manipulation = Value
        end})
    
        local manip_depbox = aimbox:AddDependencyBox();

        manip_depbox:AddSlider('silentaim_manipulation_range',{Text = 'manipulation range',Default = 5,Min = 1,Max = 3,Rounding = 1,Compact = true,Callback = function(State)
            manip_range = State
        end})
    
        manip_depbox:SetupDependencies({
            { cheat.Toggles.silentaim_manipulation, true }
        });
        --aimbox:AddToggle('silentaim_wallbang', {Text = 'silent wallbang',Default = false,Callback = function(first)
        --    global_vars.wallbang = first
        --end})
    end
    
    local calculated_aimpos;
    local moveConst = Vector2.new(1, 0.77) * math.rad(0.5) -- https://github.com/7GrandDadPGN/VapeV4ForRoblox

    RunService:BindToRenderStep(tostring(math.random()), Enum.RenderPriority.Camera.Value, LPH_JIT_MAX(function(dt)
        local indtxt = ""
        local camera_cframe = Camera.CFrame
        local camera_pos = camera_cframe.p
        
        calculated_aimpos = nil

        if aim_enabled--[[ and aim_bind_enabled]] then

            local target_part, isnpc = get_closest_target(fov_size, aim_part)
            global_vars.target_part = target_part

            if indicator.followpart then
                indicator.target_part = target_part
            end

            if target_part then

                indtxt = target_part.Parent.Name
                indtxt = indtxt .. (isnpc and " (ai)" or "")

                local current_tool     = lone.hotbar.CurrentTool
                local projectile_stats = current_tool and current_tool.Stats and current_tool.Stats.ProjectileStats
                local projectile_speed = projectile_stats and projectile_stats.Velocity
                local projectile_drop  = projectile_stats and projectile_stats.Drop or 0
                
                if aim_mode == "silent" then
                    local manipulation_pos = get_manipulation_pos(camera_pos, target_part.Parent, target_part, manip_range, manipulation, manip_thruwalls)
                    local new_origin = camera_pos + (manipulation_pos or Vector3.zero)
                    local new_pos = aim_predict and projectile_speed and cheat.trajectory(
                        new_origin, projectile_speed, target_part.Position, target_part.Velocity, false, 0 --projectile_drop / 2
                    ) or target_part.Position
                    calculated_aimpos = CFrame.lookAt(new_origin, new_pos)
                    indtxt = indtxt .. (manipulation_pos and " (manipulated)" or "")
                else
                    local new_pos = aim_predict and projectile_speed and cheat.trajectory(
                        camera_pos, projectile_speed, target_part.Position, target_part.Velocity, false, 0 --projectile_drop / 2
                    ) or target_part.Position
                    if aim_mode == "camera" then
                        Camera.CFrame = camera_cframe:Lerp(_CFramenew(camera_pos, new_pos), 1-aim_smoothing)
                    else

                        local pos = _WorldToViewportPoint(Camera, target_part.Position)
                        local mpos = UserInputService:GetMouseLocation()
                        local diff = _Vector2new((pos.X - mpos.X) * aim_smoothing , (pos.Y - mpos.Y) * aim_smoothing) 
                        mousemoverel(diff.X, diff.Y)

                        --[[local facing = camera_cframe.LookVector -- https://github.com/7GrandDadPGN/VapeV4ForRoblox
                        local new = (new_pos - camera_pos).Unit
                        new = new == new and new or Vector3.zero
                        if new ~= Vector3.zero then 
                            local diffYaw = wrapAngle(math.atan2(facing.X, facing.Z) - math.atan2(new.X, new.Z))
                            local diffPitch = math.asin(facing.Y) - math.asin(new.Y)
                            local angle = Vector2.new(diffYaw, diffPitch) // (moveConst * UserSettings():GetService('UserGameSettings').MouseSensitivity)
                            
                            angle *= math.min(30 * dt, 1)
                            mousemoverel(angle.X, angle.Y)
                        end]]
                    end
                end
            end
        end

        indicator.text = indtxt
    end))

    do
        local mainindbox = ui.box.fov:AddTab('indicator')
        mainindbox:AddToggle('indicator_enabled', {Text = 'enabled',Default = false}):OnChanged(function(b)
            indicator.enabled = b
        end)

        local indicatorbox = mainindbox:AddDependencyBox();

        indicatorbox:AddDropdown('indicator_font',{ Values = { 'UI', 'System', 'Plex', 'Monospace' }, Default = 1, Multi = false, Text = 'font', Callback = function(a)
            indicator.drawing.Font = Drawing.Fonts[a]
        end})

        indicatorbox:AddSlider('indicator_fontsize', { Text = 'size', Default = 13, Min = 1, Max = 30, Rounding = 0, Compact = true }):OnChanged(function(b)
            indicator.drawing.Size = b
        end)

        indicatorbox:AddToggle('indicator_center', {Text = 'center',Default = false}):OnChanged(function(b)
            indicator.drawing.Center = b
        end)
        indicatorbox:AddToggle('indicator_outline', {Text = 'outline',Default = false}):OnChanged(function(b)
            indicator.drawing.Outline = b
        end)
        indicatorbox:AddLabel('color'):AddColorPicker('indicator_color',{Default = Color3.new(1, 1, 1),Title = 'color',Transparency = 0,Callback = function(Value)
            indicator.drawing.Color = Value
        end})
        indicatorbox:AddLabel('outline color'):AddColorPicker('indicator_outline_color',{Default = Color3.new(1, 1, 1),Title = 'outline color',Transparency = 0,Callback = function(Value)
            indicator.drawing.OutlineColor = Value
        end})
        indicatorbox:AddToggle('indicator_followtarget', {Text = 'follow target',Default = false}):OnChanged(function(b)
            indicator.followpart = b
        end)

        do
            local scalebox = indicatorbox:AddDependencyBox();
            scalebox:AddSlider('indicator_scale_x', { Text = 'scale X', Default = 0.5, Min = 0, Max = 1, Rounding = 2, Compact = false }):OnChanged(function(b)
                indicator.scale_x = b
            end)
            scalebox:AddSlider('indicator_scale_y', { Text = 'scale Y', Default = 0.5, Min = 0, Max = 1, Rounding = 2, Compact = false }):OnChanged(function(b)
                indicator.scale_y = b
            end)

            scalebox:SetupDependencies({
                { cheat.Toggles.indicator_followtarget, false }
            });
        end

        indicatorbox:AddSlider('indicator_offset_x', { Text = 'offset X', Default = 0, Min = -100, Max = 100, Rounding = 0, Compact = false }):OnChanged(function(b)
            indicator.offset_x = b
        end)
        indicatorbox:AddSlider('indicator_offset_y', { Text = 'offset Y', Default = 0, Min = -100, Max = 100, Rounding = 0, Compact = false }):OnChanged(function(b)
            indicator.offset_y = b
        end)

        --[[
            blink = false,
            blink_speed = 1,
            blink_cycle = false,
        ]]

        indicatorbox:AddToggle('indicator_blink', {Text = 'blink',Default = false}):OnChanged(function(b)
            indicator.blink = b
        end)

        do
            local transparencybox = indicatorbox:AddDependencyBox();
            transparencybox:AddSlider('indicator_transparency', { Text = 'transparency', Default = 1, Min = 0, Max = 1, Rounding = 1, Compact = false }):OnChanged(function(b)
                indicator.transparency = b
            end)
            transparencybox:SetupDependencies({
                { cheat.Toggles.indicator_blink, false }
            });
        end

        do
            local blinkbox = indicatorbox:AddDependencyBox();
            blinkbox:AddSlider('indicator_blink_speed', { Text = 'blink speed', Default = 1, Min = 0.1, Max = 5, Rounding = 1, Compact = false }):OnChanged(function(b)
                indicator.blink_speed = b
            end)
            blinkbox:SetupDependencies({
                { cheat.Toggles.indicator_blink, true }
            });
        end


        indicatorbox:SetupDependencies({
            { cheat.Toggles.indicator_enabled, true }
        });
    end
    do
        local projectile = game:GetService("ReplicatedStorage").Modules.Client.Physics.Projectile
        local oldproj = require(projectile).New
        local old_impulse = lone.spring.Impulse
        lone.spring.Impulse = function(self, ...)
            if norecoil and self == lone.recoilspring then
                return
            end
            return old_impulse(self, ...)
        end
        require(projectile).New = function(self, data)
            if not (calculated_aimpos and not data.FromServer) then
                return oldproj(self, data)
            end

            local clon = table.clone(data)

            local spoofdata = {
                Origin = calculated_aimpos.Position,
                HitVector = calculated_aimpos.LookVector * 10000 + calculated_aimpos.Position,
                ForceHitVector = calculated_aimpos.LookVector * 10000 + calculated_aimpos.Position
            }

            clon.Origin = calculated_aimpos.Position
            clon.HitVector = calculated_aimpos.LookVector * 10000 + calculated_aimpos.Position
            clon.ForceHitVector = calculated_aimpos.LookVector * 10000 + calculated_aimpos.Position

            data.Origin = calculated_aimpos.Position
            data.HitVector = calculated_aimpos.LookVector * 10000 + calculated_aimpos.Position
            data.ForceHitVector = calculated_aimpos.LookVector * 10000 + calculated_aimpos.Position

            local thing = setmetatable(data, {
                __index = function(t, k)
                    if spoofdata[k] then
                        --print('spoof1', k)
                        clon[k] = spoofdata[k]
                        return spoofdata[k]
                    end
                    return clon[k]
                end,
                __newindex = function(t, k, v)
                    if spoofdata[k] then
                        --print('spoof2', k)
                        clon[k] = spoofdata[k]
                        return
                    end
                    clon[k] = v
                end,
                __call = function()
                    return clon
                end
            })

            lone.projectile_spoof[thing] = clon

            return oldproj(self, thing)
        end
    end
end
do
    local espb = ui.box.espsets:AddTab("esp settings")
    local main_settings = cheat.EspLibrary.main_settings
    espb:AddDropdown('espboxcalc',{ Values = { 'static', 'dynamic' }, Default = 1, Multi = false, Text = 'esp font', Callback = function(a)
        main_settings.boxStatic = a == 'static'; cheat.EspLibrary.icaca()
    end})
    espb:AddSlider('espboxcalc_x', { Text = 'static box X', Default = 3.5, Min = 0, Max = 10, Rounding = 1, Compact = true }):OnChanged(function(b)
        main_settings.boxStaticX = b; cheat.EspLibrary.icaca()
    end)
    espb:AddSlider('espboxcalc_y', { Text = 'static box Y', Default = 5, Min = 0, Max = 30, Rounding = 1, Compact = true }):OnChanged(function(b)
        main_settings.boxStaticY = b; cheat.EspLibrary.icaca()
    end)

    espb:AddDropdown('espfont',{ Values = { 'UI', 'System', 'Plex', 'Monospace' }, Default = 1, Multi = false, Text = 'esp font', Callback = function(a)
        main_settings.textFont = Drawing.Fonts[a]; cheat.EspLibrary.icaca()
    end})
    espb:AddSlider('espfontsize', { Text = 'esp font size', Default = 13, Min = 1, Max = 30, Rounding = 0, Compact = true }):OnChanged(function(b)
        main_settings.textSize = b; cheat.EspLibrary.icaca()
    end)
end
do
    local espb = ui.box.esp:AddTab("player esp")
    local es = cheat.EspLibrary.settings.enemy
    espb:AddToggle('espswitch',{ Text = 'enable esp', Default = false, Callback = function(c)
        es.enabled = c; cheat.EspLibrary.icaca()
    end})

    espb:AddToggle('espbox', { Text = 'box esp', Default = false, Callback = function(c)
        es.box = c; cheat.EspLibrary.icaca()
    end}):AddColorPicker('espboxcolor',{ Default = Color3.new(1, 1, 1), Title = 'box color', Transparency = 0, Callback = function(a)
        es.box_color[1] = a; cheat.EspLibrary.icaca()
    end})

    espb:AddToggle('espboxfill',{ Text = 'box fill', Default = false, Callback = function(c)
        es.box_fill = c; cheat.EspLibrary.icaca()
    end}):AddColorPicker('espboxfillcolor',{ Default = Color3.new(1, 1, 1), Title = 'box fill color', Transparency = 0, Callback = function(a)
        es.box_fill_color[1] = a; cheat.EspLibrary.icaca()
    end})

    espb:AddToggle('espoutlinebox',{ Text = 'box outline', Default = false, Callback = function(c)
        es.box_outline = c; cheat.EspLibrary.icaca()
    end}):AddColorPicker('espboxoutlinecolor',{ Default = Color3.new(), Title = 'box outline color', Transparency = 0, Callback = function(a)
        es.box_outline_color[1] = a; cheat.EspLibrary.icaca()
    end})

    espb:AddSlider('espboxtransparency', { Text = 'box transparency', Default = 0, Min = 0, Max = 1, Rounding = 1, Compact = false }):OnChanged(function(b)
        es.box_color[2] = 1 - b; cheat.EspLibrary.icaca()
    end)
    espb:AddSlider('espoutlineboxtransparency',{ Text = 'box outline transparency', Default = 0, Min = 0, Max = 1, Rounding = 1, Compact = false }):OnChanged(function(b)
        es.box_outline_color[2] = 1 - b; cheat.EspLibrary.icaca()
    end)
    espb:AddSlider('espboxfilltransparency', { Text = 'box fill transparency', Default = 0.5, Min = 0, Max = 1, Rounding = 1, Compact = false }):OnChanged(function(b)
        es.box_fill_color[2] = 1 - b; cheat.EspLibrary.icaca()
    end)

    espb:AddToggle('esprealname',{ Text = 'name esp', Default = false, Callback = function(c)
        es.realname = c; cheat.EspLibrary.icaca()
    end}):AddColorPicker('esprealnamecolor',{ Default = Color3.new(1, 1, 1), Title = 'name color', Transparency = 0, Callback = function(a)
        es.realname_color[1] = a; cheat.EspLibrary.icaca()
    end})
    espb:AddToggle('esprealnameoutline',{ Text = 'name outline', Default = false, Callback = function(c)
        es.realname_outline = c; cheat.EspLibrary.icaca()
    end}):AddColorPicker('esprealnameoutlinecolor',{ Default = Color3.new(), Title = 'name outline color', Transparency = 0, Callback = function(a)
        es.realname_outline_color = a; cheat.EspLibrary.icaca()
    end})
    espb:AddSlider('esprealnametransparency', { Text = 'name transparency', Default = 0, Min = 0, Max = 1, Rounding = 1, Compact = false }):OnChanged(function(b)
        es.realname_color[2] = 1 - b; cheat.EspLibrary.icaca()
    end)

    espb:AddToggle('esphealth', { Text = 'health esp', Default = false, Callback = function(c)
        es.health = c; cheat.EspLibrary.icaca()
    end}):AddColorPicker('esphealthcolor',{ Default = Color3.new(1, 1, 1), Title = 'health color', Transparency = 0, Callback = function(a)
        es.health_color[1] = a; cheat.EspLibrary.icaca()
    end})
    espb:AddToggle('esphealthoutline',{ Text = 'health outline', Default = false, Callback = function(c)
        es.health_outline = c; cheat.EspLibrary.icaca()
    end}):AddColorPicker('esphealthoutlinecolor',{ Default = Color3.new(), Title = 'health outline color', Transparency = 0, Callback = function(a)
        es.health_outline_color = a; cheat.EspLibrary.icaca()
    end})
    espb:AddSlider('esphealthtransparency', { Text = 'health transparency', Default = 0, Min = 0, Max = 1, Rounding = 1, Compact = false }):OnChanged(function(b)
        es.health_color[2] = 1 - b; cheat.EspLibrary.icaca()
    end)

    espb:AddToggle('espdisplayname',{ Text = 'display name esp', Default = false, Callback = function(c)
        es.displayname = c; cheat.EspLibrary.icaca()
    end}):AddColorPicker('espdisplaynamecolor',{ Default = Color3.new(1, 1, 1), Title = 'display name color', Transparency = 0, Callback = function(a)
        es.displayname_color[1] = a; cheat.EspLibrary.icaca()
    end})
    espb:AddToggle('espdisplaynameoutline',{ Text = 'display name outline', Default = false, Callback = function(c)
        es.displayname_outline = c; cheat.EspLibrary.icaca()
    end}):AddColorPicker('espdisplaynameoutlinecolor',{ Default = Color3.new(), Title = 'display name outline color', Transparency = 0, Callback = function(a)
        es.displayname_outline_color = a; cheat.EspLibrary.icaca()
    end})
    espb:AddSlider('espdisplaynametransparency',{ Text = 'display name transparency', Default = 0, Min = 0, Max = 1, Rounding = 1, Compact = false }):OnChanged(function(b)
        es.displayname_color[2] = 1 - b; cheat.EspLibrary.icaca()
    end)

    espb:AddToggle('espdistance',{ Text = 'distance esp', Default = false, Callback = function(c)
        es.dist = c; cheat.EspLibrary.icaca()
    end}):AddColorPicker('espdistancecolor',{ Default = Color3.new(1, 1, 1), Title = 'distance color', Transparency = 0, Callback = function(a)
        es.dist_color[1] = a; cheat.EspLibrary.icaca()
    end})
    espb:AddToggle('espdistanceoutline',{ Text = 'distance outline', Default = false, Callback = function(c)
        es.dist_outline = c; cheat.EspLibrary.icaca()
    end}):AddColorPicker('espdistanceoutlinecolor',{ Default = Color3.new(), Title = 'distance outline color', Transparency = 0, Callback = function(a)
        es.dist_outline_color = a; cheat.EspLibrary.icaca()
    end})
    espb:AddSlider('espdistancetransparency', { Text = 'distance transparency', Default = 0, Min = 0, Max = 1, Rounding = 1, Compact = false }):OnChanged(function(b)
        es.dist_color[2] = 1 - b; cheat.EspLibrary.icaca()
    end)


    espb:AddToggle('espweapon', { Text = 'weapon esp', Default = false, Callback = function(c)
        es.weapon = c; cheat.EspLibrary.icaca()
    end}):AddColorPicker('espweaponcolor',{ Default = Color3.new(1, 1, 1), Title = 'weapon color', Transparency = 0, Callback = function(a)
        es.weapon_color[1] = a; cheat.EspLibrary.icaca()
    end})
    espb:AddToggle('espweaponoutline',{ Text = 'weapon outline', Default = false, Callback = function(c)
        es.weapon_outline = c; cheat.EspLibrary.icaca()
    end}):AddColorPicker('espweaponoutlinecolor',{ Default = Color3.new(), Title = 'weapon outline color', Transparency = 0, Callback = function(a)
        es.weapon_outline_color = a; cheat.EspLibrary.icaca()
    end})
    espb:AddSlider('espweapontransparency', { Text = 'weapon transparency', Default = 0, Min = 0, Max = 1, Rounding = 1, Compact = false }):OnChanged(function(b)
        es.weapon_color[2] = 1 - b; cheat.EspLibrary.icaca()
    end)


    espb:AddToggle('espskeleton',{ Text = 'skeleton esp', Default = false, Callback = function(c)
        es.skeleton = c; cheat.EspLibrary.icaca()
    end}):AddColorPicker('espskeletoncolor',{ Default = Color3.new(1, 1, 1), Title = 'skeleton color', Transparency = 0, Callback = function(a)
        es.skeleton_color[1] = a; cheat.EspLibrary.icaca()
    end})
    espb:AddSlider('espskeletontransparency', { Text = 'skeleton transparency', Default = 0, Min = 0, Max = 1, Rounding = 1, Compact = false }):OnChanged(function(b)
        es.skeleton_color[2] = 1 - b; cheat.EspLibrary.icaca()
    end)

    espb:AddToggle('espchams', { Text = 'chams', Default = false, Callback = function(c)
        es.chams = c; cheat.EspLibrary.icaca()
    end})
    espb:AddToggle('espchamsvisibleonly',{ Text = 'chams visible only', Default = false, Callback = function(c)
        es.chams_visible_only = c; cheat.EspLibrary.icaca()
    end})

    espb:AddLabel("chams fill color"):AddColorPicker('espchamsfillcolor',{ Default = Color3.new(1, 1, 1), Title = 'chams fill color', Transparency = 0, Callback = function(a)
        es.chams_fill_color[1] = a; cheat.EspLibrary.icaca()
    end})

    espb:AddLabel("chams outline color"):AddColorPicker('espchamsoutlinecolor',{ Default = Color3.new(1, 1, 1), Title = 'chams outline color', Transparency = 0, Callback = function(a)
        es.chamsoutline_color[1] = a; cheat.EspLibrary.icaca()
    end})

    espb:AddSlider('espchamsfilltransparency', { Text = 'fill transparency', Default = 0.5, Min = 0, Max = 1, Rounding = 1, Compact = false }):OnChanged(function(b)
        es.chams_fill_color[2] = b; cheat.EspLibrary.icaca()
    end)
    espb:AddSlider('espchamsoutlinetransparency', { Text = 'outline transparency', Default = 0, Min = 0, Max = 1, Rounding = 1, Compact = false }):OnChanged(function(b)
        es.chamsoutline_color[2] = b; cheat.EspLibrary.icaca()
    end)
    ----------------------------------------------------------
    --[[espb:AddSlider('espfadetime', { Text = 'fade time', Default = 2.5, Min = 0, Max = 5, Rounding = 1, Compact = true }):OnChanged(function(State)
        cheat.EspLibrary.main_settings.fadetime = State; cheat.EspLibrary.icaca()
    end)]]
end
do
    do
        local worldbox = ui.box.world1:AddTab("lighting")
        local old_lighting = {
            Ambient = Lighting.Ambient,
            OutdoorAmbient = Lighting.OutdoorAmbient,
            Brightness = Lighting.Brightness,
            ColorShift_Bottom = Lighting.ColorShift_Bottom,
            ColorShift_Top = Lighting.ColorShift_Top,
            GlobalShadows = Lighting.GlobalShadows,
            FogColor = Lighting.FogColor,
            FogEnd = Lighting.FogEnd,
            FogStart = Lighting.FogStart,
            ClockTime = Lighting.ClockTime,
        }
        local lighting_changer = false
        local lighting_values = {
            Ambient = Color3.fromRGB(70, 70, 70),
            OutdoorAmbient = Color3.fromRGB(70, 70, 70),
            Brightness = 3,
            ColorShift_Bottom = Color3.new(),
            ColorShift_Top = Color3.new(),
            GlobalShadows = true,
            FogColor = Color3.fromRGB(192, 192, 192),
            FogEnd = 10000,
            FogStart = 0,
            ClockTime = 14.5,
        }

        worldbox:AddToggle('world_lighting_changer', {Text = 'lighting changer',Default = false,Callback = function(first)
            lighting_changer = first
            if not first then for k, v in old_lighting do
                Lighting[k] = v
            end end
        end})
        worldbox:AddLabel("lighting ambient"):AddColorPicker('world_lighting_ambient',{Default = Color3.fromRGB(70, 70, 70),Title = 'ambient',Transparency = 0,Callback = function(Value)
            lighting_values.Ambient = Value
            Lighting.Ambient = Value
        end})
        worldbox:AddLabel("lighting outdoor ambient"):AddColorPicker('world_lighting_outdoorambient',{Default = Color3.fromRGB(70, 70, 70),Title = 'outdoor ambient',Transparency = 0,Callback = function(Value)
            lighting_values.OutdoorAmbient = Value
            Lighting.OutdoorAmbient = Value
        end})
        worldbox:AddSlider('world_lighting_brightness',{Text = 'lighting brightness',Default = 1,Min = 0,Max = 10,Rounding = 2,Compact = true,Callback = function(State)
            lighting_values.Brightness = State
            Lighting.Brightness = State
        end})
        worldbox:AddLabel("lighting colorshift bottom"):AddColorPicker('world_lighting_colorshift_bottom',{Default = Color3.new(),Title = 'colorshift bottom',Transparency = 0,Callback = function(Value)
            lighting_values.ColorShift_Bottom = Value
            Lighting.ColorShift_Bottom = Value
        end})
        worldbox:AddLabel("lighting colorshift top"):AddColorPicker('world_lighting_colorshift_top',{Default = Color3.new(),Title = 'colorshift top',Transparency = 0,Callback = function(Value)
            lighting_values.ColorShift_Bottom = Value
            Lighting.ColorShift_Bottom = Value
        end})
        worldbox:AddToggle('world_lighting_globalshadows', {Text = 'lighting global shadows',Default = true,Callback = function(first)
            lighting_values.GlobalShadows = first
            Lighting.GlobalShadows = first
        end})

        worldbox:AddLabel("lighting fog color"):AddColorPicker('world_lighting_fogcolor',{Default = Color3.fromRGB(192, 192, 192),Title = 'fog color',Transparency = 0,Callback = function(Value)
            lighting_values.FogColor = Value
            Lighting.FogColor = Value
        end})
        worldbox:AddSlider('world_lighting_fogend',{Text = 'lighting fog end',Default = 100,Min = 0,Max = 100,Rounding = 0,Compact = true,Callback = function(State)
            lighting_values.FogEnd = State * 100
            Lighting.FogEnd = State * 100
        end})
        worldbox:AddSlider('world_lighting_fogstart',{Text = 'lighting fog start',Default = 0,Min = 0,Max = 100,Rounding = 0,Compact = true,Callback = function(State)
            lighting_values.FogStart = State * 100
            Lighting.FogStart = State * 100
        end})

        worldbox:AddSlider('world_lighting_fogstart',{Text = 'lighting clock time',Default = 14.5,Min = 0,Max = 24,Rounding = 1,Compact = true,Callback = function(State)
            lighting_values.ClockTime = State
            Lighting.ClockTime = State
        end})

        for _, method in {"Ambient", "OutdoorAmbient", "Brightness", "ColorShift_Bottom", "ColorShift_Top", "GlobalShadows", "FogColor", "FogEnd", "FogStart", "ClockTime"} do
            Lighting:GetPropertyChangedSignal(method):Connect(function()
                if not lighting_changer then return end
                old_lighting[method] = Lighting[method]
                Lighting[method] = lighting_values[method]
            end)
        end
    end

    do
        local worldbox = ui.box.world2:AddTab("bloom")
        local bloomeffect = _FindFirstChildOfClass(Lighting, "BloomEffect") or Instance.new("BloomEffect", Lighting)
        local old_bloomeffect = {
            Enabled = bloomeffect.Enabled,
            Intensity = bloomeffect.Intensity,
            Size = bloomeffect.Size,
            Threshold = bloomeffect.Threshold,
        }
        local bloomeffect_changer = false
        local bloomeffect_values = {
            Enabled = true,
            Intensity = 1,
            Size = 24,
            Threshold = 2,
        }

        worldbox:AddToggle('world_bloomeffect_changer', {Text = 'bloomeffect changer',Default = false,Callback = function(first)
            bloomeffect_changer = first
            if not first then for k, v in old_bloomeffect do
                bloomeffect[k] = v
            end end
        end})
        worldbox:AddToggle('world_bloomeffect_enabled', { Text = 'bloom enabled', Default = false, Callback = function(c)
            bloomeffect_values.Enabled = State
            bloomeffect.Enabled = State
        end})
        worldbox:AddSlider('world_bloomeffect_offset',{Text = 'bloom intensity',Default = 1,Min = 0,Max = 1,Rounding = 2,Compact = true,Callback = function(State)
            bloomeffect_values.Intensity = State
            bloomeffect.Intensity = State
        end})
        worldbox:AddSlider('world_bloomeffect_size',{Text = 'bloom size',Default = 1,Min = 0,Max = 56,Rounding = 0,Compact = true,Callback = function(State)
            bloomeffect_values.Size = State
            bloomeffect.Size = State
        end})
        worldbox:AddSlider('world_bloomeffect_threshold',{Text = 'bloom threshold',Default = 1,Min = 0.8,Max = 4,Rounding = 1,Compact = true,Callback = function(State)
            bloomeffect_values.Threshold = State
            bloomeffect.Threshold = State
        end})

        for _, method in {"Enabled", "Intensity", "Size", "Size", "Threshold"} do
            bloomeffect:GetPropertyChangedSignal(method):Connect(function()
                if not bloomeffect_changer then return end
                old_bloomeffect[method] = bloomeffect[method]
                bloomeffect[method] = bloomeffect_values[method]
            end)
        end
    end

    do
        local worldbox = ui.box.world2:AddTab("atmosphere")
        local atmosphere = _FindFirstChildOfClass(Lighting, "Atmosphere") or Instance.new("Atmosphere", Lighting)
        local old_atmosphere = {
            Density = atmosphere.Density,
            Offset = atmosphere.Offset,
            Color = atmosphere.Color,
            Decay = atmosphere.Decay,
            Glare = atmosphere.Glare,
            Haze = atmosphere.Haze
        }
        local atmosphere_changer = false
        local atmosphere_values = {
            Density = 0.28,
            Offset = 1,
            Color = Color3.new(1, 1, 1),
            Decay = Color3.new(),
            Glare = 1,
            Haze = 1
        }

        worldbox:AddToggle('world_atmosphere_changer', {Text = 'atmosphere changer',Default = false,Callback = function(first)
            atmosphere_changer = first
            if not first then for k, v in old_atmosphere do
                atmosphere[k] = v
            end end
        end})
        worldbox:AddSlider('world_atmosphere_density',{Text = 'atmosphere density',Default = 0.28,Min = 0,Max = 1,Rounding = 2,Compact = true,Callback = function(State)
            atmosphere_values.Density = State
            atmosphere.Density = State
        end})
        worldbox:AddSlider('world_atmosphere_offset',{Text = 'atmosphere offset',Default = 1,Min = 0,Max = 1,Rounding = 2,Compact = true,Callback = function(State)
            atmosphere_values.Offset = State
            atmosphere.Offset = State
        end})
        worldbox:AddLabel("atmosphere color"):AddColorPicker('world_atmosphere_color',{Default = Color3.new(1, 1, 1),Title = 'atmosphere color',Transparency = 0,Callback = function(Value)
            atmosphere_values.Color = Value
            atmosphere.Color = Value
        end})
        worldbox:AddLabel("atmosphere decay"):AddColorPicker('world_atmosphere_decay',{Default = Color3.new(),Title = 'atmosphere decay',Transparency = 0,Callback = function(Value)
            atmosphere_values.Decay = Value
            atmosphere.Decay = Value
        end})
        worldbox:AddSlider('world_atmosphere_glare',{Text = 'atmosphere glare',Default = 1,Min = 0,Max = 10,Rounding = 1,Compact = true,Callback = function(State)
            atmosphere_values.Glare = State
            atmosphere.Glare = State
        end})
        worldbox:AddSlider('world_atmosphere_haze',{Text = 'atmosphere haze',Default = 1,Min = 0,Max = 10,Rounding = 1,Compact = true,Callback = function(State)
            atmosphere_values.Haze = State
            atmosphere.Haze = State
        end})

        for _, method in {"Density", "Offset", "Color", "Decay", "Glare", "Haze"} do
            atmosphere:GetPropertyChangedSignal(method):Connect(function()
                if not atmosphere_changer then return end
                old_atmosphere[method] = atmosphere[method]
                atmosphere[method] = atmosphere_values[method]
            end)
        end
    end
end
do
    local movebox = ui.box.move:AddTab("movement")
    local speed_enabled, speed = false, 55
    movebox:AddToggle('speedhack_enabled', {Text = 'speedhack enabled',Default = false,Callback = function(first)
        speed_enabled = first
    end})
    movebox:AddSlider('speedhack_speed',{ Text = 'speed', Default = 12, Min = 12, Max = 18, Rounding = 1, Suffix = "sps", Compact = false }):OnChanged(function(State)
        speed = State
    end)
    cheat.utility.new_renderstepped(LPH_NO_VIRTUALIZE(function(delta)
        local character = LocalPlayer.Character
        local humanoid = character and _FindFirstChildOfClass(character, "Humanoid")
        if humanoid then
            if speed_enabled then humanoid.WalkSpeed = speed end
        end
    end))
end
do
    local exploitbox = ui.box.misc:AddTab("exploits")
    if SWG_Private then

    else
        exploitbox:AddLabel("private only 🤫🤫🤫")
    end
end
do
    --local silent_methods = {}
    --for _, key in {"Raycast", "FindPartOnRayWithWhitelist", "FindPartOnRayWithIgnoreList", "FindPartOnRay", "ScreenPointToRay", "ViewportPointToRay"} do
    --    silent_methods[key] = true
    --end
    local __namecall; __namecall = hookmetamethod(game, "__namecall", newcclosure(LPH_NO_VIRTUALIZE(function(self,...)
        if checkcaller() then return __namecall(self, ...) end
        local args = {...}
        local method = getnamecallmethod()
        if method == "FireServer" then
            if args[1] == "Create Projectile" then
                if lone.projectile_spoof[args[3]] then
                    args[3] = args[3]() -- fukkin retarded
                end
            end
        return __namecall(self, ...)
    end)))
end

ui.box.themeconfig:AddToggle('keybindshoww', {Text = 'show keybinds',Default = false,Callback = function(first)cheat.Library.KeybindFrame.Visible = first end})
cheat.ThemeManager:SetOptionsTEMP(cheat.Options, cheat.Toggles)
cheat.SaveManager:SetOptionsTEMP(cheat.Options, cheat.Toggles)
cheat.ThemeManager:SetLibrary(cheat.Library)
cheat.SaveManager:SetLibrary(cheat.Library)
cheat.SaveManager:IgnoreThemeSettings()
cheat.ThemeManager:SetFolder('swimhub')
cheat.SaveManager:SetFolder('swimhub')
cheat.SaveManager:BuildConfigSection(ui.tabs.config)
cheat.ThemeManager:ApplyToGroupbox(ui.box.themeconfig)

cheat.EspLibrary.load()
