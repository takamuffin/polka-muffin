import polkadot


AUTOLOAD_DIR = '.vim/autoload'
BUNDLE_DIR = '.vim/bundle'
VIM_TMP_DIR = '.vim/tmp'

DOTFILES = [
    polkadot.mkdir('git'),
    polkadot.gitclone('git/oh-my-zsh', 'https://github.com/robbyrussell/oh-my-zsh.git'),
    polkadot.gitclone(
        'git/oh-my-zsh/custom/plugins/zsh-dircolors-solarized',
        'https://github.com/joel-porquet/zsh-dircolors-solarized',
        git_kwargs = {
            'recursive': True,
        }
    ),
    polkadot.mkdir(AUTOLOAD_DIR),
    polkadot.mkdir(BUNDLE_DIR),
    polkadot.download(
        '%s/pathogen.vim' % AUTOLOAD_DIR,
        'https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim'
    ),
    polkadot.mkdir(VIM_TMP_DIR),
    polkadot.copy('*', 'dotfiles/*'),
]

plugins = [
    ('snipmate-snippets', 'https://github.com/honza/vim-snippets.git'),
    ('syntastic', 'https://github.com/scrooloose/syntastic.git'),
    ('tcomment_vim', 'https://github.com/tomtom/tcomment_vim.git'),
    ('tlib_vim', 'https://github.com/tomtom/tlib_vim.git'),
    ('vim-addon-mw-utils', 'https://github.com/MarcWeber/vim-addon-mw-utils.git'),
    ('vim-airline', 'https://github.com/bling/vim-airline'),
    ('vim-colors-solarized', 'https://github.com/altercation/vim-colors-solarized.git'),
    ('vim-fireplace', 'https://github.com/tpope/vim-fireplace.git'),
    ('vim-gitgutter', 'https://github.com/airblade/vim-gitgutter.git'),
    ('vim-javascript', 'https://github.com/pangloss/vim-javascript.git'),
    ('vim-json', 'https://github.com/elzr/vim-json.git'),
    ('vim-jsx', 'https://github.com/mxw/vim-jsx.git'),
    ('vim-less', 'https://github.com/groenewege/vim-less'),
    ('vim-snipmate', 'https://github.com/garbas/vim-snipmate.git'),
]

for name, repository in plugins:
    DOTFILES.append(polkadot.gitclone('%s/%s' % (BUNDLE_DIR, name), repository))
