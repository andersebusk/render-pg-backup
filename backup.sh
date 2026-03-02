#!/usr/bin/env bash
set -euo pipefail

TS="$(date -u +%Y-%m-%dT%H%M%SZ)"
OUT_DIR="/tmp/backups"
NAME="${BACKUP_NAME:-render-postgres}"
FILE="$OUT_DIR/${NAME}_${TS}.dump"
GZ_FILE="${FILE}.gz"
DEST_BASE="${ONEDRIVE_DEST:-onedrive:Products/DataBank/Datafiler - ny/Skibsdata/Render}"

mkdir -p "$OUT_DIR"

echo "Starting backup at $TS"

export PGPASSWORD="${PGPASSWORD:?Missing PGPASSWORD}"

pg_dump \
  -h "${PGHOST:?Missing PGHOST}" \
  -p "${PGPORT:-5432}" \
  -U "${PGUSER:?Missing PGUSER}" \
  -d "${PGDATABASE:?Missing PGDATABASE}" \
  --format=custom \
  --no-owner \
  --no-acl \
  -f "$FILE"

gzip -9 "$FILE"

echo "Backup created:"
ls -lh "$GZ_FILE"

echo "Uploading to OneDrive..."


rclone copy "$GZ_FILE" "${DEST_BASE}/${BACKUP_NAME}/" --checksum

echo "Backup finished successfully."