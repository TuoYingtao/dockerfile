#!/usr/bin/env sh
program_file_name="cph-dispatch-py-test.ini"
target_file="armvm.txt"

if [ ! -f "$program_file_name" ]; then
  touch "$program_file_name"
  echo "Create file: $program_file_name"
fi

while read -r line; do
  trimmed_line=$(echo "$line" | awk '{$1=$1; print}')
  if ! grep -q "\[program:cph-dispatch-py-test_$trimmed_line\]" "$program_file_name"; then
    echo "${trimmed_line} Configuration writing to $program_file_name...."
    cat <<EOF >> $program_file_name
[program:cph-dispatch-py-test_$trimmed_line]
directory=/opt/supervisor/bin
command=/home/ubuntu/code-server/cph-dispatchsystem-python/venv/bin/python
autostart=true
startsecs=10
autorestart=true
startretries=3
user=root
priority=999
redirect_stderr=true
stdout_logfile_maxbytes=20MB
stdout_logfile_backups = 20
stderr_logfile=/opt/supervisor/logs/blog_stderr.log
stdout_logfile=/opt/supervisor/logs/catalina.out
stopasgroup=true
killasgroup=true

EOF
  else
    echo "Configuration for $trimmed_line already exists in $program_file_name."
  fi
done < $target_file

#rm $program_file_name
echo "Generate program finished...."