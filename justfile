# Cross platform shebang:
shebang := if os() == 'windows' {
  'powershell.exe'
} else {
  '/usr/bin/env bash'
}

set windows-shell := ["powershell", "-c"]

default: build

clean:
  #!{{shebang}}
  cd src
  flutter clean
  cd rust; cargo clean

build:
  #!{{shebang}}
  cd src
  flutter pub get
  flutter build apk

rebuild: clean build