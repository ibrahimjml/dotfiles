### 1. Manual setup for clink

- Install clink from [clink](https://chrisant996.github.io/clink/)

### 2. Setup fzf with clink

- Copy the `fzf.lua` file and paste it inside `installation_path\clink\fzf.lua`

- clink-fzf commands :

| shortcut    | action                                                                                        |
| ----------- | --------------------------------------------------------------------------------------------- |
| `Cntrl + r` | Launches a fuzzy-search menu overlay of your entire shell command history.                    |
| `Cntrl + t` | Recursively scans files in your current working directory and pastes the path into your line. |
| `Alt + C`   | Interactive fuzzy directory listing; select a folder to instantly `cd` into it.               |

### Inject clink to registry with custom aliases_inputrc file

- Open `regedit` and navigate to `HKEY_CURRENT_USER\Software\Microsoft\Command Processor`
- Create a new `String Value` named `AutoRun` and set its value to :
  ```
  "C:\clink\clink_x64.exe" inject --autorun --profile "%LOCALAPPDATA%\clink" && doskey.exe /macrofile="%LOCALAPPDATA%\clink\aliases_inputrc"

  ```

### Run the setup

- open terminal and run

```
clink set clink.logo none
clink set autosuggest.enable true
clink config prompt use starship
clink set fzf.exe_location "C:\ProgramData\chocolatey\bin\fzf.exe"
clink set fzf.default_bindings true

```

### Create General settings config **`.inputrc`** located in %HOME% directory

