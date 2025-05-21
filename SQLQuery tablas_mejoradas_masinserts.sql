-- CREAR BASE DE DATOS

CREATE DATABASE proyectos_arquitectura1033;
GO
USE proyectos_arquitectura1033;
GO

-- ======================
-- 1. UBICACIONES
-- ======================c

CREATE TABLE paises (
    id_pais INT IDENTITY(1,1) NOT NULL,
    nombre VARCHAR(40) NOT NULL,
    CONSTRAINT pk_paises PRIMARY KEY (id_pais)
);

CREATE TABLE provincias (
    id_provincia INT IDENTITY(1,1) NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    id_pais INT NOT NULL,
    CONSTRAINT pk_provincias PRIMARY KEY (id_provincia),
    CONSTRAINT fk_provincias_paises FOREIGN KEY (id_pais) REFERENCES paises(id_pais)
);

CREATE TABLE localidades (
    id_localidad INT IDENTITY(1,1) NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    id_provincia INT NOT NULL,
    CONSTRAINT pk_localidades PRIMARY KEY (id_localidad),
    CONSTRAINT fk_localidades_provincias FOREIGN KEY (id_provincia) REFERENCES provincias(id_provincia)
);

-- ======================
-- 2. PERSONAS Y DOCUMENTOS
-- ======================

CREATE TABLE tipos_documento (
    id_tipo_documento INT IDENTITY(1,1) NOT NULL,
    descripcion VARCHAR(50) NOT NULL,
    CONSTRAINT pk_tipos_documento PRIMARY KEY (id_tipo_documento)
);



CREATE TABLE direcciones (
    id_direccion INT IDENTITY(1,1) NOT NULL,
    calle VARCHAR(60) NOT NULL,
    numero VARCHAR(10) NOT NULL,
    id_localidad INT NOT NULL,
    CONSTRAINT pk_direcciones PRIMARY KEY (id_direccion),
    CONSTRAINT fk_direcciones_localidades FOREIGN KEY (id_localidad) REFERENCES localidades(id_localidad)
);

-- ======================
-- 3. ARQUITECTOS
-- ======================



CREATE TABLE tipos_arquitectos (
    id_tipo_arquitecto INT IDENTITY(1,1) NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    descripcion VARCHAR(100),
    CONSTRAINT pk_tipos_arquitectos PRIMARY KEY (id_tipo_arquitecto)
);

CREATE TABLE arquitectos (
    matricula_habilitante VARCHAR(50) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    id_tipo_arquitecto INT NOT NULL,
    documento VARCHAR(20) NOT NULL,
    id_tipo_documento INT NOT NULL,
    id_direccion INT NOT NULL,
    telefono VARCHAR(20),
    email VARCHAR(50),
    CONSTRAINT pk_arquitectos PRIMARY KEY (matricula_habilitante),
    CONSTRAINT fk_arquitectos_tipos_arquitectos FOREIGN KEY (id_tipo_arquitecto) REFERENCES tipos_arquitectos(id_tipo_arquitecto),
    CONSTRAINT fk_arquitectos_tipos_documento FOREIGN KEY (id_tipo_documento) REFERENCES tipos_documento(id_tipo_documento),
    CONSTRAINT fk_arquitectos_direcciones FOREIGN KEY (id_direccion) REFERENCES direcciones(id_direccion)
);

-- ======================
-- 4. CLIENTES Y TIPOS
-- ======================

CREATE TABLE tipo_clientes (
    id_tipo_cliente INT NOT NULL,
    descripcion VARCHAR(50) NOT NULL,
    CONSTRAINT pk_tipo_clientes PRIMARY KEY (id_tipo_cliente)
);

CREATE TABLE clientes (
    id_cliente INT IDENTITY(1,1) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    razon_social VARCHAR(100),
    cuit VARCHAR(20),
    cuil VARCHAR(20),
    id_direccion INT NOT NULL,
    telefono VARCHAR(20),
    email VARCHAR(50),
    id_tipo_cliente INT NOT NULL,
    fecha_alta DATE,
    estado_cuenta VARCHAR(20),
    CONSTRAINT pk_clientes PRIMARY KEY (id_cliente),
    CONSTRAINT fk_clientes_domicilios FOREIGN KEY (id_direccion) REFERENCES direcciones(id_direccion),
    CONSTRAINT fk_clientes_tipo_clientes FOREIGN KEY (id_tipo_cliente) REFERENCES tipo_clientes(id_tipo_cliente)
);

-- ======================
-- 5. PROYECTOS Y PLANOS
-- ======================

