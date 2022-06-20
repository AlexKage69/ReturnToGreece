-- Going to combine all mods
if ModUtil ~= nil then
    ModUtil.Mod.Register("ReturnToGreece")

	local MyObstacleData = ModUtil.Entangled.ModData(ObstacleData)
	MyObstacleData.ReturnShipEmpty =
	{
		UseText = "RideBack",
		OnUsedFunctionName = "EndEarlyAccessPresentation",
		OnUsedFunctionArgs = { },
		InteractDistance = 180,
		InteractOffsetX = 380,
		InteractOffsetY = 60,
	}
	local MyRoomSetData = ModUtil.Entangled.ModData(RoomSetData)
	MyRoomSetData.Styx.D_Boss01.ExitFunctionName = "CheckEndStyx"
	local MyEncounterData = ModUtil.Entangled.ModData(EncounterData)
	MyEncounterData.Story_Persephone_01.StartRoomUnthreadedEvents[1].GameStateRequirements =
	{
		RequiredFalseTextLines = { "Ending01" },
	}
	MyEncounterData.Story_Persephone_01.StartRoomUnthreadedEvents[2].GameStateRequirements.RequiredFalseTextLines = { "Ending01" }
	MyEncounterData.Story_Persephone_01.StartRoomUnthreadedEvents[3] =
	{ FunctionName = "ActivateObjects", Args = { ObjectType = "ReturnShipEmpty" } }

	function CheckEndStyx(currentRun, door)
		AddInputBlock({ Name = "CheckRunEndPresentation" })
		local heroExitPointId = GetClosest({ Id = door.ObjectId, DestinationIds = GetIdsByType({ Name = "HeroExit" }), Distance = 600 })
		thread( MoveHeroToRoomPosition, { DestinationId = heroExitPointId, DisableCollision =  true, UseDefaultSpeed = true } )
		FullScreenFadeOutAnimation()
		if TextLinesRecord["LordHadesBeforePersephoneReturn01"] ~= nil then
			thread( PlayVoiceLines, GlobalVoiceLines.BossHadesPeacefulExitVoiceLines )
		end
		wait( 3.5 )
		RemoveInputBlock({ Name = "CheckRunEndPresentation" })
	end
end