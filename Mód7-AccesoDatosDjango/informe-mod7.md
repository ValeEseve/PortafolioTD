# **Informe: Integración de Django con Bases de Datos**

## **Proyecto: Sistema de Gestión de Biblioteca**

Este proyecto implementa un sistema completo de gestión de biblioteca que demuestra todas las competencias técnicas requeridas en la integración de Django con bases de datos.

---

## **1. Características Fundamentales de la Integración de Django con Bases de Datos**

### **¿Cómo Django se integra con diferentes sistemas de bases de datos?**

Django utiliza un **ORM (Object-Relational Mapping)** que actúa como capa de abstracción entre el código Python y la base de datos. Esto permite:

* **Soporte Multi-Motor**: SQLite, PostgreSQL, MySQL, MariaDB y Oracle sin cambiar el código de los modelos.
* **Configuración Centralizada**: Toda la configuración se realiza en `settings.py`.
* **Abstracción de Queries**: El ORM convierte métodos de Python en SQL nativo.

### **Gestión de Conexiones**

Django maneja automáticamente las conexiones mediante:

* **Connection Pooling**
* **Transacciones Automáticas** por request
* **Lazy Loading**: consultas solo cuando se necesitan

### **Configuración en settings.py**

```python
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR / 'db.sqlite3',
        'ATOMIC_REQUESTS': True,
        'CONN_MAX_AGE': 600,
    }
}
```

---

## **2. Modelos sin Relaciones (Entidades Independientes)**

### **Problemática**

Se requiere almacenar información básica de libros sin dependencias externas.

### **Implementación: Modelo Libro**

```python
from django.db import models

class Libro(models.Model):
    titulo = models.CharField(max_length=200)
    isbn = models.CharField(max_length=13, unique=True)
    precio = models.DecimalField(max_digits=10, decimal_places=2)
    stock = models.IntegerField(default=0)
    fecha_publicacion = models.DateField()

    def __str__(self):
        return self.titulo
```

**Características:**

* Tabla independiente sin llaves foráneas
* Validaciones integradas
* Representación legible mediante `__str__`

---

## **3. Modelos con Relaciones (Uno a Uno, Uno a Muchos, Muchos a Muchos)**

### **Problemática**

Se requiere modelar autores, libros, clientes y préstamos.

### **Implementación Completa**

```python
from django.db import models
from django.contrib.auth.models import User

# Relación Uno a Uno
class PerfilCliente(models.Model):
    usuario = models.OneToOneField(User, on_delete=models.CASCADE)
    telefono = models.CharField(max_length=15)
    direccion = models.TextField()
    fecha_registro = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Perfil de {self.usuario.username}"

# Entidades base
class Autor(models.Model):
    nombre = models.CharField(max_length=100)
    apellido = models.CharField(max_length=100)
    biografia = models.TextField(blank=True)
    fecha_nacimiento = models.DateField()

    class Meta:
        verbose_name_plural = "Autores"

    def __str__(self):
        return f"{self.nombre} {self.apellido}"

class Categoria(models.Model):
    nombre = models.CharField(max_length=50, unique=True)
    descripcion = models.TextField(blank=True)

    def __str__(self):
        return self.nombre

# Libro con relaciones Uno a Muchos y Muchos a Muchos
class Libro(models.Model):
    titulo = models.CharField(max_length=200)
    isbn = models.CharField(max_length=13, unique=True)
    autor = models.ForeignKey(Autor, on_delete=models.CASCADE, related_name='libros')
    categorias = models.ManyToManyField(Categoria, related_name='libros')
    precio = models.DecimalField(max_digits=10, decimal_places=2)
    stock = models.IntegerField(default=0)
    fecha_publicacion = models.DateField()
    descripcion = models.TextField(blank=True)

    def __str__(self):
        return self.titulo

# Relación Uno a Muchos
class Prestamo(models.Model):
    ESTADO_CHOICES = [
        ('activo', 'Activo'),
        ('devuelto', 'Devuelto'),
        ('vencido', 'Vencido'),
    ]

    cliente = models.ForeignKey(PerfilCliente, on_delete=models.CASCADE, related_name='prestamos')
    libro = models.ForeignKey(Libro, on_delete=models.CASCADE, related_name='prestamos')
    fecha_prestamo = models.DateTimeField(auto_now_add=True)
    fecha_devolucion_esperada = models.DateField()
    fecha_devolucion_real = models.DateField(null=True, blank=True)
    estado = models.CharField(max_length=10, choices=ESTADO_CHOICES, default='activo')

    def __str__(self):
        return f"{self.libro.titulo} - {self.cliente.usuario.username}"
```

