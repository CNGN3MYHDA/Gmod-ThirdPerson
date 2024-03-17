CreateClientConVar("BThirdPerson_Enable", "0", false)

CreateClientConVar("BThirdPerson_Key", tostring(KEY_T), true, false, "Key to activate third person view", 1, 159)
local backOffset, rightOffset = 60, 15


local canPress = true
hook.Add("Think", "BThirdPerson_KeyHook", function()
	local key = GetConVar("BThirdPerson_Key"):GetInt()
	if canPress and input.IsKeyDown(key) and !LocalPlayer():IsTyping() and !vgui.GetKeyboardFocus() and !gui.IsGameUIVisible() then
		canPress = false

		if GetConVar("BThirdPerson_Enable"):GetBool() then
			RunConsoleCommand("BThirdPerson_Enable", "0")
		else
			RunConsoleCommand("BThirdPerson_Enable", "1")
		end
	end

	if !input.IsKeyDown(key) then
		canPress = true
	end
end)

hook.Add("CalcView", "BThirdPerson", function(ply, pos, angles, fov)
    if ply:InVehicle() or ply:GetViewEntity() != ply then return end
    if !GetConVar("BThirdPerson_Enable"):GetBool() && IsValid(ply) then return end

    local trace = util.TraceLine{
    	start = ply:EyePos(),
    	endpos = ply:EyePos() - angles:Forward() * backOffset + angles:Right() * rightOffset,
    	filter = ply
    }

    pos = trace.HitPos

    if trace.Fraction < 1.0 then
        pos = pos + trace.HitNormal * 5
    end

    return {
    	origin=pos,
    	angles=angles,
    	fov=fov,
    	drawviewer=true
    }
end)