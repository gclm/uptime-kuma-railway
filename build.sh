# Pull upstream changes
echo -e "\033[0;32m====>\033[0m Pull origin..."
git pull

echo -e "\033[0;32m====>\033[0m Initial check..."

# Get current release name
CURRENT_RELEASE=$(git tag --sort=committerdate | tail -1)

# Get lastest release name
RELEASE=$(curl -s https://api.github.com/repos/louislam/uptime-kuma/tags | jq | grep -o '"[0-9]*\.[0-9]*\.[0-9]*"'| head -1 | sed 's/"//g')

# Exit script if already up to date
if [ "v${RELEASE}" = $CURRENT_RELEASE ]; then
    echo -e "\033[0;32m=>\033[0m Already up to date..."
    exit 0
fi

# Replace "ARG" line in dockerfile with the new release
sed -i "s#ARG UPTIME_KUMA_VERSION.*#ARG UPTIME_KUMA_VERSION=\"${RELEASE}\"#" Dockerfile

# Replace README link to uptime kuma release
UPTIME_KUMA_BADGE="[![Uptime Kuma](https://img.shields.io/badge/Uptime_Kuma-${RELEASE}-blue.svg)](https://github.com/louislam/uptime-kuma/releases/tag/${RELEASE})"
sed -i "s#\[\!\[Uptime Kuma\].*#${UPTIME_KUMA_BADGE}#" README.md

# Push changes
git add Dockerfile README.md
git commit -m "Update to uptime kuma version v${RELEASE}"
git push origin master

# Create tag
git tag "v${RELEASE}"
git push --tags