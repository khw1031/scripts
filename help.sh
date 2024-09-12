#!/bin/bash

# Add this to your .zshrc or .bashrc file
function show_help() {
  echo "Usage: help [command]"
  echo "Available commands:"
  echo "- coding"
  echo "- query"
}

function check_fabric() {
  if ! command -v fabric &> /dev/null; then
    echo "Error: 'fabric' command not found. Please install it and try again." >&2
    return 1
  fi
  return 0
}

function run_fabric() {
  local profile="$1"
  shift
  local input="$*"

  if ! echo "$input" | fabric -p "$profile"; then
    echo "Error: 'fabric' command failed." >&2
    return 1
  fi
  echo "$input" | fabric -p "$profile"
}

function coding() {
  check_fabric || return 1
  run_fabric "custom_expert_software_engineer" "$@"
}

function query() {
  check_fabric || return 1
  run_fabric "raw_query" "$@"
}

function help_main() {
  local input
  local command=${1}

  if ! read -t 0.1 input; then
    echo ">> No input provided. Please provide input via pipe or command line." >&2
    echo "Example: echo 'What is clean code?' | help coding" >&2
    echo "Or: help query < your_input_file.txt" >&2
    return 1
  fi

  # 추가 입력이 있으면 읽음
  input+=$'\n'$(cat)
  case $command in
    coding)
      coding "$input"
      ;;
    query)
      query "$input"
      ;;
    *)
      echo "Error: Invalid command." >&2
      show_help
      return 1
      ;;
  esac
}

# fabric helper
function help() {
  if [[ $# -eq 0 ]]; then
      show_help
  else
      help_main "$@"
  fi        
}
