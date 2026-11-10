const express = require('express');
const router = express.Router();
const reporteController = require('../controllers/reporteController');
const { verificarToken, esAdmin } = require('../middleware/authMiddleware');

// Todas las rutas de reportes requieren autenticación y rol de administrador (mínimo privilegio)
router.use(verificarToken);
router.use(esAdmin);

router.get('/resumen', reporteController.getResumenVentas);
router.get('/ventas/dia', reporteController.getVentasDelDia);
router.get('/productos/top', reporteController.getProductosMasVendidos);
router.get('/productos/bajo-stock', reporteController.getProductosBajoStock);
router.get('/ventas/por-empleado', reporteController.getVentasPorEmpleado);

module.exports = router;