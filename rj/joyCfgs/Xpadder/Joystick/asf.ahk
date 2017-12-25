;FileCreateDir,newpngs
Loop, %A_ScriptDir%\*,2
	{
		filename=%A_LoopFileName%
		StringReplace,nwv,A_LoopFileName,-,,All
		StringReplace,nwv,nwv,%A_Space%,,All
		;stringtrimright,nwv,nwv,5
		acx= %nwv%
		Loop, Read, C:\Users\sudopinion\Documents\skeletonkey\lkup.set
			{
				stringsplit,nad,A_LoopReadLine,=
				stringreplace,mwv,nad1,-,,All
				stringreplace,mwv,mwv,%A_Space%,,All
				;msgbox,,,%acx%=%mwv%
				if (mwv = acx)
					{
						FileMoveDir,%filename%,%nad1%,R
						;RunWait, %comspec% /c "nconvert.exe -out png  -o "newpngs\%nad1%.png" "%filename%" ",,hide
					}	
			}
	}