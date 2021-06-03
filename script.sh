# This script runs every week and just simply pulls and builds the docs
mkdir /home/pi/HDD/docs_src/crxn
cd /home/pi/HDD/docs_src/crxn

# Pull new data down
git pull

# Build to the public directory
mkdocs build -d ../../docs/crxn/site
