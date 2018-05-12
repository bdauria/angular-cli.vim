# angular-cli.vim
a Vim Plugin for angular-cli <br />

angular-cli.vim provides a support for [angular-cli](https://github.com/angular/angular-cli), directly inside Vim. It allows the interaction with the cli without having to leave the editor, and also benefit from some comfort features such as autocompletion, split file opening, spec file for the current file opening...
The plugin is based on the idea of Time Pope's [rails.vim](https://github.com/tpope/vim-rails)

## Activation

The command namespace is not cluttered unconditionally.
All commands are created on invocation of the function `angular_cli#init()`.
Thus, you can manually activate angular-cli by `call angular_cli#init()`
or automatically initialize the commands depending on your typical setting for angular projects:

### On a filetype basis

```vim
autocmd FileType typescript,html call angular_cli#init()`
```

Commands will be available in all typescript and html files.

### By indicator file

```vim
autocmd VimEnter * if globpath('.,..','node_modules/@angular') != '' | call angular_cli#init() | endif
```

Commands will be available if the current or the parent directory contains `@angular` inside `node_modules`.


## The Ng Command
The Ng command (:Ng) simply calls the ng shell command with whatever argument it folows. You can use it with all the options available, for instance:
```
Ng build
Ng test
```

## The E Command (Edit)
The E command allows to open up an Angular file. The list of compatible file types are the following:
- Component *
- Module *
- Template (HTML files) *
- Directive
- Service
- Pipe
- Guard
- Spec *
- Stylesheet *
- Ng (every other file type: Class, Interface, Enum...)

For example, to open up the app.component.ts:
` EComponent app.component` (without the .ts extension)
The command supports autocompletion for the corresponding file type. 

The elements marked with '*' are available without arguments. In this case, the plugin will try to open the directly related file.
for instance, if `ESpec` is called without arguments while editing the component app.component.ts, it will try to open the corresponding spec file, app.component.spec.ts.

Stylesheet format is set automatically to the corresponding styleExt value from `.angular-cli.json`.

## The S, V, T Commands (Split, VSplit, Tabnew)
Similar to the E command, except that the files are edited in a horizontal split (S), vertical split (V), new tab (T) respectively.

## The G Command (Generate)
The G command is used to call directly the `ng g` shell command. It is compatible with the following file types:
- Component
- Module
- Template
- Directive
- Service
- Pipe
- Guard
- Class
- Interface
- Enum

To generate a component, simply use: `GComponent my-component`

## Dispatch support
The plugin is compatible with Tim Pope's [vim-dispatch](https://github.com/tpope/vim-dispatch), by adding this to your .vimrc:

```let g:angular_cli_use_dispatch = 1```

Any PR or Feature suggestion is welcome. 

