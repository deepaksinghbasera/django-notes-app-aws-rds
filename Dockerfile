# Use official Python image
FROM python:3.9

# Set working directory
WORKDIR /app/backend

# Copy requirements
COPY requirements.txt /app/backend

# Install system dependencies
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y gcc default-libmysqlclient-dev pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip install --no-cache-dir mysqlclient
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files
COPY . /app/backend

# Expose port Django/Gunicorn will run on
EXPOSE 8000

# Use Gunicorn to serve app and run migrations on container start
CMD ["sh", "-c", "python manage.py migrate && gunicorn notesapp.wsgi:application --bind 0.0.0.0:8000"]