CREATE TABLE tipos_proyectos (
    id_tipo_proyecto INT IDENTITY(1,1) NOT NULL,
    descripcion VARCHAR(50) NOT NULL,
    CONSTRAINT pk_tipos_proyectos PRIMARY KEY (id_tipo_proyecto)
);

CREATE TABLE proyectos (
    id_proyecto INT IDENTITY(1,1) NOT NULL,
    id_cliente INT NOT NULL,
    numero_catastral VARCHAR(50),
    id_direccion INT NOT NULL,
    superficie_terreno DECIMAL(10,2),
    superficie_proyecto DECIMAL(10,2),
    fecha_inicio DATE,
    fecha_fin DATE,
    fecha_fin_estimado DATE,
    id_tipo_proyecto INT NOT NULL,
    precio_m2 DECIMAL(10,2),
    CONSTRAINT pk_proyectos PRIMARY KEY (id_proyecto),
    CONSTRAINT fk_proyectos_clientes FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    CONSTRAINT fk_proyectos_tipos_proyectos FOREIGN KEY (id_tipo_proyecto) REFERENCES tipos_proyectos(id_tipo_proyecto),
	CONSTRAINT fk_proyectos_direcciones FOREIGN KEY (id_direccion) REFERENCES direcciones(id_direccion)

);

CREATE TABLE tipos_planos (
    id_tipo_plano INT IDENTITY(1,1) NOT NULL,
    descripcion VARCHAR(100) NOT NULL,
    CONSTRAINT pk_tipos_planos PRIMARY KEY (id_tipo_plano)
);


CREATE TABLE estados_planos (
    id_estado_plano INT IDENTITY(1,1) NOT NULL,
    descripcion VARCHAR(100) NOT NULL,
    CONSTRAINT pk_estados_planos PRIMARY KEY (id_estado_plano)
);

CREATE TABLE planos (
    id_plano INT IDENTITY(1,1) NOT NULL,
    id_proyecto INT NOT NULL, 
    fecha_creacion DATE NOT NULL,
    hora_creacion TIME NOT NULL,
    id_tipo_plano INT NOT NULL, 
    id_estado_plano INT NOT NULL, 
    descripcion VARCHAR(200),
    CONSTRAINT pk_planos PRIMARY KEY (id_plano),
    CONSTRAINT fk_planos_proyecto FOREIGN KEY (id_proyecto) REFERENCES proyectos(id_proyecto),
    CONSTRAINT fk_planos_tipo FOREIGN KEY (id_tipo_plano) REFERENCES tipos_planos(id_tipo_plano),
    CONSTRAINT fk_planos_estado FOREIGN KEY (id_estado_plano) REFERENCES estados_planos(id_estado_plano)
);

-- ======================
-- 7. FACTURACIÓN Y PAGOS
-- ======================

CREATE TABLE tipos_pagos (
    id_tipo_pago INT IDENTITY(1,1) NOT NULL,
    descripcion VARCHAR(50) NOT NULL,
    CONSTRAINT pk_tipos_pagos PRIMARY KEY (id_tipo_pago)
);

