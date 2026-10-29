local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

-- Ordner mit allen Checkpoints
local checkpointOrdner = Workspace:WaitForChild("Checkpoints")

-- Wir sammeln alle Parts und lesen ihre Attribute
local checkpoints = {}

for _, teil in ipairs(checkpointOrdner:GetChildren()) do
	if teil:IsA("BasePart") then
		local nummer = teil:GetAttribute("CheckpointID")
		if nummer then
			checkpoints[nummer] = teil
		else
			warn("Part " .. teil.Name .. " hat kein CheckpointID-Attribut!")
		end
	end
end

-- Pro Spieler: welcher Checkpoint ist erreicht?
local erreicht = {}

-- Merkt sich, ob der Spieler gerade gestorben ist
local wartetAufRespawn = {}

-- Schickt einen frisch gespawnten Charakter zum Checkpoint
local function teleportZuCheckpoint(spieler, charakter)
	local nummer = erreicht[spieler]
	if not nummer then return end

	local ziel = checkpoints[nummer]
	if not ziel then return end

	local root = charakter:WaitForChild("HumanoidRootPart")
	
	-- SOFORT teleportieren, ohne Wartezeit
	if charakter.Parent and root.Parent then
		root.CFrame = ziel.CFrame + Vector3.new(0, 4, 0)
	end
end

-- Wird jedes Mal aufgerufen, wenn ein Charakter erscheint
local function charakterGeladen(spieler, charakter)
	local humanoid = charakter:WaitForChild("Humanoid")

	-- War das ein Tod? Dann ab zum Checkpoint.
	if wartetAufRespawn[spieler] then
		wartetAufRespawn[spieler] = nil
		teleportZuCheckpoint(spieler, charakter)
	end

	-- Beim Sterben merken wir uns das
	humanoid.Died:Connect(function()
		wartetAufRespawn[spieler] = true
	end)
end

-- Wenn ein Spieler dem Spiel beitritt
local function spielerBeigetreten(spieler)
	erreicht[spieler] = nil
	wartetAufRespawn[spieler] = nil

	spieler.CharacterAdded:Connect(function(charakter)
		charakterGeladen(spieler, charakter)
	end)

	-- Falls der Charakter schon da ist
	if spieler.Character then
		charakterGeladen(spieler, spieler.Character)
	end
end

-- Bereits im Spiel befindliche Spieler abholen
for _, spieler in ipairs(Players:GetPlayers()) do
	spielerBeigetreten(spieler)
end

Players.PlayerAdded:Connect(spielerBeigetreten)

-- Aufräumen, wenn jemand das Spiel verlässt
Players.PlayerRemoving:Connect(function(spieler)
	erreicht[spieler] = nil
	wartetAufRespawn[spieler] = nil
end)

-- Die Checkpoints selbst: was passiert beim Durchlaufen?
for nummer, teil in pairs(checkpoints) do
	teil.Touched:Connect(function(beruehrung)
		local charakter = beruehrung.Parent
		if not charakter then return end

		local humanoid = charakter:FindFirstChildOfClass("Humanoid")
		if not humanoid or humanoid.Health <= 0 then return end

		local spieler = Players:GetPlayerFromCharacter(charakter)
		if not spieler then return end -- HIER KORRIGIERT: "not" statt "nicht"

		-- Immer zum letzten berührten Checkpoint (auch zurück!)
		erreicht[spieler] = nummer
		print(spieler.Name .. " hat Checkpoint " .. nummer .. " erreicht!")
	end)
end
