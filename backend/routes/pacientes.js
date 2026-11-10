const express = require('express');
const router = express.Router();
const pacienteController = require('../controllers/pacienteController');
const { verificarToken, esAdmin } = require('../middleware/authMiddleware');
const { mongoIdParam } = require('../middleware/mongoId');
const { handleValidationErrors } = require('../middleware/handleValidation');
const {
  createPacienteValidators,
  updatePacienteValidators,
} = require('../validators/pacienteValidators');

// Todas las rutas de pacientes requieren autenticación
router.use(verificarToken);

router.get('/', pacienteController.getPacientes);
router.get('/buscar', pacienteController.buscarPacientes);

router.get('/:id', mongoIdParam(), pacienteController.getPacienteById);
router.post(
  '/',
  createPacienteValidators,
  handleValidationErrors,
  pacienteController.createPaciente
);
router.put(
  '/:id',
  mongoIdParam(),
  updatePacienteValidators,
  handleValidationErrors,
  pacienteController.updatePaciente
);
// Eliminación/desactivación restringida solo a administradores (menor privilegio)
router.delete('/:id', esAdmin, mongoIdParam(), pacienteController.deletePaciente);
router.post('/:id/consultas', mongoIdParam(), pacienteController.addConsulta);

module.exports = router;