---

## **Tipos de Relaciones Explicadas**

### **OneToOneField (PerfilCliente.usuario)**

* Un usuario tiene exactamente un perfil.
* `on_delete=CASCADE`: al borrar el usuario, se borra su perfil.

### **ForeignKey (Libro.autor, Prestamo.cliente)**

* Un autor puede escribir muchos libros.
* Un cliente puede tener varios préstamos.
* `related_name` permite acceder a los objetos relacionados, por ejemplo:

```python
autor.libros.all()
```

### **ManyToManyField (Libro.categorias)**

* Un libro puede tener muchas categorías y viceversa.
* Permite consultas dinámicas como:

```python
categoria.libros.all()
```

# 4. Migraciones para Propagación de Cambios

## ¿Qué son las migraciones?

Las migraciones son archivos **Python** que contienen instrucciones para modificar el esquema de la base de datos. Django los genera automáticamente al detectar cambios en los modelos.

## Proceso de Migración

### 1. Crear migraciones

```bash
python manage.py makemigrations
```

### 2. Ver el SQL que se ejecutará

```bash
python manage.py sqlmigrate biblioteca 0001
```

### 3. Aplicar migraciones

```bash
python manage.py migrate
```

---

## Ejemplo Práctico: Agregar Campo a Modelo Existente

### Modificación en `models.py`

```python
class Libro(models.Model):
    # ... campos existentes ...
    editorial = models.CharField(max_length=100, default='Sin Editorial')  # Campo nuevo
    paginas = models.IntegerField(default=0)  # Campo nuevo
```

### Comandos

Generar archivo de migración:

```bash
python manage.py makemigrations
```

Salida:

```
Migrations for 'biblioteca':
  biblioteca/migrations/0002_auto_20241204_1234.py
    - Add field editorial to libro
    - Add field paginas to libro
```

Aplicar migraciones:

```bash
python manage.py migrate
```

Salida:

```
Running migrations:
  Applying biblioteca.0002_auto_20241204_1234... OK
```

---

## Contenido de un Archivo de Migración

```python
# Generated by Django 4.2 on 2024-12-04 12:34

from django.db import migrations, models

class Migration(migrations.Migration):

    dependencies = [
        ('biblioteca', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='libro',
            name='editorial',
            field=models.CharField(default='Sin Editorial', max_length=100),
        ),
        migrations.AddField(
            model_name='libro',
            name='paginas',
            field=models.IntegerField(default=0),
        ),
    ]
```

---

# 5. Consultas de Filtrado y Consultas Personalizadas

## Consultas con el ORM

### Filtrado básico

