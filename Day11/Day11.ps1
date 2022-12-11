using namespace System.Collections.Generic
$data = get-content .\Day11\Input11.txt
#$data = get-content .\Day11\Test11.txt
class Monkey {
    #[stack[int]]$items
    [queue[int]]$items
    
    [int]$inspected
    #[int]$operation
    [string]$op #operation worrylevel increase
    [int]$operationresult
    [int]$div
    [string]$throwtrue
    [string]$throwfalse
    
    Monkey () {}

    Operation () {

        #$pop = $this.items.pop()
        $pop = $this.items.Dequeue()
        $this.operationresult = iex $this.op
        $this.inspected++

    }

    [object[]] test () {
        

        $pop = $this.operationresult
        [int]$testvalue = [math]::Floor(($pop / 3))
        
        if ($testvalue%$this.div -eq 0) {
            return @($this.throwtrue,$testvalue)
        }
        return @($this.throwfalse,$testvalue)
        
    }
}

$monkeys = @{}

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

    $monkeys[$nr].throwtrue = $monkey[($m+4)] -replace '.+?(\d+)','$1'
    $monkeys[$nr].throwfalse = $monkey[($n+5)] -replace '.+?(\d+)','$1'

    $i++

}


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

$m1,$m2 = $monkeys.keys | % {$monkeys[$_].inspected} | sort -Descending | select -first 2

[pscustomobject]@{
    Part1 = $m1*$m2
}



$monkeys.keys|sort | % {$monkeys[$_].op}
# $monkeys['0'].Operation()
# $toMonkey,$item = $monkeys['0'].test()

# $monkeys['0'].items.count
