using namespace System.Collections.Generic
$data = Get-Content .\Day9\Input9.txt
$data = Get-Content .\Day9\test9.txt

class Rope {
    [int]$v = 0
    [int]$h = 0
    [int]$tv = 0
    [int]$th = 0
    [int]$limit = -1000
    [int]$limitV
    [int]$limitH
    [HashSet[string]]$visited = @{}#'99,0'
    [sortedset[int]]$vset=@{}
    [sortedset[int]]$hset=@{}

    Rope ([int]$gv, [int]$gh) {
        $this.visited.add("0,0")
        $this.limitV = $gv
        $this.limitH = $gh

    }
    Rope () {
        $this.visited.add("0,0")
    }

    MoveHead ( $dir, $numbers) {

        for ($i = 1; $i -le $numbers; $i++) {
            #Write-Verbose "$i $dir"
            #Write-Verbose "x : $($this.v) y: $($this.h)"
            switch ($dir) {
                'U' {
                    $this.v++
                    $this.checktail($dir)
                    break
                }
                'D' {
                    $this.v--
                    $this.checktail($dir)
                    break
                }
                'L' {
                    $this.h--
                    $this.checktail($dir)
                    break
                }
                'R' {
                    $this.h++
                    $this.checktail($dir)
                    break
                }
            }

        }

    }

    CheckTail ($dir) {

        if (([math]::abs($this.v - $this.tv) -ge 2) -or ([math]::abs($this.h - $this.th) -ge 2 )) {
            #Write-Verbose "tail is drifting"

            switch ($dir) {
                'U' { 
                    $this.tv = $this.v - 1 
                    $this.th = $this.h
                }
                'D' {
                    $this.tv = $this.v + 1 
                    $this.th = $this.h
                }
                'L' { 
                    $this.th = $this.h + 1 
                    $this.tv = $this.v
                }
                'R' { 
                    $this.th = $this.h - 1 
                    $this.tv = $this.v
                }
            }
            $this.visited.add("$($this.tv),$($this.th)")

        }

        elseif (([math]::abs($this.v - $this.tv) -le 1) -and ([math]::abs($this.h - $this.th) -le 1 )) {
            # Write-Verbose 'Tail is within 1'
            # Write-Verbose "Head v: [$($this.v)] tail v: [$($this.tv)]"
            # Write-Verbose "Head h: [$($this.h)] tail h: [$($this.th)]"
        }

        else {
            switch ($dir) {
                'U' { $this.tv++ }
                'D' { $this.tv-- }
                'L' { $this.th-- }
                'R' { $this.th++ }
            }
            $this.visited.add("$($this.tv),$($this.th)")
        }

    }
    Overlap ($dir) {
        #Write-Verbose 'overlap'
        #set tail to overlap head
        switch ($dir) {
            'U' { $this.tv = $this.v }
            'D' { $this.tv = $this.v }
            'L' { $this.th = $this.h }
            'R' { $this.th = $this.h }
        }
        $this.visited.add("$($this.tv),$($this.th)")
    }
    MaxMin () {
        $this.visited | foreach-object {
            [int]$a,[int]$b = $_.split(',')
            $this.vset.add($a)
            $this.hset.add($b)
        }
    }
    Draw () {
        $this.maxmin()
        #write-verbose "draw"
        for ($i = $this.vset.max; $i -ge $this.vset.min; $i--) {

            for ($j = $this.hset.min ;$j -le $this.hset.max; $j++) {
                if ($this.visited.contains("$i,$j")) {
                    Write-Host "#" -ForegroundColor Green -NoNewline
                }
                else {
                    Write-Host "." -ForegroundColor Gray -NoNewline
                }
            }
            Write-Host ''
        }
    }
}


$rope = [rope]::new()

foreach ($d in $data) {
    $dir, [int]$path = $d.split()
    $rope.MoveHead($dir, $path)
}

$rope.Draw()

[pscustomobject]@{
    Part1 = $rope.visited.count
}
#test result
<#
..##..
...##.
.####.
....#.
s###..
#>