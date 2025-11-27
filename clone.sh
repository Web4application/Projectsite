#!/bin/bash
# A script to clone Git repositories

# List of repositories to clone
REPOS=(
    "https://github.com/Kubucoinincs/web4.git"
    "https://github.com/Kubucoin-eth/web4.git"
    "https://github.com/QUBUHUB-repos/master.git"
    "https://github.com/QUBUHUB-repos/ChatGPT-web4.git"
    "https://github.com/QUBUHUB-repos/RODA-AI-Web.git"
    "https://github.com/Kubucoin-eth/OMIRAN.git"
    "https://github.com/QUBUHUB/web4UI.git"
    "https://github.com/QUBUHUB/web4.app.git"
    "https://github.com/Web4application/kubu-hai.git"
    "https://github.com/Web4application/fadaka.git"
)

# Target directory to store cloned repositories
TARGET_DIR="./cloned_repositories"

# Create the target directory if it doesn't exist
mkdir -p $TARGET_DIR

# Loop through the list of repositories and clone them
for REPO in "${REPOS[@]}"; do
    echo "Cloning $REPO into $TARGET_DIR..."
    git clone $REPO $TARGET_DIR/$(basename $REPO .git)
done

echo "All repositories have been cloned."
