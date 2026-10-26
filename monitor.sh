#!/usr/bin/env bash
# скрипт 2

PID_FILE="monitor.pid"
INTERVAL=${INTERVAL:-600}

is_running() {
    [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null
}

collect() {
    FILE="system_report_$(date +%F).csv"

    # если файла за сегодня ещё нет - сначала пишем заголовок
    if [ ! -f "$FILE" ]; then
        echo "timestamp;all_memory;free_memory;%memory_used;%cpu_used;%disk_used;load_average_1m" > "$FILE"
    fi

    TS=$(date '+%Y-%m-%d %H:%M:%S')
    MEM_ALL=$(free -m | awk '/Mem:/ {print $2}')
    MEM_FREE=$(free -m | awk '/Mem:/ {print $7}')
    MEM_PCT=$(free | awk '/Mem:/ {printf "%.1f", ($2-$7)*100/$2}')
    CPU=$(vmstat 1 2 | tail -1 | awk '{print 100-$15}')
    DISK=$(df / | awk 'NR==2 {print $5}' | tr -d '%')
    LOAD=$(cut -d' ' -f1 /proc/loadavg)

    echo "$TS;$MEM_ALL;$MEM_FREE;$MEM_PCT;$CPU;$DISK;$LOAD" >> "$FILE"
}

loop() {
    while true; do
        collect
        sleep "$INTERVAL"
    done
}

case "$1" in
    START)
        if is_running; then
            echo "running, PID $(cat "$PID_FILE")"
        else
            nohup "$0" LOOP > /dev/null 2>&1 &
            echo $! > "$PID_FILE"
            echo "running, PID $!"
        fi
        ;;
    STOP)
        if is_running; then
            kill "$(cat "$PID_FILE")"
            rm -f "$PID_FILE"
            echo "stopped"
        else
            echo "not started"
        fi
        ;;
    STATUS)
        if is_running; then
            echo "started, PID $(cat "$PID_FILE")"
        else
            echo "not started"
        fi
        ;;
    LOOP)
        loop
        ;;
    *)
        echo "Использование: $0 START|STOP|STATUS"
        exit 1
        ;;
esac
