import express, { Request, Response } from 'express';
import * as path from 'path';  // Importando o módulo 'path' explicitamente

const app = express();
const port = 8080;

// Middleware para parsing de JSON
app.use(express.json());

// Rota principal
app.get('/', (req: Request, res: Response) => {
  res.send('Hello, World!');
});

// Rota para retornar informações
app.get('/api/info', (req: Request, res: Response) => {
  res.json({ message: 'API Node.js funcionando!', version: '1.0.0' });
});

// Iniciar o servidor
app.listen(port, () => {
  console.log(`API rodando em http://localhost:${port}`);
});
