openssl req \
  -new \
  -newkey rsa:4096 \
  -days 3650 \
  -nodes \
  -x509 \
  -subj "/C=US/ST=CA/L=SF/O=Docker-demo/CN=app.example.org" \
  -keyout app.example.org.key \
  -out app.example.org.cert
  