const { body } = require('express-validator');

const createPacienteValidators = [
  body('nombre')
    .trim()
    .notEmpty()
    .withMessage('El nombre del paciente es obligatorio')
    .isLength({ min: 2, max: 120 })
    .withMessage('El nombre debe tener entre 2 y 120 caracteres')
    .matches(/^[\p{L}\p{N}\s.'\-]+$/u)
    .withMessage('El nombre contiene caracteres no permitidos'),

  body('telefono')
    .trim()
    .notEmpty()
    .withMessage('El teléfono es obligatorio')
    .isLength({ min: 7, max: 25 })
    .withMessage('El teléfono debe tener entre 7 y 25 caracteres')
    .matches(/^[0-9+\s\-().]*$/)
    .withMessage('Formato de teléfono no válido'),

  body('edad')
    .optional({ values: 'falsy' })
    .isInt({ min: 0, max: 130 })
    .withMessage('La edad debe ser un número entre 0 y 130'),

  body('direccion')
    .optional({ values: 'falsy' })
    .trim()
    .isLength({ max: 300 })
    .withMessage('La dirección no debe exceder 300 caracteres'),

  body('como_se_entero')
    .optional({ values: 'falsy' })
    .trim()
    .isLength({ max: 100 })
    .withMessage('El campo "cómo se enteró" no debe exceder 100 caracteres'),

  body('observaciones')
    .optional({ values: 'falsy' })
    .trim()
    .isLength({ max: 1000 })
    .withMessage('Las observaciones no deben exceder 1000 caracteres'),
];

const updatePacienteValidators = [
  body('nombre')
    .optional()
    .trim()
    .notEmpty()
    .withMessage('El nombre no puede estar vacío')
    .isLength({ min: 2, max: 120 })
    .withMessage('El nombre debe tener entre 2 y 120 caracteres')
    .matches(/^[\p{L}\p{N}\s.'\-]+$/u)
    .withMessage('El nombre contiene caracteres no permitidos'),

  body('telefono')
    .optional()
    .trim()
    .notEmpty()
    .withMessage('El teléfono no puede estar vacío')
    .isLength({ min: 7, max: 25 })
    .withMessage('El teléfono debe tener entre 7 y 25 caracteres')
    .matches(/^[0-9+\s\-().]*$/)
    .withMessage('Formato de teléfono no válido'),

  body('edad')
    .optional({ values: 'falsy' })
    .isInt({ min: 0, max: 130 })
    .withMessage('La edad debe ser un número entre 0 y 130'),

  body('direccion')
    .optional({ values: 'falsy' })
    .trim()
    .isLength({ max: 300 })
    .withMessage('La dirección no debe exceder 300 caracteres'),

  body('como_se_entero')
    .optional({ values: 'falsy' })
    .trim()
    .isLength({ max: 100 })
    .withMessage('El campo "cómo se enteró" no debe exceder 100 caracteres'),

  body('observaciones')
    .optional({ values: 'falsy' })
    .trim()
    .isLength({ max: 1000 })
    .withMessage('Las observaciones no deben exceder 1000 caracteres'),
];

module.exports = {
  createPacienteValidators,
  updatePacienteValidators,
};
