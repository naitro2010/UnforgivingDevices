Scriptname zadBoundCombatScript_UDPatch Extends zadBoundCombatScript Hidden

import UnforgivingDevicesMain

;is not used by parent script, no sin here
Function OnInit()
	Utility.waitMenuMode(2.0) ;wait few moments, so computer doesn't explode
	Maintenance_ABC()
EndFunction

Function EvaluateAA(actor akActor)
	if StorageUtil.GetIntValue(akActor,"DDStartBoundEffectQue",0)
		return
	endif
	StorageUtil.SetIntValue(akActor,"DDStartBoundEffectQue",1)
	
	bool loc_paralysis = false
	while akActor.getAV("Paralysis")
		loc_paralysis = true
		Utility.wait(1.0) ;wait for actors paralysis to worn out first, because it can cause issue if idle is set when paralysed
	endwhile
	
	if loc_paralysis
		Utility.wait(8.0)
	endif
	
	parent.EvaluateAA(akActor)
	StorageUtil.UnSetIntValue(akActor,"DDStartBoundEffectQue")
EndFunction