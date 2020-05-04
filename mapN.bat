@echo off
set drive=N:
set ipMan=<ip_address_here>
set srvMac=<serverMacAddress>
set srvName=homeMagicBox
set wolApp="C:\Program Files\Aquila Technology\WakeOnLAN\WakeOnLanC.exe"
set dPath=\\%ipMan%\stg

echo [  v0.2 ]
echo [ Start ] Checking if %drive% exists

for /f "tokens=*" %%i in ('net use ^| findstr %drive%') do set mountedNow=%%i
if "%mountedNow%" == "" (

	echo [ DRmnt ] No drive %drive% found
	echo [  Net  ] Checking availability
	ping -n 1 -4 %ipMan% | find /I "time" >> NUL
	if errorlevel 1 (

		echo [  Net  ] noPing from %ipMan%, trying to wake up server
		%wolApp% -w -mac %srvMac%
		timeout 4
		echo [  Net  ] Checking availability
		ping -n 1 -4 %ipMan% | find /I "time" >> NUL
		if errorlevel 1 (
			echo [  Net  ] noPing from %ipMan%, system stop
		) else (
			echo [ DRmnt ] Got ping, mounting
			net use %drive% %dpath%	
		)
	) else (
		echo [ DRmnt ] Got ping, mounting
		net use %drive% %dpath%	
	)

) else (

	echo [ DRmnt ] Drive %drive% exists, unmounting
	net use %drive% /delete 
	%wolApp% -s -m %srvName% > NUL

)

echo [  End  ] Program done

