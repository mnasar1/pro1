#!/bin/bash

# GitHub API URL
API_URL="https://api.github.com"

# GitHub username and personal access token from environment variables
USERNAME="${GITHUB_USERNAME}"
TOKEN="${GITHUB_TOKEN}"

# User and Repository information from script arguments
REPO_OWNER="$1"
REPO_NAME="$2"

# Function to make a GET request to the GitHub API
github_api_get() {
    local endpoint="$1"
    local url="${API_URL}/${endpoint}"

    # Send a GET request to the GitHub API with authentication
    curl -s -H "Authorization: token ${TOKEN}" "$url"
}

# Function to list users with read access to the repository
list_users_with_read_access() {
    local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"

    # Fetch the list of collaborators on the repository
    collaborators="$(github_api_get "$endpoint" | jq -r '.[] | select(.permissions.pull == true) | .login')"

    # Display the list of collaborators with read access
    if [[ -z "$collaborators" ]]; then
        echo "No users with read access found for ${REPO_OWNER}/${REPO_NAME}."
    else
        echo "Users with read access to ${REPO_OWNER}/${REPO_NAME}:"
        echo "$collaborators"
    fi
}

# Main script

# Check if arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <owner> <repository>"
    exit 1
fi

echo "Listing users with read access to ${REPO_OWNER}/${REPO_NAME}..."
list_users_with_read_access
