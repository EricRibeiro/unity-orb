#!/bin/false
# shellcheck shell=bash
# shellcheck disable=SC2154

trap_build_script_exit() {
  local -r exit_status="$?"

  # The build script has a "set -x" on it. This will disable it for the rest of the run.
  set +x

  if [ "$exit_status" -ne 0 ]; then
    printf '%s\n' 'The script did not complete successfully.'
    printf '%s\n' "The exit code was $exit_status"

    rm -rf "$gameci_sample_project_dir"
    exit "$exit_status"
  fi

  if [ "$PARAM_COMPRESS" -eq 1 ]; then
    printf '%s\n' 'Compressing build artifacts...'

    # Compress artifacts to store them in the artifacts bucket.
    tar -czf "$base_dir/$PARAM_BUILD_NAME-$PARAM_BUILD_TARGET.tar.gz" -C "$unity_project_full_path/Builds/$PARAM_BUILD_TARGET" .
  fi

  # Clean up.
  rm -rf "$gameci_sample_project_dir"
}

# Copy GameCI's build script to the base directory.
cp "$gameci_sample_project_dir/ci/build.sh" "$base_dir/build.sh"
chmod +x "$base_dir/build.sh"

# Clean up.
rm -rf "$gameci_sample_project_dir"

# Name variables as required by the "build.sh" script.
readonly BUILD_NAME="$PARAM_BUILD_NAME"
readonly BUILD_TARGET="$PARAM_BUILD_TARGET"
readonly UNITY_DIR="$unity_project_full_path"

export BUILD_NAME
export BUILD_TARGET
export UNITY_DIR

# Trap "build.sh" exit otherwise it won't be possible to zip the artifacts.
trap trap_build_script_exit EXIT

# Run the build script.
# shellcheck source=/dev/null
source "$base_dir/build.sh"