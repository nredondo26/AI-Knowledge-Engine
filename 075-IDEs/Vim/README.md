# Vim — Editor Modal de Terminal

## Visión General

Vim (Vi Improved) es un editor de texto modal altamente configurable. Su filosofía se centra en la eficiencia mediante modos de operación (normal, inserción, visual, comando) que permiten editar texto sin apartar las manos del teclado.

## Modos de Vim

```
┌─────────┐   i,a,o   ┌──────────┐
│ Normal  │ ────────▶ │ Inserción │
│ (navegar│ ◀──────── │ (escribir)│
│ y editar│   Esc     └──────────┘
│ comandos│
└────┬────┘              │
     │ v,V,Ctrl+v        │
     ▼                   ▼
┌─────────┐         ┌──────────┐
│ Visual  │         │ Comando  │
│(selecci-│         │(ex: :wq, │
│  onar)  │         │ :s, :!)  │
└─────────┘         └──────────┘
```

## Navegación Esencial (Modo Normal)

### Movimiento Básico
```bash
h j k l          ← ↓ ↑ →     # Movimiento carácter
w b              Palabra siguiente/anterior
W B              PALABRA (separada por espacios)
e E              Final de palabra
0 ^ $            Inicio, primer carácter, final de línea
gg G              Primera/última línea del archivo
:n                Ir a línea n
Ctrl+d Ctrl+u    Media página abajo/arriba
Ctrl+f Ctrl+b    Página completa abajo/arriba
{ }              Párrafo anterior/siguiente
%                Paréntesis/llave correspondiente
```

### Búsqueda
```bash
/patrón          Buscar hacia adelante
?patrón          Buscar hacia atrás
n N              Siguiente/anterior coincidencia
* #              Buscar palabra bajo cursor (adelante/atrás)
```

## Edición (Modo Normal)

```bash
# Modos de inserción
i                Insertar antes del cursor
a                Insertar después del cursor
I                Insertar al inicio de línea
A                Insertar al final de línea
o                Abrir línea debajo
O                Abrir línea arriba

# Eliminar (delete)
x                Eliminar carácter bajo cursor
dd               Eliminar línea completa
dw               Eliminar palabra
d$ / D           Eliminar hasta final de línea
d0               Eliminar hasta inicio de línea
dG               Eliminar hasta final del archivo
dgg              Eliminar hasta inicio del archivo

# Copiar (yank) y pegar
yy               Copiar (yank) línea
yw               Copiar palabra
y$               Copiar hasta final de línea
p P              Pegar después/antes del cursor

# Deshacer/rehacer
u                Undo
Ctrl+r           Redo
```

## Comandos (Modo Comando)

```bash
:w               Guardar archivo
:wq / :x / ZZ    Guardar y salir
:q!              Salir sin guardar
:w nuevonombre   Guardar como
:e archivo       Abrir archivo
:ls              Lista de buffers
:b N             Ir al buffer N
:bnext / :bprev  Siguiente/anterior buffer
:bd              Borrar buffer
:!comando        Ejecutar comando shell
:r !comando      Insertar salida de comando
:help tema       Abrir ayuda
```

## Búsqueda y Reemplazo

```bash
# Sintaxis: :[rango]s/patrón/reemplazo/[flags]

:s/foo/bar/               # Reemplazar primera ocurrencia en línea actual
:s/foo/bar/g              # Reemplazar todas en línea actual
:%s/foo/bar/g             # Reemplazar en todo el archivo
:%s/foo/bar/gc            # Reemplazar con confirmación
:10,20s/foo/bar/g         # Reemplazar entre líneas 10 y 20

# Usar grupos de captura
:%s/\(foo\)bar/\1baz/g    # Capturar "foo" -> "foobaz"

# Nueva sintaxis (Vim 8+)
:%s/\v(foo)bar/\1baz/g    # \v = very magic (regex simplificado)
```

## Visual Mode (Selección)

```bash
v                Modo visual (carácter)
V                Modo visual (línea)
Ctrl+v           Modo visual (bloque)

# Acciones en selección
d                Eliminar selección
y                Copiar selección
> <              Indentar a derecha/izquierda
~ u U            Cambiar mayúsculas/minúsculas
:!comando        Filtrar selección por comando externo

# Ejemplo: añadir prefijo a varias líneas
Ctrl+v           # Seleccionar bloque vertical
Shift+i          # Insertar al inicio
# escribir el texto
Esc              # Aplicar a todas las líneas
```

## Configuración (.vimrc)

