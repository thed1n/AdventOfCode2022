using namespace System.Collections.Generic
$data = Get-Content .\Day8\Input8.txt

#$data = Get-Content .\Day8\test8.txt

function drawtree {
    param(
        [array]$trees,
        [int]$v,
        [int]$h
    )

    $v = $trees.GetLength(0) #gets vertical lenght GetUpperBound to get last position in the dimension
    $h = $trees.GetLength(1) #gets horizontal lenght
    for ($v = 0; $v -lt $trees.GetLength(0); $v++) {
        #horisontal
        for ($h = 0; $h -lt $trees.GetLength(1); $h++) {
            Write-Host $trees[$v, $h] -NoNewline
        }
        Write-Host ''
    }

}

function find-visibletree {
    param (
        #[array]$trees,
        [int]$horizontal,
        [int]$vertical
    )
    #use the defined array as readonly
    [int]$singleTree = $trees[$vertical, $horizontal]
    #check left
    [SortedSet[int]]$left = for ($h = $horizontal - 1; $h -ge 0 ; $h--) {
        $trees[$vertical, $h]
    }
    if ($left.max -lt $singleTree) {
        return 1
    }
    #right
    [SortedSet[int]]$right = for ($h = $horizontal + 1; $h -le $trees.GetLength(1); $h++) {
        $trees[$vertical, $h]
    }
    if ($right.max -lt $singleTree) {
        return 1
    }
    #up
    [SortedSet[int]]$up = for ($v = $vertical - 1; $v -ge 0; $v--) {
        $trees[$v, $horizontal]
    }
    if ($up.max -lt $singleTree) {
        return 1
    }
    #down
    [SortedSet[int]]$down = for ($v = $vertical + 1; $v -le $trees.GetLength(0); $v++) {
        $trees[$v, $horizontal]
    }
    if ($down.max -lt $singleTree) {
        return 1
    }
}
function find-visibletreerange {
    param (
        #[array]$trees,
        [int]$horizontal,
        [int]$vertical
    )
    #use the defined array as readonly
    [int]$singleTree = $trees[$vertical, $horizontal]
    $ranges =@{}
    #check left
    [int]$left = 0
    for ($h = $horizontal - 1; $h -ge 0 ; $h--) {
        #write-host $h
        if ($trees[$vertical, $h] -ge $singletree ) {
            $left++
            break
        }
        else {
            $left++
        }
    
    }
    $ranges['left'] = $left
    
    #right
    [int]$right = 0
    for ($h = $horizontal + 1; $h -lt $trees.GetLength(1); $h++) {
        if ($trees[$vertical, $h] -ge $singletree ) {
            $right++
            break
        }
        else {
            $right++
        }
    }
    $ranges['right'] = $right

    #up
    [int]$up = 0
    for ($v = $vertical - 1; $v -ge 0; $v--) {
        if ($trees[$v, $horizontal] -ge $singletree ) {
            $up++
            break
        }
        else {
            $up++
        }
    }
    $ranges['up'] = $up

    #down
    [int]$down = 0
    for ($v = $vertical + 1; $v -lt $trees.GetLength(0); $v++) {
        #write-host $v
        if ($trees[$v, $horizontal] -ge $singletree ) {
            $down++
            break
        }
        else {
            $down++
        }
    }
    $ranges['down'] = $down

    return [pscustomobject]$ranges
}

[int]$outside = ($data.count + $data[0].Length) * 2 - 4 #-4 for the corners

$trees = [int[,]]::new($($data.count), $($data[0].Length))

#fill trees

#vertical
for ($v = 0; $v -lt $data.count; $v++) {

    #horisontal
    for ($h = 0; $h -lt $data[0].Length; $h++) {
        $trees[$v, $h] = [int]$data[$v][$h]-48 #char to int
    }

    <# Action that will repeat until the condition is met #>
}

$sum=0
#find the inner trees
for ($v = 1; $v -lt $data.count-1; $v++) {
    #horisontal
    for ($h = 1; $h -lt $data[0].Length-1; $h++) {
        #write-host "$($trees[$v,$h])" -NoNewline
        #write-host " $(find-visibletree -v $v -h $h)"-ForegroundColor Green
        $sum += find-visibletree -v $v -h $h
    }
}

for ($v = 0; $v -lt $data.count-1; $v++) {
    #horisental
    for ($h = 0; $h -lt $data[0].Length-1; $h++) {
        find-visibletree -v $v -h $h
    }
}

[pscustomobject]@{
Part1 = $sum + $outside
}



drawtree -trees $trees
find-visibletree -v 2 -h 2
find-visibletreerange -v 3 -h 2