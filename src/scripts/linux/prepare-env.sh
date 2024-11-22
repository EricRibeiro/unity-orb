#!/bin/false
# shellcheck shell=bash
# shellcheck disable=SC2154

resolve_unity_license() {
  if [ -n "$unity_username" ] && [ -n "$unity_password" ]; then
    if [ -n "$unity_serial" ]; then
      # Combination: username + email + serial
      echo "Activating Unity with username, password, and serial."
      unity-editor \
        -logFile /dev/stdout \
        -batchmode \
        -nographics \
        -quit \
        -username "$unity_username" \
        -password "$unity_password" \
        -serial "$unity_serial"

      validate_license_file || return 1

    elif [ -n "$unity_encoded_license" ]; then
      # Combination: username + email + encoded license file
      echo "Activating Unity with username, password, and encoded license."
      unity_license=$(printf '%s\n' "$unity_encoded_license" | base64 --decode)

      # Extract serial number from license
      unity_serial=$(echo "$unity_license" | grep -oP '(?<=SerialNumber=).*')
      if [ -z "$unity_serial" ]; then
        echo "Failed to extract serial number from the encoded license file."
        return 1
      fi

      unity-editor \
        -logFile /dev/stdout \
        -batchmode \
        -nographics \
        -quit \
        -username "$unity_username" \
        -password "$unity_password" \
        -serial "$unity_serial"

      validate_license_file || return 1

    else
      echo "Missing serial or encoded license. Cannot activate Unity."
      return 1
    fi

  elif [ -n "$unity_encoded_license" ]; then
    # Combination: encoded license file only
    echo "Activating Unity with encoded license only."
    unity_license=$(printf '%s\n' "$unity_encoded_license" | base64 --decode)
    echo "$unity_license" > "/root/.local/share/unity3d/Unity/Unity_lic.ulf"

    validate_license_file || return 1

  else
    echo "No valid activation combination provided."
    return 1
  fi
}

validate_license_file() {
  if [ -e "/root/.local/share/unity3d/Unity/Unity_lic.ulf" ]; then
    echo "Unity license file successfully generated or applied."
    return 0
  else
    echo "Failed to generate Unity license file. Please verify your inputs."
    return 1
  fi
}

download_and_prepare_before_script() {
  local repo_url="$1"
  local ref="$2"
  local file_path="$3"
  local output_path="$4"

  # Construct the full URL
  local full_url="$repo_url/-/raw/$ref/$file_path"

  # Use curl to download the file
  curl --silent --location \
    --request GET \
    --url "$full_url" \
    --output "$output_path"

  # Make the script executable
  chmod +x "$output_path"
}

# Check if serial or encoded license was provided.
if ! resolve_unity_license; then
  echo "Failed to activate Unity. Please check your inputs or open an issue."
  exit 1
fi

# Define variables
repo_url="https://gitlab.com/game-ci/unity3d-gitlab-ci-example"
ref="7fc1c95"  # Will update to a tag once the latest version is merged
file_path="ci/before_script.sh"
before_script="$base_dir/before_script.sh"

# Download and prepare the before_script file
download_and_prepare_before_script "$repo_url" "$ref" "$file_path" "$before_script"

# Nomenclature required by the script.
readonly UNITY_LICENSE="$unity_license"

export UNITY_LICENSE

# Run the test script.
echo "Running the before_script.sh from $repo_url at $ref."
# TODO: this will fail if user did not provide UNITY_SERIAL as env var. Also, relying on this external script is not ideal.
# shellcheck source=/dev/null
source "$before_script"
