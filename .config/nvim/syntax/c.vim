syn match cOperator "[!~*&%<>^|=+-]"
syn match cOperator "&&\|||\|<<\|>>\|++\|--\|->"
syn match cOperator "\(<<\|>>\|[-+*/%&^|<>!=]\)="
syn match cOperator "/[^/*=]"me=e-1

syn match cUserFunction "\<\h\w*\>\(\s\|\n\)*("me=e-1 contains=cParen,cCppParen
hi def link cUserFunction Function

hi def link cInclude Statement
hi def link cTypedef Statement
hi def link cStorageClass Statement

hi def link cPreCondit Conditional
