
let prompt = "Input:"
echon prompt
let expr = ""
let c = nr2char(getchar())
echo c == "\<BS>"

" while c != "\<Esc>" && c != "\<CR>"
  " if c == "<BS>"
    " echon "backpace"
    " if len(expr) != 0
      let expr = expr[0:-1]
      " echon "\<CR>".substitute(expr, ".", " ", "g")
      " echon "\<CR>".prompt.expr
    " endif
  " else
    " let expr .= c
    " echon "\n".prompt.expr
  " endif
  " let c = nr2char(getchar())
" endwhile
"
" if c == "\<Esc>"
  " silent echo "cancelled"
" elseif c == "\<CR>"
  " silent echo "entred"
" endif
