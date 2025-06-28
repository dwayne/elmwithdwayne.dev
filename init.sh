#!/usr/bin/env bash

#
# Usage: . init.sh
#

dist="${dist:?}"


# FUNCTIONS


deploy-production () {
  pnpm build
  deploy "$@" "$dist" release/production
}

export -f deploy-production


# ALIASES


alias d='pnpm dev'
alias b='pnpm build'
alias p='pnpm preview'
alias dp=deploy-production