CREATE TABLE facturas (
    id_factura INT IDENTITY(1,1) NOT NULL,
    id_cliente INT NOT NULL,
    fecha DATE NOT NULL,
    total DECIMAL(12,2) NOT NULL,
    CONSTRAINT pk_facturas PRIMARY KEY (id_factura),
    CONSTRAINT fk_facturas_clientes FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

CREATE TABLE detalle_facturas (
    id_detalle_factura INT IDENTITY(1,1) NOT NULL,
    id_factura INT NOT NULL,
    id_proyecto INT NOT NULL,
    descripcion VARCHAR(100),
    CONSTRAINT pk_detalle_facturas PRIMARY KEY (id_detalle_factura),
    CONSTRAINT fk_detalle_facturas_facturas FOREIGN KEY (id_factura) REFERENCES facturas(id_factura),
    CONSTRAINT fk_detalle_facturas_proyectos FOREIGN KEY (id_proyecto) REFERENCES proyectos(id_proyecto)
);


CREATE TABLE cuotas (
    id_cuota INT IDENTITY(1,1) NOT NULL,
    id_factura INT NOT NULL,
    numero_cuota INT NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    fecha_vencimiento DATE NOT NULL,
	estado_cuota BIT NOT NULL,
    CONSTRAINT pk_cuotas PRIMARY KEY (id_cuota),
    CONSTRAINT fk_cuotas_facturas FOREIGN KEY (id_factura) REFERENCES facturas(id_factura),
);

CREATE TABLE recibos (
    id_recibo INT IDENTITY(1,1) NOT NULL,
    id_cuota INT NOT NULL,
    fecha_pago DATE NOT NULL,
    monto DECIMAL(12,2) NOT NULL,
    forma_pago VARCHAR(50),
    observaciones VARCHAR(100),
    CONSTRAINT pk_recibos PRIMARY KEY (id_recibo),
    CONSTRAINT fk_recibos_cuotas FOREIGN KEY (id_cuota) REFERENCES cuotas(id_cuota)
);

CREATE TABLE factura_tipos_pago (
    id_factura INT NOT NULL,
    id_tipo_pago INT NOT NULL,
    monto_pago DECIMAL(12,2) NOT NULL,
    CONSTRAINT pk_factura_tipos_pago PRIMARY KEY (id_factura, id_tipo_pago),
    CONSTRAINT fk_factura_tipos_pago_facturas FOREIGN KEY (id_factura) REFERENCES facturas(id_factura),
    CONSTRAINT fk_factura_tipos_pago_tipos_pagos FOREIGN KEY (id_tipo_pago) REFERENCES tipos_pagos(id_tipo_pago)
);

-- ======================
-- 9. SOCIOS
-- ======================

CREATE TABLE niveles_socios (
    id_nivel_socio INT IDENTITY(1,1) NOT NULL,
    descripcion VARCHAR(50) NOT NULL,
    beneficio VARCHAR(50),
    CONSTRAINT pk_niveles_socios PRIMARY KEY (id_nivel_socio)
);

CREATE TABLE socios (
    id_socio INT IDENTITY(1,1) NOT NULL,
    razon_social VARCHAR(100) NOT NULL,
    cuil VARCHAR(20) NOT NULL,
	id_tipo_documento INT NOT NULL,
    id_direccion INT NOT NULL,
    fecha_incorporacion DATE NOT NULL,
    id_nivel_socio INT NOT NULL,
    CONSTRAINT pk_socios PRIMARY KEY (id_socio),
    CONSTRAINT fk_socios_niveles_socios FOREIGN KEY (id_nivel_socio) REFERENCES niveles_socios(id_nivel_socio)
);

CREATE TABLE socios_proyectos (
    id_socio_proyecto INT IDENTITY(1,1) NOT NULL,
    id_socio INT NOT NULL,
    id_proyecto INT NOT NULL,
    actividad VARCHAR(100),
    CONSTRAINT pk_socios_proyectos PRIMARY KEY (id_socio_proyecto),
    CONSTRAINT fk_socios_proyectos_socios FOREIGN KEY (id_socio) REFERENCES socios(id_socio),
    CONSTRAINT fk_socios_proyectos_proyectos FOREIGN KEY (id_proyecto) REFERENCES proyectos(id_proyecto)
);

-- ======================
-- 10. ETAPAS DE PROYECTOS
-- ======================

CREATE TABLE estado_etapas (
    id_estado_etapa INT IDENTITY(1,1) NOT NULL,
    descripcion VARCHAR(50) NOT NULL,
    CONSTRAINT pk_estado_etapas PRIMARY KEY (id_estado_etapa)
);

CREATE TABLE etapas_proyecto (
    id_etapa_proyecto INT IDENTITY(1,1) NOT NULL,
    id_proyecto INT NOT NULL,
    id_estado_etapa INT NOT NULL,
    fecha_inicio DATE,
    fecha_estimada_finalizacion DATE,
    fecha_finalizacion DATE,
    id_equipo VARCHAR(50),
    facturada BIT NOT NULL DEFAULT 0,
    id_factura INT NULL,
    CONSTRAINT pk_etapas_proyecto PRIMARY KEY (id_etapa_proyecto),
    CONSTRAINT fk_etapas_proyecto_proyectos FOREIGN KEY (id_proyecto) REFERENCES proyectos(id_proyecto),
    CONSTRAINT fk_etapas_proyecto_estado_etapas FOREIGN KEY (id_estado_etapa) REFERENCES estado_etapas(id_estado_etapa),
    CONSTRAINT fk_etapas_proyecto_facturas FOREIGN KEY (id_factura) REFERENCES facturas(id_factura)
);


-- ======================
-- 11. Contactos
-- ======================

CREATE TABLE tipos_contactos (
    id_tipo_contacto INT IDENTITY(1,1) NOT NULL,
    descripcion VARCHAR(100) NOT NULL,
    CONSTRAINT pk_tipos_contactos PRIMARY KEY (id_tipo_contacto)
);

CREATE TABLE contactos (
    id_contacto INT IDENTITY(1,1) NOT NULL,
    contacto VARCHAR(100) NOT NULL,
    id_tipo_contacto INT NOT NULL,
    matricula_arquitecto VARCHAR(50) NULL,
    id_socio INT NULL,
    id_cliente INT NULL,
    CONSTRAINT pk_contactos PRIMARY KEY (id_contacto),
    CONSTRAINT fk_contactos_tipo FOREIGN KEY (id_tipo_contacto) REFERENCES tipos_contactos(id_tipo_contacto),
    CONSTRAINT fk_contactos_arquitecto FOREIGN KEY (matricula_arquitecto) REFERENCES arquitectos(matricula_habilitante),
    CONSTRAINT fk_contactos_socio FOREIGN KEY (id_socio) REFERENCES socios(id_socio),
    CONSTRAINT fk_contactos_cliente FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
);


-- ================
-- NUEVAS TABLAS
-- ================

-- Tabla intermedia: Arquitectos en proyectos
CREATE TABLE arquitectos_proyectos (
    id_arquitecto_proyecto INT IDENTITY(1,1) NOT NULL,
    matricula_arquitecto VARCHAR(50) NOT NULL,
    id_proyecto INT NOT NULL,
    rol VARCHAR(100),
    CONSTRAINT pk_arquitectos_proyectos PRIMARY KEY (id_arquitecto_proyecto),
    CONSTRAINT fk_arquitectos_proyectos_arquitecto FOREIGN KEY (matricula_arquitecto) REFERENCES arquitectos(matricula_habilitante),
    CONSTRAINT fk_arquitectos_proyectos_proyecto FOREIGN KEY (id_proyecto) REFERENCES proyectos(id_proyecto)
);

-- Tabla intermedia: Formas de pago usadas en recibos
CREATE TABLE formas_pago_recibos (
    id_recibo INT NOT NULL,
    id_tipo_pago INT NOT NULL,
    monto_pago DECIMAL(12,2) NOT NULL,
    CONSTRAINT pk_formas_pago_recibos PRIMARY KEY (id_recibo, id_tipo_pago),
    CONSTRAINT fk_formas_pago_recibos_recibos FOREIGN KEY (id_recibo) REFERENCES recibos(id_recibo),
    CONSTRAINT fk_formas_pago_recibos_tipo_pago FOREIGN KEY (id_tipo_pago) REFERENCES tipos_pagos(id_tipo_pago)
);

-- Rubros de gasto posibles
CREATE TABLE rubros_gastos (
    id_rubro INT IDENTITY(1,1) NOT NULL,
    descripcion VARCHAR(100) NOT NULL,
    CONSTRAINT pk_rubros_gastos PRIMARY KEY (id_rubro)
);

-- Gastos por etapa de proyecto
CREATE TABLE gastos_etapas (
    id_gasto_etapa INT IDENTITY(1,1) NOT NULL,
    id_etapa_proyecto INT NOT NULL,
    id_rubro INT NOT NULL,
    descripcion VARCHAR(200),
    monto DECIMAL(12,2) NOT NULL,
    fecha DATE NOT NULL,
    CONSTRAINT pk_gastos_etapas PRIMARY KEY (id_gasto_etapa),
    CONSTRAINT fk_gastos_etapas_etapa FOREIGN KEY (id_etapa_proyecto) REFERENCES etapas_proyecto(id_etapa_proyecto),
    CONSTRAINT fk_gastos_etapas_rubro FOREIGN KEY (id_rubro) REFERENCES rubros_gastos(id_rubro)
);

-- Grado de avance por etapa
CREATE TABLE avance_etapas (
    id_avance INT IDENTITY(1,1) NOT NULL,
    id_etapa_proyecto INT NOT NULL,
    porcentaje_avance DECIMAL(5,2) NOT NULL,
    fecha_registro DATE NOT NULL,
    observaciones VARCHAR(200),
    CONSTRAINT pk_avance_etapas PRIMARY KEY (id_avance),
    CONSTRAINT fk_avance_etapas_etapa FOREIGN KEY (id_etapa_proyecto) REFERENCES etapas_proyecto(id_etapa_proyecto)
);


--INSERT TABLA PAISES
INSERT INTO paises (id_pais, nombre) VALUES (1, 'Argentina');
INSERT INTO paises (id_pais, nombre) VALUES (2, 'Brasil');
INSERT INTO paises (id_pais, nombre) VALUES (3, 'Chile');
INSERT INTO paises (id_pais, nombre) VALUES (4, 'Uruguay');
INSERT INTO paises (id_pais, nombre) VALUES (5, 'Paraguay');
INSERT INTO paises (id_pais, nombre) VALUES (6, 'Peru');
INSERT INTO paises (id_pais, nombre) VALUES (7, 'Colombia');
INSERT INTO paises (id_pais, nombre) VALUES (8, 'Ecuador');
INSERT INTO paises (id_pais, nombre) VALUES (9, 'Mexico');
INSERT INTO paises (id_pais, nombre) VALUES (10,'Estados Unidos');

-- tabla provincias
INSERT INTO provincias (id_provincia, nombre, id_pais) VALUES (1, 'Buenos Aires', 1);
INSERT INTO provincias (id_provincia, nombre, id_pais) VALUES (2, 'Catamarca', 1);
INSERT INTO provincias (id_provincia, nombre, id_pais) VALUES (3, 'Chaco', 1);
INSERT INTO provincias (id_provincia, nombre, id_pais) VALUES (4, 'Chubut', 1);
INSERT INTO provincias (id_provincia, nombre, id_pais) VALUES (5, 'Cordoba', 1);
INSERT INTO provincias (id_provincia, nombre, id_pais) VALUES (6, 'Corrientes', 1);
INSERT INTO provincias (id_provincia, nombre, id_pais) VALUES (7, 'Entre Rios', 1);
INSERT INTO provincias (id_provincia, nombre, id_pais) VALUES (8, 'Formosa', 1);
INSERT INTO provincias (id_provincia, nombre, id_pais) VALUES (9, 'Jujuy', 1);
INSERT INTO provincias (id_provincia, nombre, id_pais) VALUES (10, 'La Pampa', 1);
INSERT INTO provincias (id_provincia, nombre, id_pais) VALUES (11, 'La Rioja', 1);
INSERT INTO provincias (id_provincia, nombre, id_pais) VALUES (12, 'Mendoza', 1);
INSERT INTO provincias (id_provincia, nombre, id_pais) VALUES (13, 'Misiones', 1);
INSERT INTO provincias (id_provincia, nombre, id_pais) VALUES (14, 'Neuquen', 1);
INSERT INTO provincias (id_provincia, nombre, id_pais) VALUES (15, 'Rio Negro', 1);
INSERT INTO provincias (id_provincia, nombre, id_pais) VALUES (16, 'Salta', 1);
INSERT INTO provincias (id_provincia, nombre, id_pais) VALUES (17, 'San Juan', 1);
INSERT INTO provincias (id_provincia, nombre, id_pais) VALUES (18, 'San Luis', 1);
INSERT INTO provincias (id_provincia, nombre, id_pais) VALUES (19, 'Santa Cruz', 1);
INSERT INTO provincias (id_provincia, nombre, id_pais) VALUES (20, 'Santa Fe', 1);
INSERT INTO provincias (id_provincia, nombre, id_pais) VALUES (21, 'Santiago del Estero', 1);
INSERT INTO provincias (id_provincia, nombre, id_pais) VALUES (22, 'Tierra del Fuego', 1);
INSERT INTO provincias (id_provincia, nombre, id_pais) VALUES (23, 'Tucuman', 1);
INSERT INTO provincias (id_provincia, nombre, id_pais) VALUES (24, 'Sao Paulo', 2);
INSERT INTO provincias (id_provincia, nombre, id_pais) VALUES (25, 'Rio de Janeiro', 2);
INSERT INTO provincias (id_provincia, nombre, id_pais) VALUES (26, 'Bahia', 2);
INSERT INTO provincias (id_provincia, nombre, id_pais) VALUES (27, 'Minas Gerais', 2);
INSERT INTO provincias (id_provincia, nombre, id_pais) VALUES (28, 'Santiago', 3);
INSERT INTO provincias (id_provincia, nombre, id_pais) VALUES (29, 'Valparaiso', 3);
INSERT INTO provincias (id_provincia, nombre, id_pais) VALUES (30, 'Biobio', 3);
INSERT INTO provincias (id_provincia, nombre, id_pais) VALUES (31, 'Montevideo', 4);
INSERT INTO provincias (id_provincia, nombre, id_pais) VALUES (32, 'Canelones', 4);
INSERT INTO provincias (id_provincia, nombre, id_pais) VALUES (33, 'Maldonado', 4);
INSERT INTO provincias (id_provincia, nombre, id_pais) VALUES (34, 'Asuncion', 5);
INSERT INTO provincias (id_provincia, nombre, id_pais) VALUES (35, 'Central', 5);
INSERT INTO provincias (id_provincia, nombre, id_pais) VALUES (36, 'Alto Parana', 5);
INSERT INTO provincias (id_provincia, nombre, id_pais) VALUES (37, 'Lima', 6);
INSERT INTO provincias (id_provincia, nombre, id_pais) VALUES (38, 'Cusco', 6);
INSERT INTO provincias (id_provincia, nombre, id_pais) VALUES (39, 'Arequipa', 6);
INSERT INTO provincias (id_provincia, nombre, id_pais) VALUES (40, 'Bogota', 7);
INSERT INTO provincias (id_provincia, nombre, id_pais) VALUES (41, 'Antioquia', 7);
INSERT INTO provincias (id_provincia, nombre, id_pais) VALUES (42, 'Valle del Cauca', 7);
INSERT INTO provincias (id_provincia, nombre, id_pais) VALUES (43, 'Quito', 8);
INSERT INTO provincias (id_provincia, nombre, id_pais) VALUES (44, 'Guayas', 8);
INSERT INTO provincias (id_provincia, nombre, id_pais) VALUES (45, 'Manabi', 8);
INSERT INTO provincias (id_provincia, nombre, id_pais) VALUES (46, 'CDMX', 9);
INSERT INTO provincias (id_provincia, nombre, id_pais) VALUES (47, 'Jalisco', 9);
INSERT INTO provincias (id_provincia, nombre, id_pais) VALUES (48, 'Nuevo Leon', 9);
INSERT INTO provincias (id_provincia, nombre, id_pais) VALUES (49, 'Yucatan', 9);
INSERT INTO provincias (id_provincia, nombre, id_pais) VALUES (50, 'California', 10);
INSERT INTO provincias (id_provincia, nombre, id_pais) VALUES (51, 'Texas', 10);
INSERT INTO provincias (id_provincia, nombre, id_pais) VALUES (52, 'Florida', 10);
INSERT INTO provincias (id_provincia, nombre, id_pais) VALUES (53, 'New York', 10);

--INSERT TABLA LOCALIDADES
INSERT INTO localidades (id_localidad, nombre, id_provincia) VALUES (1, 'La Plata', 1);
INSERT INTO localidades (id_localidad, nombre, id_provincia) VALUES (2, 'Mar del Plata', 1);
INSERT INTO localidades (id_localidad, nombre, id_provincia) VALUES (3, 'Cordoba Capital', 2);
INSERT INTO localidades (id_localidad, nombre, id_provincia) VALUES (4, 'Villa Carlos Paz', 2);
INSERT INTO localidades (id_localidad, nombre, id_provincia) VALUES (5, 'Resistencia', 3);
INSERT INTO localidades (id_localidad, nombre, id_provincia) VALUES (6, 'Presidencia Roque Saenz Pena', 3);
INSERT INTO localidades (id_localidad, nombre, id_provincia) VALUES (7, 'Rawson', 4);
INSERT INTO localidades (id_localidad, nombre, id_provincia) VALUES (8, 'Comodoro Rivadavia', 4);
INSERT INTO localidades (id_localidad, nombre, id_provincia) VALUES (9, 'Parana', 5);
INSERT INTO localidades (id_localidad, nombre, id_provincia) VALUES (10, 'Concordia', 5);
INSERT INTO localidades (id_localidad, nombre, id_provincia) VALUES (11, 'Formosa', 6);
INSERT INTO localidades (id_localidad, nombre, id_provincia) VALUES (12, 'Clorinda', 6);
INSERT INTO localidades (id_localidad, nombre, id_provincia) VALUES (13, 'San Salvador de Jujuy', 7);
INSERT INTO localidades (id_localidad, nombre, id_provincia) VALUES (14, 'Palpala', 7);
INSERT INTO localidades (id_localidad, nombre, id_provincia) VALUES (15, 'Santa Rosa', 8);
INSERT INTO localidades (id_localidad, nombre, id_provincia) VALUES (16, 'General Pico', 8);
INSERT INTO localidades (id_localidad, nombre, id_provincia) VALUES (17, 'La Rioja', 9);
INSERT INTO localidades (id_localidad, nombre, id_provincia) VALUES (18, 'Chilecito', 9);
INSERT INTO localidades (id_localidad, nombre, id_provincia) VALUES (19, 'Mendoza', 10);
INSERT INTO localidades (id_localidad, nombre, id_provincia) VALUES (20, 'San Rafael', 10);
INSERT INTO localidades (id_localidad, nombre, id_provincia) VALUES (21, 'Posadas', 11);
INSERT INTO localidades (id_localidad, nombre, id_provincia) VALUES (22, 'Obera', 11);
INSERT INTO localidades (id_localidad, nombre, id_provincia) VALUES (23, 'Neuquen Capital', 12);
INSERT INTO localidades (id_localidad, nombre, id_provincia) VALUES (24, 'Cutral Co', 12);
INSERT INTO localidades (id_localidad, nombre, id_provincia) VALUES (25, 'Viedma', 13);
INSERT INTO localidades (id_localidad, nombre, id_provincia) VALUES (26, 'Bariloche', 13);
INSERT INTO localidades (id_localidad, nombre, id_provincia) VALUES (27, 'Salta Capital', 14);
INSERT INTO localidades (id_localidad, nombre, id_provincia) VALUES (28, 'Oran', 14);
INSERT INTO localidades (id_localidad, nombre, id_provincia) VALUES (29, 'San Juan Capital', 15);
INSERT INTO localidades (id_localidad, nombre, id_provincia) VALUES (30, 'Rawson (SJ)', 15);
INSERT INTO localidades (id_localidad, nombre, id_provincia) VALUES (31, 'San Luis', 16);
INSERT INTO localidades (id_localidad, nombre, id_provincia) VALUES (32, 'Villa Mercedes', 16);
INSERT INTO localidades (id_localidad, nombre, id_provincia) VALUES (33, 'Rio Gallegos', 17);
INSERT INTO localidades (id_localidad, nombre, id_provincia) VALUES (34, 'Caleta Olivia', 17);
INSERT INTO localidades (id_localidad, nombre, id_provincia) VALUES (35, 'Santa Fe Capital', 18);
INSERT INTO localidades (id_localidad, nombre, id_provincia) VALUES (36, 'Rosario', 18);
INSERT INTO localidades (id_localidad, nombre, id_provincia) VALUES (37, 'Santiago del Estero', 19);
INSERT INTO localidades (id_localidad, nombre, id_provincia) VALUES (38, 'La Banda', 19);
INSERT INTO localidades (id_localidad, nombre, id_provincia) VALUES (39, 'San Miguel de Tucuman', 20);
INSERT INTO localidades (id_localidad, nombre, id_provincia) VALUES (40, 'Tafi Viejo', 20);
INSERT INTO localidades (id_localidad, nombre, id_provincia) VALUES (41, 'Ushuaia', 21);
INSERT INTO localidades (id_localidad, nombre, id_provincia) VALUES (42, 'Rio Grande', 21);
INSERT INTO localidades (id_localidad, nombre, id_provincia) VALUES (43, 'Ciudad Autonoma de Buenos Aires', 22);
INSERT INTO localidades (id_localidad, nombre, id_provincia) VALUES (44, 'Puerto Madero', 22);
INSERT INTO localidades (id_localidad, nombre, id_provincia) VALUES (45, 'Ciudad de Buenos Aires', 23);
INSERT INTO localidades (id_localidad, nombre, id_provincia) VALUES (46, 'Barracas', 23);

--INSERT TABLA TIPOS DOCUMENTOS
INSERT INTO tipos_documento (id_tipo_documento, descripcion) VALUES(1,'DNI');
INSERT INTO tipos_documento (id_tipo_documento, descripcion) VALUES(2,'Pasaporte');
INSERT INTO tipos_documento (id_tipo_documento, descripcion) VALUES(3,'Licencia de Conducir');
INSERT INTO tipos_documento (id_tipo_documento, descripcion) VALUES(4,'Cedula Profesional');
INSERT INTO tipos_documento (id_tipo_documento, descripcion) VALUES(5,'Credencial para Votar');
INSERT INTO tipos_documento (id_tipo_documento, descripcion) VALUES(6,'Libreta Civica');
INSERT INTO tipos_documento (id_tipo_documento, descripcion) VALUES(7,'Libreta de Enrolamiento');
INSERT INTO tipos_documento (id_tipo_documento, descripcion) VALUES(8,'Cedula de Extranjeria');
INSERT INTO tipos_documento (id_tipo_documento, descripcion) VALUES(9,'Certificado Unico de Discapacidad');
INSERT INTO tipos_documento (id_tipo_documento, descripcion) VALUES(9,'Acta de Nacimiento');
INSERT INTO tipos_documento (id_tipo_documento, descripcion) VALUES(9,'Certificado Unico de Discapacidad');
INSERT INTO tipos_documento (id_tipo_documento, descripcion) VALUES(9,'Certificado Unico de Discapacidad');
INSERT INTO tipos_documento (id_tipo_documento, descripcion) VALUES(9,'Certificado Unico de Discapacidad');

--INSERT TABLA DIRECCIONES
INSERT INTO direcciones (id_direccion, calle, numero, id_localidad)
		VALUES();

--INSERT TABLA TIPOS ARQUITECTOS
INSERT INTO tipos_arquitectos (id_tipo_arquitecto, tipo, descripcion)
		VALUES();

-- INSERT TABLA ARQUITECTOS
INSERT INTO arquitectos (matricula_habilitante, nombre, apellido, id_tipo_arquitecto, documento, id_tipo_documento, id_direccion, telefono, email)
                  VALUES();

-- INSERT TABLA TIPO CLIENTES
INSERT INTO tipo_clientes (id_tipo_cliente, descripcion)
		VALUES();

--INSERT TABLA CLIENTES
INSERT INTO clientes (id_cliente, nombre, razon_social, cuit, cuil, id_direccion, telefono, email, id_tipo_cliente, fecha_alta, estado_cuenta)
		VALUES();

--INSERT TABLA TIPOS PROYECTOS
INSERT INTO tipos_proyectos (id_tipo_proyecto, descripcion)
VALUES();

--INSERT TABLA PROYECTOS
INSERT INTO proyectos (id_proyecto, id_cliente, id_plano, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
VALUES();

--INSERT TABLA TIPOS PLANOS
INSERT INTO tipos_planos (id_tipo_plano, descripcion)
VALUES();

--INSERT TABLA ESTADO PLANOS
INSERT INTO estados_planos (id_estado_plano, descripcion)
VALUES();

--INSERT TABLA PLANOS
INSERT INTO planos (id_plano, id_proyecto, fecha_creacion, hora_creacion, id_tipo_plano, id_estado_plano, descripcion)
VALUES();

--INSERT TABLA TIPOS PAGO
INSERT INTO tipos_pagos (id_tipo_pago, descripcion)
VALUES();

--INSERT TABLA FACTURAS
INSERT INTO facturas (id_factura, id_cliente, fecha, total)
VALUES();

--INSERT TABLA DETALLE FACTURA
INSERT INTO detalle_facturas (id_detalle_factura, id_factura, id_proyecto, descripcion)
VALUES();

--INSERT TABLA CUOTAS
INSERT INTO cuotas (id_cuota, id_factura, numero_cuota, monto, fecha_vencimiento, estado_cuota)
VALUES();

--INSERT TABLA RECIBOS
INSERT INTO recibos (id_recibo, id_cuota, fecha_pago, monto, forma_pago, observaciones)
VALUES();

--INSERT TABLA FACTURAS TIPOS PAGO
INSERT INTO factura_tipos_pago (id_factura, id_tipo_pago, monto_pago)
VALUES();

--INSERT TABLA NIVELES SOCIOS
INSERT INTO niveles_socios (id_nivel_socio, descripcion, beneficio)
VALUES();

--INSERT TABLA SOCIOS
INSERT INTO socios (id_socio, razon_social, cuil, id_tipo_documento, id_direccion, fecha_incorporacion, id_nivel_socio)
VALUES();

--INSERT TABLA SOCIOS PROYECTOS
INSERT INTO socios_proyectos (id_socio_proyecto, id_socio, id_proyecto, actividad)
VALUES();

--INSERT TABLA ESTADO ETAPAS
INSERT INTO estado_etapas (id_estado_etapa, descripcion)
VALUES();

--INSERT TABLA ETAPAS PROYECTO
INSERT INTO etapas_proyecto (id_etapa_proyecto, id_proyecto, id_estado_etapa, fecha_inicio, fecha_estimada_finalizacion, fecha_finalizacion, id_equipo, facturada, id_factura)
VALUES();

--INSERT TABLA TIPOS CONTACTOS
INSERT INTO tipos_contactos (id_tipo_contacto, descripcion)
VALUES();

--INSERT TABLA CONTACTOS
INSERT INTO contactos (id_contacto, contacto, id_tipo_contacto, matricula_arquitecto, id_socio, id_cliente)
VALUES();

--INSERT TABLA ARQUITECTOS EN PROYECTOS
INSERT INTO arquitectos_proyectos (id_arquitecto_proyecto, matricula_arquitecto, id_proyecto, rol)
VALUES();

--INSERT TABLA FORMAS DE PAGOS USADAS EN RECIBOS
INSERT INTO formas_pago_recibos (id_recibo, id_tipo_pago, monto_pago)
VALUES();

--INSERT TABLA POSIBLES GASTO
INSERT INTO rubros_gastos (id_rubro, descripcion)
VALUES();

--INSERT TABLA GASTOS POR ETAPA DE PROYECTO
INSERT INTO gastos_etapas (id_gasto_etapa, id_etapa_proyecto, id_rubro, descripcion, monto, fecha)
VALUES();

--INSERT TABLA DEL GRADO DE AVANCE POR ETAPAS
INSERT INTO avance_etapas (id_avance, id_etapa_proyecto, porcentaje_avance, fecha_registro, observaciones)
VALUES();