#!/bin/zsh

# Add this to your .zshrc or .bashrc file
append_text() {
  local input
  local text_to_append="$1"

  if read -t 0.1 input; then
    # 표준 입력에서 데이터를 읽음
    input+=$'\n'$(cat)
  fi
    echo "$input" | awk -v text="$text_to_append" '
      {print}
      END {
        if (NR > 0) {
          print ""
          print ""
          print text
        }
      }
    '
}

append() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: $0 <text to append>"
    return 1
  fi

  local result=$(append_text "$1")

  if [[ -z "$result" ]]; then
    echo "$1"
  else
    echo "$result"
  fi
}