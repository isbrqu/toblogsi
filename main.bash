#!/usr/bin/env bash

main() { 
  while IFS= read -r -d $'\0' md;do
    local html="$(cext "${md}" "html")"
    html="$(cpath "${html}" "public")"
    local css="$(generate_css_path "${html}")"
    create_html "${md}" "${css}" "${html}"
  done < <(find markdown -type f -print0)
}

generate_css_path() {
  local html="${1}"
  local path="${html%/*}"
  local slash="${path//[^\/]}"
  local css="css"
  for (( i=1; i <= ${#slash}; i++ )); do
    css="../${css}"
  done
  echo "${css}/pico.min.css"
}

cext() {
  local file="${1}"
  local ext="${2}"
  echo "${file%.*}.${ext}"
}

cpath() {
  local file="${1}"
  local path="${2}"
  echo "${path}/${html#*/}"
}

create_html() {
  local css="css/pico.min.css"
  local template="template.html"
  local author="Lhunath,GreyCat,isbrqu"
  local markdown="${1}"
  local css="${2}"
  local html="${3}"
  mkdir --parents "${html%/*}"
  pandoc "${markdown}"\
    --wrap=none\
    --standalone=true\
    --css="${css}"\
    --metadata=author:"${author}"\
    --template="${template}"\
    --output="${html}"
}

main "${@}"

