del /q SET.cmd
goto :SETCMDS
[INI]
:SETCMDS
set GPUD=[GPUD]
set GPU=[GPU]
set SPUD=[SPUD]
set SPU=[SPU]
set PADCFG=[PADTYPE]
REM 4,4,1,1,4,1,1,1
set PAD1TYPE=[PAD1CFG]
REM 514,513,512,515,275,273,272,274,276,260,277,261,279,278,280,281
set PAD2TYPE=[PAD2CFG]
REM 547,39,544,545,307,305,304,306,308,292,309,293,311,310,312,313
set PAD3TYPE=[PAD3CFG]
REM 514,513,512,515,275,273,272,274,276,260,277,261,279,278,280,281
set PAD4TYPE=[PAD4CFG]
REM 514,513,512,515,275,273,272,274,276,260,277,261,279,278,280,281
set PAD5TYPE=[PAD5CFG]
REM 514,513,512,515,275,273,272,274,276,260,277,261,279,278,280,281
set PAD6TYPE=[PAD6CFG]
REM 514,513,512,515,275,273,272,274,276,260,277,261,279,278,280,281
set PAD7TYPE=[PAD7CFG]
REM 514,513,512,515,275,273,272,274,276,260,277,261,279,278,280,281
set PAD8TYPE=[PAD8CFG]
REM 514,513,512,515,275,273,272,274,276,260,277,261,279,278,280,281
SET MULTITAP1=[MULTI1]
SET MULTITAP2=[MULTI2]
call %GPU%_DEFAULT.cmd
call %SPU%_DEFAULT.cmd
for %%a in ('dir /b/a-d "Internal*.cmd"') do call "%%~a"