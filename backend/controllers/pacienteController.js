const Paciente = require('../models/Paciente');
const { handleServerError } = require('../middleware/errorHandler');

// Evita que caracteres especiales de regex (o un objeto inyectado vía query
// string, ej. ?q[$gt]=) rompan la búsqueda o disparen un patrón costoso.
const escapeRegex = (s) => s.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');

// Solo estos campos pueden llegar a Mongo desde el body: evita que un cliente
// mande operadores ($set, $unset, $rename, etc.) que Mongoose aplicaría tal cual.
// 'consultas', 'ventas' y 'activo' se manejan por sus propios endpoints.
const CAMPOS_PACIENTE = ['nombre', 'telefono', 'direccion', 'edad', 'como_se_entero', 'observaciones'];

function pickPacienteData(body) {
  const data = {};
  for (const campo of CAMPOS_PACIENTE) {
    if (body[campo] !== undefined) data[campo] = body[campo];
  }
  return data;
}

// Obtener todos los pacientes
exports.getPacientes = async (req, res) => {
  try {
    const pacientes = await Paciente.find().sort({ fecha_registro: -1 });
    res.json(pacientes);
  } catch (error) {
    return handleServerError(res, error, 'Error al obtener pacientes');
  }
};

// Obtener paciente por ID
exports.getPacienteById = async (req, res) => {
  try {
    const paciente = await Paciente.findById(req.params.id);
    if (!paciente) {
      return res.status(404).json({ message: 'Paciente no encontrado' });
    }
    res.json(paciente);
  } catch (error) {
    return handleServerError(res, error, 'Error al obtener el paciente');
  }
};

// Crear paciente
exports.createPaciente = async (req, res) => {
  try {
    const paciente = new Paciente(pickPacienteData(req.body));
    const nuevoPaciente = await paciente.save();
    res.status(201).json(nuevoPaciente);
  } catch (error) {
    console.error('Error en createPaciente:', error);
    return res.status(400).json({ message: 'Datos de paciente no válidos' });
  }
};

// Actualizar paciente
exports.updatePaciente = async (req, res) => {
  try {
    const paciente = await Paciente.findByIdAndUpdate(
      req.params.id,
      pickPacienteData(req.body),
      { new: true, runValidators: true }
    );
    if (!paciente) {
      return res.status(404).json({ message: 'Paciente no encontrado' });
    }
    res.json(paciente);
  } catch (error) {
    console.error('Error en updatePaciente:', error);
    return res.status(400).json({ message: 'Datos de actualización no válidos' });
  }
};

// Eliminar paciente (soft delete)
exports.deletePaciente = async (req, res) => {
  try {
    const paciente = await Paciente.findByIdAndUpdate(
      req.params.id,
      { activo: false },
      { new: true }
    );
    if (!paciente) {
      return res.status(404).json({ message: 'Paciente no encontrado' });
    }
    res.json({ message: 'Paciente desactivado correctamente', paciente });
  } catch (error) {
    return handleServerError(res, error, 'Error al desactivar el paciente');
  }
};

// Buscar pacientes
exports.buscarPacientes = async (req, res) => {
  try {
    const { q } = req.query;
    if (!q || typeof q !== 'string') {
      return res.json([]);
    }
    const term = escapeRegex(q);
    const pacientes = await Paciente.find({
      $or: [
        { nombre: { $regex: term, $options: 'i' } },
        { telefono: { $regex: term, $options: 'i' } },
      ],
      activo: true
    }).limit(20);
    res.json(pacientes);
  } catch (error) {
    return handleServerError(res, error, 'Error en la búsqueda de pacientes');
  }
};

// Agregar consulta a paciente
exports.addConsulta = async (req, res) => {
  try {
    if (!req.body.fecha || !req.body.especialista || !req.body.motivoConsulta) {
      return res.status(400).json({ 
        message: 'Faltan campos requeridos en la consulta'
      });
    }
    
    const paciente = await Paciente.findById(req.params.id);
    if (!paciente) {
      return res.status(404).json({ message: 'Paciente no encontrado' });
    }
    
    paciente.consultas.push(req.body);
    await paciente.save();
    
    res.json(paciente);
  } catch (error) {
    console.error('Error en addConsulta:', error);
    return res.status(400).json({ message: 'Error al registrar la consulta' });
  }
};