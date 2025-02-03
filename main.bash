#!/usr/bin/env bash

 
main() { 
  local content="content"
  local docs="docs"
  local param="${1}"
  local base_url
  if [[ "${param}" = "build" ]];then
    base_url="https://isbrqu.github.io/toblogsi"
  else
    base_url="http://localhost:8000"
  fi
  while IFS= read -r -d $'\0' md;do
    local html="$(cext "${md}" "html")"
    html="$(cpath "${html}" "${docs}")"
    local css="$(generate_css_path "${html}")"
    create_html "${md}" "${css}" "${html}"
    sed -i "s#base_url#${base_url}#g" "${html}"
    echo "${html}"
  done < <(find "${content}" -type f -print0)
  echo "done!"
}

generate_css_path() {
  local css_file="pico.min.css"
  local html="${1}"
  local path="${html%/*}"
  local slash="${path//[^\/]}"
  local css="css"
  for (( i=1; i <= ${#slash}; i++ )); do
    css="../${css}"
  done
  echo "${css}/${css_file}"
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
  sed -i 's/\r//g' "${html}"
}

main "${@}"

