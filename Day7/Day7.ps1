using namespace System.Collections.Generic
$data = Get-Content .\Day7\Input7.txt
#$data = Get-Content .\Day7\test7.txt



class dir {
    [string]$node
    [int]$level
    [string]$parent
    [string]$parentguid
    [object[]]$files
    [string[]]$childFolder
    [int64]$size
    [int64]$totalsize

    dir () {}
    dir ($node, $level, $parent) {
        $this.node = $node
        $this.level = $level
        $this.parent = $parent
    }
    dir ($parent,$node) {
        $this.parent = $parent
        $this.node = $node
    }
}



#$dirs = $data -match '\$ cd|dir .+|\$ cd \.\.'
$structure = @{}
$level = -1

$path = '\'
foreach ($d in $data) {

    #write-verbose $d
    if ($d -match '\.\.') {
        $path = Split-Path $path -Parent
    }

    if ($d -match '\$ cd \/') {
        $structure[$path] = [dir]::new()
    }

    if ($d -match '\$ cd \w+') {
        $subdir = $d -replace '\$ cd (.+)', '$1'
        $parentpath = $path.Clone()
        $path = join-path $path $subdir
        $structure[$path] = [dir]::new($parentpath, $path)
    }

    if ($d -match '^dir') {
        $dir = $d -replace 'dir (.+)','$1'
        $structure[$path].childFolder += @($dir)
    }

    if ($d -match '\d+') {
        #write-verbose "enter file $d"
        $size, $name = $d -split ' '
        $structure[$path].files += [pscustomobject]@{size = $size; name = $name }
        $structure[$path].size += $size
        $structure[$path].totalsize += $size
    }
}


$deepestnodes = $structure.keys | % {if (!$structure[$_].childfolder) {
    $_
}}

#updates the totalsize
foreach ($n in $deepestnodes) {
    $addsum = [stack[string]]::new()
    $tempsum = 0  
    
    $tempsum += $structure[$n].size
    $addsum.push($structure[$n].parent)

    while ($addsum.count -gt 0) {

        $parent = $addsum.pop()
        write-verbose "updateing $parent [$($structure[$parent].totalsize)] with sum [$tempsum]"
        $structure[$parent].totalsize += $tempsum
        $tempsum = $structure[$parent].totalsize
        if ($structure[$parent].parent) {
            $addsum.push($structure[$parent].parent)
        }
    }

}


<#
stack summation overkill

$root = '\'
[stack[string]]$stack = '\'
[hashset[string]]$checked= @{}
$sum = 0
while ($stack.count -ne 0) {
    
    $workingnode = $stack.pop()
    if ($checked.Contains($workingnode)) {
        continue
    }
    [void]$checked.add($workingnode)

    write-verbose "popped $workingnode"
        if ($structure[$root].size -lt 100000) {
            $sum+=$structure[$root].size
        }
    
    $childs = $structure[$workingnode].childFolder


    if ($structure[$workingnode].size -lt 100000) {
            $sum+= $structure[$workingnode].size
    }

    foreach ($child in $childs) {
        write-verbose "pushing $child"
        $childpath = join-path $workingnode -ChildPath $child
        $stack.push($childpath)
        }
    
}

$sum
#>


#summ all nodes gt 10000
$sum = 0
$sums = $structure.keys | ForEach-Object {
    if ($structure[$_].size -le 100000 -and $structure[$_].size -gt 0) {
        Write-verbose "$_ size [$($structure[$_].size)]"
        [pscustomobject]@{
            Name = $_
            Size = $($structure[$_].size)
        }
    $sum+=$structure[$_].size
    }
}
$sum


$sums|sort name

#checks totalsize
<#
$sum = 0
$sums = $structure.keys | ForEach-Object {
    if ($structure[$_].totalsize -lt 100000 -and $structure[$_].totalsize -gt 0) {
        Write-verbose "$_ size [$($structure[$_].totalsize)]"
        [pscustomobject]@{
            Name = $_
            Size = $($structure[$_].totalsize)
        }
    $sum+=$structure[$_].totalsize
    }
}
$sum
#1397223
$structure['\']

#>
