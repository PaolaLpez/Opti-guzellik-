// lib/screens/empleado/productos/productos_empleado.dart
import 'package:flutter/material.dart';
import '../../../utils/colors.dart';
import '../../../services/producto_service.dart';
import '../../../models/productos/producto_model.dart';
import '../../admin/productos/producto_form.dart';

class ProductosEmpleado extends StatefulWidget {
  @override
  _ProductosEmpleadoState createState() => _ProductosEmpleadoState();
}

class _ProductosEmpleadoState extends State<ProductosEmpleado> {
  List<Producto> _productos = [];
  bool _isLoading = true;
  String _errorMessage = '';
  String _searchQuery = '';
  String _selectedTipo = 'todos'; // Filtro por categoría

  @override
  void initState() {
    super.initState();
    _cargarProductos();
  }

  Future<void> _cargarProductos() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final productos = await ProductoService.getProductos();
      setState(() {
        _productos = productos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  List<Producto> get _productosFiltrados {
    return _productos.where((p) {
      final matchesSearch = _searchQuery.isEmpty ||
          p.nombre.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.marca.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.codigo.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchesTipo = _selectedTipo == 'todos' || p.tipo == _selectedTipo;

      return matchesSearch && matchesTipo;
    }).toList();
  }

  Future<void> _agregarProducto() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductoForm(),
      ),
    );
    if (result == true) {
      _cargarProductos();
    }
  }

  Future<void> _editarProducto(Producto producto) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductoForm(producto: producto),
      ),
    );
    if (result == true) {
      _cargarProductos();
    }
  }

  Future<void> _eliminarProducto(Producto producto) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar Producto'),
        content: Text('¿Estás seguro de eliminar "${producto.nombre}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isLoading = true);
      try {
        await ProductoService.deleteProducto(producto.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${producto.nombre} eliminado correctamente'),
            backgroundColor: Colors.green,
          ),
        );
        _cargarProductos();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al eliminar: $e'),
            backgroundColor: Colors.red,
          ),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: AppColors.azulReal,
        title: Text(
          'Catálogo de Productos',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.azulReal,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: AppColors.azulReal),
            tooltip: 'Recargar catálogo',
            onPressed: _cargarProductos,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(115),
          child: Column(
            children: [
              // Barra de búsqueda
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar por nombre, marca o código...',
                    prefixIcon: Icon(Icons.search, color: AppColors.azulCobalto),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
              // Filtro rápido por tipo (Armazones, Micas, Lentes de contacto)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    _buildFilterChip('todos', 'Todos', Icons.grid_view),
                    SizedBox(width: 8),
                    _buildFilterChip('armazon', 'Armazones', Icons.visibility),
                    SizedBox(width: 8),
                    _buildFilterChip('mica', 'Micas', Icons.lens),
                    SizedBox(width: 8),
                    _buildFilterChip('lente_contacto', 'Lentes de Contacto', Icons.contactless),
                    SizedBox(width: 8),
                    _buildFilterChip('accesorio', 'Accesorios', Icons.shopping_bag),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _agregarProducto,
        backgroundColor: AppColors.turquesa,
        tooltip: 'Agregar Producto',
        child: Icon(Icons.add),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(color: AppColors.azulReal),
            )
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.red),
                      SizedBox(height: 16),
                      Text('Error: $_errorMessage'),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _cargarProductos,
                        child: Text('Reintentar'),
                      ),
                    ],
                  ),
                )
              : _productosFiltrados.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inventory, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'No hay productos registrados',
                            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                          ),
                          SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: _agregarProducto,
                            icon: Icon(Icons.add),
                            label: Text('Agregar Producto'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.turquesa,
                            ),
                          ),
                        ],
                      ),
                    )
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        // [OP-05] Diseño responsivo: adapta columnas según ancho de pantalla
                        final double width = constraints.maxWidth;
                        int crossAxisCount = 2; // Teléfonos móviles
                        double childAspectRatio = 0.65;

                        if (width >= 1100) {
                          crossAxisCount = 4; // Pantallas grandes / tablets horizontal
                          childAspectRatio = 0.72;
                        } else if (width >= 650) {
                          crossAxisCount = 3; // Tablets
                          childAspectRatio = 0.68;
                        } else if (width < 360) {
                          childAspectRatio = 0.58; // Teléfonos pequeños
                        }

                        return GridView.builder(
                          padding: EdgeInsets.all(12),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            childAspectRatio: childAspectRatio,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: _productosFiltrados.length,
                          itemBuilder: (context, index) {
                            final producto = _productosFiltrados[index];
                            return _buildProductoCard(producto);
                          },
                        );
                      },
                    ),
    );
  }

  Widget _buildFilterChip(String tipo, String label, IconData icon) {
    final bool isSelected = _selectedTipo == tipo;
    return ChoiceChip(
      avatar: Icon(
        icon,
        size: 16,
        color: isSelected ? Colors.white : AppColors.azulCobalto,
      ),
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() {
            _selectedTipo = tipo;
          });
        }
      },
      selectedColor: AppColors.azulReal,
      backgroundColor: Colors.white,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : AppColors.azulReal,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        fontSize: 12,
      ),
      elevation: isSelected ? 2 : 0,
    );
  }

  // [OP-05] Card personalizada con imagen, nombre, marca, precio, stock y estados visuales
  Widget _buildProductoCard(Producto producto) {
    final bool estaAgotado = producto.stock <= 0;
    final bool stockBajo = !estaAgotado && producto.stock <= producto.stockMinimo;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: estaAgotado
              ? Colors.red.withOpacity(0.4)
              : (stockBajo ? Colors.orange.withOpacity(0.4) : Colors.transparent),
          width: 1.5,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen del producto con badge de tipo y alerta
          Stack(
            children: [
              Container(
                height: 125,
                width: double.infinity,
                color: Colors.grey[100],
                child: (producto.imagenes.isNotEmpty && producto.imagenes.first.trim().isNotEmpty)
                    ? Image.network(
                        producto.imagenes.first,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => _buildImagePlaceholder(producto),
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.azulCobalto,
                              ),
                            ),
                          );
                        },
                      )
                    : _buildImagePlaceholder(producto),
              ),

              // Badge de Tipo de Producto
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: _getColorForTipo(producto.tipo).withOpacity(0.92),
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_getIconForTipo(producto.tipo), size: 12, color: Colors.white),
                      SizedBox(width: 4),
                      Text(
                        _getLabelForTipo(producto.tipo),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Badge superior si está agotado
              if (estaAgotado)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.red[700],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'AGOTADO',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          // Información del producto
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nombre del producto
                  Text(
                    producto.nombre,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.azulReal,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2),

                  // Marca y código
                  Text(
                    '${producto.marca.isNotEmpty ? producto.marca : 'Genérico'} • ${producto.codigo}',
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  Spacer(),

                  // Precio de venta
                  Text(
                    '\$${producto.precioVenta.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.turquesa,
                    ),
                  ),
                  SizedBox(height: 6),

                  // [OP-05] Distinción visual del stock (disponible, bajo o agotado)
                  _buildStockBadge(producto, estaAgotado, stockBajo),
                  SizedBox(height: 6),

                  // Acciones (Editar y Eliminar)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () => _editarProducto(producto),
                        borderRadius: BorderRadius.circular(6),
                        child: Padding(
                          padding: EdgeInsets.all(4),
                          child: Icon(Icons.edit_outlined, size: 18, color: AppColors.azulCobalto),
                        ),
                      ),
                      SizedBox(width: 8),
                      InkWell(
                        onTap: () => _eliminarProducto(producto),
                        borderRadius: BorderRadius.circular(6),
                        child: Padding(
                          padding: EdgeInsets.all(4),
                          child: Icon(Icons.delete_outline, size: 18, color: Colors.red[400]),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Placeholder elegante cuando no hay imagen
  Widget _buildImagePlaceholder(Producto producto) {
    final color = _getColorForTipo(producto.tipo);
    return Container(
      color: color.withOpacity(0.08),
      child: Center(
        child: Icon(
          _getIconForTipo(producto.tipo),
          size: 44,
          color: color.withOpacity(0.6),
        ),
      ),
    );
  }

  // Indicador visual de stock
  Widget _buildStockBadge(Producto producto, bool estaAgotado, bool stockBajo) {
    Color bg;
    Color text;
    IconData icon;
    String label;

    if (estaAgotado) {
      bg = Colors.red.withOpacity(0.12);
      text = Colors.red[800]!;
      icon = Icons.cancel_outlined;
      label = 'Sin existencias (0)';
    } else if (stockBajo) {
      bg = Colors.orange.withOpacity(0.15);
      text = Colors.orange[900]!;
      icon = Icons.warning_amber_rounded;
      label = 'Stock bajo (${producto.stock})';
    } else {
      bg = Colors.green.withOpacity(0.12);
      text = Colors.green[800]!;
      icon = Icons.check_circle_outline;
      label = 'Stock: ${producto.stock}';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: text),
          SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: text,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForTipo(String tipo) {
    switch (tipo) {
      case 'armazon':
        return Icons.visibility;
      case 'mica':
        return Icons.lens;
      case 'lente_contacto':
        return Icons.contactless;
      default:
        return Icons.shopping_bag;
    }
  }

  Color _getColorForTipo(String tipo) {
    switch (tipo) {
      case 'armazon':
        return Colors.blue;
      case 'mica':
        return Colors.green;
      case 'lente_contacto':
        return Colors.purple;
      default:
        return Colors.orange;
    }
  }

  String _getLabelForTipo(String tipo) {
    switch (tipo) {
      case 'armazon':
        return 'Armazón';
      case 'mica':
        return 'Mica';
      case 'lente_contacto':
        return 'Lente Contacto';
      default:
        return 'Accesorio';
    }
  }
}