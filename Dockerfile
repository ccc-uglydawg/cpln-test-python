FROM python:3.12-slim

WORKDIR /app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 3000

CMD if [ -f Procfile ]; then \
      sh -c "$(grep '^web:' Procfile | sed 's/^web: *//' | sed 's/\$PORT/3000/g')"; \
    elif pip show gunicorn >/dev/null 2>&1; then \
      gunicorn app:app --bind 0.0.0.0:3000; \
    else \
      python app.py; \
    fi
