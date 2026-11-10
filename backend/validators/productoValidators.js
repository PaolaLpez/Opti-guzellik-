const { body } = require('express-validator');

const createProductoValidators = [
  body('tipo')
    .notEmpty()
    .withMessage('El tipo de producto es obligatorio')
    .isIn(['armazon', 'mica', 'lente_contacto', 'accesorio'])
    .withMessage('Tipo de producto no válido'),

  body('codigo')
    .trim()
    .notEmpty()
    .withMessage('El código de producto es obligatorio')
    .isLength({ min: 1, max: 50 })
    .withMessage('El código debe tener entre 1 y 50 caracteres')
    .matches(/^[A-Za-z0-9_\-.]+$/)
    .withMessage('El código solo puede contener letras, números, guiones y puntos'),

  body('nombre')
    .trim()
    .notEmpty()
    .withMessage('El nombre del producto es obligatorio')
    .isLength({ min: 2, max: 150 })
    .withMessage('El nombre debe tener entre 2 y 150 caracteres'),

  body('precios.costo')
    .notEmpty()
    .withMessage('El costo es obligatorio')
    .isFloat({ min: 0 })
    .withMessage('El costo debe ser un número mayor o igual a 0'),

  body('precios.precio_venta')
    .notEmpty()
    .withMessage('El precio de venta es obligatorio')
    .isFloat({ min: 0 })
    .withMessage('El precio de venta debe ser un número mayor o igual a 0'),

  body('stock')
    .optional()
    .isInt({ min: 0 })
    .withMessage('El stock debe ser un entero no negativo'),

  body('stock_minimo')
    .optional()
    .isInt({ min: 0 })
    .withMessage('El stock mínimo debe ser un entero no negativo'),
];

const updateProductoValidators = [
  body('tipo')
    .optional()
    .isIn(['armazon', 'mica', 'lente_contacto', 'accesorio'])
    .withMessage('Tipo de producto no válido'),

  body('codigo')
    .optional()
    .trim()
    .notEmpty()
    .withMessage('El código no puede estar vacío')
    .isLength({ min: 1, max: 50 })
    .withMessage('El código debe tener entre 1 y 50 caracteres')
    .matches(/^[A-Za-z0-9_\-.]+$/)
    .withMessage('El código solo puede contener letras, números, guiones y puntos'),

  body('nombre')
    .optional()
    .trim()
    .notEmpty()
    .withMessage('El nombre no puede estar vacío')
    .isLength({ min: 2, max: 150 })
    .withMessage('El nombre debe tener entre 2 y 150 caracteres'),

  body('precios.costo')
    .optional()
    .isFloat({ min: 0 })
    .withMessage('El costo debe ser un número mayor o igual a 0'),

  body('precios.precio_venta')
    .optional()
    .isFloat({ min: 0 })
    .withMessage('El precio de venta debe ser un número mayor o igual a 0'),

  body('stock')
    .optional()
    .isInt({ min: 0 })
    .withMessage('El stock debe ser un entero no negativo'),

  body('stock_minimo')
    .optional()
    .isInt({ min: 0 })
    .withMessage('El stock mínimo debe ser un entero no negativo'),
];

module.exports = {
  createProductoValidators,
  updateProductoValidators,
};
