if !exists('g:angular_cli_use_dispatch')
  let g:angular_cli_use_dispatch = 0
endif

if !exists('g:angular_cli_stylesheet_format')
  let g:angular_cli_stylesheet_format = 'css'
endif

function! ExecuteNgCommand(args)
  if g:angular_cli_use_dispatch == 1
    let prefix = 'Dispatch '
  else 
    let prefix = '!'
  endif
  execute prefix . 'ng ' . a:args
endfunction

function! CreateEditCommands()
  let modes = 
        \[ ['E', 'edit'],
        \  ['V', 'vsplit'] ]
  for mode in modes
    let elements_with_relation = 
          \[ ['Component', 'component.ts'],
          \  ['Module', 'module.ts'],
          \  ['Template', 'component.html'],
          \  ['Spec', 'spec.ts'],
          \  ['Stylesheet', 'component.' . g:angular_cli_stylesheet_format] ]
    for element in elements_with_relation
      silent execute 'command! -nargs=? -complete=customlist,' . element[0] .'Files ' . mode[0] . element[0] . ' call EditRelatedFile(<q-args>, "'. mode[1] .'", "' .element[1]. '")'
    endfor
    let elements_without_relation = 
        \[ 'Directive',
        \  'Service',
        \  'Pipe',
        \  'Ng' ]
    for element in elements_without_relation
      silent execute 'command! -nargs=1 -complete=customlist,'. element . 'Files ' mode[0] . element . ' call EditFile(<f-args>, "' . mode[1] .'")'
    endfor
  endfor

  command! -nargs=? -complete=customlist,SpecFiles ESpec call EditSpecFile(<q-args>, 'edit')
  command! -nargs=? -complete=customlist,SpecFiles VSpec call EditSpecFile(<q-args>, 'vsplit')
endfunction

function! CreateGenerateCommands()
  let elements = 
        \[ 'Component',
        \  'Template',
        \  'Module',
        \  'Directive',
        \  'Service',
        \  'Class',
        \  'Interface',
        \  'Enum' ]
  for element in elements
    silent execute 'command! -nargs=1 -bang G' . element . ' call Generate("'.tolower(element).'", <q-args>)'
  endfor
endfunction

function! CreateDestroyCommand()
  silent execute command! -nargs=1 -complete=customlist,NgFiles call DestroyElement(<f-args>)
endfunction

function! ComponentFiles(A,L,P)
  return Files('component.ts', a:A)
endfunction

function! ModuleFiles(A,L,P)
  return Files('module.ts', a:A)
endfunction

function! DirectiveFiles(A,L,P)
  return Files('directive.ts', a:A)
endfunction

function! TemplateFiles(A,L,P)
  return Files('html', a:A)
endfunction

function! ServiceFiles(A,L,P)
  return Files('service.ts', a:A)
endfunction

function! PipeFiles(A,L,P)
  return Files('pipe.ts', a:A)
endfunction

function! SpecFiles(A,L,P)
  return Files('spec.ts', a:A)
endfunction

function! NgFiles(A,L,P)
  return Files('ts', a:A)
endfunction

function! StylesheetFiles(A,L,P)
  return Files(g:angular_cli_stylesheet_format, a:A)
endfunction

function! DestroyElement(file)
  call ExecuteNgCommand('d ' . g:global_files[a:file])
endfunction

function! Generate(type, name)
  call ExecuteNgCommand('g ' . a:type . ' ' . a:name)
endfunction

function! Files(extension,A)
  let path = '.'
  if isdirectory("src")
    let path .= '/src/'
  endif
  if isdirectory("app")
    let path .= '/app/'
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

function! EditFile(file, command)
  let fileToEdit = has_key(g:global_files, a:file)?  g:global_files[a:file] : a:file . '.ts'
  if !empty(glob(fileToEdit))
    execute a:command fileToEdit
  else
    echoerr fileToEdit . ' was not found'
  endif
endfunction

function! EditFileIfExist(file, command, extension)
  let fileToEdit = exists('g:global_files') && has_key(g:global_files, a:file)?  g:global_files[a:file] : a:file
  if !empty(glob(fileToEdit))
    execute a:command fileToEdit
  else
    echoerr fileToEdit . ' was not found'
  endif
endfunction

function! EditSpecFile(file, command)
  let file = a:file
  if file == ''
    let file = substitute(expand('%'), '.ts', '.spec', '')
  endif 
    call EditFile(file, a:command)
endfunction

function! EditRelatedFile(file, command, target_extension)
  let file = a:file
  if file == ''
    let source_extension = GetSourceNgExtension()
    let file = substitute(expand('%'), source_extension,  '.' . a:target_extension, '')
    call EditFileIfExist(file, a:command, a:target_extension)
  else 
    call EditFileIfExist(a:file, a:command, a:target_extension)
  endif
endfunction

function! GetSourceNgExtension()
  let extensions = 
        \[ 'component.ts',
        \  'module.ts',
        \  'component.html',
        \  'component.' . g:angular_cli_stylesheet_format,
        \  'component.spec']
  for extension in extensions
    if expand('%e') =~ extension
      return '.' . extension
    endif
  endfor
  return '\.' . expand('%:e')
endfunction

call CreateEditCommands()
call CreateGenerateCommands()
command! -nargs=* Ng call ExecuteNgCommand(<q-args>)