```vim
" .vimrc — Configuración básica
syntax on
set nocompatible
filetype plugin indent on

" Interfaz
set number                     " Mostrar números de línea
set relativenumber             " Números relativos
set ruler                      " Posición del cursor
set showcmd                    " Mostrar comandos incompletos
set showmode                   " Mostrar modo actual
set laststatus=2               " Barra de estado siempre visible
set wildmenu                   " Menú de autocompletado en línea de comandos

" Edición
set tabstop=4                  " Ancho del tabulador
set shiftwidth=4               " Indentación con >>
set softtabstop=4              " Tabulador suave
set expandtab                  " Espacios en lugar de tabs
set autoindent                 " Auto-indentación
set smartindent                " Indentación inteligente
set wrap                       " Ajuste de línea
set linebreak                  " No partir palabras al wrap
set textwidth=100              " Ancho máximo de línea
set backspace=indent,eol,start " Backspace completo

" Búsqueda
set hlsearch                   " Resaltar coincidencias
set incsearch                  " Búsqueda incremental
set ignorecase                 " Ignorar mayúsculas
set smartcase                  " Sensible si hay mayúsculas

" Navegación
set mouse=a                    " Habilitar mouse
set scrolloff=5                " Líneas de contexto al hacer scroll
set splitright                 " Split vertical a la derecha
set splitbelow                 " Split horizontal abajo

" Complementos
set completeopt=menuone,noselect,noinsert

" Atajos personalizados
let mapleader = " "
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>e :e.
nnoremap <leader>f :Files<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>/ :nohlsearch<CR>

" Abrir terminal integrado
command T term ++close
nnoremap <leader>t :T<CR>
```

## Plugins (Vim 8+ nativo / vim-plug)

```vim
" Instalar vim-plug (una vez):
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
"   https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

call plug#begin('~/.vim/plugged')

" Navegación
Plug 'preservim/nerdtree'              " Explorador de archivos
Plug 'ctrlpvim/ctrlp.vim'              " Búsqueda difusa de archivos
Plug 'easymotion/vim-easymotion'       " Navegación rápida

" Edición
Plug 'tpope/vim-surround'              " Cambiar rodeos ("" '' () etc)
Plug 'tpope/vim-commentary'            " Comentar/descomentar (gc)
Plug 'jiangmiao/auto-pairs'            " Auto-cerrar paréntesis
Plug 'alvan/vim-closetag'              " Auto-cerrar HTML/XML
Plug 'matze/vim-move'                  " Mover líneas (Alt+hjkl)

" Git
Plug 'tpope/vim-fugitive'              " Git integrado (:Gstatus, :Gdiff)
Plug 'airblade/vim-gitgutter'          " Marcas de diff en gutter

" Lenguajes
Plug 'preservim/tagbar'                " Vista de símbolos (ctags)
Plug 'sheerun/vim-polyglot'            " Resaltado de sintaxis multi-lenguaje
Plug 'neoclide/coc.nvim', {'branch': 'release'}  " LSP + autocompletado

" Temas
Plug 'morhetz/gruvbox'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'vim-airline/vim-airline'         " Barra de estado mejorada

call plug#end()

" Tema
colorscheme gruvbox
set background=dark
```

## Edición con LSP (coc.nvim)

```vim
" Después de instalar coc.nvim:
" :CocInstall coc-json coc-tsserver coc-python coc-go coc-rust-analyzer

" Configuración de coc.nvim
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nmap <leader>rn <Plug>(coc-rename)
nmap <leader>ca  <Plug>(coc-codeaction)
nmap <leader>cf  <Plug>(coc-fix-current)

" Siguiente / anterior error
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Sugerencias
inoremap <silent><expr> <C-space> coc#refresh()
```

## Modos de Línea de Comando (Ex Mode)

```bash
# Rango y comandos útiles
:g/patrón/comando             # Ejecutar comando en líneas que coinciden
:g/patrón/d                   # Eliminar todas las líneas que coinciden
:v/patrón/d                   # Eliminar líneas que NO coinciden
:g/^$/d                       # Eliminar todas las líneas vacías
:g/\s\+$/s//                  # Eliminar espacios al final de línea (%s)

:!sort                        # Ordenar todo el archivo
:%!sort -u                    # Ordenar y eliminar duplicados
:%!python -m json.tool        # Formatear JSON

:r!date                       # Insertar fecha actual
:r!curl -s https://api.example.com/data  # Insertar respuesta HTTP
```

## Macros

```bash
qa               # Empezar a grabar macro en registro a
(...acciones...) # Realizar acciones
q                # Detener grabación
@a               # Reproducir macro a
@@               # Repetir última macro
10@a             # Reproducir 10 veces

# Ejemplo: añadir ; al final de 10 líneas
qa               # Grabar
A;               # Ir a final de línea e insertar ;
Esc              # Volver a modo normal
j                # Bajar una línea
q                # Detener
10@a             # Aplicar a 10 líneas más
```

## Referencias

- `:help` — La mejor referencia (integrada en Vim)
- [Vim Tips Wiki](https://vim.fandom.com/)
- [Open Vim (tutorial interactivo)](https://openvim.com/)
- [Vim Adventures (juego)](https://vim-adventures.com/)
- [Learn Vim Progressively](https://yannesposito.com/Scratch/en/blog/Learn-Vim-Progressively/)
- [Vim Awesome (plugins)](https://vimawesome.com/)
