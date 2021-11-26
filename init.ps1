
1..24 | % {
New-Item -Path .\ -ItemType Directory -Name "Day$_"
New-Item -Path ".\Day$_" -ItemType File -Name "Day$_.ps1"
New-Item -Path ".\Day$_" -ItemType File -Name "Input$_.txt"
New-Item -Path ".\Day$_" -ItemType File -Name "Test$_.txt"

}
1..24 | % {$day = $_
'$data = get-content .\Day{0}\Input{0}.txt' -f $day | set-content ".\Day$day\Day$day.ps1"
}
