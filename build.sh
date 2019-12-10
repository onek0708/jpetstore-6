docker build -t jpetstore .
docker run -d -p 22222:22 -p 8080:8080 -p 80:80 --name jpetstore jpetstore
