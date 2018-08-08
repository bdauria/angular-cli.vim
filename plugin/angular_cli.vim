if !exists('g:angular_cli_use_dispatch')
  let g:angular_cli_use_dispatch = 0
endif

if !exists('g:angular_cli_stylesheet_format')
  let g:angular_cli_stylesheet_format = 'css'
endif

if !exists('g:gnu_grep')
  let g:gnu_grep = 'grep'
endif

" Moved to angular_cli#init() to be called manually by users.
" call CreateEditCommands()
" call CreateGenerateCommands()
" command! -nargs=* Ng call ExecuteNgCommand(<q-args>)
