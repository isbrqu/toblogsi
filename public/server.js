
const http = require('http');
const fs = require('fs');
const path = require('path');

// Configuración del puerto
const PORT = 3000;

// Crear el servidor HTTP
const server = http.createServer((req, res) => {
    let filePath = '.' + req.url;

    // Si no se especifica archivo, servir index.html por defecto
    if (filePath === './') {
        filePath = './index.html';
    }

    // Obtener la extensión del archivo
    const extname = String(path.extname(filePath)).toLowerCase();
    const mimeTypes = {
        '.html': 'text/html',
        '.js': 'text/javascript',
        '.css': 'text/css',
        '.json': 'application/json',
        '.png': 'image/png',
        '.jpg': 'image/jpeg',
        '.gif': 'image/gif',
        '.svg': 'image/svg+xml',
        '.wav': 'audio/wav',
        '.mp4': 'video/mp4',
        '.woff': 'application/font-woff',
        '.ttf': 'application/font-ttf',
        '.eot': 'application/vnd.ms-fontobject',
        '.otf': 'application/font-otf',
        '.wasm': 'application/wasm',
    };

    const contentType = mimeTypes[extname] || 'application/octet-stream';

    // Leer el archivo solicitado
    fs.readFile(filePath, (error, content) => {
        if (error) {
            if (error.code === 'ENOENT') {
                // Archivo no encontrado
                fs.readFile('./404.html', (err, notFoundContent) => {
                    res.writeHead(404, { 'Content-Type': 'text/html' });
                    res.end(notFoundContent, 'utf-8');
                });
            } else {
                // Otro tipo de error
                res.writeHead(500);
                res.end(`Error: ${error.code}`);
            }
        } else {
            // Servir el archivo
            res.writeHead(200, { 'Content-Type': contentType });
            res.end(content, 'utf-8');
        }
    });
});

// Escuchar en el puerto configurado
server.listen(PORT, () => {
    console.log(`Servidor corriendo en http://localhost:${PORT}/`);
});
