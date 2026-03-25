const express = require('express');
const http = require('http');
const { Server } = require('socket.io');
const cors = require('cors');
const db = require('./db');

const app = express();
app.use(cors());
app.use(express.json());

const server = http.createServer(app);
const io = new Server(server, {
  cors: {
    origin: '*', // En producción, ajustar a la URL del frontend Nuxt
    methods: ['GET', 'POST']
  }
});

// Ruta de health check para validar conexión a DB
app.get('/api/health', async (req, res) => {
  try {
    const [rows] = await db.query('SELECT 1');
    res.json({ status: 'ok', db: 'connected', message: 'API funcionando correctamente' });
  } catch (error) {
    console.error('Error DB:', error);
    res.status(500).json({ status: 'error', db: 'disconnected', error: error.message });
  }
});

// Manejo de conexiones WebSocket
io.on('connection', (socket) => {
  console.log(`Cliente conectado: ${socket.id}`);

  socket.on('disconnect', () => {
    console.log(`Cliente desconectado: ${socket.id}`);
  });
});

const PORT = process.env.PORT || 3001; // Usando 3001 para que no interfiera con Nuxt en el host
server.listen(PORT, () => {
  console.log(`🚀 Servidor ejecutándose en el puerto ${PORT}`);
});
