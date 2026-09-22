CLIENTES PWA v2

Cambios:
- N.º de recibo / ID (el número rojo del talonario)
- N.º de talonario
- Todos los datos visibles en el recibo de la imagen
- Lista compacta: ID, nombre y teléfono
- Botón "Mostrar datos" para ver la ficha completa
- Botón Editar
- Exportación CSV con todos los campos
- CSS separado en styles.css
- Mantiene Supabase y la PWA

ORDEN DE ACTUALIZACIÓN:
1. En Supabase > SQL Editor ejecuta supabase_update.sql UNA VEZ.
2. En GitHub reemplaza/sube index.html y agrega styles.css.
3. Mantén manifest.json, service-worker.js e iconos de la PWA.
4. Vercel detectará el commit y desplegará automáticamente.

IMPORTANTE:
- No vuelvas a ejecutar el SQL original que crea la tabla.
- Este SQL usa ADD COLUMN IF NOT EXISTS y no borra los clientes existentes.
- La clave usada en index.html es la PUBLISHABLE KEY de Supabase. No pongas una sb_secret_ ni service_role en el frontend.
