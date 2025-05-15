# Use Python 3.6 or later as a base image
FROM python:3.9-slim

# Copy contents into image
COPY . /app
WORKDIR /app
# Install pip dependencies from requirements
RUN pip install --no-cache-dir -r requirements.txt
# Set YOUR_NAME environment variable
ENV YOUR_NAME="Tom"
# Expose the correct port
EXPOSE 5500
# Create an entrypoint
ENTRYPOINT ["python", "app.py"]