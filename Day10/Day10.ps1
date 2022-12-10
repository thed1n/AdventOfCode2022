using namespace System.Collections.Generic
$data = Get-Content .\Day10\input10.txt
#$data = Get-Content .\Day10\Test10.txt


[int]$x = 1
[int]$c = 0 #crt position
[int]$r = 0 #crt row
$sprite = @(0, 1, 2)



$i = 0 #cycle
$datapointer = 0
$freq = [Dictionary[int, int]]@{}

$crtrow = @{}

0..5 | ForEach-Object {
    $n = $_
    [char[]]$row = 0..39 | ForEach-Object { '.' }
    $crtrow["$n"] = $row
}

function get-crtrow {
    param ($i)

    switch ($i) {
        { $i -in 0..39 } { return @(0, $i) }
        { $i -in 40..79 } { return @(1, ($i - 40)) }
        { $i -in 80..119 } { return @(2, ($i - 80)) }
        { $i -in 120..159 } { return @(3, ($i - 120)) }
        { $i -in 160..199 } { return @(4, ($i - 160)) }
        { $i -in 200..239 } { return @(5, ($i - 200)) }
    }
}
function update-sprite {
    param ([int]$x) 
    return @(($x - 1), $x, ($x + 1))
}

function draw-crt {
    param (
        $row,
        $pos,
        $sprite
    )
    Write-Verbose "draw $row $pos"

    if ($pos -in $sprite) {
        $crtrow["$row"][$pos] = '#'
        return
    }
    $crtrow["$row"][$pos] = '.'
}

while ($true) {


        #write-verbose "$i $x"
    if ($i -ge 240) { break }

    #write-verbose "$i $datapointer"
    #write-verbose "draw outside"
    $r, $c = get-crtrow $i
    draw-crt -row $r -pos $c -sprite $sprite

    if ($data[$datapointer] -eq 'noop') {
        
            #write-verbose "draw noop"
        $r, $c = get-crtrow $i
        draw-crt -row $r -pos $c -sprite $sprite
        
        $datapointer++
        $i++
        
        $r, $c = get-crtrow $i
        draw-crt -row $r -pos $c -sprite $sprite

        if ($i % 20 -eq 0) {
            #write-verbose "noop added to freq $i $x"
            [void]$freq.add($i, ($i * $x))
        }
        #write-verbose "noop"
        continue
    }
    
    $addx, [int]$val = $data[$datapointer].split()

    if ($addx -eq 'addx') {
            #write-verbose "addx"
        $i++

            #write-verbose "draw1 addx"
        $r, $c = get-crtrow $i
        draw-crt -row $r -pos $c -sprite $sprite

        if ($i % 20 -eq 0) {
                #write-verbose "1 added to freq $i $x"
            [void]$freq.add($i, ($i * $x))
        }

        $i++

            #write-verbose "draw2 addx"
        $r, $c = get-crtrow $i
        draw-crt -row $r -pos $c -sprite $sprite

        if ($i % 20 -eq 0) {
            #write-verbose "2 added to freq $i $x"
            [void]$freq.add($i, ($i * $x))
        }
            #write-verbose "$i adding $val to $x"
        #add last of the addx cycle
        $x += $val
        $sprite = update-sprite $x
    }

    $datapointer++
}




$sum = 0

20, 60, 100, 140, 180, 220 | ForEach-Object { $sum += $freq[$_] }
[pscustomobject]@{
    Part1 = $sum
}

##PART 2 read the text
0..5 | ForEach-Object { $crtrow["$_"] -join '' }
