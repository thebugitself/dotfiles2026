if status is-interactive
    # Matikan greeting
    set fish_greeting

    # Alias standar yang aman
    alias ls='ls --color=auto'
    alias ll='ls -lah'
    alias grep='grep --color=auto'
    
    # Perbaikan Typo (lucu juga kalau tetap dipakai)
    alias pamcan='sudo pacman'
    
    # Tambahkan path untuk tools pentest jika ada (opsional)
    # set -gx PATH $PATH /path/ke/folder/tools/kamu
end


# Added by Antigravity CLI installer
set -gx PATH "/home/len/.local/bin" $PATH

fish_add_path /home/len/.spicetify
