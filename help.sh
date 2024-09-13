#!/bin/bash

# Add this to your .zshrc or .bashrc file
function show_help() {
  echo "Usage: help <command> [input]"
  echo "   or: echo 'input' | help <command>"
  echo
  echo "Available commands:"
  echo "- coding : Get coding best practices"
  echo "- query  : General query processing"
  echo "- prompt : Improve given prompt"
  echo "- pattern: Create a fabric pattern"
  echo
  echo "Examples:"
  echo "  help coding 'What is clean code?'"
  echo "  echo 'How to implement singleton?' | help pattern"
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

 # fabric 명령을 한 번만 실행하고 결과를 변수에 저장
  local output
   if ! output=$(echo "$input" | fabric -p "$profile" 2>&1); then
    echo "Error: 'fabric' command failed." >&2
    echo "$output" >&2  # 오류 메시지 출력
    return 1
  fi
  
  # 성공 시 출력
  echo "$output"
}

function coding() {
  check_fabric || return 1
  run_fabric "custom_expert_software_engineer" "$@"
}

function query() {
  check_fabric || return 1
  run_fabric "raw_query" "$@"
}

function prompt() {
  check_fabric || return 1
  run_fabric "improve_prompt" "$@"
}

function pattern() {
  check_fabric || return 1
  run_fabric "create_pattern" "$@"
}

function help_main() {
  local command=$1
  shift
  local input

  if [[ $# -gt 0 ]]; then
    input="$*"
  elif [[ ! -t 0 ]]; then
    # 표준 입력이 터미널이 아니면 (즉, 파이프나 리다이렉션) 입력을 읽음
    input=$(cat)
  else
    echo "Error: No input provided. Use command line arguments or pipe input." >&2
    show_help
    return 1
  fi

  if [[ -z "$input" ]]; then
    echo ">>Error: Empty input." >&2
    show_help
    return 1
  fi

  # 추가 입력이 있으면 읽음
  case $command in
    coding|query|prompt|pattern)
      $command "$input"
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