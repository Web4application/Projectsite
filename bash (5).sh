git clone https://github.com/Web4application/programdata.git
cd programdata

# Install dune & bisect_ppx
opam install dune bisect_ppx
# Build all executables
dune build @all
# Run tests
dune runtest

# Full folder tree
tree -L 3
# Search for main executables
find . -type f -name "*.ml"
curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" INSTALL_K3S_EXEC="server" sh -s - --flannel-backend none
curl -sfL https://get.k3s.io | sh - 
# Check for Ready node, takes ~30 seconds 
sudo k3s kubectl get node 

sudo k3s server &
# Kubeconfig is written to /etc/rancher/k3s/k3s.yaml
sudo k3s kubectl get node

# On a different node run the below command. 
# NODE_TOKEN comes from /var/lib/rancher/k3s/server/node-token on your server
sudo k3s agent --server https://localhost.me:6443 --token ${AIzaSyAvrxOyAVzPVcnzxuD0mjKVDyS2bNWfC10}

gpg --verify guix-system-vm-image-1.4.0.x86_64-linux.qcow2.sig guix-system-vm-image-1.4.0.x86_64-linux.qcow2
# Assuming the file is named guix-system-vm-image-1.4.0.x86_64-linux.qcow2.sig.cpp
# This will strip everything except the signature lines
grep -E "-----BEGIN PGP SIGNATURE-----|-----END PGP SIGNATURE-----|^[A-Za-z0-9+/=]+$" guix-system-vm-image-1.4.0.x86_64-linux.qcow2.sig.cpp > guix-system-vm-image-1.4.0.x86_64-linux.qcow2.sig
#!/bin/bash
# guix-verify.sh - Extracts .sig.cpp, verifies GPG signature, generates SHA512 checksum
# Usage: ./guix-verify.sh guix-system-vm-image-1.4.0.x86_64-linux.qcow2

set -e

IMAGE="$1"

if [ -z "$IMAGE" ]; then
    echo "Usage: $0 <image-file>"
    exit 1
fi

SIG_CPP="${IMAGE}.sig.cpp"
SIG_FILE="${IMAGE}.sig"

# Step 1: Check if .sig.cpp exists
if [ ! -f "$SIG_CPP" ]; then
    echo "Error: $SIG_CPP not found!"
    exit 1
fi

# Step 2: Extract PGP signature
echo "[INFO] Extracting signature from .sig.cpp..."
grep -E "-----BEGIN PGP SIGNATURE-----|-----END PGP SIGNATURE-----|^[A-Za-z0-9+/=]+$" "$SIG_CPP" > "$SIG_FILE"

# Step 3: Verify signature
echo "[INFO] Verifying GPG signature..."
if gpg --verify "$SIG_FILE" "$IMAGE"; then
    echo "[OK] Signature verified successfully!"
else
    echo "[ERROR] Signature verification failed!"
    exit 2
fi

# Step 4: Generate SHA512 checksum
CHECKSUM_FILE="${IMAGE}-SHA512SUM.txt"
echo "[INFO] Generating SHA512 checksum..."
sha512sum "$IMAGE" > "$CHECKSUM_FILE"
echo "[OK] Checksum saved to $CHECKSUM_FILE"

echo "[DONE] All checks complete."