```python
from biblioteca.models import Libro, Prestamo, Autor
from django.db.models import Q, Count, Avg, Sum

# 1. Obtener todos los libros
libros = Libro.objects.all()

# 2. Filtrar por autor
e
libros_garcia = Libro.objects.filter(autor__apellido='García')

# 3. Excluir libros sin stock
libros_disponibles = Libro.objects.exclude(stock=0)

# 4. Obtener un solo objeto
libro_especifico = Libro.objects.get(isbn='9781234567890')

# 5. Búsqueda con OR (Q objects)
libros_busqueda = Libro.objects.filter(
    Q(titulo__icontains='python') | Q(titulo__icontains='django')
)

# 6. Filtrado por rango de fechas
from datetime import datetime, timedelta
hace_30_dias = datetime.now() - timedelta(days=30)
prestamos_recientes = Prestamo.objects.filter(
    fecha_prestamo__gte=hace_30_dias
)

# 7. Consultas con relaciones (JOIN)
libros_con_prestamos = Libro.objects.filter(prestamos__estado='activo')

# 8. Agregaciones
estadisticas = Libro.objects.aggregate(
    total_libros=Count('id'),
    precio_promedio=Avg('precio'),
    total_stock=Sum('stock')
)

# 9. Anotaciones
autores_con_conteo = Autor.objects.annotate(
    cantidad_libros=Count('libros')
).filter(cantidad_libros__gte=3)

# 10. Ordenamiento
libros_ordenados = Libro.objects.order_by('-fecha_publicacion', 'titulo')

# 11. Limitar resultados
top_5_mas_caros = Libro.objects.order_by('-precio')[:5]
```

---

## Consultas SQL Personalizadas

### Método 1: `raw()` — SQL con mapeo a modelos

```python
libros = Libro.objects.raw('''
    SELECT l.id, l.titulo, l.precio, a.nombre || ' ' || a.apellido AS autor_completo
    FROM biblioteca_libro l
    INNER JOIN biblioteca_autor a ON l.autor_id = a.id
    WHERE l.precio > 20
    ORDER BY l.precio DESC
''')

for libro in libros:
    print(f"{libro.titulo} - ${libro.precio}")
```

---

### Método 2: cursor — SQL puro

```python
from django.db import connection

def obtener_prestamos_por_cliente():
    with connection.cursor() as cursor:
        cursor.execute('''
            SELECT
                u.username,
                COUNT(p.id) AS total_prestamos,
                COUNT(CASE WHEN p.estado = 'activo' THEN 1 END) AS activos
            FROM auth_user u
            INNER JOIN biblioteca_perfilcliente pc ON u.id = pc.usuario_id
            INNER JOIN biblioteca_prestamo p ON pc.id = p.cliente_id
            GROUP BY u.username
            HAVING COUNT(p.id) > 5
            ORDER BY total_prestamos DESC
        ''')

        resultados = cursor.fetchall()
        return [
            {
                'usuario': row[0],
                'total': row[1],
                'activos': row[2]
            }
            for row in resultados
        ]
```

---

### Método 3: `extra()` — Extender queries del ORM

```python
libros_complejos = Libro.objects.extra(
    select={'precio_multiplicado': 'precio * 1.25'},
    where=['stock > 0'],
    order_by=['-precio']
)
```

# 6. Aplicación Web MVC con Operaciones CRUD

## Arquitectura MVC en Django

Django utiliza el patrón **MTV (Model-Template-View)**, que funciona como la versión propia del patrón MVC tradicional.

* **Model**: Maneja datos y la lógica de negocio.
* **Template**: Equivale a la "Vista" de MVC; se encarga de la presentación.
* **View**: Actúa como el "Controlador"; dirige la lógica de la aplicación.

---

## **Implementación CRUD Completa para Libros**

### **views.py – Operaciones CRUD**

