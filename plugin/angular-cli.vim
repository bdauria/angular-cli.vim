call CreateEditCommand('EComponent', 'ComponentFiles')
call CreateEditCommand('ETemplate', 'TemplateFiles')
call CreateEditCommand('EDirective', 'DirectiveFiles')
call CreateEditCommand('EService', 'ServiceFiles')
call CreateEditCommand('EPipe', 'PipeFiles')
call CreateEditCommand('ENg', 'NgFiles')
call CreateGenerateCommand('GComponent', 'component')
call CreateGenerateCommand('GDirective', 'directive')
call CreateGenerateCommand('GService', 'service')
call CreateGenerateCommand('GPipe', 'pipe')
call CreateGenerateCommand('GClass', 'class')
call CreateGenerateCommand('GInterface', 'interface')
call CreateGenerateCommand('GEnum', 'enum')

function! CreateEditCommand(command, listFunction)
  silent execute 'command! -nargs=1 -complete=customlist,'. a:listFunction . ' ' . a:command . ' call EditFile(<f-args>)'
endfunction

function! CreateGenerateCommand(command, type)
  silent execute 'command! -nargs=1 -bang ' . a:command . ' ' . 'call Generate("'.a:type.'", <args>)'
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
