#!/bin/bash

# Путь к вашему файлу с переменными окружения
FILE_PATH=".deploy_secrets.env"

# Чтение файла построчно
while IFS= read -r line || [[ -n "$line" ]]; do
    # Игнорировать комментарии и пустые строки
    if [[ "$line" = \#* ]] || [[ -z "$line" ]]; then
        continue
    fi
    
    # Разделение строки на ключ и значение
    IFS='=' read -r key value <<< "$line"
    
    # Убираем возможные пробелы в ключе и значении
    key=$(echo $key | xargs)
    value=$(echo $value | xargs)
    
    # Выполнение команды gh variable set
    if gh secret set "$key" --body "$value"; then
        echo "Secret $key added successfully."
    else
        exit_code=$?
        echo "Failed to add variable $key. Exit code: $exit_code"
    fi
done < "$FILE_PATH"