```python
from django.shortcuts import render, redirect, get_object_or_404
from django.contrib import messages
from django.contrib.auth.decorators import login_required
from .models import Libro, Autor, Categoria
from .forms import LibroForm

# CREATE - Crear nuevo libro
@login_required
def crear_libro(request):
    if request.method == 'POST':
        form = LibroForm(request.POST)
        if form.is_valid():
            libro = form.save()
            messages.success(request, f'Libro "{libro.titulo}" creado exitosamente.')
            return redirect('detalle_libro', pk=libro.pk)
    else:
        form = LibroForm()
    
    return render(request, 'biblioteca/libro_form.html', {'form': form, 'accion': 'Crear'})

# READ - Listar todos los libros
def listar_libros(request):
    libros = Libro.objects.select_related('autor').prefetch_related('categorias').all()
    
    # Filtros opcionales
    busqueda = request.GET.get('q')
    if busqueda:
        libros = libros.filter(
            Q(titulo__icontains=busqueda) |
            Q(autor__nombre__icontains=busqueda)
        )
    
    return render(request, 'biblioteca/libro_list.html', {'libros': libros})

# READ - Ver detalle de un libro
def detalle_libro(request, pk):
    libro = get_object_or_404(Libro, pk=pk)
    prestamos = libro.prestamos.select_related('cliente__usuario').order_by('-fecha_prestamo')[:5]
    
    return render(request, 'biblioteca/libro_detail.html', {
        'libro': libro,
        'prestamos_recientes': prestamos
    })

# UPDATE - Actualizar libro existente
@login_required
def actualizar_libro(request, pk):
    libro = get_object_or_404(Libro, pk=pk)
    
    if request.method == 'POST':
        form = LibroForm(request.POST, instance=libro)
        if form.is_valid():
            form.save()
            messages.success(request, f'Libro "{libro.titulo}" actualizado exitosamente.')
            return redirect('detalle_libro', pk=libro.pk)
    else:
        form = LibroForm(instance=libro)
    
    return render(request, 'biblioteca/libro_form.html', {
        'form': form,
        'libro': libro,
        'accion': 'Actualizar'
    })

# DELETE - Eliminar libro
@login_required
def eliminar_libro(request, pk):
    libro = get_object_or_404(Libro, pk=pk)
    
    if request.method == 'POST':
        titulo = libro.titulo
        libro.delete()
        messages.success(request, f'Libro "{titulo}" eliminado exitosamente.')
        return redirect('listar_libros')
    
    return render(request, 'biblioteca/libro_confirm_delete.html', {'libro': libro})
```

---

### **forms.py – Formularios**

```python
from django import forms
from .models import Libro, Categoria

class LibroForm(forms.ModelForm):
    categorias = forms.ModelMultipleChoiceField(
        queryset=Categoria.objects.all(),
        widget=forms.CheckboxSelectMultiple,
        required=False
    )
    
    class Meta:
        model = Libro
        fields = ['titulo', 'isbn', 'autor', 'categorias', 'precio', 'stock',
                  'fecha_publicacion', 'descripcion']
        widgets = {
            'fecha_publicacion': forms.DateInput(attrs={'type': 'date'}),
            'descripcion': forms.Textarea(attrs={'rows': 4}),
        }
    
    def clean_isbn(self):
        isbn = self.cleaned_data.get('isbn')
        if len(isbn) != 13:
            raise forms.ValidationError('El ISBN debe tener 13 caracteres.')
        return isbn
```

---

### **urls.py – Rutas**

```python
from django.urls import path
from . import views

urlpatterns = [
    path('libros/', views.listar_libros, name='listar_libros'),
    path('libros/crear/', views.crear_libro, name='crear_libro'),
    path('libros/<int:pk>/', views.detalle_libro, name='detalle_libro'),
    path('libros/<int:pk>/actualizar/', views.actualizar_libro, name='actualizar_libro'),
    path('libros/<int:pk>/eliminar/', views.eliminar_libro, name='eliminar_libro'),
]
```

---

### **Templates – libro_list.html**

