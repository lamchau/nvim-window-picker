#!/usr/bin/env bash

render() {
  local font_name="$1"
  local character="$2"
  toilet --font "$font_name" --directory "fonts" --filter crop "$character"
}

# use `toilet` instead of `figlet` since it has more options, it'll also be
# able to load `figlet` fonts
if ! command -v toilet > /dev/null 2>&1; then
  echo 'error: toilet must be installed'
fi

font_name="$1"
if ! toilet --font "$font_name" --directory "fonts" 'hello' > /dev/null; then
  exit 1
fi

output_file="$(echo "$font_name" | tr ' ' '-' | tr '[:upper:]' '[:lower:]')"
output_file="${output_file%.*}.lua"
# included fonts - https://github.com/cacalabs/toilet/tree/master/fonts
# other - http://www.figlet.org/fontdb.cgi
printf 'local M = {\n' > "$output_file"

echo 'info: rendering letters..'
for letter in {a..z}; do
  rendered="$(render "$font_name" "$letter")"
  printf "  $letter = [[\n%s ]],\n" "$rendered" >> "$output_file"
done

echo 'info: rendering numbers..'
for number in {0..9}; do
  rendered="$(render "$font_name" "$number")"
  printf "  ['$number'] = [[\n%s ]],\n" "$rendered" >> "$output_file"
done

printf '}\n\nreturn M' >> "$output_file"
sed -i '' -E 's/[[:space:]]*$//' "$output_file"

echo "info: finished rendering $font_name to $(realpath "$output_file")"
