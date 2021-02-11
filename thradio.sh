#!/usr/bin/env bash
# shellcheck disable=SC2145,SC2178,SC2120,SC2162

# Functions to manage .env files
__dotenv=
__dotenv_file=
__dotenv_cmd=.env

.env() {
  REPLY=()
  [[ $__dotenv_file || ${1-} == -* ]] || .env.--file .env || return
  if declare -F -- ".env.${1-}" >/dev/null; then
    .env."$@"
    return
  fi
  return 64
}

.env.-f() { .env.--file "$@"; }

.env.get() {
  .env::arg "get requires a key" "$@" &&
    [[ "$__dotenv" =~ ^(.*(^|$'\n'))([ ]*)"$1="(.*)$ ]] &&
    REPLY=${BASH_REMATCH[4]%%$'\n'*} && REPLY=${REPLY%"${REPLY##*[![:space:]]}"}
}

.env.parse() {
  local line key
  while IFS= read -r line; do
    line=${line#"${line%%[![:space:]]*}"} # trim leading whitespace
    line=${line%"${line##*[![:space:]]}"} # trim trailing whitespace
    if [[ ! "$line" || "$line" == '#'* ]]; then continue; fi
    if (($#)); then
      for key; do
        if [[ $key == "${line%%=*}" ]]; then
          REPLY+=("$line")
          break
        fi
      done
    else
      REPLY+=("$line")
    fi
  done <<<"$__dotenv"
  ((${#REPLY[@]}))
}

.env.export() { ! .env.parse "$@" || export "${REPLY[@]}"; }

.env.set() {
  .env::file load || return
  local key saved=$__dotenv
  while (($#)); do
    key=${1#+}
    key=${key%%=*}
    if .env.get "$key"; then
      REPLY=()
      if [[ $1 == +* ]]; then
        shift
        continue # skip if already found
      elif [[ $1 == *=* ]]; then
        __dotenv=${BASH_REMATCH[1]}${BASH_REMATCH[3]}$1$'\n'${BASH_REMATCH[4]#*$'\n'}
      else
        __dotenv=${BASH_REMATCH[1]}${BASH_REMATCH[4]#*$'\n'}
        continue # delete all occurrences
      fi
    elif [[ $1 == *=* ]]; then
      __dotenv+="${1#+}"$'\n'
    fi
    shift
  done
  [[ $__dotenv == "$saved" ]] || .env::file save
}

.env.puts() { echo "${1-}" >>"$__dotenv_file" && __dotenv+="$1"$'\n'; }

.env.generate() {
  .env::arg "key required for generate" "$@" || return
  .env.get "$1" && return || REPLY=$("${@:2}") || return
  .env::one "generate: ouptut of '${*:2}' has more than one line" "$REPLY" || return
  .env.puts "$1=$REPLY"
}

.env.--file() {
  .env::arg "filename required for --file" "$@" || return
  __dotenv_file=$1
  .env::file load || return
  (($# < 2)) || .env "${@:2}"
}

.env::arg() { [[ "${2-}" ]] || {
  echo "$__dotenv_cmd: $1" >&2
  return 64
}; }

.env::one() { [[ "$2" != *$'\n'* ]] || .env::arg "$1"; }

.env::file() {
  local REPLY=$__dotenv_file
  case "$1" in
  load)
    __dotenv=
    ! [[ -f "$REPLY" ]] || __dotenv="$(<"$REPLY")"$'\n' || return
    ;;
  save)
    if [[ -L "$REPLY" ]] && declare -F -- realpath.resolved >/dev/null; then
      realpath.resolved "$REPLY"
    fi
    { [[ ! -f "$REPLY" ]] || cp -p "$REPLY" "$REPLY.bak"; } &&
      printf %s "$__dotenv" >"$REPLY.bak" && mv "$REPLY.bak" "$REPLY"
    ;;
  esac
}

# This is a general-purpose function to ask Yes/No questions in Bash, either
# with or without a default answer. It keeps repeating the question until it
# gets a valid answer.
ask() {
  # https://djm.me/ask
  local prompt default reply

  while true; do

    if [[ "${2:-}" == "Y" ]]; then
      prompt="Y/n"
      default=Y
    elif [[ "${2:-}" == "N" ]]; then
      prompt="y/N"
      default=N
    else
      prompt="y/n"
      default=
    fi

    # Ask the question (not using "read -p" as it uses stderr not stdout)
    echo -n "$1 [$prompt] "

    read reply

    # Default?
    if [[ -z "$reply" ]]; then
      reply=${default}
    fi

    # Check if the reply is valid
    case "$reply" in
    Y* | y*) return 0 ;;
    N* | n*) return 1 ;;
    esac

  done
}

# Generate a prompt to set an environment file value.
envfile-set() {
  local VALUE INPUT

  .env --file .env

  .env get "$1"
  VALUE=${REPLY:-$2}

  echo -n "$3 [$VALUE]: "
  read INPUT

  VALUE=${INPUT:-$VALUE}

  .env set "${1}=${VALUE}"
}

install() {
  if [[ ! $(command -v curl) ]]; then
    echo "cURL does not appear to be installed."
    echo "Install curl using your host's package manager,"
    echo "then continue installing using this script."
    exit
  fi

  if [[ $(command -v docker) && $(docker --version) ]]; then
    echo "Docker is already installed! Continuing..."
  else
    if ask "Docker does not appear to be installed. Install Docker now?" Y; then
      curl -fsSL get.docker.com -o get-docker.sh
      sh get-docker.sh
      rm get-docker.sh

      if [[ $EUID -ne 0 ]]; then
        sudo usermod -aG docker "$(whoami)"

        echo "You must log out or restart to apply necessary Docker permissions changes."
        echo "Restart, then continue installing using this script."
        exit
      fi
    else
      echo "You need to install docker."
      exit
    fi
  fi

  if [[ $(command -v docker-compose) && $(docker-compose --version) ]]; then
    echo "Docker Compose is already installed! Continuing..."
  else
    if ask "Docker Compose does not appear to be installed. Install Docker Compose now?" Y; then
      local COMPOSE_VERSION=1.25.3

      if [[ $EUID -ne 0 ]]; then
        if [[ ! $(command -v sudo) ]]; then
          echo "Sudo does not appear to be installed."
          echo "Install sudo using your host's package manager,"
          echo "then continue installing using this script."
          exit 1
        fi

        sudo sh -c "curl -fsSL https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose"
        sudo chmod +x /usr/local/bin/docker-compose
        sudo sh -c "curl -fsSL https://raw.githubusercontent.com/docker/compose/${COMPOSE_VERSION}/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose"
      else
        curl -fsSL https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
        chmod +x /usr/local/bin/docker-compose
        curl -fsSL https://raw.githubusercontent.com/docker/compose/${COMPOSE_VERSION}/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose
      fi
    fi
  fi

  if [[ ! -f docker-compose.yaml ]]; then
    echo "Retrieving default docker-compose.yml file..."
    curl -fsSL https://raw.githubusercontent.com/ThRadio/ThRadio/main/docker-compose.sample.yaml -o docker-compose.yaml
  fi

  if [[ ! -f Caddyfile ]]; then
    echo "Retrieving default Caddyfile file..."
    curl -fsSL https://raw.githubusercontent.com/ThRadio/ThRadio/main/Caddyfile.sample -o Caddyfile
  fi

  if [[ ! -f .env ]]; then
    echo "Writing default .env file..."
    curl -fsSL https://raw.githubusercontent.com/ThRadio/ThRadio/main/sample.env -o .env
  fi

  local SECRET
  SECRET=$(
    tr </dev/urandom -dc _A-Z-a-z-0-9 | head -c"${1:-32}"
    echo
  )
  sed -i "s/super_secret/${SECRET}/g" .env

  envfile-set "SITE_ADDRESS" "localhost" "Optional: Domain name (example.com) or names (example.com,foo.bar) to use with LetsEncrypt"

  docker-compose pull
  docker-compose up -d
  exit
}

"$@"