```html
{% extends 'base.html' %}

{% block content %}
<div class="container mt-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1>Catálogo de Libros</h1>
        <a href="{% url 'crear_libro' %}" class="btn btn-primary">
            <i class="fas fa-plus"></i> Agregar Libro
        </a>
    </div>
    
    <!-- Barra de búsqueda -->
    <form method="get" class="mb-4">
        <div class="input-group">
            <input type="text" name="q" class="form-control"
                   placeholder="Buscar por título o autor..."
                   value="{{ request.GET.q }}">
            <button class="btn btn-outline-secondary" type="submit">Buscar</button>
        </div>
    </form>

    <table class="table table-striped">
        <thead>
            <tr>
                <th>Título</th>
                <th>Autor</th>
                <th>Categorías</th>
                <th>Acciones</th>
            </tr>
        </thead>
        <tbody>
            {% for libro in libros %}
            <tr>
                <td>{{ libro.titulo }}</td>
                <td>{{ libro.autor }}</td>
                <td>
                    {% for categoria in libro.categorias.all %}
                        <span class="badge bg-info me-1">{{ categoria.nombre }}</span>
                    {% endfor %}
                </td>
                <td>
                    <a href="{% url 'detalle_libro' libro.pk %}" class="btn btn-sm btn-info">Ver</a>
                    <a href="{% url 'actualizar_libro' libro.pk %}" class="btn btn-sm btn-warning">Editar</a>
                    <a href="{% url 'eliminar_libro' libro.pk %}" class="btn btn-sm btn-danger">Eliminar</a>
                </td>
            </tr>
            {% endfor %}
        </tbody>
    </table>
</div>
{% endblock %}
```

# 7. Aplicaciones Preinstaladas de Django

Django incluye varias aplicaciones integradas que facilitan el desarrollo y que se configuran en `INSTALLED_APPS` dentro de `settings.py`.

## Principales Aplicaciones Preinstaladas

---

## 1. django.contrib.admin

**Utilidad:** Panel de administración automático

**Características:**

* Interfaz web para gestionar modelos
* Filtros, búsqueda y paginación automáticos
* Personalización mediante clases `ModelAdmin`

**Ejemplo de personalización:**

```python
# admin.py
from django.contrib import admin
from .models import Libro, Autor, Prestamo, Categoria

@admin.register(Libro)
class LibroAdmin(admin.ModelAdmin):
    list_display = ('titulo', 'autor', 'isbn', 'precio', 'stock')
    list_filter = ('autor', 'categorias', 'fecha_publicacion')
    search_fields = ('titulo', 'isbn', 'autor__nombre')
    filter_horizontal = ('categorias',)

    fieldsets = (
        ('Información Básica', {
            'fields': ('titulo', 'isbn', 'autor')
        }),
        ('Detalles', {
            'fields': ('descripcion', 'categorias', 'fecha_publicacion')
        }),
        ('Inventario', {
            'fields': ('precio', 'stock'),
            'classes': ('collapse',)
        }),
    )

@admin.register(Autor)
class AutorAdmin(admin.ModelAdmin):
    list_display = ('nombre', 'apellido', 'fecha_nacimiento', 'cantidad_libros')
    search_fields = ('nombre', 'apellido')

    def cantidad_libros(self, obj):
        return obj.libros.count()
    cantidad_libros.short_description = 'Libros Publicados'

@admin.register(Prestamo)
class PrestamoAdmin(admin.ModelAdmin):
    list_display = ('libro', 'cliente', 'fecha_prestamo', 'estado', 'dias_prestado')
    list_filter = ('estado', 'fecha_prestamo')
    date_hierarchy = 'fecha_prestamo'

    def dias_prestado(self, obj):
        from django.utils import timezone
        if obj.fecha_devolucion_real:
            delta = obj.fecha_devolucion_real - obj.fecha_prestamo.date()
        else:
            delta = timezone.now().date() - obj.fecha_prestamo.date()
        return delta.days
    dias_prestado.short_description = 'Días de Préstamo'

admin.site.register(Categoria)
```

---

## 2. django.contrib.auth

**Utilidad:** Sistema de autenticación y autorización

**Características:**

* Modelos `User`, `Group`, `Permission`
* Login/logout y registro de usuarios
* Decoradores para proteger vistas

**Ejemplo de uso:**

