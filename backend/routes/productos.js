const express = require('express');
const router = express.Router();
const productoController = require('../controllers/productoController');
const { verificarToken, esAdmin, esAdminOEmpleado } = require('../middleware/authMiddleware');
const { mongoIdParam } = require('../middleware/mongoId');
const { handleValidationErrors } = require('../middleware/handleValidation');
const {
  createProductoValidators,
  updateProductoValidators,
} = require('../validators/productoValidators');

router.get('/', verificarToken, productoController.getProductos);
router.get('/bajo-stock', verificarToken, productoController.getProductosBajoStock);

router.get('/:id', verificarToken, mongoIdParam(), productoController.getProductoById);

router.post(
  '/',
  verificarToken,
  esAdminOEmpleado,
  createProductoValidators,
  handleValidationErrors,
  productoController.createProducto
);
router.put(
  '/:id',
  verificarToken,
  esAdminOEmpleado,
  mongoIdParam(),
  updateProductoValidators,
  handleValidationErrors,
  productoController.updateProducto
);
router.delete('/:id', verificarToken, esAdmin, mongoIdParam(), productoController.deleteProducto);
router.patch('/:id/stock', verificarToken, esAdminOEmpleado, mongoIdParam(), productoController.updateStock);
router.patch('/:id/toggle', verificarToken, esAdminOEmpleado, mongoIdParam(), productoController.toggleActivo);

module.exports = router;
