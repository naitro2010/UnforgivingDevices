;/  File: UD_ModTrigger_DeviceEvent
    It triggers on device event(s)
    
    NameFull: On Device Event
    
    Parameters in DataStr:
        [0]     String      Device event to trigger (one or several abbreviations separated by space)
                                DL - Device locked
                                DU - Device unlocked
                                DB - Device broken
                            
        [1]     Float       Base probability to trigger on event (in %)
                            Default value: 100.0%
                              
    Example:
        DL,100              It triggers when device is locked
/;
Scriptname UD_ModTrigger_DeviceEvent extends UD_ModTrigger

import UnforgivingDevicesMain
import UD_Native

;/  Group: Events Processing
===========================================================================================
===========================================================================================
===========================================================================================
/;
Bool Function DeviceLocked(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1)
    Float loc_prob = MultFloat(GetStringParamFloat(aiDataStr, 1, 100.0), akModifier.MultProbabilities)
    String loc_event = GetStringParamString(aiDataStr, 0, "")

    If StringUtil.Find(loc_event, "DL") < 0
        Return False
    EndIf

    PrintNotification(akDevice, ;/ reacted /;"as soon as it touches you.")

    Return (RandomFloat(0.0, 100.0) < loc_prob)
EndFunction

Bool Function DeviceUnlocked(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1)
    Float loc_prob = MultFloat(GetStringParamFloat(aiDataStr, 1, 100.0), akModifier.MultProbabilities)
    String loc_event = GetStringParamString(aiDataStr, 0, "")

    If StringUtil.Find(loc_event, "DU") < 0
        Return False
    EndIf

    Return (RandomFloat(0.0, 100.0) < loc_prob)
EndFunction

Bool Function ConditionLoss(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, Int aiCondition, String aiDataStr, Form akForm1)
    If aiCondition < 4
        Return False
    EndIf
    Float loc_prob = MultFloat(GetStringParamFloat(aiDataStr, 1, 100.0), akModifier.MultProbabilities)
    String loc_event = GetStringParamString(aiDataStr, 0, "")

    If StringUtil.Find(loc_event, "DB") < 0
        Return False
    EndIf

    Return (RandomFloat(0.0, 100.0) < loc_prob)
EndFunction

;/  Group: User interface
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetParamsTableRows(UD_Modifier_Combo akModifier, UD_CustomDevice_RenderScript akDevice, String aiDataStr, Form akForm1)
    Float loc_prob = MultFloat(GetStringParamFloat(aiDataStr, 1, 100.0), akModifier.MultProbabilities)
    String loc_res = ""
    String loc_frag = GetStringParamString(aiDataStr, 0, "")
    If UDmain.UDMTF.HasHtmlMarkup()
        loc_frag = GetDeviceEventString(loc_frag, "<br/> \t\t")
    Else
        loc_frag = GetDeviceEventString(loc_frag, ", ")
    EndIf
    loc_res += UDmain.UDMTF.TableRowDetails("Event(s):", loc_frag)
    loc_res += UDmain.UDMTF.TableRowDetails("Base probability:", FormatFloat(loc_prob, 1) + "%")
    Return loc_res
EndFunction

;/  Group: Protected Methods
===========================================================================================
===========================================================================================
===========================================================================================
/;
String Function GetDeviceEventString(String asAbbr, String asSep = ", ")
    String loc_str = ""
    Bool loc_comma = False
    If StringUtil.Find(asAbbr, "DL") >= 0
        loc_str += "Device Locked"
        loc_comma = True
    EndIf
    If StringUtil.Find(asAbbr, "DU") >= 0
        If loc_comma 
            loc_str += asSep
        EndIf
        loc_str += "Device Unlocked"
        loc_comma = True
    EndIf
    If StringUtil.Find(asAbbr, "DB") >= 0
        If loc_comma 
            loc_str += asSep
        EndIf
        loc_str += "Device Broken"
        loc_comma = True
    EndIf
    Return loc_str
EndFunction