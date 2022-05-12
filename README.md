# Dotfiles

Olá, **eu**! 😳

Esse é meu repositório pessoal de arquivos de configuração.

## Instalando

Para instalar estes arquivos de configuração, basta baixar o [GNU
stow](https://www.gnu.org/software/stow/) e executá-lo nos módulos que desejar
utilizar.

O passo a passo do processo fica:

1.  Instalação do `GNU stow`:

    ```bash 
    sudo apt install stow # Debian
    sudo dnf install stow # Fedora
    ```

2.  Clonando o repo:

    ```bash
    git clone "https://github.com/DanielCardeal/dotfiles" ~/.dotfiles
    ```

    Note que o diretório de destino deve ser apenas um nível acima da `$HOME`
    para que o stow funcione corretamente.

3.  Instalação de um módulo (por exemplo **nvim**):

    ```bash
    cd ~/.dotfiles
    stow nvim
    ```

    OBS: esse comando pode falhar se os arquivos presentes na sua máquina
    conflitarem com os arquivos de configuração que se deseja sincronizar.
    Nestes casos, o *stow* vai mostrar uma mensagem de erro que pode ser útil
    para encontrar o arquivo problemático.

## Dependências

Para que as configurações rodem tranquilamente, o seu sistema precisa ter:

- JetBrains Mono Nerd Font (download em
  [](https://www.nerdfonts.com/font-downloads))