```python
from django.contrib.auth.decorators import login_required, permission_required
from django.contrib.auth import authenticate, login, logout

@login_required
def vista_protegida(request):
    return render(request, 'protegida.html')

@permission_required('biblioteca.add_libro', raise_exception=True)
def agregar_libro_privilegiado(request):
    # Solo usuarios con permiso 'add_libro' pueden acceder
    pass

def login_view(request):
    if request.method == 'POST':
        username = request.POST['username']
        password = request.POST['password']
        user = authenticate(request, username=username, password=password)
        if user is not None:
            login(request, user)
            return redirect('home')
    return render(request, 'login.html')
```

---

## 3. django.contrib.sessions

**Utilidad:** Gestión de sesiones de usuario

**Características:**

* Almacena datos entre requests
* Soporte para cookies, base de datos y caché

**Ejemplo:**

```python
def agregar_al_carrito(request, libro_id):
    carrito = request.session.get('carrito', [])
    carrito.append(libro_id)
    request.session['carrito'] = carrito
    request.session.modified = True
```

---

## 4. django.contrib.messages

**Utilidad:** Sistema de mensajes flash

**Características:**

* Notificaciones de una sola vez
* Niveles: success, info, warning, error

**Ejemplo:**

```python
from django.contrib import messages

def procesar_prestamo(request):
    # ... lógica ...
    messages.success(request, 'Préstamo registrado exitosamente.')
    messages.warning(request, 'Recuerda devolver el libro en 15 días.')
```

---

## 5. django.contrib.staticfiles

**Utilidad:** Gestión de archivos estáticos (CSS, JS, imágenes)

**Características:**

* Recolección de archivos con `collectstatic`
* Servidos automáticamente en modo desarrollo

---

## 6. django.contrib.contenttypes

**Utilidad:** Framework de tipos de contenido

**Características:**

* Permite referencias genéricas a cualquier modelo
* Usado internamente por Django

---

## 7. django.contrib.humanize

**Utilidad:** Filtros para hacer datos más legibles

**Ejemplo:**

```html
{% load humanize %}
{{ libro.precio|intcomma }}           <!-- 1,234.56 -->
{{ prestamo.fecha_prestamo|naturaltime }}  <!-- "hace 3 días" -->
```

---

## Configuración en `settings.py`

```python
INSTALLED_APPS = [
    'django.contrib.admin',          # Panel de administración
    'django.contrib.auth',           # Autenticación
    'django.contrib.contenttypes',   # Framework de tipos
    'django.contrib.sessions',       # Gestión de sesiones
    'django.contrib.messages',       # Mensajes flash
    'django.contrib.staticfiles',    # Archivos estáticos
    'django.contrib.humanize',       # Filtros humanizados

    # Apps propias
    'biblioteca',
]
```

---

## Estructura del Proyecto Completo

```
biblioteca_django/
├── manage.py
├── requirements.txt
├── README.md
├── .gitignore
├── biblioteca_project/
│   ├── __init__.py
│   ├── settings.py
│   ├── urls.py
│   ├── wsgi.py
│   └── asgi.py
└── biblioteca/
    ├── __init__.py
    ├── admin.py           # Configuración del panel admin
    ├── apps.py
    ├── models.py          # Modelos de datos
    ├── views.py           # Lógica de vistas
    ├── forms.py           # Formularios
    ├── urls.py            # Rutas de la app
    ├── tests.py           # Pruebas unitarias
    ├── migrations/
    │   ├── __init__.py
    │   ├── 0001_initial.py
    │   └── 0002_auto_....py
    ├── templates/
    │   └── biblioteca/
    │       ├── base.html
    │       ├── libro_list.html
    │       ├── libro_detail.html
    │       ├── libro_form.html
    │       └── libro_confirm_delete.html
    └── static/
        └── biblioteca/
            ├── css/
            ├── js/
            └── img/

```


