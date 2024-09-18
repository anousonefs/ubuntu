#!/usr/bin/env bash

usage() {
  cat <<EOUSAGE
Usage: $0 [subcommand]
Available subcommands:
  help           - display this help message
  (empty)        - run all standard checks and tests
  ci             - run checks and tests suitable for continuous integration
  build          - build the docker image
  deploy         - deploy the docker image to the server
EOUSAGE
}

main() {
  case "$1" in
    "-h" | "--help" | "help")
      usage
      echo "Exiting with status 1" >&2
      exit 1
      ;;

    lint)
      local start="$(date +%s)"

      local wd="$(pwd)"
      runcmd git config --system --add safe.directory "${wd}"

      go_linters
      # Print how long it takes to download dependencies and run the standard
      # linters in CI.
      local end="$(date +%s)"
      echo
      echo "--------------------"
      echo "DONE: $((end-start)) seconds"
      echo "--------------------"
      ;;
    misspell) check_misspell ;;
    staticcheck) check_staticcheck ;;
    build) build_docker ;;
    deploy) deploy ;;

    *)
      usage
      exit 1
      ;;
  esac

  if [[ "$EXIT_CODE" -ne 0 ]]; then
    err "FAILED; see errors above"
  fi
  
  exit "$EXIT_CODE"
}

main "$@"

