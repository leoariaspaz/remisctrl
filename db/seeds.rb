# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
agencia 	= TipoRelleno.create(codigo: 1, descripcion: "Agencia")
Relleno.create(codigo: 1, descripcion: "Madre de Ciudades", sintetico: "MDC", habilitado: "t", tipo_relleno_id: agencia.id)

tipdoc 		= TipoRelleno.create(codigo: 2, descripcion: "Tipo de documento")
Relleno.create(codigo: 1, descripcion: "Documento Nacional de Indentidad", sintetico: "DNI", habilitado: "t", tipo_relleno_id: tipdoc.id)
Relleno.create(codigo: 2, descripcion: "Libreta Cívica", sintetico: "LC", habilitado: "t", tipo_relleno_id: tipdoc.id)
Relleno.create(codigo: 3, descripcion: "Pasaporte", sintetico: "Pspr", habilitado: "f", tipo_relleno_id: tipdoc.id)

estchofer = TipoRelleno.create(codigo: 3, descripcion: "Estado de Chofer")
Relleno.create(codigo: 1, descripcion: "Activo", sintetico: "A", habilitado: "t", tipo_relleno_id: estchofer.id)
Relleno.create(codigo: 2, descripcion: "Baja", sintetico: "B", habilitado: "t", tipo_relleno_id: estchofer.id)
Relleno.create(codigo: 3, descripcion: "Inactivo", sintetico: "I", habilitado: "t", tipo_relleno_id: estchofer.id)

estprop 	= TipoRelleno.create(codigo: 4, descripcion: "Estado de propietario")
Relleno.create(codigo: 1, descripcion: "Activo", sintetico: "A", habilitado: "t", tipo_relleno_id: estprop.id)
Relleno.create(codigo: 2, descripcion: "Baja", sintetico: "B", habilitado: "t", tipo_relleno_id: estprop.id)
Relleno.create(codigo: 3, descripcion: "Inactivo", sintetico: "I", habilitado: "t", tipo_relleno_id: estprop.id)

estmovil 	= TipoRelleno.create(codigo: 5, descripcion: "Estado de móvil")
Relleno.create(codigo: 1, descripcion: "Activo", sintetico: "A", habilitado: "t", tipo_relleno_id: estmovil.id)
Relleno.create(codigo: 2, descripcion: "Baja", sintetico: "B", habilitado: "t", tipo_relleno_id: estmovil.id)
Relleno.create(codigo: 3, descripcion: "En taller", sintetico: "T", habilitado: "t", tipo_relleno_id: estmovil.id)

tipoimg 	= TipoRelleno.create(codigo: 6, descripcion: "Tipo de imagen")
Relleno.create(codigo: 1, descripcion: "Documento Nacional de Identidad", sintetico: "DNI", habilitado: "t", tipo_relleno_id: tipoimg.id)
Relleno.create(codigo: 2, descripcion: "Cédula verde", sintetico: "CEDVER", habilitado: "t", tipo_relleno_id: tipoimg.id)
Relleno.create(codigo: 3, descripcion: "Carnet de conducir", sintetico: "CARNET", habilitado: "f", tipo_relleno_id: tipoimg.id)

estcta		= TipoRelleno.create(codigo: 7, descripcion: "Estado de cuenta")
Relleno.create(codigo: 1, descripcion: "Activo", sintetico: "A", habilitado: "t", tipo_relleno_id: estcta.id)
Relleno.create(codigo: 2, descripcion: "Inactivo", sintetico: "I", habilitado: "t", tipo_relleno_id: estcta.id)
Relleno.create(codigo: 3, descripcion: "Baja", sintetico: "B", habilitado: "t", tipo_relleno_id: estcta.id)

Configuracion.create(fecha_proceso: Date.today)

g = Usuario.create(nombre: "gabriel", password: "123456", password_confirmation: "123456")
a = Usuario.create(nombre: "admin", password: "abcdefg", password_confirmation: "abcdefg")
r = Rol.create(nombre: "Administrador")
r.usuarios << g
r.usuarios << a