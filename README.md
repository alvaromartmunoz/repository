[![Anurag's GitHub stats](https://github-readme-stats.vercel.app/api?username=alvaromm6556&show_icons=true&theme=monokai)](https://github.com/anuraghazra/github-readme-stats)

#### **Aplicaciones que incluyen:** 

- BookStack

### 🐋Codigo del docker-compose.yml:

```YAML
---
version: "2"
services:
  bookstack:
    image: lscr.io/linuxserver/bookstack
    container_name: bookstack
    environment:
      - PUID=1000
      - PGID=1000
      - APP_URL=
      - DB_HOST=bookstack_db
      - DB_USER=bookstack
      - DB_PASS=Pass
      - DB_DATABASE=bookstackapp
    volumes:
      - ./app/config:/config
    ports:
      - 6875:80
    restart: unless-stopped
    depends_on:
      - bookstack_db
  bookstack_db:
    image: lscr.io/linuxserver/mariadb
    container_name: bookstack_db
    environment:
      - PUID=1000
      - PGID=1000
      - MYSQL_ROOT_PASSWORD=Pass
      - TZ=Europe/Madrid
      - MYSQL_DATABASE=bookstackapp
      - MYSQL_USER=bookstack
      - MYSQL_PASSWORD=Pass
    volumes:
      - ./DB/config:/config
    restart: unless-stopped


```

