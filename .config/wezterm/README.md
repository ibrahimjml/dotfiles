
### Windows Combo Wezterm + Cmder + Starship

![Wezterm screen split](https://i.postimg.cc/44bGY4hk/Screenshot-2026-09-22-155531.png)


### Requirements

- **[NerdFont](https://www.nerdfonts.com/)** ( beautify icons for terminal ). 
- **[Wezterm](https://wezterm.org/)** ( A powerful terminal written in Rust, multiplexer by default for splitting screen , replace tmux on windows ).
- **[Cmder](https://cmder.app/)** ( A powerfull commandline with Clink , with lua scripting support ).
- **[Starship](https://starship.rs/)** ( Customizable status shell , written in Rust ).


### 1. Installation with  choco

```
choco install wezterm starship -y
```

### 2. Setup Starship in Cmder

- **navigate** `cd %CMDER_ROOT%/vendor/clink` 
- create `starship.lua`
- paste this code :

```
--  Stop clinck message at top
clink.prompt.register_filter(function() return false end, 1)

-- run starship
local handle = io.popen("starship init cmd")
if handle then
    local script = handle:read("*a")
    handle:close()
    if script then
        load(script)()
    end
end
```

- **navigate** `cd %home%/.config/` and paste the `starship.toml` file 
- reload **Cmder**

> **note: add a Nerdfont inside Cmder settings > Font**

### 3. clone dotfiles 

- Cmder
```
  git clone --depth=1 https://github.com/ibrahimjml/dotfiles %USERPROFILE%\.config
```
