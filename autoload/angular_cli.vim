" Added by lgalke 28/02/17 

function! angular_cli#init() abort
  call angular_cli#CreateDefaultStyleExt()
  call angular_cli#CreateEditCommands()
  call angular_cli#CreateGenerateCommands()
  command! -nargs=* Ng call angular_cli#ExecuteNgCommand(<q-args>)
endfunction

" The remaining functions are just prefixed by angular_cli# and suffixed by
" abort. Hope I did not miss any call statement.

function! angular_cli#ExecuteNgCommand(args) abort
  if g:angular_cli_use_dispatch == 1
    let prefix = 'Dispatch '
  else 
    let prefix = '!'
  endif
  execute prefix . 'ng ' . a:args
endfunction

function! angular_cli#CreateEditCommands() abort
  let modes = 
        \[ ['E', 'edit'],
        \  ['S', 'split'],
        \  ['V', 'vsplit'],
        \  ['T', 'tabnew'] ]
  for mode in modes
    let elements_with_relation = 
          \[ ['Component', 'component.ts'],
          \  ['Module', 'module.ts'],
          \  ['Template', 'component.html'],
          \  ['Spec', 'spec.ts'],
          \  ['Stylesheet', 'component.' . g:angular_cli_stylesheet_format] ]
    for element in elements_with_relation
      silent execute 'command! -nargs=? -complete=customlist,angular_cli#' . element[0] .'Files ' . mode[0] . element[0] . ' call angular_cli#EditRelatedFile(<q-args>, "'. mode[1] .'", "' .element[1]. '")'
    endfor
    let elements_without_relation = 
          \[ 'Directive',
          \  'Service',
          \  'Pipe',
          \  'Guard',
          \  'Ng' ]
    for elt in elements_without_relation
      silent execute 'command! -nargs=1 -complete=customlist,angular_cli#'. elt . 'Files ' mode[0] . elt . ' call angular_cli#EditFile(<f-args>, "' . mode[1] .'")'
    endfor
  endfor

  command! -nargs=? -complete=customlist,angular_cli#SpecFiles ESpec call angular_cli#EditSpecFile(<q-args>, 'edit')
  command! -nargs=? -complete=customlist,angular_cli#SpecFiles SSpec call angular_cli#EditSpecFile(<q-args>, 'split')
  command! -nargs=? -complete=customlist,angular_cli#SpecFiles VSpec call angular_cli#EditSpecFile(<q-args>, 'vsplit')
  command! -nargs=? -complete=customlist,angular_cli#SpecFiles TSpec call angular_cli#EditSpecFile(<q-args>, 'tabnew')
endfunction

function! angular_cli#CreateGenerateCommands() abort
  let elements = 
        \[ 'Component',
        \  'Template',
        \  'Module',
        \  'Directive',
        \  'Service',
        \  'Pipe',
        \  'Guard',
        \  'Class',
        \  'Interface',
        \  'Enum' ]
  for element in elements
    silent execute 'command! -nargs=1 -bang G' . element . ' call angular_cli#Generate("'.tolower(element).'", <q-args>)'
  endfor
endfunction

function! angular_cli#CreateDefaultStyleExt() abort
  let re = "\'" . '(?<=(?i)styleext.:..)\w+' . "\'"
  let target = empty(glob('angular.json')) ? ' .angular-cli.json' : ' angular.json'
  let g:angular_cli_stylesheet_format = system('grep -Po ' . re . target)[:-2]
endfunction

function! angular_cli#CreateDestroyCommand() abort
  silent execute command! -nargs=1 -complete=customlist,angular_cli#NgFiles call angular_cli#DestroyElement(<f-args>)
endfunction

function! angular_cli#ComponentFiles(A,L,P) abort
  return angular_cli#Files('component.ts', a:A)
endfunction

function! angular_cli#ModuleFiles(A,L,P) abort
  return angular_cli#Files('module.ts', a:A)
endfunction

function! angular_cli#DirectiveFiles(A,L,P) abort
  return angular_cli#Files('directive.ts', a:A)
endfunction

function! angular_cli#TemplateFiles(A,L,P) abort
  return angular_cli#Files('html', a:A)
endfunction

function! angular_cli#ServiceFiles(A,L,P) abort
  return angular_cli#Files('service.ts', a:A)
endfunction

function! angular_cli#PipeFiles(A,L,P) abort
  return angular_cli#Files('pipe.ts', a:A)
endfunction

function! angular_cli#GuardFiles(A,L,P) abort
  return angular_cli#Files('guard.ts', a:A)
endfunction

function! angular_cli#SpecFiles(A,L,P) abort
  return angular_cli#Files('spec.ts', a:A)
endfunction

function! angular_cli#NgFiles(A,L,P) abort
  return angular_cli#Files('ts', a:A)
endfunction

function! angular_cli#StylesheetFiles(A,L,P) abort
  return angular_cli#Files(g:angular_cli_stylesheet_format, a:A)
endfunction

function! angular_cli#DestroyElement(file) abort
  call angular_cli#ExecuteNgCommand('d ' . g:global_files[a:file])
endfunction

function! angular_cli#Generate(type, name) abort
  call angular_cli#ExecuteNgCommand('g ' . a:type . ' ' . a:name)
endfunction

function! angular_cli#Files(extension,A) abort
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

function! angular_cli#EditFile(file, command) abort
  let fileToEdit = has_key(g:global_files, a:file)?  g:global_files[a:file] : a:file . '.ts'
  if !empty(glob(fileToEdit))
    execute a:command fileToEdit
  else
    echoerr fileToEdit . ' was not found'
  endif
endfunction

function! angular_cli#EditFileIfExist(file, command, extension) abort
  let fileToEdit = exists('g:global_files') && has_key(g:global_files, a:file)?  g:global_files[a:file] : a:file
  if !empty(glob(fileToEdit))
    execute a:command fileToEdit
  else
    echoerr fileToEdit . ' was not found'
  endif
endfunction

function! angular_cli#EditSpecFile(file, command) abort
  let file = a:file
  if file == ''
    let base_file = substitute(expand('%'), '.html', '', '')
    let base_file = substitute(base_file, '.ts', '', '')

    " just cover everything
    let base_file = substitute(base_file, '.css', '', '')
    let base_file = substitute(base_file, '.scss', '', '')
    let base_file = substitute(base_file, '.less', '', '')
    let file = base_file . '.spec.ts'
  endif 
  if expand('%') =~ 'component.spec.ts'
    return
  endif
  call angular_cli#EditFileIfExist(file, a:command, '.ts')
endfunction

function! angular_cli#EditRelatedFile(file, command, target_extension) abort
  let file = a:file
  if file == ''
    let source_extension = angular_cli#GetSourceNgExtension()
    let file = substitute(expand('%'), source_extension,  '.' . a:target_extension, '')
    call angular_cli#EditFileIfExist(file, a:command, a:target_extension)
  else 
    call angular_cli#EditFileIfExist(a:file, a:command, a:target_extension)
  endif
endfunction

function! angular_cli#GetSourceNgExtension() abort
  let extensions = 
        \[ 'component.ts',
        \  'module.ts',
        \  'component.html',
        \  'component.' . g:angular_cli_stylesheet_format,
        \  'component.spec.ts']
  for extension in extensions
    if expand('%e') =~ extension
      return '.' . extension
    endif
  endfor
  return '\.' . expand('%:e')
endfunction
