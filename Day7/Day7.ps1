using namespace System.Collections.Generic
$data = Get-Content .\Day7\Input7.txt
#$data = Get-Content .\Day7\test7.txt

class dir {
    [string]$node
    [string]$parent
    [object[]]$files
    [string[]]$childFolder
    [int64]$size
    [int64]$totalsize
    [bool]$filesAdded = $false
    dir () {}

    dir ($parent, $node) {
        $this.parent = $parent
        $this.node = $node
    }
}

$structure = @{}
$path = '\'
foreach ($d in $data) {

    if ($d -match '\.\.') {
        $structure[$path].filesAdded = $true
        $path = Split-Path $path -Parent
    }

    if ($d -match '\$ cd \/') {
        $structure[$path] = [dir]::new('', '\')

    }

    if ($d -match '\$ cd \w+') {
        $structure[$path].filesAdded = $true

        $subdir = $d -replace '\$ cd (.+)', '$1'
        $parentpath = $path.Clone()
        $path = Join-Path $path $subdir
        $structure[$path] = [dir]::new($parentpath, $path)
    }

    if ($d -match '^dir') {
        $dir = $d -replace 'dir (.+)', '$1'
        $structure[$path].childFolder += @($dir)
    }

    if ($d -match '^\d+') {
        if ($structure[$path].filesAdded -eq $false) {
            $size, $name = $d -split ' '
            $structure[$path].files += [pscustomobject]@{size = [int]$size; name = $name }
            $structure[$path].size += [int]$size
            $structure[$path].totalsize += $size
        }
    }

}

foreach ($deep in $structure.keys) {

    write-verbose $deep
    if ($deep -eq '\') {
        write-verbose 'continue if its root'
        continue}
    $tempsum = $structure[$deep].size
    $parent = $structure[$deep].parent
    
    while ($true) {
        write-verbose $parent
        if ($parent -eq '\') {
            $structure['\'].totalsize += $tempsum
            write-verbose "break loop"
            break
        }
        $structure[$parent].totalsize += $tempsum
        $parent = $structure[$parent].parent
    }
}


$sum = 0
$structure.keys | ForEach-Object {
    if ($structure[$_].totalsize -lt 100000) {
        $sum += $structure[$_].totalsize
    }
}

#The total disk space available to the filesystem is 70000000. To run the update, you need unused space of at least 30000000.
$sizeNeeded = [math]::abs((70000000 - $structure['\'].totalsize) - 30000000)


[sortedset[int]]$sum2 = $structure.keys | ForEach-Object {
    if ($structure[$_].totalsize -gt $sizeNeeded) 
    { $structure[$_].totalsize }
}

[pscustomobject]@{
    Part1 = $sum
    Part2 = $sum2.min
}

#Draw structure
#$structure.keys | ForEach-Object { $structure[$_] } | Select-Object node, size, totalsize | Sort-Object node