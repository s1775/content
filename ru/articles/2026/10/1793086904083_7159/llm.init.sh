#!/usr/bin/env -S bash -euo pipefail
# -------------------------------------------------------------------------------------------------------------------- #
# INIT: VLLM
#
# -------------------------------------------------------------------------------------------------------------------- #
# @package    Bash
# @author     Kai Kimera <mail@kaikim.ru>
# @license    MIT
# @version    0.1.0
# @link
# -------------------------------------------------------------------------------------------------------------------- #

(( EUID == 0 )) && { echo >&2 'This script should not be run as root!'; exit 1; }

# -------------------------------------------------------------------------------------------------------------------- #
# CONFIGURATION
# -------------------------------------------------------------------------------------------------------------------- #

# Sources.
SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd -P )"; readonly SRC_DIR
SRC_NAME="$( basename "$( readlink -f "${BASH_SOURCE[0]}" )" )"; readonly SRC_NAME
# shellcheck source=/dev/null
. "${SRC_DIR}/${SRC_NAME%.*}.conf"

# Parameters.
MODEL="${MODEL:?}"; readonly MODEL
GPU_MEMORY_UTILIZATION="${GPU_MEMORY_UTILIZATION:?}"; readonly GPU_MEMORY_UTILIZATION

# -------------------------------------------------------------------------------------------------------------------- #
# -----------------------------------------------------< SCRIPT >----------------------------------------------------- #
# -------------------------------------------------------------------------------------------------------------------- #

function init() {
  cd "${HOME}" || exit
  "${HOME}/.venv/bin/vllm" serve "${MODEL}" --gpu_memory_utilization="${GPU_MEMORY_UTILIZATION}"
}

function main() {
  init
}; main "$@"
