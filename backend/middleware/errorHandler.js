/**
 * Middleware central de manejo de errores.
 * Garantiza que nunca se expongan datos sensibles, trazas de pila (stack traces),
 * ni detalles internos de la base de datos al cliente.
 */
function errorHandler(err, req, res, next) {
  // Registrar el detalle completo del error en los logs internos del servidor
  console.error(`[ERROR INTERNO] [${req.method} ${req.originalUrl}]:`, err);

  // Si las cabeceras ya fueron enviadas, delegar a Express
  if (res.headersSent) {
    return next(err);
  }

  const statusCode = err.statusCode || err.status || 500;

  // Manejo de errores específicos de Mongoose / MongoDB sin exponer esquemas
  if (err.name === 'ValidationError') {
    return res.status(400).json({
      message: 'Los datos proporcionados no cumplen con las validaciones requeridas.',
    });
  }

  if (err.name === 'CastError') {
    return res.status(400).json({
      message: 'Formato de identificador o dato no válido.',
    });
  }

  if (err.code === 11000) {
    return res.status(400).json({
      message: 'Ya existe un registro con esos datos únicos.',
    });
  }

  // Respuesta genérica y segura para errores 500
  return res.status(statusCode).json({
    message:
      statusCode >= 500
        ? 'Ocurrió un error interno en el servidor. Inténtelo más tarde.'
        : err.message || 'Error en la solicitud.',
  });
}

/**
 * Helper para captura segura de errores en controladores asíncronos
 */
function handleServerError(res, error, customMessage = 'Error interno del servidor') {
  console.error('[Error de Controlador]:', error);
  return res.status(500).json({ message: customMessage });
}

module.exports = { errorHandler, handleServerError };

