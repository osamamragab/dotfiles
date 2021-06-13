syn match goOperator '[-+%<>!&|^*=]=\?'
syn match goOperator '\/\%(=\|\ze[^/*]\)'
syn match goOperator '\%(<<\|>>\|&^\)=\?'
syn match goOperator ':=\|||\|<-\|++\|--'
syn match goOperator '\.\.\.'

hi def link goOperator Operator
hi def link goBuiltins Function
