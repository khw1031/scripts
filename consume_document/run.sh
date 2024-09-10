#!/bin/bash

set -euo pipefail

script_dir="$(dirname "$0")"

# Configuration
LOG_FILE="workflow.log"
INPUT_FILE="$script_dir/input.md"
TEMP_DIR="/tmp/doc_workflow"

log() {
    local message="$1"
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $message" | tee -a "$LOG_FILE"
}

# Step 1: Get the document
get_document() {
  if [[ ! -f "$INPUT_FILE" ]]; then
    log "Error: Document not found at $INPUT_FILE"
    exit 1
  fi
  log "Document found at $INPUT_FILE"
  cat "$INPUT_FILE" > "$TEMP_DIR/raw_document.md"
}

# Step 2: Clean the text
clean_text() {
  log "Cleaning text..."
  cat "$TEMP_DIR/raw_document.md" | fabric -p clean_text | sed '1d' > "$TEMP_DIR/clean_text.md"
}

# Step 3: Create tags
create_tags() {
  log "Creating tags..."
  echo "# Tags" > "$TEMP_DIR/tags.md"
  cat "$TEMP_DIR/clean_text.md" | fabric -p custom_tags | sed '1d' >> "$TEMP_DIR/tags.md"
}

# Step 4: Rate the content
rate_content() {
    log "Rating content..."
    echo "# Rate" > "$TEMP_DIR/content_rating.md"
    cat "$TEMP_DIR/clean_text.md" | fabric -p rate_content > "$TEMP_DIR/content_rating.md"
}

# Step 5: Create a summary
create_summary() {
    log "Creating a summary..."
    echo "# Summary" > "$TEMP_DIR/summary.md"
    cat "$TEMP_DIR/clean_text.md" | fabric -p create_summary | sed '1d' >> "$TEMP_DIR/summary.md"
}

# Step 6: Extract insights
extract_insights() {
    log "Extracting insights..."
    echo "# Insights\n" > "$TEMP_DIR/insights.md"
    cat "$INPUT_FILE" | fabric -p extract_insights > "$TEMP_DIR/insights.md"
}

join() {
  log "Joining files..."
  cat "$TEMP_DIR/tags.md" > "$script_dir/output.md"
  echo "" >> "$script_dir/output.md"
  cat "$TEMP_DIR/content_rating.md" >> "$script_dir/output.md"
  echo "" >> "$script_dir/output.md"
  cat "$TEMP_DIR/summary.md" >> "$script_dir/output.md"
  echo "" >> "$script_dir/output.md"
  cat "$TEMP_DIR/insights.md" >> "$script_dir/output.md"
  echo "" >> "$script_dir/output.md"
  cat "$TEMP_DIR/clean_text.md" >> "$script_dir/output.md"
}

main() {

  echo "Document path: $INPUT_FILE"
  log "Starting Read Document Workflow"

  mkdir -p "$TEMP_DIR"

  get_document "$INPUT_FILE"
  clean_text
  create_tags
  rate_content
  create_summary
  extract_insights
  join

  log "Workflow completed successfully"

}

# Check if a document path is provided
if [[ ! -f $INPUT_FILE ]];
then
    echo "Usage: add input.md to the $script_dir directory"
    exit 1
fi

main