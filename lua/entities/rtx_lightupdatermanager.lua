 
CreateConVar( "rtx_experimental_lightupdater_count", 8,  FCVAR_ARCHIVE )
CreateConVar( "rtx_experimental_lightupdater_show", 0,  FCVAR_ARCHIVE )
AddCSLuaFile()

ENT.Type 			= "anim"
ENT.PrintName		= "lightupdatermanager"
ENT.Author			= "Xenthio"
ENT.Information		= "update lights as fast as possible"
ENT.Category		= "RTX"

ENT.Spawnable		= false
ENT.AdminSpawnable	= false
  

function shuffle(tbl)
	for i = #tbl, 2, -1 do
	  local j = math.random(i)
	  tbl[i], tbl[j] = tbl[j], tbl[i]
	end
	return tbl
end
function TableConcat(t1,t2)
    for i=1,#t2 do
        t1[#t1+1] = t2[i]
    end
    return t1
end

function ENT:Initialize() 
    print("[RTX Fixes] - Lightupdater Initialised.")
    self:SetModel("models/hunter/blocks/cube025x025x025.mdl") 
    --self:SetPos("LocalPlayer():GetPos()")
    self:SetRenderMode(2) 
    self:SetColor(Color(255,255,255,1))
    
    self.lights = NikNaks.CurrentMap:FindByClass( "light" )
	self.lights = TableConcat(self.lights,NikNaks.CurrentMap:FindByClass( "light_spot" ))

	self.Updaters = { }
    for i = 1, math.min(GetConVar( "rtx_experimental_lightupdater_count" ):GetInt(), table.Count(self.lights)) do
        self.Updaters[i] = ents.CreateClientside( "rtx_lightupdater" ) 
        self.Updaters[i]:Spawn()
    end

    self.doshuffle = true;
end
function ENT:Think()
    --lights = NikNaks.CurrentMap:GetEntities()
	--lights = TableConcat(lights,NikNaks.CurrentMap:FindByClass( "light_environment" ))
	if (self.doshuffle) then
        stash = shuffle(self.lights)
    end
    for i, updater in pairs(self.Updaters) do
        if (stash[i] == nil) then
            table.remove( self.Updaters, i )
            updater:Remove() 
        else
            updater:SetPos(stash[i].origin - (stash[i].angles:Forward() * 8)) 
            updater:SetRenderMode(2) 
            updater:SetColor(Color(255,255,255,1))
            if (GetConVar( "rtx_experimental_lightupdater_show" ):GetBool()) then
                updater:SetRenderMode(0) 
            end
        end
    end
end

function ENT:OnRemove() 
end
