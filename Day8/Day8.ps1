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

function part1_supercharged {
    param (
        [int]$tree,
        [int]$horizontal,
        [int]$vertical,
        [string]$direction,
        [switch]$start
    )
    
    write-verbose "$vertical $horizontal $direction"
    if ($start) {
    [int]$singleTree = $trees[$vertical, $horizontal]
    write-verbose $singleTree
    part1_supercharged -vertical $($vertical+1) -horizontal $horizontal -direction 'down' -tree $singleTree
    part1_supercharged -vertical $($vertical-1) -horizontal $horizontal -direction 'up' -tree $singleTree
    part1_supercharged -vertical $vertical -horizontal $($horizontal-1) -direction 'left' -tree $singleTree
    part1_supercharged -vertical $vertical -horizontal $($horizontal+1) -direction 'right' -tree $singleTree
    }

    if ($vertical -lt 0 -or $vertical -ge $trees.GetLength(0) -or $horizontal -lt 0 -or $horizontal -ge $trees.GetLength(1)) {
        write-verbose 'return 1'
        return 1}
    if ($trees[$vertical, $horizontal] -ge $tree) {write-verbose 'return blank'; return}
    switch ($direction) {
        'down' {part1_supercharged -vertical (++$vertical) -horizontal $horizontal -direction 'down' -tree $singleTree}
        'up' {part1_supercharged -vertical (--$vertical) -horizontal $horizontal -direction 'up' -tree $singleTree}
        'left' {part1_supercharged -vertical $vertical -horizontal (--$horizontal) -direction 'left' -tree $singleTree}
        'right' {part1_supercharged -vertical $vertical -horizontal (++$horizontal) -direction 'right' -tree $singleTree}
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
    $ranges =[ordered]@{}
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

    $ranges['sum'] = $left*$right*$up*$down
    return [pscustomobject]$ranges
}

function find-visibletree2 {
    param (
        #[array]$trees,
        [int]$horizontal,
        [int]$vertical
    )
    #use the defined array as readonly
    [int]$singleTree = $trees[$vertical, $horizontal]

    #check left

    $free = 0
    for ($h = $horizontal - 1; $h -ge 0 ; $h--) {
        if ($trees[$vertical, $h] -ge $singletree ) {
            $free = 1
            break
        }
    }
    if ($free -eq 0) {return 1}
    
    #right

    $free = 0
    for ($h = $horizontal + 1; $h -lt $trees.GetLength(1); $h++) {
        if ($trees[$vertical, $h] -ge $singletree ) {
            $free = 1
            break
        }
    }
    if ($free -eq 0) {return 1}

    #up

    $free = 0
    for ($v = $vertical - 1; $v -ge 0; $v--) {
        if ($trees[$v, $horizontal] -ge $singletree ) {
            $free = 1
            break 
    }}
    if ($free -eq 0) {return 1}

    #down

    $free = 0
    for ($v = $vertical + 1; $v -lt $trees.GetLength(0); $v++) {
        if ($trees[$v, $horizontal] -ge $singletree ) {
            $free = 1
            break
        }
    }
    if ($free -eq 0) {return 1}

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
}

#old part 1
<#
$sum=0
#find the inner trees
for ($v = 1; $v -lt $data.count-1; $v++) {
    #horisontal
    for ($h = 1; $h -lt $data[0].Length-1; $h++) {
        $sum += find-visibletree -v $v -h $h 
    }
}
#>



$sum = 0
for ($v = 0; $v -lt $data.count; $v++) {
    #horisontal
    for ($h = 0; $h -lt $data[0].Length; $h++) {
        $sum += find-visibletree2 -v $v -h $h
    }
}

$sum

$treeranges = for ($v = 0; $v -lt $data.count-1; $v++) {
    #horisontal
    for ($h = 0; $h -lt $data[0].Length-1; $h++) {
        find-visibletreerange -v $v -h $h
    }
}

[SortedSet[int]]$maxrange = $treeranges.sum

[pscustomobject]@{
Part1 = $sum2
Part2 = $maxrange.max
}