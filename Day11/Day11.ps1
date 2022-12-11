using namespace System.Collections.Generic

$data = get-content .\Day11\Input11.txt
#$data = get-content .\Day11\Test11.txt
class Monkey {
    #[stack[int]]$items
    [queue[double]]$items
    
    [int64]$inspected
    #[int]$operation
    [int64]$mod = 1
    [string]$op #operation worrylevel increase
    [int64]$operationresult
    [int64]$div
    [string]$throwtrue
    [string]$throwfalse
    
    Monkey () {}

    Operation () {

        #$pop = $this.items.pop()
        [int64]$pop = $this.items.Dequeue()
        $this.operationresult = iex $this.op
        $this.inspected++

    }

    [object[]] test () {
        

        $pop = $this.operationresult
        [int64]$testvalue = [math]::Floor(($pop / 3))
        
        if ($testvalue%$this.div -eq 0) {
            return @($this.throwtrue,$testvalue)
        }
        return @($this.throwfalse,$testvalue)
    }

    [object[]] testnoworries () {
    
        $opModulus = $this.operationresult % $this.mod
            if ($opModulus%$this.div -eq 0) {
            return @($this.throwtrue,$opModulus)
        }
        return @($this.throwfalse,$opModulus)
    }
    
}

$monkeys = @{}
$mod = 1
#calculate lcm for all divisible in the test, since GCD =1 is x*y/1 and /1 can be removed.
#its $sum *= $testvalue, 23*19*17*13
for ($i = 0; $i -lt $data.Count; $i+=6) {
    
    $monkey = $data[$i..($i+5)].trim()

    $m = 0
 
    $nr = $monkey[$m] -replace '.+?(\d+):', '$1'
    $monkeys.add($nr,[Monkey]::new())
    
    $monkeys[$nr].items = ($monkey[($m+1)] -replace '.+: ' -split ',').trim()

    $tempop = $monkey[($m+2)] -replace '.+: new = old ' -split '\s' | % {
        switch ($_) {
            '+' {[string]$_}
            '*' {[string]$_}
            'old' {'$pop'}
            default {[int]$_}
        }
    }
    $opblock = '$pop {0}' -f $($tempop -join ' ')
    $monkeys[$nr].op = $opblock
    # [scriptblock]::Create($opblock)
    $monkeys[$nr].div =  $monkey[($m+3)] -replace '.+?(\d+)','$1'
    $mod *= $monkeys[$nr].div
    $monkeys[$nr].throwtrue = $monkey[($m+4)] -replace '.+?(\d+)','$1'
    $monkeys[$nr].throwfalse = $monkey[($n+5)] -replace '.+?(\d+)','$1'

    $i++

}
$monkeys.keys|sort|% {$monkeys[$_].mod = $mod}

$part = '2'

if ($part -eq '1'){
#part 1
for ($r = 0; $r -lt 20; $r++) {

    foreach ($key in $monkeys.keys|sort) {

        while ($monkeys[$key].items.count -ne 0) {

            $monkeys[$key].Operation()
            $toMonkey,$item = $monkeys[$key].test()
            #write-verbose "$key enqueue $item to Monkey $toMonkey"
            $monkeys[$toMonkey].items.Enqueue($item)
        }
    }
    
}
}
else {
#part2
for ($r = 0; $r -lt 10000; $r++) {

    foreach ($key in $monkeys.keys|sort) {

        while ($monkeys[$key].items.count -ne 0) {

            $monkeys[$key].Operation()
            $toMonkey,$item = $monkeys[$key].testnoworries()
            #write-verbose "$key enqueue $item to Monkey $toMonkey"
            $monkeys[$toMonkey].items.Enqueue($item)
        }
    }
}
}

$m1,$m2 = $monkeys.keys | % {$monkeys[$_].inspected} | sort -Descending | select -first 2

[pscustomobject]@{
    Result = $m1*$m2
}

<#
calculate gcd / LCM for test file
23%19 #4
19%4 #3
4%3 # 1 <- gcd
3%1 # 0

19%13 # 6
13%6 # 1 <- gcd
6%1 # 1

##LCM
(23*19)/1 #437
437*13/1 # 5681
5681*17 # 96577
#>