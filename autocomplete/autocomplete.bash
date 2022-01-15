#!/bin/bash

_script()
{

  local cur
  COMPREPLY=()

  if [[ COMP_CWORD -le 1 ]]; then
    _script_commands="init run exploit make restore compress extract backup exit edit"
    cur="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=( $(compgen -W "${_script_commands}" -- ${cur}) )
  elif [[ ${COMP_WORDS[$((COMP_CWORD-1))]} =~ (exploit|restore|compress|extract|backup) ]]; then
    _script_commands=$(ls src/src-kernel)
    cur="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=( $(compgen -W "${_script_commands}" -- ${cur}) )
  fi

  return 0
}
complete -F _script ./kpwninit.sh
