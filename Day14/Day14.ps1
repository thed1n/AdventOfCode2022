using namespace System.Collections.Generic
$data = Get-Content .\day14\Input14.txt
#$data = get-content .\Day14\test14.txt



function drawgrid {
    param(
        [int]$x,
        [int]$xto,
        [int]$y,
        [int]$yto,
        $othergrid
    )

    if ($PSBoundParameters.ContainsKey('othergrid')) {
        $grid = $othergrid
    }

    for ($v = $y; $v -lt $yto; $v++) {
        #horisontal
        for ($h = $x; $h -lt $xto; $h++) {

            if ($grid.containskey("$h,$v")) {
            Write-Host $grid["$h,$v"] -NoNewline
            }
            else {
                Write-Host '.' -NoNewline
            }
            
        }
        Write-Host ''
    }

}
function drawcave {
    param(
        [int]$x,
        [int]$xto,
        [int]$y,
        [int]$yto,
        $othergrid
    )

    if ($PSBoundParameters.ContainsKey('othergrid')) {
        $grid = $othergrid
    }

    for ($v = $y; $v -lt $yto; $v++) {
        #horisontal
        for ($h = $x; $h -lt $xto; $h++) {

            if ($grid.containskey("$h,$v")) {
            Write-Host $grid["$h,$v"] -NoNewline
            }
            else {
                Write-Host '.' -NoNewline
            }
            
        }
        Write-Host ''
    }

}
function drop-sand {
    param (
        $start,
        $end = 12
    )
    

    $x = 500
    $y = 0
    $iterator = 1
    while ($true) {
        
        if ($y -gt $end) {

            write-verbose "break [$y]<[$end]"
            break
        }
        $y++
        write-verbose "Current [$x][$y]"
        if ($grid.containskey("$x,$y") -eq $false) {
            write-verbose "Move down [$x][$y]"
            #movedown
            $y++
        }

        if ($grid.containskey("$x,$y")) {

            #check left 
            if ($grid.containskey("$($x-1),$y") -eq $false) {
                $x--
                write-verbose "Check Left its free: [$x][$y]"
                continue
            }
            #check right
            if ($grid.containskey("$($x+1),$y") -eq $false) {
                $x++
                write-verbose "Check Right its free: [$x][$y]"
                continue
            }
            #if no free spot
            write-verbose "No free spot setting o above [$x][$y]"
            $grid["$x,$($y-1)"] = 'o'
            $x = 500
            $y = 0
            $iterator++
        }
    }
    return $iterator-1
}

function drop-sandOnHardFloor {
    [cmdletbinding()]
    param (
        $start,
        $end = 12
    )
    

    $x = 500
    $y = 0
    $iterator = 1
    while ($true) {
        
        if ($grid2.contains("$x,$y")) {
            break
        }
        if ($y -gt $end) {
            write-verbose "reached the end start over. [$y]<[$end]"
            $x = 500
            $y = 0
        }
        $y++
        write-verbose "Current [$x][$y]"
        if ($grid2.containskey("$x,$y") -eq $false) {
            write-verbose "Move down [$x][$y]"
            #movedown
            $y++
        }

        if ($grid2.containskey("$x,$y")) {

            #check left 
            if ($grid2.containskey("$($x-1),$y") -eq $false) {
                $x--
                write-verbose "Check Left its free: [$x][$y]"
                continue
            }
            #check right
            if ($grid2.containskey("$($x+1),$y") -eq $false) {
                $x++
                write-verbose "Check Right its free: [$x][$y]"
                continue
            }
            #if no free spot
            write-verbose "No free spot setting o above [$x][$y]"
            $grid2["$x,$($y-1)"] = 'o'
            $x = 500
            $y = 0
            $iterator++
        }

    }
    return $iterator-1
}
[Dictionary[int,string[]]]$rocks = @{}

$i = 0
foreach ($d in $data) {
[string[]]$arr = @($($d -split ' -> '))
$rocks.add($i,$arr)
$i++
}

$grid = @{}
$grid2 = @{}


[sortedset[int]]$ycords = @{}
[sortedset[int]]$xcords = @{}

$rocks.keys | % {
    $k = $_
        for ($i=0;$i -lt ($rocks[$k].count-1);$i++) {
            $x,$y = $rocks[$k][$i] -split ','
            $x2,$y2 = $rocks[$k][$i+1] -split ','

            if ($x -ne $x2) {
                $x..$x2 | % {
                    $grid["$_,$y"]= '#'
                    $grid2["$_,$y"]= '#'
                }
            }
            if ($y -ne $y2) {
                $y..$y2 | % {
                    $grid["$x,$_"]= '#'
                    $grid2["$x,$_"]= '#' #forgot to change this for part2 facepalm so it was a copy of $x vector
                }
            }
            [void]$ycords.add($y)
            [void]$ycords.add($y2)
            [void]$xcords.add($x)
            [void]$xcords.add($x2)


        }
    }

#part1

$result = drop-sand -end $($ycords.max+3) -grid $grid
drawgrid -x $($xcords.min-4) -xto $($xcords.max+4) -y 0 -yto $($ycords.max+2)


#fill last row
($xcords.min-2000)..$($xcords.Max+2000) | % {
    $grid2["$_,$($ycords.max+2)"] = '#'
}

$result2 = drop-sandOnHardFloor -end $($ycords.max+2)
#drawgrid -x $($xcords.min-40) -xto $($xcords.max+180) -y 0 -yto $($ycords.max+3) -othergrid $grid2
drawcave -x $($xcords.min-40) -xto $($xcords.max+180) -y 0 -yto $($ycords.max+3) -othergrid $grid2

$sum = 0
$grid2.Keys|% {
    if ($grid2[$_] -eq 'o') {
        $sum++
    }
}
$sum
[pscustomobject]@{
    Part1 = $result
    Part2 = $result2
}

