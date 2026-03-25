FROM node:20-alpine

WORKDIR /app

# Copia los archivos de configuración
COPY package*.json ./

# Instala todas las dependencias
RUN npm install

# Copia el resto del código
COPY . .

# Exponemos el puerto
EXPOSE 3001

# Ejecutaremos el comando dev vía docker-compose
