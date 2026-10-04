#!/usr/bin/env bash
# скрипт 1

REPO_URL="$1"
BRANCH_1="$2"
BRANCH_2="$3" 
REPORT="diff_report_${BRANCH_1}_vs_${BRANCH_2}.txt"

TMP_DIR=$(mktemp -d)
git clone  "$REPO_URL" "$TMP_DIR"

DIFF=$(git -C "$TMP_DIR" diff --name-status --no-renames "origin/$BRANCH_1" "origin/$BRANCH_2")

rm -rf "$TMP_DIR"

COUNT_A=$(echo "$DIFF" | grep -c '^A')
COUNT_D=$(echo "$DIFF" | grep -c '^D')
COUNT_M=$(echo "$DIFF" | grep -c '^M')
TOTAL=$((COUNT_A + COUNT_D + COUNT_M))

cat > "$REPORT" <<EOF
Отчет о различиях между ветками

================================
Репозиторий:    $REPO_URL
Ветка 1:        $BRANCH_1
Ветка 2:        $BRANCH_2
Дата генерации: $(date '+%Y-%m-%d %H:%M:%S')
================================

СПИСОК ИЗМЕНЕННЫХ ФАЙЛОВ:
$DIFF

СТАТИСТИКА:
Всего измененных файлов: $TOTAL
Добавлено (A):    $COUNT_A
Удалено (D):      $COUNT_D
Изменено (M):     $COUNT_M
EOF

echo "saved: $REPORT"
