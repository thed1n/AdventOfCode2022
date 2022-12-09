using namespace System.Collections.Generic
$data = Get-Content .\Day9\Input9.txt
#$data = Get-Content .\Day9\test9.txt
#$data = Get-Content .\Day9\test9_2.txt
class knot {
    [int]$v = 0
    [int]$h = 0
}
class Rope {
    #head
    [int]$v = 0
    [int]$h = 0
    #tail
    [int]$tv = 0
    [int]$th = 0

    [int]$knotenumerator
    [hashtable]$knots =@{}

    [HashSet[string]]$visited = @{}#'99,0'
    [hashset[string]]$visitedp2 = @{}
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
    Rope ($numKnots) {
        for ($i=0;$i-le$numknots;$i++) {
        $this.knots.add($i,[knot]::new())
        }
        $this.knotenumerator = $numknots
        $this.visitedp2.add("0,0")
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
    MoveHeadp2 ( $dir, $numbers) {

        for ($i = 1; $i -le $numbers; $i++) {
            Write-Verbose "$i $dir"
            Write-Verbose "x : $($this.knots[0].v) y: $($this.knots[0].h)"

            switch ($dir) {
                'U' {
                    $this.knots[0].v++
                    $this.checktailp2($dir)
                    break
                }
                'D' {
                    $this.knots[0].v--
                    $this.checktailp2($dir)
                    break
                }
                'L' {
                    $this.knots[0].h--
                    $this.checktailp2($dir)
                    break
                }
                'R' {
                    $this.knots[0].h++
                    $this.checktailp2($dir)
                    break
                }
            }

        }

    }    
    CheckTailp2 ($dir) {
        #Write-Verbose "tailp2"
        for ($i=0;$i -lt $this.knotenumerator;$i++) {

            if (([math]::abs($this.knots[$i].v - $this.knots[$i+1].v) -ge 2) -or ([math]::abs($this.knots[$i].h - $this.knots[$i+1].h) -ge 2 )) {

            $movement =($this.knots[$i+1].v - $this.knots[$i].v),($this.knots[$i+1].h - $this.knots[$i].h)
            
            #Damn you chris if your read this and see that i in the end stole this cause my logic died inside my head
            
            if ($movement[0] -in 2, -2 -or $movement[1] -in 2, -2) {
                if ($movement[0] -ne 0) {
                    $this.knots[$i+1].v += $movement[0] / [Math]::Abs($movement[0]) * -1
                }
                if ($movement[1] -ne 0) {
                    $this.knots[$i+1].h += $movement[1] / [Math]::Abs($movement[1]) * -1
                }
            }
        }
        $this.visitedp2.add("$($this.knots[$this.knotenumerator].v),$($this.knots[$this.knotenumerator].h)")
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

    MaxMin () {
        $this.visited | foreach-object {
            [int]$a,[int]$b = $_.split(',')
            $this.vset.add($a)
            $this.hset.add($b)
        }
    }
    MaxMinp2 () {
        $this.visitedp2 | foreach-object {
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
    Drawp2 () {
        $this.maxminp2()
        #write-verbose "draw"
        for ($i = $this.vset.max; $i -ge $this.vset.min; $i--) {

            for ($j = $this.hset.min ;$j -le $this.hset.max; $j++) {
                if ($this.visitedp2.contains("$i,$j")) {
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
$rope2 = [rope]::new(9)

foreach ($d in $data) {
    $dir, [int]$path = $d.split()
    $rope.MoveHead($dir, $path)
}

#p2

foreach ($d in $data) {
    $dir, [int]$path = $d.split()
    $rope2.MoveHeadp2($dir, $path)
}


[pscustomobject]@{
    Part1 = $rope.visited.count
    Part2 = $rope2.visitedp2.count
}