function! CreateEditCommands()
  let elements = 
        \[ 'Component',
        \  'Template',
        \  'Directive',
        \  'Service',
        \  'Pipe',
        \  'Ng' ]
  for element in elements
    silent execute 'command! -nargs=1 -complete=customlist,'. element . 'Files E' . element . ' call EditFile(<f-args>)'
  endfor
endfunction

function! CreateGenerateCommands()
  let elements = 
        \[ 'Component',
        \  'Template',
        \  'Directive',
        \  'Service',
        \  'Class',
        \  'Interface',
        \  'Enum' ]
  for element in elements
    silent execute 'command! -nargs=1 -bang G' . element . ' call Generate("'.tolower(element).'", <q-args>)'
  endfor
endfunction

function! ComponentFiles(A,L,P)
  return Files('component.ts', a:A)
endfunction

function! DirectiveFiles(A,L,P)
  return Files('component.ts', a:A)
endfunction

function! DirectiveFiles(A,L,P)
  return Files('directive.ts', a:A)
endfunction

function! TemplateFiles(A,L,P)
  return Files('html')
endfunction

function! ServiceFiles(A,L,P)
  return Files('service.ts', a:A)
endfunction

function! PipeFiles(A,L,P)
  return Files('pipe.ts', a:A)
endfunction

function! NgFiles(A,L,P)
  return Files('.ts', a:A)
endfunction

function! Generate(type, name)
  execute '!ng g ' . a:type . ' ' . a:name
endfunction

function! Files(extension,A)
  let path = '.'
  if isdirectory("src")
    let path .= '/src/'
  endif
  let files = split(globpath(path, '**/*'. a:A .'*.' . a:extension), "\n")
  let idx = range(0, len(files)-1)
  let g:global_files = {}
  for i in idx
    let g:global_files[fnamemodify(files[i], ':t:r')] = files[i]
  endfor
  call map(files, 'fnamemodify(v:val, ":t:r")')
  return files
endfunction

function! EditFile(file)
  execute 'edit' g:global_files[a:file]
endfunction

call CreateEditCommands()
call CreateGenerateCommands()
