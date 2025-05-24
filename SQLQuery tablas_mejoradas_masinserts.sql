
-- CREAR BASE DE DATOS

CREATE DATABASE proyectos_arquitecturaTPI6;
GO
USE proyectos_arquitecturaTPI6;
GO
SET DATEFORMAT dmy;

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
    descripcion VARCHAR(200),
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
    id_localidad INT NULL,  
    id_pais INT NULL,
    CONSTRAINT pk_arquitectos PRIMARY KEY (matricula_habilitante),
    CONSTRAINT fk_arquitectos_tipos_arquitectos FOREIGN KEY (id_tipo_arquitecto) REFERENCES tipos_arquitectos(id_tipo_arquitecto),
    CONSTRAINT fk_arquitectos_tipos_documento FOREIGN KEY (id_tipo_documento) REFERENCES tipos_documento(id_tipo_documento),
    CONSTRAINT fk_arquitectos_direcciones FOREIGN KEY (id_direccion) REFERENCES direcciones(id_direccion),
    CONSTRAINT fk_arquitectos_localidades FOREIGN KEY (id_localidad) REFERENCES localidades(id_localidad),
    CONSTRAINT fk_arquitectos_paises FOREIGN KEY (id_pais) REFERENCES paises(id_pais)
);


-- ======================
-- 4. CLIENTES Y TIPOS
-- ======================

CREATE TABLE tipo_clientes (
    id_tipo_cliente INT IDENTITY(1,1) NOT NULL,
    descripcion VARCHAR(50) NOT NULL,
    CONSTRAINT pk_tipo_clientes PRIMARY KEY (id_tipo_cliente)
);

CREATE TABLE clientes (
    id_cliente INT IDENTITY(1,1) NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    razon_social VARCHAR(100),
	apellido VARCHAR(100),
    cuit VARCHAR(20),
    cuil VARCHAR(20),
    id_direccion INT NOT NULL,
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


--INSERT TABLA TIPOS DOCUMENTOS


INSERT INTO tipos_documento (descripcion) 
					  VALUES('DNI');
INSERT INTO tipos_documento (descripcion) 
					  VALUES('Pasaporte');
INSERT INTO tipos_documento (descripcion) 
					  VALUES('Licencia de Conducir');
INSERT INTO tipos_documento (descripcion) 
					  VALUES('Cedula Profesional');
INSERT INTO tipos_documento (descripcion) 
					  VALUES('Credencial para Votar');
INSERT INTO tipos_documento (descripcion) 
					  VALUES('Libreta Civica');
INSERT INTO tipos_documento ( descripcion) 
					  VALUES('Libreta de Enrolamiento');
INSERT INTO tipos_documento (descripcion) 
					  VALUES('Cedula de Extranjeria');
INSERT INTO tipos_documento (descripcion) 
				      VALUES('Certificado Unico de Discapacidad');
INSERT INTO tipos_documento (descripcion) 
					  VALUES('Acta de Nacimiento');
INSERT INTO tipos_documento (descripcion) 
				      VALUES('Numero de Seguridad Social');
INSERT INTO tipos_documento (descripcion) 
					  VALUES('CIF');
INSERT INTO tipos_documento (descripcion) 
					  VALUES('Tarjeta PAN');



--INSERT TABLA PAISES
INSERT INTO paises (nombre) 
			VALUES ('Argentina');
INSERT INTO paises (nombre) 
			VALUES ('Brasil');
INSERT INTO paises (nombre) 
			VALUES ('Chile');
INSERT INTO paises (nombre) 
			VALUES ('Uruguay');
INSERT INTO paises (nombre) 
			VALUES ('Paraguay');
INSERT INTO paises (nombre) 
			VALUES ('Peru');
INSERT INTO paises (nombre) 
			VALUES ('Colombia');
INSERT INTO paises (nombre) 
			VALUES ('Ecuador');
INSERT INTO paises (nombre) 
			VALUES ('Mexico');
INSERT INTO paises (nombre) 
			VALUES ('Estados Unidos');

-- tabla provincias
INSERT INTO provincias (nombre           , id_pais)
            VALUES ('Buenos Aires'   , 1);
INSERT INTO provincias (nombre           , id_pais)
            VALUES ('Catamarca'      , 1);
INSERT INTO provincias (nombre           , id_pais)
            VALUES ('Chaco'          , 1);
INSERT INTO provincias (nombre           , id_pais)
            VALUES ('Chubut'         , 1);
INSERT INTO provincias (nombre           , id_pais)
            VALUES ('Cordoba'        , 1);
INSERT INTO provincias (nombre           , id_pais)
            VALUES ('Corrientes'     , 1);
INSERT INTO provincias (nombre           , id_pais)
            VALUES ('Entre Rios'     , 1);
INSERT INTO provincias (nombre           , id_pais)
            VALUES ('Formosa'        , 1);
INSERT INTO provincias (nombre           , id_pais)
            VALUES ('Jujuy'          , 1);
INSERT INTO provincias (nombre           , id_pais)
            VALUES ('La Pampa'       , 1);
INSERT INTO provincias (nombre           , id_pais)
            VALUES ('La Rioja'       , 1);
INSERT INTO provincias (nombre           , id_pais)
            VALUES ('Mendoza'        , 1);
INSERT INTO provincias (nombre           , id_pais)
            VALUES ('Misiones'       , 1);
INSERT INTO provincias (nombre           , id_pais)
            VALUES ('Neuquen'        , 1);
INSERT INTO provincias (nombre           , id_pais)
            VALUES ('Rio Negro'      , 1);
INSERT INTO provincias (nombre           , id_pais)
            VALUES ('Salta'          , 1);
INSERT INTO provincias (nombre           , id_pais)
            VALUES ('San Juan'       , 1);
INSERT INTO provincias (nombre           , id_pais)
            VALUES ('San Luis'       , 1);
INSERT INTO provincias (nombre           , id_pais)
            VALUES ('Santa Cruz'     , 1);
INSERT INTO provincias (nombre           , id_pais)
            VALUES ('Santa Fe'       , 1);
INSERT INTO provincias (nombre           , id_pais)
            VALUES ('Santiago del Estero', 1);
INSERT INTO provincias (nombre           , id_pais)
            VALUES ('Tierra del Fuego', 1);
INSERT INTO provincias (nombre           , id_pais)
            VALUES ('Tucuman'        , 1);
INSERT INTO provincias (nombre           , id_pais)
            VALUES ('Sao Paulo'      , 2);
INSERT INTO provincias (nombre           , id_pais)
            VALUES ('Rio de Janeiro' , 2);
INSERT INTO provincias (nombre           , id_pais)
            VALUES ('Bahia'          , 2);
INSERT INTO provincias (nombre           , id_pais)
            VALUES ('Minas Gerais'   , 2);
INSERT INTO provincias (nombre           , id_pais)
            VALUES ('Santiago'       , 3);
INSERT INTO provincias (nombre           , id_pais)
            VALUES ('Valparaiso'     , 3);
INSERT INTO provincias (nombre           , id_pais)
            VALUES ('Biobio'         , 3);
INSERT INTO provincias (nombre           , id_pais)
            VALUES ('Montevideo'     , 4);
INSERT INTO provincias (nombre           , id_pais)
            VALUES ('Canelones'      , 4);
INSERT INTO provincias (nombre           , id_pais)
            VALUES ('Maldonado'      , 4);
INSERT INTO provincias (nombre           , id_pais)
            VALUES ('Asuncion'       , 5);
INSERT INTO provincias (nombre           , id_pais)
            VALUES ('Central'        , 5);
INSERT INTO provincias (nombre           , id_pais)
            VALUES ('Alto Parana'    , 5);
INSERT INTO provincias (nombre           , id_pais)
            VALUES ('Lima'           , 6);
INSERT INTO provincias (nombre           , id_pais)
            VALUES ('Cusco'          , 6);
INSERT INTO provincias (nombre           , id_pais)
            VALUES ('Arequipa'       , 6);
INSERT INTO provincias (nombre           , id_pais)
            VALUES ('Bogota'         , 7);
INSERT INTO provincias (nombre           , id_pais)
            VALUES ('Antioquia'      , 7);
INSERT INTO provincias (nombre           , id_pais)
            VALUES ('Valle del Cauca', 7);
INSERT INTO provincias (nombre           , id_pais)
            VALUES ('Quito'          , 8);
INSERT INTO provincias (nombre           , id_pais)
            VALUES ('Guayas'         , 8);
INSERT INTO provincias (nombre           , id_pais)
            VALUES ('Manabi'         , 8);
INSERT INTO provincias (nombre           , id_pais)
            VALUES ('CDMX'           , 9);
INSERT INTO provincias (nombre           , id_pais)
            VALUES ('Jalisco'        , 9);
INSERT INTO provincias (nombre           , id_pais)
            VALUES ('Nuevo Leon'     , 9);
INSERT INTO provincias (nombre           , id_pais)
            VALUES ('Yucatan'        , 9);
INSERT INTO provincias (nombre           , id_pais)
            VALUES ('California'     , 10);
INSERT INTO provincias (nombre           , id_pais)
            VALUES ('Texas'          , 10);
INSERT INTO provincias (nombre           , id_pais)
            VALUES ('Florida'        , 10);
INSERT INTO provincias (nombre           , id_pais)
            VALUES ('New York'       , 10);

--INSERT TABLA LOCALIDADES
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('La Plata'         , 1);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('Mar del Plata'    , 1);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('Cordoba Capital'  , 5);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('Villa Carlos Paz' , 5);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('Resistencia'      , 3);
INSERT INTO localidades (nombre                   , id_provincia)
            VALUES ('Presidencia Roque Saenz Pena', 3);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('Rawson'           , 4);
INSERT INTO localidades (nombre         , id_provincia)
            VALUES ('Comodoro Rivadavia', 4);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('Parana'           , 7);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('Concordia'        , 7);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('Formosa'          , 8);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('Clorinda'         , 8);
INSERT INTO localidades (nombre            , id_provincia)
            VALUES ('San Salvador de Jujuy', 9);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('Palpala'          , 9);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('Santa Rosa'       , 10);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('General Pico'     , 10);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('La Rioja'         , 11);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('Chilecito'        , 11);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('Mendoza'          , 12);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('San Rafael'       , 12);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('Posadas'          , 13);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('Obera'            , 13);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('Neuquen Capital'  , 14);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('Cutral Co'        , 14);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('Viedma'           , 15);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('Bariloche'        , 15);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('Salta Capital'    , 16);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('Oran'             , 16);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('San Juan Capital' , 17);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('Rawson (SJ)'      , 17);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('San Luis'         , 18);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('Villa Mercedes'   , 18);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('Rio Gallegos'     , 19);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('Caleta Olivia'    , 19);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('Santa Fe Capital' , 20);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('Rosario'          , 20);
INSERT INTO localidades (nombre          , id_provincia)
            VALUES ('Santiago del Estero', 21);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('La Banda'         , 21);
INSERT INTO localidades (nombre            , id_provincia)
            VALUES ('San Miguel de Tucuman', 23);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('Tafi Viejo'       , 23);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('Ushuaia'          , 22);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('Rio Grande'       , 22);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('Sao Paulo'        , 24);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('Rio de Janeiro'   , 25);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('Salvador'         , 26);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('Belo Horizonte'   , 27);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('Santiago Centro'  , 28);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('Vina del Mar'     , 29);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('Concepcion'       , 30);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('Montevideo Centro', 31);
INSERT INTO localidades (nombre         , id_provincia)
            VALUES ('Ciudad de la Costa', 32);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('Punta del Este'   , 33);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('Asuncion Capital' , 34);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('San Lorenzo'      , 35);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('Ciudad del Este'  , 36);
INSERT INTO localidades (nombre         , id_provincia)
            VALUES ('Lima Metropolitana', 37);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('Machu Picchu'     , 38);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('Arequipa Ciudad'  , 39);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('Bogota DC'        , 40);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('Medellin'         , 41);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('Cali'             , 42);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('Quito Capital'    , 43);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('Guayaquil'        , 44);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('Manta'            , 45);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('Ciudad de Mexico' , 46);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('Guadalajara'      , 47);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('Monterrey'        , 48);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('Merida'           , 49);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('Los Angeles'      , 50);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('Houston'          , 51);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('Miami'            , 52);
INSERT INTO localidades (nombre        , id_provincia)
            VALUES ('New York City'    , 53);



--INSERT TABLA DIRECCIONES

INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Avenida Siempreviva'        , 101   , 17);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Calle Ficticia'             , 202   , 18);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Pasaje del Sol'             , 303   , 19);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Bulevar de la Luna'         , 404   , 20);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Camino Estrellado'          , 505   , 21);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Ruta Desconocida'           , 606   , 22);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Sendero Encantado'          , 707   , 23);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Alameda del Parque'         , 808   , 24);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Avenida Principal'          , 909   , 25);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Calle Secundaria'           , 111   , 26);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Pasaje Peatonal'            , 222   , 27);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Bulevar Comercial'          , 333   , 28);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Camino Rural'               , 444   , 29);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Ruta Provincial'            , 555   , 30);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Sendero Urbano'             , 666   , 31);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Alameda Residencial'        , 777   , 32);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Avenida Central'            , 888   , 33);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Calle Lateral'              , 999   , 34);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Pasaje Escondido'           , 1234  , 35);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Bulevar Tranquilo'          , 5678  , 36);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Camino Vecinal'             , 9012  , 37);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Ruta Panamericana'          , 3456  , 38);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Sendero Boscoso'            , 7890  , 39);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Alameda de las Flores'      , 100   , 40);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Avenida de los Arboles'     , 200   , 41);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Calle de las Rosas'         , 300   , 42);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Pasaje del Viento'          , 400   , 43);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Bulevar del Agua'           , 500   , 44);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Camino de Fuego'            , 600   , 45);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Ruta del Desierto'          , 700   , 46);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Sendero de Montania'        , 800   , 1);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Alameda del Lago'           , 900   , 2);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Avenida del Rio'            , 1000  , 3);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Calle del Mar'              , 1100  , 4);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Pasaje del Cielo'           , 1200  , 5);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Bulevar de la Tierra'       , 1300  , 6);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Camino del Universo'        , 1400  , 7);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Ruta de la Galaxia'         , 1500  , 8);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Sendero del Planeta'        , 1600  , 9);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Alameda Cosmica'            , 1700  , 10);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Avenida Interestelar'       , 1800  , 11);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Calle de las Estrellas'     , 1900  , 12);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Pasaje Lunar'               , 2000  , 13);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Bulevar Solar'              , 2100  , 14);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Camino de los Cometas'      , 2200  , 15);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Ruta de Asteroides'         , 2300  , 16);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Sendero de Meteoritos'      , 2400  , 17);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Alameda de Cohetes'         , 2500  , 18);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Avenida de Naves'           , 2600  , 19);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Calle del Espacio'          , 2700  , 20);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Pasaje del Tiempo'          , 2800  , 21);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Bulevar de las Dimensiones' , 2900  , 22);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Camino de Energia'          , 3000  , 23);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Ruta de la Materia'         , 3100  , 24);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Sendero de Ondas'           , 3200  , 25);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Alameda de Particulas'      , 3300  , 26);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Avenida de la Fuerza'       , 3400  , 27);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Calle del Campo'            , 3500  , 28);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Pasaje de Gravedad'         , 3600  , 29);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Bulevar de la Luz'          , 3700  , 30);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Camino del Sonido'          , 3800  , 31);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Ruta del Color'             , 3900  , 32);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Sendero de Formas'          , 4000  , 33);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Alameda de Tamanos'         , 4100  , 34);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Avenida de Pesos'           , 4200  , 35);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Calle de Volumenes'         , 4300  , 36);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Pasaje de Densidades'       , 4400  , 37);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Bulevar de Temperaturas'    , 4500  , 38);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Camino de Presiones'        , 4600  , 39);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Ruta de Velocidades'        , 4700  , 40);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Sendero de Aceleraciones'   , 4800  , 41);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Alameda de Frecuencias'     , 4900  , 42);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Avenida de Longitudes'      , 5000  , 43);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Calle de Anchuras'          , 5100  , 44);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Pasaje de Alturas'          , 5200  , 45);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Bulevar de Profundidades'   , 5300  , 46);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Camino de Distancias'       , 5400  , 1);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Ruta de Angulos'            , 5500  , 2);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Sendero de Curvas'          , 5600  , 3);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Alameda Recta'              , 5700  , 4);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Avenida Circular'           , 5800  , 5);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Calle Cuadrada'             , 5900  , 6);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Pasaje Triangular'          , 6000  , 7);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Bulevar Poligonal'          , 6100  , 8);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Camino Cubico'              , 6200  , 9);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Ruta Esferica'              , 6300  , 10);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Sendero Cilindrico'         , 6400  , 11);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Alameda Conica'             , 6500  , 12);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Avenida Piramidal'          , 6600  , 13);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Calle Eliptica'             , 6700  , 14);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Parabola'                   , 6800  , 15);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Hiperbola'                  , 6900  , 16);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Geometria'                  , 7000  , 17);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Algebra'                    , 7100  , 18);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Calculo'                    , 7200  , 19);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Estadistica'                , 7300  , 20);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Probabilidad'               , 7400  , 21);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Logica'                     , 7500  , 22);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Filosofia'                  , 7600  , 23);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Historia'                   , 7700  , 24);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Literatura'                 , 7800  , 25);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Arte'                       , 7900  , 26);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Musica'                     , 8000  , 27);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Danza'                      , 8100  , 28);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Teatro'                     , 8200  , 29);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Cine'                       , 8300  , 30);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Fotografia'                 , 8400  , 31);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Escultura'                  , 8500  , 32);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Pintura'                    , 8600  , 33);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Dibujo'                     , 8700  , 34);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Diseno'                     , 8800  , 35);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Arquitectura'               , 8900  , 36);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Ingenieria'                 , 9000  , 37);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Ciencia'                    , 9100  , 38);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Tecnologia'                 , 9200  , 39);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Informatica'                , 9300  , 40);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Programacion'               , 9400  , 41);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Datos'                      , 9500  , 42);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Redes'                      , 9600  , 43);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Seguridad'                  , 9700  , 44);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Cloud'                      , 9800  , 45);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Servidor'                   , 9900  , 46);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Cliente'                    , 10000 , 1);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Software'                   , 10100 , 2);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Hardware'                   , 10200 , 3);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Internet'                   , 10300 , 4);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Web'                        , 10400 , 5);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Mobile'                     , 10500 , 6);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Desktop'                    , 10600 , 7);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Gaming'                     , 10700 , 8);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Realidad Virtual'           , 10800 , 9);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Inteligencia Artificial'    , 10900 , 10);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Machine Learning'           , 11000 , 11);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Deep Learning'              , 11100 , 12);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Big Data'                   , 11200 , 13);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Data Science'               , 11300 , 14);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Analisis de Datos'          , 11400 , 15);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Visualizacion'              , 11500 , 16);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Negocio'                    , 11600 , 17);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Marketing'                  , 11700 , 18);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Ventas'                     , 11800 , 19);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Finanzas'                   , 11900 , 20);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Contabilidad'               , 12000 , 21);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Recursos Humanos'           , 12100 , 22);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Administracion'             , 12200 , 23);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Operaciones'                , 12300 , 24);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Logistica'                  , 12400 , 25);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Produccion'                 , 12500 , 26);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Calidad'                    , 12600 , 27);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Servicio'                   , 12700 , 28);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Soporte'                    , 12800 , 29);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Consultoria'                , 12900 , 30);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Educacion'                  , 13000 , 31);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Salud'                      , 13100 , 32);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Medicina'                   , 13200 , 33);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Deporte'                    , 13300 , 34);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Nutricion'                  , 13400 , 35);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Bienestar'                  , 13500 , 36);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Viajes'                     , 13600 , 37);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Turismo'                    , 13700 , 38);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Gastronomia'                , 13800 , 39);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Moda'                       , 13900 , 40);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Belleza'                    , 14000 , 41);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Hogar'                      , 14100 , 42);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Jardineria'                 , 14200 , 43);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Mascotas'                   , 14300 , 44);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Ninios'                     , 14400 , 45);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Jovenes'                    , 14500 , 46);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Adultos'                    , 14600 , 1);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Mayores'                    , 14700 , 2);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Familia'                    , 14800 , 3);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Amigos'                     , 14900 , 4);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Comunidad'                  , 15000 , 5);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Sociedad'                   , 15100 , 6);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Gobierno'                   , 15200 , 7);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Ley'                        , 15300 , 8);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Justicia'                   , 15400 , 9);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Derechos'                   , 15500 , 10);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Deberes'                    , 15600 , 11);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Responsabilidad'            , 15700 , 12);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Etica'                      , 15800 , 13);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Moral'                      , 15900 , 14);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Valores'                    , 16000 , 15);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Cultura'                    , 16100 , 16);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Tradicion'                  , 16200 , 17);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Historia'                   , 16300 , 18);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Costumbres'                 , 16400 , 19);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Idiomas'                    , 16500 , 20);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Religiones'                 , 16600 , 21);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Creencias'                  , 16700 , 22);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Mitos'                      , 16800 , 23);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Leyendas'                   , 16900 , 24);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Cuentos'                    , 17000 , 25);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Novelas'                    , 17100 , 26);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Poemas'                     , 17200 , 27);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Canciones'                  , 17300 , 28);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Musica'                     , 17400 , 29);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Ruta Escenica'              , 17500 , 30);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Sendero Creativo'           , 17600 , 31);
INSERT INTO direcciones (calle                     , numero, id_localidad)
            VALUES ('Alameda de la Inspiracion'  , 17700 , 32);


INSERT INTO tipos_arquitectos (tipo                          , descripcion)
                        VALUES('Arquitecto Residencial'      ,'Diseña y construye casas y edificios residenciales');

INSERT INTO tipos_arquitectos (tipo                          , descripcion)
                        VALUES('Arquitecto Comercial'        ,'Diseña y construye edificios comerciales, como oficinas, centros comerciales');

INSERT INTO tipos_arquitectos (tipo                          , descripcion)
                        VALUES('Arquitecto Industrial'       ,'Diseñan y construyen edificios industriales, como fábricas, almacenes y plantas');

INSERT INTO tipos_arquitectos (tipo                          , descripcion)
                        VALUES('Arquitecto de Restauracion'  ,'Se especializan en la restauración y rehabilitación de edificios históricos');

INSERT INTO tipos_arquitectos (tipo                          , descripcion)
                        VALUES('Arquitecto Sustentable'      ,'Diseñan edificios con un enfoque en la sostenibilidad, utilizando materiales eco-amigables y sistemas de energía renovable.');

INSERT INTO arquitectos (matricula_habilitante, nombre   , apellido   , id_tipo_arquitecto, documento , id_tipo_documento, id_direccion)
                VALUES ('ARQ0001'             , 'Fausto', 'Ballester', 3                 , '32293097', 2                , 6           );

INSERT INTO arquitectos (matricula_habilitante, nombre   , apellido   , id_tipo_arquitecto, documento , id_tipo_documento, id_direccion)
                VALUES ('ARQ0002'             , 'Luz'    , 'Robles'   , 5                 , '24796026', 2                , 8           );

INSERT INTO arquitectos (matricula_habilitante, nombre   , apellido   , id_tipo_arquitecto, documento , id_tipo_documento, id_direccion)
                VALUES ('ARQ0003'             , 'Alberto', 'Martini'  , 5                 , '22787833', 1                , 10          );

INSERT INTO arquitectos (matricula_habilitante, nombre   , apellido   , id_tipo_arquitecto, documento , id_tipo_documento, id_direccion)
                VALUES ('ARQ0004'             , 'Adrian' , 'Valles'   , 1                 , '21739670', 2                , 9           );

INSERT INTO arquitectos (matricula_habilitante, nombre   , apellido   , id_tipo_arquitecto, documento , id_tipo_documento, id_direccion)
                VALUES ('ARQ0005'             , 'Calixto', 'Lerma'    , 2                 , '41139945', 2                , 4           );

INSERT INTO arquitectos (matricula_habilitante, nombre   , apellido   , id_tipo_arquitecto, documento , id_tipo_documento, id_direccion)
                VALUES ('ARQ0006'             , 'Carlos' , 'Ahumada'  , 4                 , '31239945', 2                , 4           );

INSERT INTO arquitectos (matricula_habilitante, nombre   , apellido   , id_tipo_arquitecto, documento , id_tipo_documento, id_direccion)
                VALUES ('ARQ0007'             , 'Mariela', 'Torrado'  , 4                 , '30122345', 1                , 12          );

INSERT INTO arquitectos (matricula_habilitante, nombre   , apellido   , id_tipo_arquitecto, documento , id_tipo_documento, id_direccion)
                VALUES ('ARQ0008'             , 'Julio'  , 'Barrios'  , 2                 , '18222331', 2                , 14          );

INSERT INTO arquitectos (matricula_habilitante, nombre   , apellido   , id_tipo_arquitecto, documento , id_tipo_documento, id_direccion)
                VALUES ('ARQ0009'             , 'Emilia' , 'González' , 1                 , '35500678', 1                , 11          );

INSERT INTO arquitectos (matricula_habilitante, nombre   , apellido   , id_tipo_arquitecto, documento , id_tipo_documento, id_direccion)
                VALUES ('ARQ0010'             , 'Carlos' , 'Funes'    , 3                 , '27559922', 2                , 15          );

INSERT INTO arquitectos (matricula_habilitante, nombre   , apellido   , id_tipo_arquitecto, documento , id_tipo_documento, id_direccion)
                VALUES ('ARQ0011'             , 'Alberione', 'Franco' , 5                 , '40440321', 1                , 13          );

INSERT INTO arquitectos (matricula_habilitante, nombre   , apellido   , id_tipo_arquitecto, documento , id_tipo_documento, id_direccion)
                VALUES ('ARQ0012'             , 'Amaya'  , 'Tomas'    , 2                 , '30998231', 1                , 16          );

INSERT INTO arquitectos (matricula_habilitante, nombre   , apellido   , id_tipo_arquitecto, documento , id_tipo_documento, id_direccion)
                VALUES ('ARQ0013'             , 'Biasco' , 'Pablo'    , 5                 , '28890123', 2                , 17          );

INSERT INTO arquitectos (matricula_habilitante, nombre   , apellido   , id_tipo_arquitecto, documento , id_tipo_documento, id_direccion)
                VALUES ('ARQ0014'             , 'Caseres', 'Thiago'   , 1                 , '33333222', 1                , 18          );

INSERT INTO arquitectos (matricula_habilitante, nombre   , apellido   , id_tipo_arquitecto, documento , id_tipo_documento, id_direccion)
                VALUES ('ARQ0015'             , 'Gatica' , 'Nahuel'   , 3                 , '30119999', 2                , 19          );

INSERT INTO arquitectos (matricula_habilitante, nombre   , apellido   , id_tipo_arquitecto, documento , id_tipo_documento, id_direccion)
                VALUES ('ARQ0016'             , 'Polzoni', 'Benjamin' , 4                 , '28441233', 2                , 20          );

INSERT INTO arquitectos (matricula_habilitante, nombre   , apellido   , id_tipo_arquitecto, documento , id_tipo_documento, id_direccion)
                VALUES ('ARQ0017'             , 'Brandon', 'Ariel'    , 2                 , '27551245', 1                , 21          );

INSERT INTO arquitectos (matricula_habilitante, nombre   , apellido   , id_tipo_arquitecto, documento , id_tipo_documento, id_direccion)
                VALUES ('ARQ0018'             , 'Verónica','Ferrari'  , 5                 , '29512378', 2                , 22          );

INSERT INTO tipo_clientes  ( descripcion)
                     VALUES('Particular');

INSERT INTO tipo_clientes ( descripcion)
                    VALUES('Empresa'   );

INSERT INTO tipo_clientes ( descripcion)
                    VALUES('Organismo Publico ');


INSERT INTO clientes(nombre     , apellido          , razon_social                       , cuit              , cuil          , id_direccion , id_tipo_cliente , fecha_alta  , estado_cuenta)
VALUES              ('Lionel'   , 'Messi'           , 'Arcor S.A'                        , '20-12345678-9'   , NULL          , 10           , 2               , '27/07/2020', 'Activa');

INSERT INTO clientes(nombre     , apellido          , razon_social                       , cuit              , cuil          , id_direccion , id_tipo_cliente , fecha_alta  , estado_cuenta)
VALUES              ('Franco'   , 'Alberione'       , 'Adidas S.A'                       , '20-12345622-2'   , NULL          , 20           , 2               , '20/03/2021', 'Activa');

INSERT INTO clientes(nombre     , apellido          , razon_social                       , cuit              , cuil          , id_direccion , id_tipo_cliente , fecha_alta  , estado_cuenta)
VALUES              ('Raúl'     , 'Giménez'         , NULL                               , NULL              , '20111222333' , 21           , 1               , '15/03/2020', 'Activa');

INSERT INTO clientes(nombre     , apellido          , razon_social                       , cuit              , cuil          , id_direccion , id_tipo_cliente , fecha_alta  , estado_cuenta)
VALUES              ('Tatiana'  , 'Mendoza'         , NULL                               , NULL              , '20345789001' , 13           , 1               , '20/11/2023', 'Baja');

INSERT INTO clientes(nombre     , apellido          , razon_social                       , cuit              , cuil          , id_direccion , id_tipo_cliente , fecha_alta  , estado_cuenta)
VALUES              ('Julio'    , 'Barrios'         , 'Constructora Sur SRL'             , '30-70889991-7'   , NULL          , 14           , 2               , '05/09/2021', 'Activa');

INSERT INTO clientes(nombre     , apellido          , razon_social                       , cuit              , cuil          , id_direccion , id_tipo_cliente , fecha_alta  , estado_cuenta)
VALUES              ('Calixto'  , 'Lema'            , NULL                               , NULL              , '20333123445' , 4            , 1               , '10/12/2022', 'Baja');

INSERT INTO clientes(nombre     , apellido          , razon_social                       , cuit              , cuil          , id_direccion , id_tipo_cliente , fecha_alta  , estado_cuenta)
VALUES              ('Alberto'  , 'Martini'         , NULL                               , NULL              , '20444999444' , 10           , 1               , '02/06/2020', 'Activa');

INSERT INTO clientes(nombre     , apellido          , razon_social                       , cuit              , cuil          , id_direccion , id_tipo_cliente , fecha_alta  , estado_cuenta)
VALUES              ('Mariela'  , 'Torrado'         , NULL                               , NULL              , '109881234' , 12           , 1               , '28/02/2021', 'Baja');

INSERT INTO clientes(nombre     , apellido          , razon_social                       , cuit              , cuil          , id_direccion , id_tipo_cliente , fecha_alta  , estado_cuenta)
VALUES              ('Marta'    , 'Ortega'          , 'Grupo Diseño SRL'                 , '30-55667788-1'   , NULL          , 17           , 2               , '09/01/2025', 'Activa');

INSERT INTO clientes(nombre     , apellido          , razon_social                       , cuit              , cuil          , id_direccion , id_tipo_cliente , fecha_alta  , estado_cuenta)
VALUES              ('Carlos'   , 'Funes'           , NULL                               , NULL              , '20912345678' , 15           , 1               , '25/10/2024', 'Baja');

INSERT INTO clientes(nombre     , apellido          , razon_social                       , cuit              , cuil          , id_direccion , id_tipo_cliente , fecha_alta  , estado_cuenta)
VALUES              ('Sofía'    , 'Cabral'          , NULL                               , NULL              , '20987654321' , 18           , 1               , '12/08/2020', 'Activa');

INSERT INTO clientes(nombre     , apellido          , razon_social                       , cuit              , cuil          , id_direccion , id_tipo_cliente , fecha_alta  , estado_cuenta)
VALUES              ('Lorena'   , 'Sosa'            , 'Estudios Sosa S.A.'               , '30-11223344-0'   , NULL          , 20           , 2               , '18/07/2023', 'Baja');

INSERT INTO clientes(nombre     , apellido          , razon_social                       , cuit              , cuil          , id_direccion , id_tipo_cliente , fecha_alta  , estado_cuenta)
VALUES              ('Gobierno' , NULL              , 'Ministerio de Infraestructura'    , '30-12345678-9'   , NULL          , 33           , 2               , '15/05/2020', 'Activa');

INSERT INTO clientes(nombre     , apellido          , razon_social                       , cuit              , cuil          , id_direccion , id_tipo_cliente , fecha_alta  , estado_cuenta)
VALUES              ('Gobierno' , NULL              , 'Secretaría de Vivienda'           , '30-23456789-0'   , NULL          , 34           , 2               , '02/11/2021', 'Baja');

INSERT INTO clientes(nombre     , apellido          , razon_social                       , cuit              , cuil          , id_direccion , id_tipo_cliente , fecha_alta  , estado_cuenta)
VALUES              ('Municipio', NULL              , 'Dirección de Obras Públicas'      , '30-34567890-1'   , NULL          , 35           , 2               , '10/09/2022', 'Activa');

INSERT INTO clientes(nombre     , apellido          , razon_social                       , cuit              , cuil          , id_direccion , id_tipo_cliente , fecha_alta  , estado_cuenta)
VALUES              ('Provincia', NULL              , 'Infraestructura Escolar'          , '30-45678901-2'   , NULL          , 36           , 2               , '20/12/2023', 'Baja');

INSERT INTO clientes(nombre     , apellido          , razon_social                             , cuit              , cuil , id_direccion , id_tipo_cliente , fecha_alta  , estado_cuenta)
VALUES              ('Gobierno' , NULL              , 'Dirección Provincial de Vivienda' , '30-56789012-3'   , NULL , 37            , 2               , '03/04/2025', 'Activa');

INSERT INTO clientes(nombre     , apellido          , razon_social                             , cuit              , cuil , id_direccion , id_tipo_cliente , fecha_alta  , estado_cuenta)
VALUES              ('Gobierno' , NULL              , 'Ministerio de Obras Públicas de Chile'  , '34-98765432-1'   , NULL , 40            , 2               , '14/08/2022', 'Activa');

INSERT INTO clientes(nombre     , apellido          , razon_social                             , cuit              , cuil , id_direccion , id_tipo_cliente , fecha_alta  , estado_cuenta)
VALUES              ('Gobierno' , NULL              , 'Dirección Nacional de Vivienda - Uruguay', '35-87654321-0'  , NULL , 41            , 2               , '25/03/2021', 'Baja');

INSERT INTO clientes(nombre     , apellido          , razon_social                             , cuit              , cuil , id_direccion , id_tipo_cliente , fecha_alta  , estado_cuenta)
VALUES              ('Gobierno' , NULL              , 'Ministerio de Infraestructura Paraguay' , '36-76543210-9'   , NULL , 42            , 2               , '11/07/2023', 'Activa');

INSERT INTO clientes(nombre     , apellido          , razon_social                             , cuit              , cuil , id_direccion , id_tipo_cliente , fecha_alta  , estado_cuenta)
VALUES              ('Gobierno' , NULL              , 'Secretaria de Habitação do Brasil'      , '37-65432109-8'   , NULL , 43            , 2               , '19/10/2020', 'Baja');

INSERT INTO clientes(nombre     , apellido          , razon_social                             , cuit              , cuil , id_direccion , id_tipo_cliente , fecha_alta  , estado_cuenta)
VALUES              ('Municipio', NULL              , 'Gobierno Autónomo Municipal de La Paz' , '38-54321098-7'   , NULL , 44            , 2               , '05/05/2024', 'Activa');

INSERT INTO clientes(nombre     , apellido          , razon_social                       , cuit              , cuil          , id_direccion , id_tipo_cliente , fecha_alta  , estado_cuenta)
VALUES              ('Juan'		, 'Steve'              , 'Persona normal SRL'			, '30-123452328-9'   , NULL          , 33           , 2               , '15/05/2020', 'Activa');

INSERT INTO clientes(nombre     , apellido          , razon_social                       , cuit              , cuil          , id_direccion , id_tipo_cliente , fecha_alta  , estado_cuenta)
VALUES              ('Marcelo'  , NULL              , 'Secretaría de Vivienda'           , '30-222221212-0'   , NULL          , 34           , 2               , '02/11/2021', 'Baja');

INSERT INTO clientes(nombre     , apellido          , razon_social                       , cuit              , cuil          , id_direccion , id_tipo_cliente , fecha_alta  , estado_cuenta)
VALUES              ('Pablo', NULL              , 'Dirección de Obras Públicas'      , '30-343434334-1'   , NULL          , 35           , 2               , '10/09/2022', 'Activa');

INSERT INTO clientes(nombre     , apellido          , razon_social                       , cuit              , cuil          , id_direccion , id_tipo_cliente , fecha_alta  , estado_cuenta)
VALUES              ('Jorge'	,'Aimar'              , 'Jardineros Unidos SRL'          , '30-555555555-2'   , NULL          , 36           , 2               , '20/12/2023', 'Baja');

INSERT INTO clientes(nombre     , apellido          , razon_social                             , cuit              , cuil , id_direccion , id_tipo_cliente , fecha_alta  , estado_cuenta)
VALUES              ('Federico' , NULL              , 'Dirección Nacional de satelites'	 , '30-666666666-3'		   , NULL , 37            , 2               , '03/04/2025', 'Activa');

INSERT INTO clientes(nombre     , apellido          , razon_social                             , cuit              , cuil , id_direccion , id_tipo_cliente , fecha_alta  , estado_cuenta)
VALUES              ('Mauricio' , 'Sotelo'              , 'Creaciones SRL'  , '34-77787877-1'   , NULL , 40            , 2               , '14/08/2022', 'Activa');

INSERT INTO clientes(nombre     , apellido          , razon_social                             , cuit              , cuil , id_direccion , id_tipo_cliente , fecha_alta  , estado_cuenta)
VALUES              ('Pablo'	, 'Biasco'              , ' Minecraft SRL', '41-846981-2'  , NULL , 41            , 2               , '25/03/2021', 'Activa');

INSERT INTO clientes(nombre     , apellido          , razon_social                             , cuit              , cuil , id_direccion , id_tipo_cliente , fecha_alta  , estado_cuenta)
VALUES              ('Micaela' , NULL              , 'Postman INC' , '36-76543210-9'   , NULL , 42            , 2               , '11/07/2023', 'Activa');

INSERT INTO clientes(nombre     , apellido          , razon_social                             , cuit              , cuil , id_direccion , id_tipo_cliente , fecha_alta  , estado_cuenta)
VALUES              ('Francisco' , 'Rodriguez'      ,'Muy generico SRL'						   , '37-644432109-8'   , NULL , 43            , 2               , '19/10/2020', 'Baja');

INSERT INTO clientes(nombre     , apellido          , razon_social                             , cuit              , cuil , id_direccion , id_tipo_cliente , fecha_alta  , estado_cuenta)
VALUES              ('Roman'	, 'Riquelme'        ,'Destrucciones SA' , '38-54321098-7'		, NULL , 44            , 2               , '05/05/2024', 'Activa');

INSERT INTO clientes(nombre     , apellido          , razon_social                       , cuit              , cuil          , id_direccion , id_tipo_cliente , fecha_alta  , estado_cuenta)
VALUES              ('Gobierno' , NULL              , 'Ministerio de Infraestructura'    , '30-12345678-9'   , NULL          , 33           , 2               , '15/05/2020', 'Activa');

INSERT INTO clientes(nombre     , apellido          , razon_social                       , cuit              , cuil          , id_direccion , id_tipo_cliente , fecha_alta  , estado_cuenta)
VALUES              ('Gobierno' , NULL              , 'Secretaría de Vivienda'           , '30-55545444-0'   , NULL          , 34           , 2               , '02/11/2021', 'Baja');

INSERT INTO clientes(nombre     , apellido          , razon_social                       , cuit              , cuil          , id_direccion , id_tipo_cliente , fecha_alta  , estado_cuenta)
VALUES              ('Municipio', NULL              , 'Dirección de Obras Públicas'      , '30-54545452-1'   , NULL          , 35           , 2               , '10/09/2022', 'Activa');

INSERT INTO clientes(nombre     , apellido          , razon_social                       , cuit              , cuil          , id_direccion , id_tipo_cliente , fecha_alta  , estado_cuenta)
VALUES              ('Provincia', NULL              , 'Infraestructura Escolar'          , '30-32323222-2'   , NULL          , 36           , 2               , '20/12/2023', 'Baja');

INSERT INTO clientes(nombre     , apellido          , razon_social                             , cuit              , cuil , id_direccion , id_tipo_cliente , fecha_alta  , estado_cuenta)
VALUES              ('Gobierno' , NULL              , 'Dirección Provincial de Vivienda' , '30-33333333-3'   , NULL , 37            , 2               , '03/04/2025', 'Activa');

INSERT INTO clientes(nombre     , apellido          , razon_social                             , cuit              , cuil , id_direccion , id_tipo_cliente , fecha_alta  , estado_cuenta)
VALUES              ('Gobierno' , NULL              , 'Ministerio de Obras Públicas de Chile'  , '34-232321211-1'   , NULL , 40            , 2               , '14/08/2022', 'Activa');

INSERT INTO clientes(nombre     , apellido          , razon_social                             , cuit              , cuil , id_direccion , id_tipo_cliente , fecha_alta  , estado_cuenta)
VALUES              ('Gobierno' , NULL              , 'Dirección Nacional de Vivienda - Uruguay', '35-11111111-0'  , NULL , 41            , 2               , '25/03/2021', 'Baja');

INSERT INTO clientes(nombre     , apellido          , razon_social                             , cuit              , cuil , id_direccion , id_tipo_cliente , fecha_alta  , estado_cuenta)
VALUES              ('Gobierno' , NULL              , 'Ministerio de Infraestructura Paraguay' , '36-000000000-9'   , NULL , 42            , 2               , '11/07/2023', 'Activa');

INSERT INTO clientes(nombre     , apellido          , razon_social                             , cuit              , cuil , id_direccion , id_tipo_cliente , fecha_alta  , estado_cuenta)
VALUES              ('Gobierno' , NULL              , 'Secretaria de Habitação do Brasil'      , '37-121111211-8'   , NULL , 43            , 2               , '19/10/2020', 'Baja');

INSERT INTO clientes(nombre     , apellido          , razon_social                             , cuit              , cuil , id_direccion , id_tipo_cliente , fecha_alta  , estado_cuenta)
VALUES              ('Municipio', NULL              , 'Gobierno Autónomo Municipal de La Paz' , '38-3232323232-7'   , NULL , 44            , 2               , '05/05/2024', 'Activa');


--INSERT TABLA FACTURAS

INSERT INTO facturas (id_cliente, fecha       , total          )
               VALUES(1         , '01/01/2024', 10000.00);

INSERT INTO facturas (id_cliente, fecha       , total          )
               VALUES(2         , '15/01/2024', 20000.00);

INSERT INTO facturas (id_cliente, fecha       , total          )
               VALUES(3         , '01/02/2024', 30000.00);

INSERT INTO facturas (id_cliente, fecha       , total          )
               VALUES(4         , '01/03/2024', 40000.00);

INSERT INTO facturas (id_cliente, fecha       , total          )
               VALUES(5         , '01/04/2024', 50000.00);

INSERT INTO facturas (id_cliente, fecha       , total          )
               VALUES(6         , '01/05/2024', 60000.00);

INSERT INTO facturas (id_cliente, fecha       , total          )
               VALUES(7         , '01/06/2024', 70000.00);

INSERT INTO facturas (id_cliente, fecha       , total          )
               VALUES(8         , '01/07/2024', 80000.00);

INSERT INTO facturas (id_cliente, fecha       , total          )
               VALUES(9         , '01/08/2024', 90000.00);

INSERT INTO facturas (id_cliente, fecha       , total          )
               VALUES(10        , '01/09/2024', 100000.00);

INSERT INTO facturas (id_cliente, fecha       , total          )
               VALUES(11        , '01/10/2024', 110000.00);

INSERT INTO facturas (id_cliente, fecha       , total          )
               VALUES(12        , '01/11/2024', 120000.00);

INSERT INTO facturas (id_cliente, fecha       , total          )
               VALUES(13        , '01/12/2024', 130000.00);

INSERT INTO facturas (id_cliente, fecha       , total          )
               VALUES(14        , '01/01/2024', 140000.00);

INSERT INTO facturas (id_cliente, fecha       , total          )
               VALUES(15        , '01/02/2024', 150000.00);

--INSERT TABLA CUOTAS

INSERT INTO cuotas (id_factura, numero_cuota, monto    , fecha_vencimiento, estado_cuota)
             VALUES(1         , 1           , 5000.00  , '01/02/2024'     , 0           );

INSERT INTO cuotas (id_factura, numero_cuota, monto    , fecha_vencimiento, estado_cuota)
             VALUES(1         , 2           , 5000.00  , '01/03/2024'     , 0           );

INSERT INTO cuotas (id_factura, numero_cuota, monto    , fecha_vencimiento, estado_cuota)
             VALUES(2         , 1           , 10000.00 , '15/02/2024'     , 0           );

INSERT INTO cuotas (id_factura, numero_cuota, monto    , fecha_vencimiento, estado_cuota)
             VALUES(2         , 2           , 10000.00 , '15/03/2024'     , 0           );

INSERT INTO cuotas (id_factura, numero_cuota, monto    , fecha_vencimiento, estado_cuota)
             VALUES(3         , 1           , 15000.00 , '01/03/2024'     , 0           );

INSERT INTO cuotas (id_factura, numero_cuota, monto    , fecha_vencimiento, estado_cuota)
             VALUES(3         , 2           , 15000.00 , '01/04/2024'     , 0           );

INSERT INTO cuotas (id_factura, numero_cuota, monto    , fecha_vencimiento, estado_cuota)
             VALUES(4         , 1           , 20000.00 , '01/04/2024'     , 0           );

INSERT INTO cuotas (id_factura, numero_cuota, monto    , fecha_vencimiento, estado_cuota)
             VALUES(4         , 2           , 20000.00 , '01/05/2024'     , 0           );

INSERT INTO cuotas (id_factura, numero_cuota, monto    , fecha_vencimiento, estado_cuota)
             VALUES(5         , 1           , 25000.00 , '01/05/2024'     , 0           );

INSERT INTO cuotas (id_factura, numero_cuota, monto    , fecha_vencimiento, estado_cuota)
             VALUES(5         , 2           , 25000.00 , '01/06/2024'     , 0           );

INSERT INTO cuotas (id_factura, numero_cuota, monto    , fecha_vencimiento, estado_cuota)
             VALUES(6         , 15          , 30000.00 , '01/06/2024'     , 0           );

INSERT INTO cuotas (id_factura, numero_cuota, monto    , fecha_vencimiento, estado_cuota)
             VALUES(6         , 2           , 30000.00 , '01/07/2024'     , 0           );

INSERT INTO cuotas (id_factura, numero_cuota, monto    , fecha_vencimiento, estado_cuota)
             VALUES(7         , 8           , 35000.00 , '01/07/2024'     , 0           );

INSERT INTO cuotas (id_factura, numero_cuota, monto    , fecha_vencimiento, estado_cuota)
             VALUES(7         , 5          , 35000.00  , '01/08/2024'     , 1           );

INSERT INTO cuotas (id_factura, numero_cuota, monto    , fecha_vencimiento, estado_cuota)
             VALUES(8         , 1           , 40000.00 , '01/08/2024'     , 0           );

INSERT INTO cuotas (id_factura, numero_cuota, monto    , fecha_vencimiento, estado_cuota)
             VALUES(8         , 2           , 40000.00 , '01/09/2024'     , 1           );

--INSERT TABLA RECIBOS

INSERT INTO recibos (id_cuota, fecha_pago  , monto   , forma_pago     , observaciones)
              VALUES(1       , '01/02/2024', 1000000.10 , 'Efectivo'     , 'Pago en efectivo');

INSERT INTO recibos (id_cuota, fecha_pago  , monto   , forma_pago     , observaciones)
              VALUES(2       , '01/03/2024', 2321.12 , 'Transferencia', 'Pago por transferencia');

INSERT INTO recibos (id_cuota, fecha_pago  , monto   , forma_pago     , observaciones)
              VALUES(3       , '15/02/2024', 102000.22, 'Efectivo'     , 'Pago en efectivo');

INSERT INTO recibos (id_cuota, fecha_pago  , monto   , forma_pago     , observaciones)
              VALUES(4       , '15/03/2024', 10000.53, 'Transferencia', 'Pago por transferencia');

INSERT INTO recibos (id_cuota, fecha_pago  , monto   , forma_pago     , observaciones)
              VALUES(5       , '01/03/2024', 15000.55, 'Efectivo'     , 'Pago en efectivo');

INSERT INTO recibos (id_cuota, fecha_pago  , monto   , forma_pago     , observaciones)
              VALUES(6       , '01/04/2024', 15000.00, 'Transferencia', 'Pago por transferencia');

INSERT INTO recibos (id_cuota, fecha_pago  , monto   , forma_pago     , observaciones)
              VALUES(7       , '01/04/2024', 20000.02, 'Efectivo'     ,'Pago en efectivo');

INSERT INTO recibos (id_cuota, fecha_pago  , monto   , forma_pago     , observaciones)
              VALUES(8       , '01/05/2024', 20000.05, 'Transferencia', 'Pago por transferencia');

INSERT INTO recibos (id_cuota, fecha_pago  , monto   , forma_pago     , observaciones)
              VALUES(9       , '15/03/2024', 10000.53, 'Transferencia', 'Pago por transferencia');

INSERT INTO recibos (id_cuota, fecha_pago  , monto   , forma_pago     , observaciones)
              VALUES(10       , '01/03/2024', 15000.55, 'Efectivo'     , 'Pago en efectivo');

INSERT INTO recibos (id_cuota, fecha_pago  , monto   , forma_pago     , observaciones)
              VALUES(11      , '01/04/2024', 15000.00, 'Transferencia', 'Pago por transferencia');

INSERT INTO recibos (id_cuota, fecha_pago  , monto   , forma_pago     , observaciones)
              VALUES(12       , '01/04/2024', 20000.02, 'Efectivo'     ,'Pago en efectivo');

INSERT INTO recibos (id_cuota, fecha_pago  , monto   , forma_pago     , observaciones)
              VALUES(13       , '01/05/2024', 20000.05, 'Transferencia', 'Pago por transferencia');

INSERT INTO recibos (id_cuota, fecha_pago  , monto   , forma_pago     , observaciones)
              VALUES(14       , '15/03/2024', 10000.53, 'Transferencia', 'Pago por transferencia');

INSERT INTO recibos (id_cuota, fecha_pago  , monto   , forma_pago     , observaciones)
              VALUES(15       , '01/03/2024', 15000.55, 'Efectivo'     , 'Pago en efectivo');

INSERT INTO recibos (id_cuota, fecha_pago  , monto   , forma_pago     , observaciones)
              VALUES(16       , '01/04/2024', 15000.00, 'Transferencia', 'Pago por transferencia');

-- =======================
-- INSERTS DE NAHUEL
-- =======================

--INSERT TABLA NIVELES SOCIOS

INSERT INTO niveles_socios (descripcion,  beneficio)
                     VALUES('Hierro',     '5% descuento');

INSERT INTO niveles_socios ( descripcion, beneficio)
                     VALUES('Bronce',     '15% descuento');

INSERT INTO niveles_socios (descripcion,  beneficio)
                     VALUES('Oro',        '25% descuento');

INSERT INTO niveles_socios ( descripcion, beneficio)
                     VALUES('Platino',    '30% descuento');

INSERT INTO niveles_socios (descripcion,  beneficio)
                     VALUES('Diamante',   '35% descuento');

--INSERT TABLA ESTADO ETAPAS

INSERT INTO estado_etapas (descripcion)
                    VALUES('Planificada');

INSERT INTO estado_etapas (descripcion)
                    VALUES('En proceso');

INSERT INTO estado_etapas (descripcion)
                    VALUES('En espera');

INSERT INTO estado_etapas (descripcion)
                    VALUES('Requiere aprobacion');

INSERT INTO estado_etapas (descripcion)
                    VALUES('Finalizada sin facturar');

INSERT INTO estado_etapas (descripcion)
                    VALUES('Finalizada y facturada');

INSERT INTO estado_etapas (descripcion)
                    VALUES('Cancelada');

--INSERT TABLA TIPOS CONTACTOS

INSERT INTO tipos_contactos (descripcion)
                      VALUES('Telefono');
INSERT INTO tipos_contactos (descripcion)
                      VALUES('Email');
INSERT INTO tipos_contactos (descripcion)
                      VALUES('Telegrafo');
INSERT INTO tipos_contactos (descripcion)
                      VALUES('Telegram');
INSERT INTO tipos_contactos (descripcion)
                      VALUES('LinkedIn');
INSERT INTO tipos_contactos (descripcion)
                      VALUES('Discord');
INSERT INTO tipos_contactos (descripcion)
                      VALUES('Zoom');
INSERT INTO tipos_contactos (descripcion)
                      VALUES('Skype');



--INSERT TABLA POSIBLES GASTO

INSERT INTO rubros_gastos (descripcion)
VALUES   ('Materiales');

INSERT INTO rubros_gastos (descripcion)
VALUES   ('Mano de obra');

INSERT INTO rubros_gastos (descripcion)
VALUES   ('Transporte');

INSERT INTO rubros_gastos (descripcion)
VALUES   ('Servicios');

INSERT INTO rubros_gastos (descripcion)
VALUES   ('Impuestos');

INSERT INTO rubros_gastos (descripcion)
VALUES   ('Alquiler maquinaria');

INSERT INTO rubros_gastos (descripcion)
VALUES   ('Honorarios profesionales');

INSERT INTO rubros_gastos (descripcion)
VALUES   ('Permisos municipales');

INSERT INTO rubros_gastos (descripcion)
VALUES   ('Publicidades');

INSERT INTO rubros_gastos (descripcion)
VALUES   ('Mantenimiento');

INSERT INTO rubros_gastos (descripcion)
VALUES   ('Herramientas');

INSERT INTO rubros_gastos (descripcion)
VALUES   ('Seguridad e higiene');

INSERT INTO rubros_gastos (descripcion)
VALUES   ('Catering');

INSERT INTO rubros_gastos (descripcion)
VALUES   ('Capacitación');

INSERT INTO rubros_gastos (descripcion)
VALUES   ('Relevamientos');

INSERT INTO rubros_gastos (descripcion)
VALUES   ('Estudios de suelo');

INSERT INTO rubros_gastos (descripcion)
VALUES   ('Honorarios legales');

INSERT INTO rubros_gastos (descripcion)
VALUES   ('Viáticos');

INSERT INTO rubros_gastos (descripcion)
VALUES   ('Supervisión técnica');

INSERT INTO rubros_gastos (descripcion)
VALUES   ('Mobiliario');

INSERT INTO rubros_gastos (descripcion)
VALUES   ('Acondicionamiento térmico');

INSERT INTO rubros_gastos (descripcion)
VALUES   ('Electricidad');

INSERT INTO rubros_gastos (descripcion)
VALUES   ('Gas');

INSERT INTO rubros_gastos (descripcion)
VALUES   ('Agua');

INSERT INTO rubros_gastos (descripcion)
VALUES   ('Telefonía e internet');

INSERT INTO rubros_gastos (descripcion)
VALUES   ('Remodelación');

INSERT INTO rubros_gastos (descripcion)
VALUES   ('Obras adicionales');

INSERT INTO rubros_gastos (descripcion)
VALUES   ('Cerrajería');

INSERT INTO rubros_gastos (descripcion)
VALUES   ('Jardinería');

INSERT INTO rubros_gastos (descripcion)
VALUES   ('Demoliciones');

-- =======================
-- INSERTS DE PABLO
-- =======================

--INSERT TABLA TIPOS PLANOS

INSERT INTO tipos_planos(descripcion)
			    VALUES  ('Plano de obra');

INSERT INTO tipos_planos(descripcion)
			   VALUES	('Plano eléctrico');

INSERT INTO tipos_planos(descripcion)
			   VALUES	('Plano de instalación sanitaria');

INSERT INTO tipos_planos(descripcion)
			   VALUES   ('Plano estructural');

INSERT INTO tipos_planos(descripcion)
				VALUES	('Plano municipal');

INSERT INTO tipos_planos(descripcion)
				VALUES  ('Plano de arquitectura');

--INSERT TABLA ESTADOS PLANOS

INSERT INTO estados_planos(descripcion)
				VALUES    ('En desarrollo');

INSERT INTO estados_planos(descripcion)
				VALUES    ('Presentado');

INSERT INTO estados_planos(descripcion)
				VALUES    ('Aprobado');

INSERT INTO estados_planos(descripcion)
				VALUES    ('Rechazado');


--INSERT TABLA TIPOS PAGOS 
INSERT INTO tipos_pagos(descripcion)
			    VALUES  ('Efectivo');

INSERT INTO tipos_pagos(descripcion)
			  VALUES   ('Tarjeta de crédito');

INSERT INTO tipos_pagos(descripcion)
				VALUES ('Tarjeta de débito');

INSERT INTO tipos_pagos(descripcion)
			    VALUES ('Transferencia');

INSERT INTO tipos_pagos(descripcion)
			   VALUES   ('Cheque');

INSERT INTO tipos_pagos(descripcion)
			  VALUES   ('Pagaré');

			  -- INSERT TIPOS PROYECTOS
INSERT INTO tipos_proyectos (descripcion) 
                     VALUES ('Vivienda Unifamiliar');

INSERT INTO tipos_proyectos (descripcion) 
                     VALUES ('Edificio de Oficinas');

INSERT INTO tipos_proyectos (descripcion) 
                     VALUES ('Espacio Público');

INSERT INTO tipos_proyectos (descripcion) 
                     VALUES ('Centro Comercial');

INSERT INTO tipos_proyectos (descripcion) 
                     VALUES ('Obra de Restauración');




-- INSERT PROYECTOS

INSERT INTO proyectos (id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
			 VALUES   (5,          'NC-23456',       12,           400.75,             150.30,              '2024-02-01', '2025-01-31', '2025-02-15',         3,             1200.00);

INSERT INTO proyectos (id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
			 VALUES   (12,         'NC-98765',       7,            550.00,             250.00,              '2023-06-15', '2024-06-14', '2024-07-01',         2,              850.50);

INSERT INTO proyectos(id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
			VALUES	 (18,         'NC-12389',       20,           320.20,             120.50,              '2024-01-10', '2024-12-31', '2025-01-15',         1,              950.75);

INSERT INTO proyectos (id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
			VALUES	  (3,          'NC-54321',       35,           1000.00,            800.00,              '2023-11-01', '2024-10-30', '2024-11-15',         5,             2000.00);

INSERT INTO proyectos(id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
			VALUES	 (20,         'NC-67890',       15,           150.75,             100.25,              '2024-03-15', '2025-03-14', '2025-04-01',         4,             1150.00);

INSERT INTO proyectos(id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
			VALUES	 (7,          'NC-34567',       3,            600.00,             400.00,              '2023-09-01', '2024-08-31', '2024-09-15',         2,              900.00);

INSERT INTO proyectos(id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
			VALUES	 (14,         'NC-11223',       28,           700.25,             350.50,              '2024-04-01', '2025-03-31', '2025-04-15',         1,              1000.00);

INSERT INTO proyectos(id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
			VALUES	 (9,          'NC-99887',       40,           800.00,             500.00,              '2023-07-15', '2024-07-14', '2024-07-31',         3,             1100.25);

INSERT INTO proyectos(id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
			VALUES	 (21,         'NC-77654',       11,           450.50,             200.75,              '2024-05-10', '2025-05-09', '2025-05-25',         5,              950.00);

INSERT INTO proyectos(id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
			VALUES	 (4,          'NC-33445',       8,            500.00,             300.00,              '2023-08-20', '2024-08-19', '2024-09-05',         4,              980.75);

INSERT INTO proyectos(id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
		      VALUES (8,          'NC-55667',       22,           420.00,             210.00,              '2024-01-15', '2024-12-15', '2025-01-05',         2,               870.00);

INSERT INTO proyectos(id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
		      VALUES (16,         'NC-77889',       18,           360.50,             180.25,              '2023-10-01', '2024-09-30', '2024-10-20',         1,               925.50);

INSERT INTO proyectos(id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
			  VALUES (2,          'NC-99001',       4,            750.00,             450.00,              '2023-07-10', '2024-07-09', '2024-07-25',         3,               1050.00);

INSERT INTO proyectos(id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
			  VALUES (11,         'NC-11234',       29,           680.25,             340.00,              '2024-03-05', '2025-03-04', '2025-03-20',         4,               1150.50);

INSERT INTO proyectos(id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
			  VALUES (19,         'NC-44556',       10,           400.00,             200.00,              '2023-08-01', '2024-07-31', '2024-08-15',         5,               990.00);

INSERT INTO proyectos(id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
			  VALUES (13,         'NC-66778',       14,           520.50,             260.00,              '2024-02-20', '2025-02-19', '2025-03-01',         2,               880.75);

INSERT INTO proyectos(id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
			  VALUES (17,         'NC-88990',       25,           330.75,             160.00,              '2023-11-15', '2024-11-14', '2024-11-30',         1,               940.00);

INSERT INTO proyectos(id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
			  VALUES (10,         'NC-22334',       6,            610.00,             300.00,              '2023-09-05', '2024-09-04', '2024-09-20',         3,               1025.00);

INSERT INTO proyectos(id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
			  VALUES (15,         'NC-55678',       31,           700.00,             350.00,              '2024-04-10', '2025-04-09', '2025-04-25',         4,               1175.50);

INSERT INTO proyectos(id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
			  VALUES (23,         'NC-99012',       13,           440.00,             220.00,              '2023-07-20', '2024-07-19', '2024-08-05',         5,               985.00);

INSERT INTO proyectos(id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
			  VALUES (6,          'NC-33456',       9,            480.50,             230.25,              '2024-01-25', '2025-01-24', '2025-02-10',         2,               890.25);

INSERT INTO proyectos(id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
			  VALUES (1,          'NC-77890',       17,           390.00,             190.00,              '2023-10-05', '2024-10-04', '2024-10-20',         1,               935.50);

INSERT INTO proyectos(id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
			  VALUES (24,         'NC-11222',       26,           730.00,             360.00,              '2024-03-25', '2025-03-24', '2025-04-10',         3,               1075.00);

INSERT INTO proyectos(id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
			  VALUES (22,         'NC-44567',       19,           560.00,             280.00,              '2023-08-15', '2024-08-14', '2024-08-30',         4,               1120.50);

INSERT INTO proyectos(id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
			  VALUES (25,         'NC-66789',       21,           410.50,             205.00,              '2024-02-05', '2025-02-04', '2025-02-20',         5,               995.00);

INSERT INTO proyectos(id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
			  VALUES (5,          'NC-88991',       23,           680.00,             340.00,              '2023-11-10', '2024-11-09', '2024-11-25',         2,               885.00);

INSERT INTO proyectos(id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
			  VALUES (12,         'NC-22345',       27,           350.00,             175.00,              '2023-09-15', '2024-09-14', '2024-09-30',         1,               940.00);

INSERT INTO proyectos(id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
			  VALUES (18,         'NC-55679',       30,           620.00,             310.00,              '2024-04-05', '2025-04-04', '2025-04-20',         3,               1080.00);

INSERT INTO proyectos(id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
			  VALUES (3,          'NC-99013',       32,           540.00,             270.00,              '2023-07-25', '2024-07-24', '2024-08-10',         4,               1135.50);

INSERT INTO proyectos(id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
			  VALUES (20,         'NC-33457',       33,           460.00,             230.00,              '2024-01-20', '2025-01-19', '2025-02-05',         5,               1005.00);

INSERT INTO proyectos(id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
			  VALUES (7,          'NC-77891',       34,           700.00,             350.00,              '2023-10-10', '2024-10-09', '2024-10-25',         2,               895.00);

INSERT INTO proyectos(id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
			  VALUES (14,         'NC-11233',       36,           390.50,             195.00,              '2024-03-15', '2025-03-14', '2025-03-30',         1,               945.50);

INSERT INTO proyectos(id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
			  VALUES (9,          'NC-44568',       37,           580.00,             290.00,              '2023-08-25', '2024-08-24', '2024-09-10',         3,               1090.00);

INSERT INTO proyectos(id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
		      VALUES (21,         'NC-66790',       38,           630.00,             315.00,              '2024-02-15', '2025-02-14', '2025-03-01',         4,               1140.75);

INSERT INTO proyectos(id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
			  VALUES (4,          'NC-88992',       39,           410.00,             205.00,              '2023-11-20', '2024-11-19', '2024-12-05',         5,               1010.25);

INSERT INTO proyectos(id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
			  VALUES (8,          'NC-22346',       16,           500.00,             250.00,              '2024-01-10', '2025-01-09', '2025-01-25',         2,               900.50);

INSERT INTO proyectos(id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
			  VALUES (16,         'NC-55680',       24,           350.50,             175.00,              '2023-10-20', '2024-10-19', '2024-11-05',         1,               940.75);

INSERT INTO proyectos(id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
			  VALUES (2,          'NC-77892',       5,            600.00,             300.00,              '2023-07-15', '2024-07-14', '2024-07-30',         3,               1075.00);

INSERT INTO proyectos(id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
			  VALUES (11,         'NC-11235',       1,            700.25,             350.00,              '2024-03-20', '2025-03-19', '2025-04-05',         4,               1180.00);

INSERT INTO proyectos(id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
			  VALUES (19,         'NC-44569',       2,            420.00,             210.00,              '2023-08-10', '2024-08-09', '2024-08-25',         5,               1000.00);

INSERT INTO proyectos(id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
			  VALUES (13,         'NC-66791',       3,            520.50,             260.25,              '2024-02-25', '2025-02-24', '2025-03-10',         2,               890.50);

INSERT INTO proyectos(id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
			  VALUES (17,         'NC-88993',       4,            330.75,             165.00,              '2023-11-25', '2024-11-24', '2024-12-10',         1,               945.00);

INSERT INTO proyectos (id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
			  VALUES  (26,		  'NC-77892',	     36,		   390.50,			   195.25,				'2024-02-10', '2025-02-09', '2025-02-25',	 3,				   995.75);

INSERT INTO proyectos (id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
			  VALUES (27,         'NC-00112',       41,           500.00,             250.00,              '2024-05-01', '2025-04-30', '2025-05-15',         1,             1000.00);

INSERT INTO proyectos (id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
			  VALUES (28,         'NC-00223',       42,           650.00,             320.00,              '2024-06-10', '2025-06-09', '2025-06-25',         2,              910.00);

INSERT INTO proyectos (id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
			  VALUES (29,         'NC-00334',       43,           300.00,             140.00,              '2024-07-01', '2025-06-30', '2025-07-15',         3,             1100.00);

INSERT INTO proyectos (id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
			  VALUES (30,         'NC-00445',       44,           800.00,             600.00,              '2024-08-15', '2025-08-14', '2025-08-30',         4,             1250.00);

INSERT INTO proyectos (id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
			  VALUES (31,         'NC-00556',       45,           420.00,             210.00,              '2024-09-01', '2025-08-31', '2025-09-15',         5,             1020.00);

INSERT INTO proyectos (id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
			  VALUES (32,         'NC-00667',       46,           550.50,             270.25,              '2024-10-20', '2025-10-19', '2025-11-05',         1,              980.50);

INSERT INTO proyectos (id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
			  VALUES (33,         'NC-00778',       47,           700.00,             350.00,              '2024-11-05', '2025-11-04', '2025-11-20',         2,              890.00);

INSERT INTO proyectos (id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
			  VALUES (34,         'NC-00889',       48,           380.00,             190.00,              '2024-12-01', '2025-11-30', '2025-12-15',         3,             1085.00);

INSERT INTO proyectos (id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
			  VALUES (35,         'NC-00990',       49,           900.00,             700.00,              '2025-01-10', '2025-12-31', '2026-01-15',         4,             1300.00);

INSERT INTO proyectos (id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
			  VALUES (1,          'NC-01001',       50,           450.00,             225.00,              '2025-02-01', '2026-01-31', '2026-02-15',         5,             1030.00);

INSERT INTO proyectos (id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
			  VALUES (2,          'NC-01112',       1,            600.00,             300.00,              '2025-03-01', '2026-02-28', '2026-03-15',         1,             1015.00);

INSERT INTO proyectos (id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
			  VALUES (3,          'NC-01223',       2,            520.00,             260.00,              '2025-04-10', '2026-04-09', '2026-04-25',         2,              920.00);

INSERT INTO proyectos (id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
			  VALUES (4,          'NC-01334',       3,            340.00,             170.00,              '2025-05-05', '2026-05-04', '2026-05-20',         3,             1095.00);

INSERT INTO proyectos (id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
			  VALUES (5,          'NC-01445',       4,            720.00,             400.00,              '2025-06-15', '2026-06-14', '2026-06-30',         4,             1260.00);

INSERT INTO proyectos (id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
			  VALUES (6,          'NC-01556',       5,            480.00,             240.00,              '2025-07-01', '2026-06-30', '2026-07-15',         5,             1040.00);

INSERT INTO proyectos (id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
			  VALUES (7,          'NC-01667',       6,            590.00,             295.00,              '2025-08-20', '2026-08-19', '2026-09-05',         1,              990.00);

INSERT INTO proyectos (id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
			  VALUES (8,          'NC-01778',       7,            630.00,             315.00,              '2025-09-10', '2026-09-09', '2026-09-25',         2,              930.00);

INSERT INTO proyectos (id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
			  VALUES (9,          'NC-01889',       8,            370.00,             185.00,              '2025-10-01', '2026-09-30', '2026-10-15',         3,             1110.00);

INSERT INTO proyectos (id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
			  VALUES (10,         'NC-01990',       9,            850.00,             650.00,              '2025-11-01', '2026-10-31', '2026-11-15',         4,             1270.00);

INSERT INTO proyectos (id_cliente, numero_catastral, id_direccion, superficie_terreno, superficie_proyecto, fecha_inicio, fecha_fin, fecha_fin_estimado, id_tipo_proyecto, precio_m2)
			  VALUES (11,         'NC-02001',       10,           430.00,             215.00,              '2025-12-10', '2026-12-09', '2026-12-25',         5,             1050.00);



INSERT INTO detalle_facturas (id_factura, id_proyecto, descripcion)
                       VALUES(1         , 1          , 'Proyecto 1');

INSERT INTO detalle_facturas (id_factura, id_proyecto, descripcion)
                       VALUES(1         , 2          , 'Proyecto 2');

INSERT INTO detalle_facturas (id_factura, id_proyecto, descripcion)
                       VALUES(2         , 3          , 'Proyecto 3');

INSERT INTO detalle_facturas (id_factura, id_proyecto, descripcion)
                       VALUES(2         , 4          , 'Proyecto 4');

INSERT INTO detalle_facturas (id_factura, id_proyecto, descripcion)
                       VALUES(3         , 5          , 'Proyecto 5');

INSERT INTO detalle_facturas (id_factura, id_proyecto, descripcion)
                       VALUES(3         , 6          , 'Proyecto 6');

INSERT INTO detalle_facturas (id_factura, id_proyecto, descripcion)
                       VALUES(4         , 7          , 'Proyecto 7');

INSERT INTO detalle_facturas (id_factura, id_proyecto, descripcion)
                       VALUES(4         , 8          , 'Proyecto 8');

INSERT INTO detalle_facturas (id_factura, id_proyecto, descripcion)
                       VALUES(5         , 9          , 'Proyecto 9');

INSERT INTO detalle_facturas (id_factura, id_proyecto, descripcion)
                       VALUES(5         , 10         , 'Proyecto 10');

INSERT INTO detalle_facturas (id_factura, id_proyecto, descripcion)
                       VALUES(6         , 11         , 'Proyecto 11');

INSERT INTO detalle_facturas (id_factura, id_proyecto, descripcion)
                       VALUES(6         , 12         , 'Proyecto 12');

INSERT INTO detalle_facturas (id_factura, id_proyecto, descripcion)
                       VALUES(7         , 13         , 'Proyecto 13');

INSERT INTO detalle_facturas (id_factura, id_proyecto, descripcion)
                       VALUES(7         , 14         , 'Proyecto 14');

INSERT INTO detalle_facturas (id_factura, id_proyecto, descripcion)
                       VALUES(8         , 15         , 'Proyecto 15');

INSERT INTO detalle_facturas (id_factura, id_proyecto, descripcion)
                       VALUES(8         , 16         , 'Proyecto 16');

INSERT INTO detalle_facturas (id_factura, id_proyecto, descripcion)
                       VALUES(9         , 17         , 'Proyecto 17');

INSERT INTO detalle_facturas (id_factura, id_proyecto, descripcion)
                       VALUES(9         , 18         , 'Proyecto 18');

INSERT INTO detalle_facturas (id_factura, id_proyecto, descripcion)
                       VALUES(10        , 19         , 'Proyecto 19');

INSERT INTO detalle_facturas (id_factura, id_proyecto, descripcion)
                       VALUES(10        , 20         , 'Proyecto 20');



--INSERT TABLA PLANOS

INSERT INTO planos (id_proyecto,   fecha_creacion,  hora_creacion,  id_tipo_plano,  id_estado_plano,  descripcion)	
			VALUES ( 1,           '02/03/2010',    '09:45:00',    1,              2,                'revisión técnica');

INSERT INTO planos (id_proyecto,   fecha_creacion,  hora_creacion,  id_tipo_plano,  id_estado_plano,  descripcion)	
			VALUES ( 2,           '24/07/2022',    '15:20:00',    2,              4,                'sanitario chicos');

INSERT INTO planos (id_proyecto,   fecha_creacion,  hora_creacion,  id_tipo_plano,  id_estado_plano,  descripcion)	
			VALUES ( 3,            '21/01/2000',    '11:00:00',    1,              1,                'actualización planos');

INSERT INTO planos (id_proyecto,   fecha_creacion,  hora_creacion,  id_tipo_plano,  id_estado_plano,  descripcion)	
			VALUES ( 4,            '23/12/2001',    '16:10:00',    1,              1,                'modificación fachada');

INSERT INTO planos (id_proyecto,   fecha_creacion,  hora_creacion,  id_tipo_plano,  id_estado_plano,  descripcion)	
			VALUES ( 5,           '11/04/2015',    '10:25:00',    2,              2,                'ajuste en diseño');

INSERT INTO planos (id_proyecto,   fecha_creacion,  hora_creacion,  id_tipo_plano,  id_estado_plano,  descripcion)	
			VALUES ( 6,           '21/11/2018',    '14:40:00',    1,              4,                'revisión técnica');

INSERT INTO planos (id_proyecto,   fecha_creacion,  hora_creacion,  id_tipo_plano,  id_estado_plano,  descripcion)	
			VALUES ( 7,           '23/06/2023',    '09:15:00',    2,              3,                'actualización planos');

INSERT INTO planos (id_proyecto,   fecha_creacion,  hora_creacion,  id_tipo_plano,  id_estado_plano,  descripcion)	
			VALUES ( 8,           '02/02/2021',    '15:35:00',    1,              3,                'ajuste en diseño');

INSERT INTO planos (id_proyecto,   fecha_creacion,  hora_creacion,  id_tipo_plano,  id_estado_plano,  descripcion)	
			VALUES ( 9,           '05/05/2001',    '08:40:00',    2,              4,                 'baños');

INSERT INTO planos (id_proyecto,   fecha_creacion,  hora_creacion,  id_tipo_plano,  id_estado_plano,  descripcion)	
			VALUES ( 10,           '05/09/2024',    '17:00:00',    1,              1,                'actualización planos');

INSERT INTO planos (id_proyecto,   fecha_creacion,  hora_creacion,  id_tipo_plano,  id_estado_plano,  descripcion)	
			VALUES ( 11,           '06/01/2017',    '16:45:00',    1,              2,                'revisión técnica');

INSERT INTO planos (id_proyecto,   fecha_creacion,  hora_creacion,  id_tipo_plano,  id_estado_plano,  descripcion)	
			VALUES ( 12,            '13/04/2020',    '08:50:00',    1,              3,                'detalle estructural');

INSERT INTO planos (id_proyecto,   fecha_creacion,  hora_creacion,  id_tipo_plano,  id_estado_plano,  descripcion)	
			VALUES ( 13,           '17/12/2007',    '16:25:00',    2,              1,                'cocina ampliada');

INSERT INTO planos (id_proyecto,   fecha_creacion,  hora_creacion,  id_tipo_plano,  id_estado_plano,  descripcion)	
			VALUES ( 14,           '06/05/2006',    '13:15:00',    1,              3,                'actualización planos');

INSERT INTO planos (id_proyecto,   fecha_creacion,  hora_creacion,  id_tipo_plano,  id_estado_plano,  descripcion)	
			VALUES ( 15,           '03/07/2018',    '09:55:00',    2,              2,                'version corregida');

INSERT INTO planos (id_proyecto,   fecha_creacion,  hora_creacion,  id_tipo_plano,  id_estado_plano,  descripcion)	
			VALUES ( 16,           '23/02/2014',    '11:40:00',    1,              4,                'modificación fachada');

INSERT INTO planos (id_proyecto,   fecha_creacion,  hora_creacion,  id_tipo_plano,  id_estado_plano,  descripcion)	
			VALUES ( 17,            '21/09/2009',    '15:05:00',    2,              1,                'ajuste en diseño');

INSERT INTO planos (id_proyecto,   fecha_creacion,  hora_creacion,  id_tipo_plano,  id_estado_plano,  descripcion)	
			VALUES ( 18,           '23/01/2009',    '08:30:00',    1,              2,                'revisión técnica');

INSERT INTO planos (id_proyecto,   fecha_creacion,  hora_creacion,  id_tipo_plano,  id_estado_plano,  descripcion)	
			VALUES ( 19,           '21/06/2010',    '14:50:00',    2,              3,                'actualización planos');

INSERT INTO planos (id_proyecto,   fecha_creacion,  hora_creacion,  id_tipo_plano,  id_estado_plano,  descripcion)	
			VALUES ( 21,            '05/10/2013',    '15:30:00',    1,              1,                'actualización planos');


INSERT INTO planos (id_proyecto,   fecha_creacion,  hora_creacion,  id_tipo_plano,  id_estado_plano,  descripcion)	
			VALUES ( 22,            '12/02/2006',    '08:20:00',    1,              3,                'dibujo completo');


INSERT INTO planos (id_proyecto,   fecha_creacion,  hora_creacion,  id_tipo_plano,  id_estado_plano,  descripcion)	
			VALUES ( 24,           '12/09/2020',    '16:40:00',    2,              1,                'actualización planos');

INSERT INTO planos (id_proyecto,   fecha_creacion,  hora_creacion,  id_tipo_plano,  id_estado_plano,  descripcion)	
			VALUES ( 27,           '13/01/2005',    '15:10:00',    1,              1,                'ajuste en diseño');

INSERT INTO planos (id_proyecto,   fecha_creacion,  hora_creacion,  id_tipo_plano,  id_estado_plano,  descripcion)	
			VALUES ( 28,           '12/06/2016',    '08:45:00',    2,              2,                'revisión técnica');

INSERT INTO planos (id_proyecto,   fecha_creacion,  hora_creacion,  id_tipo_plano,  id_estado_plano,  descripcion)	
			VALUES ( 29,           '08/08/2002',    '14:35:00',    1,              3,                'actualización planos');

INSERT INTO planos (id_proyecto,   fecha_creacion,  hora_creacion,  id_tipo_plano,  id_estado_plano,  descripcion)	
			VALUES ( 30,           '24/10/2007',    '11:20:00',    2,              4,                'detalle estructural');

INSERT INTO planos (id_proyecto,   fecha_creacion,  hora_creacion,  id_tipo_plano,  id_estado_plano,  descripcion)	
			VALUES ( 31,           '17/05/2009',    '09:00:00',    1,              1,                'modificación fachada');

INSERT INTO planos (id_proyecto,   fecha_creacion,  hora_creacion,  id_tipo_plano,  id_estado_plano,  descripcion)	
			VALUES ( 32,           '03/12/2000',    '13:25:00',    2,              2,                'ajuste en diseño');

INSERT INTO planos (id_proyecto,   fecha_creacion,  hora_creacion,  id_tipo_plano,  id_estado_plano,  descripcion)	
			VALUES ( 33,           '13/02/2012',    '10:40:00',    1,              3,                'revisión técnica');

INSERT INTO planos (id_proyecto,   fecha_creacion,  hora_creacion,  id_tipo_plano,  id_estado_plano,  descripcion)	
			VALUES ( 34,           '13/07/2009',    '15:55:00',    2,              4,                'actualización planos');

INSERT INTO planos (id_proyecto,   fecha_creacion,  hora_creacion,  id_tipo_plano,  id_estado_plano,  descripcion)	
			VALUES ( 35,           '19/04/2018',    '11:30:00',    1,              1,                'detalle estructural');
			
INSERT INTO planos (id_proyecto,   fecha_creacion,  hora_creacion,  id_tipo_plano,  id_estado_plano,  descripcion)	
			VALUES ( 36,            '13/02/2006',    '08:20:00',    1,              3,                'dibujo completo');

INSERT INTO planos (id_proyecto,   fecha_creacion,  hora_creacion,  id_tipo_plano,  id_estado_plano,  descripcion)	
			VALUES ( 37,           '15/04/2001',    '10:50:00',    1,              2,                'plano nuevo');

INSERT INTO planos (id_proyecto,   fecha_creacion,  hora_creacion,  id_tipo_plano,  id_estado_plano,  descripcion)	
			VALUES ( 38,           '13/09/2016',    '16:40:00',    2,              1,                'actualización planos');

INSERT INTO planos (id_proyecto,   fecha_creacion,  hora_creacion,  id_tipo_plano,  id_estado_plano,  descripcion)	
			VALUES ( 39,            '17/11/2010',    '09:25:00',    1,              3,                'escaleras');

INSERT INTO planos (id_proyecto,   fecha_creacion,  hora_creacion,  id_tipo_plano,  id_estado_plano,  descripcion)	
			VALUES ( 40,           '20/03/2018',    '12:50:00',    2,              4,                'cableado general');


INSERT INTO arquitectos_proyectos (matricula_arquitecto, id_proyecto, rol)
VALUES ('ARQ0001', 1, 'Responsable');

INSERT INTO arquitectos_proyectos (matricula_arquitecto, id_proyecto, rol)
VALUES ('ARQ0002', 2, 'Colaborador');

INSERT INTO arquitectos_proyectos (matricula_arquitecto, id_proyecto, rol)
VALUES ('ARQ0003', 3, 'Responsable');

INSERT INTO arquitectos_proyectos (matricula_arquitecto, id_proyecto, rol)
VALUES ('ARQ0004', 4, 'Consultor');

INSERT INTO arquitectos_proyectos (matricula_arquitecto, id_proyecto, rol)
VALUES ('ARQ0005', 5, 'Colaborador');

INSERT INTO arquitectos_proyectos (matricula_arquitecto, id_proyecto, rol)
VALUES ('ARQ0006', 6, 'Responsable');

INSERT INTO arquitectos_proyectos (matricula_arquitecto, id_proyecto, rol)
VALUES ('ARQ0007', 7, 'Colaborador');

INSERT INTO arquitectos_proyectos (matricula_arquitecto, id_proyecto, rol)
VALUES ('ARQ0008', 8, 'Consultor');

INSERT INTO arquitectos_proyectos (matricula_arquitecto, id_proyecto, rol)
VALUES ('ARQ0009', 9, 'Responsable');

INSERT INTO arquitectos_proyectos (matricula_arquitecto, id_proyecto, rol)
VALUES ('ARQ0010', 10, 'Colaborador');

INSERT INTO arquitectos_proyectos (matricula_arquitecto, id_proyecto, rol)
VALUES ('ARQ0011', 11, 'Consultor');

INSERT INTO arquitectos_proyectos (matricula_arquitecto, id_proyecto, rol)
VALUES ('ARQ0012', 12, 'Responsable');

INSERT INTO arquitectos_proyectos (matricula_arquitecto, id_proyecto, rol)
VALUES ('ARQ0013', 13, 'Colaborador');

INSERT INTO arquitectos_proyectos (matricula_arquitecto, id_proyecto, rol)
VALUES ('ARQ0014', 14, 'Responsable');

INSERT INTO arquitectos_proyectos (matricula_arquitecto, id_proyecto, rol)
VALUES ('ARQ0015', 15, 'Consultor');

INSERT INTO arquitectos_proyectos (matricula_arquitecto, id_proyecto, rol)
VALUES ('ARQ0016', 16, 'Colaborador');

INSERT INTO arquitectos_proyectos (matricula_arquitecto, id_proyecto, rol)
VALUES ('ARQ0017', 17, 'Responsable');

INSERT INTO arquitectos_proyectos (matricula_arquitecto, id_proyecto, rol)
VALUES ('ARQ0018', 18, 'Consultor');

INSERT INTO arquitectos_proyectos (matricula_arquitecto, id_proyecto, rol)
VALUES ('ARQ0001', 19, 'Colaborador');

INSERT INTO arquitectos_proyectos (matricula_arquitecto, id_proyecto, rol)
VALUES ('ARQ0003', 21, 'Consultor');

INSERT INTO arquitectos_proyectos (matricula_arquitecto, id_proyecto, rol)
VALUES ('ARQ0004', 22, 'Responsable');

INSERT INTO arquitectos_proyectos (matricula_arquitecto, id_proyecto, rol)
VALUES ('ARQ0006', 24, 'Consultor');

INSERT INTO arquitectos_proyectos (matricula_arquitecto, id_proyecto, rol)
VALUES ('ARQ0008', 26, 'Colaborador');

INSERT INTO arquitectos_proyectos (matricula_arquitecto, id_proyecto, rol)
VALUES ('ARQ0009', 27, 'Consultor');

INSERT INTO arquitectos_proyectos (matricula_arquitecto, id_proyecto, rol)
VALUES ('ARQ0010', 28, 'Responsable');

INSERT INTO arquitectos_proyectos (matricula_arquitecto, id_proyecto, rol)
VALUES ('ARQ0011', 29, 'Colaborador');

INSERT INTO arquitectos_proyectos (matricula_arquitecto, id_proyecto, rol)
VALUES ('ARQ0012', 30, 'Responsable');

INSERT INTO arquitectos_proyectos (matricula_arquitecto, id_proyecto, rol)
VALUES ('ARQ0013', 31, 'Consultor');

INSERT INTO arquitectos_proyectos (matricula_arquitecto, id_proyecto, rol)
VALUES ('ARQ0014', 32, 'Colaborador');

INSERT INTO arquitectos_proyectos (matricula_arquitecto, id_proyecto, rol)
VALUES ('ARQ0015', 33, 'Responsable');

INSERT INTO arquitectos_proyectos (matricula_arquitecto, id_proyecto, rol)
VALUES ('ARQ0016', 34, 'Consultor');

INSERT INTO arquitectos_proyectos (matricula_arquitecto, id_proyecto, rol)
VALUES ('ARQ0017', 35, 'Colaborador');

INSERT INTO arquitectos_proyectos (matricula_arquitecto, id_proyecto, rol)
VALUES ('ARQ0018', 36, 'Responsable');

INSERT INTO arquitectos_proyectos (matricula_arquitecto, id_proyecto, rol)
VALUES ('ARQ0001', 37, 'Consultor');

INSERT INTO arquitectos_proyectos (matricula_arquitecto, id_proyecto, rol)
VALUES ('ARQ0002', 38, 'Colaborador');

INSERT INTO arquitectos_proyectos (matricula_arquitecto, id_proyecto, rol)
VALUES ('ARQ0003', 39, 'Responsable');

INSERT INTO arquitectos_proyectos (matricula_arquitecto, id_proyecto, rol)
VALUES ('ARQ0004', 40, 'Consultor');





INSERT INTO etapas_proyecto (id_proyecto, id_estado_etapa, fecha_inicio, fecha_estimada_finalizacion, fecha_finalizacion, id_equipo, facturada, id_factura)
                      VALUES(1,           5,               '09/10/2022', '12/11/2024',                '23/09/2024',       'EQUIPO A', 0,        NULL);

INSERT INTO etapas_proyecto (id_proyecto, id_estado_etapa, fecha_inicio, fecha_estimada_finalizacion, fecha_finalizacion, id_equipo, facturada, id_factura)
                      VALUES(2,           7,               '22/08/2024', '21/12/2025',                NULL,               'EQUIPO C', 0,        NULL);

INSERT INTO etapas_proyecto (id_proyecto, id_estado_etapa, fecha_inicio, fecha_estimada_finalizacion, fecha_finalizacion, id_equipo, facturada, id_factura)
                      VALUES(4,           5,               '12/10/2020', '07/07/2023',                '07/07/2023',       'EQUIPO B', 0,        NULL);

INSERT INTO etapas_proyecto (id_proyecto, id_estado_etapa, fecha_inicio, fecha_estimada_finalizacion, fecha_finalizacion, id_equipo, facturada, id_factura)
                      VALUES(6,           6,               '13/01/2021', '17/03/2024',                '17/03/2024',       'EQUIPO N', 1,        2);

INSERT INTO etapas_proyecto (id_proyecto, id_estado_etapa, fecha_inicio, fecha_estimada_finalizacion, fecha_finalizacion, id_equipo, facturada, id_factura)
                      VALUES(7,           6,               '14/06/2023', '12/03/2025',                '19/04/2025',       'EQUIPO N', 1,        3);

INSERT INTO etapas_proyecto (id_proyecto, id_estado_etapa, fecha_inicio, fecha_estimada_finalizacion, fecha_finalizacion, id_equipo, facturada, id_factura)
                      VALUES(8,           7,               '07/04/2021', '15/01/2024',                NULL,               'EQUIPO F', 0,        NULL);

INSERT INTO etapas_proyecto (id_proyecto, id_estado_etapa, fecha_inicio, fecha_estimada_finalizacion, fecha_finalizacion, id_equipo, facturada, id_factura)
                      VALUES(9,           2,               '19/11/2024', '29/04/2026',                NULL,               'EQUIPO Z', 0,        NULL);

INSERT INTO etapas_proyecto (id_proyecto, id_estado_etapa, fecha_inicio, fecha_estimada_finalizacion, fecha_finalizacion, id_equipo, facturada, id_factura)
                      VALUES(10,          1,               '05/04/2025', '08/03/2027',                NULL,               'EQUIPO X', 0,        NULL);

INSERT INTO etapas_proyecto (id_proyecto, id_estado_etapa, fecha_inicio, fecha_estimada_finalizacion, fecha_finalizacion, id_equipo, facturada, id_factura)
                      VALUES(11,           5,               '09/10/2022', '12/11/2024',                '23/09/2024',       'EQUIPO A', 0,        NULL);

INSERT INTO etapas_proyecto (id_proyecto, id_estado_etapa, fecha_inicio, fecha_estimada_finalizacion, fecha_finalizacion, id_equipo, facturada, id_factura)
                      VALUES(12,           7,               '22/08/2024', '21/12/2025',                NULL,               'EQUIPO C', 0,        NULL);

INSERT INTO etapas_proyecto (id_proyecto, id_estado_etapa, fecha_inicio, fecha_estimada_finalizacion, fecha_finalizacion, id_equipo, facturada, id_factura)
                      VALUES(13,           5,               '12/10/2020', '07/07/2023',                '07/07/2023',       'EQUIPO B', 0,        NULL);

INSERT INTO etapas_proyecto (id_proyecto, id_estado_etapa, fecha_inicio, fecha_estimada_finalizacion, fecha_finalizacion, id_equipo, facturada, id_factura)
                      VALUES(14,           6,               '13/01/2021', '17/03/2024',                '17/03/2024',       'EQUIPO N', 1,        2);

INSERT INTO etapas_proyecto (id_proyecto, id_estado_etapa, fecha_inicio, fecha_estimada_finalizacion, fecha_finalizacion, id_equipo, facturada, id_factura)
                      VALUES(15,           6,               '14/06/2023', '12/03/2025',                '19/04/2025',       'EQUIPO N', 1,        3);

INSERT INTO etapas_proyecto (id_proyecto, id_estado_etapa, fecha_inicio, fecha_estimada_finalizacion, fecha_finalizacion, id_equipo, facturada, id_factura)
                      VALUES(16,           7,               '07/04/2021', '15/01/2024',                NULL,               'EQUIPO F', 0,        NULL);

INSERT INTO etapas_proyecto (id_proyecto, id_estado_etapa, fecha_inicio, fecha_estimada_finalizacion, fecha_finalizacion, id_equipo, facturada, id_factura)
                      VALUES(17,           2,               '19/11/2024', '29/04/2026',                NULL,               'EQUIPO Z', 0,        NULL);

INSERT INTO etapas_proyecto (id_proyecto, id_estado_etapa, fecha_inicio, fecha_estimada_finalizacion, fecha_finalizacion, id_equipo, facturada, id_factura)
                      VALUES(18,          1,               '05/04/2025', '08/03/2027',                NULL,               'EQUIPO X', 0,        NULL);

INSERT INTO etapas_proyecto (id_proyecto, id_estado_etapa, fecha_inicio, fecha_estimada_finalizacion, fecha_finalizacion, id_equipo, facturada, id_factura)
                      VALUES(19,           5,               '09/10/2022', '12/11/2024',                '23/09/2024',       'EQUIPO A', 0,        NULL);

INSERT INTO etapas_proyecto (id_proyecto, id_estado_etapa, fecha_inicio, fecha_estimada_finalizacion, fecha_finalizacion, id_equipo, facturada, id_factura)
                      VALUES(20,           7,               '22/08/2024', '21/12/2025',                NULL,               'EQUIPO C', 0,        NULL);

INSERT INTO etapas_proyecto (id_proyecto, id_estado_etapa, fecha_inicio, fecha_estimada_finalizacion, fecha_finalizacion, id_equipo, facturada, id_factura)
                      VALUES(21,           5,               '12/10/2020', '07/07/2023',                '08/07/2023',       'EQUIPO B', 0,        NULL);

INSERT INTO etapas_proyecto (id_proyecto, id_estado_etapa, fecha_inicio, fecha_estimada_finalizacion, fecha_finalizacion, id_equipo, facturada, id_factura)
                      VALUES(22,           6,               '13/01/2021', '17/03/2024',                '18/03/2024',       'EQUIPO N', 1,        2);

INSERT INTO etapas_proyecto (id_proyecto, id_estado_etapa, fecha_inicio, fecha_estimada_finalizacion, fecha_finalizacion, id_equipo, facturada, id_factura)
                      VALUES(23,           6,               '14/06/2023', '12/03/2025',                '19/04/2025',       'EQUIPO N', 1,        3);

INSERT INTO etapas_proyecto (id_proyecto, id_estado_etapa, fecha_inicio, fecha_estimada_finalizacion, fecha_finalizacion, id_equipo, facturada, id_factura)
                      VALUES(24,           7,               '07/04/2021', '15/01/2024',                NULL,               'EQUIPO F', 0,        NULL);

INSERT INTO etapas_proyecto (id_proyecto, id_estado_etapa, fecha_inicio, fecha_estimada_finalizacion, fecha_finalizacion, id_equipo, facturada, id_factura)
                      VALUES(25,           2,               '19/11/2024', '29/04/2026',                NULL,               'EQUIPO Z', 0,        NULL);

INSERT INTO etapas_proyecto (id_proyecto, id_estado_etapa, fecha_inicio, fecha_estimada_finalizacion, fecha_finalizacion, id_equipo, facturada, id_factura)
                      VALUES(26,          1,               '05/04/2025', '08/03/2027',                NULL,               'EQUIPO X', 0,        NULL);

INSERT INTO etapas_proyecto (id_proyecto, id_estado_etapa, fecha_inicio, fecha_estimada_finalizacion, fecha_finalizacion, id_equipo, facturada, id_factura)
                      VALUES(27,           5,               '09/10/2022', '12/11/2024',                '23/09/2024',       'EQUIPO A', 0,        NULL);

INSERT INTO etapas_proyecto (id_proyecto, id_estado_etapa, fecha_inicio, fecha_estimada_finalizacion, fecha_finalizacion, id_equipo, facturada, id_factura)
                      VALUES(28,           7,               '22/08/2024', '21/12/2025',                NULL,               'EQUIPO C', 0,        NULL);

INSERT INTO etapas_proyecto (id_proyecto, id_estado_etapa, fecha_inicio, fecha_estimada_finalizacion, fecha_finalizacion, id_equipo, facturada, id_factura)
                      VALUES(29,           5,               '12/10/2020', '07/07/2023',                '07/07/2023',       'EQUIPO B', 0,        NULL);

INSERT INTO etapas_proyecto (id_proyecto, id_estado_etapa, fecha_inicio, fecha_estimada_finalizacion, fecha_finalizacion, id_equipo, facturada, id_factura)
                      VALUES(30,           6,               '13/01/2021', '17/03/2024',                '17/03/2024',       'EQUIPO N', 1,        2);

INSERT INTO etapas_proyecto (id_proyecto, id_estado_etapa, fecha_inicio, fecha_estimada_finalizacion, fecha_finalizacion, id_equipo, facturada, id_factura)
                      VALUES(31,           6,               '14/06/2023', '12/03/2025',                '19/04/2025',       'EQUIPO N', 1,        3);

INSERT INTO etapas_proyecto (id_proyecto, id_estado_etapa, fecha_inicio, fecha_estimada_finalizacion, fecha_finalizacion, id_equipo, facturada, id_factura)
                      VALUES(32,           7,               '07/04/2021', '15/01/2024',                NULL,               'EQUIPO F', 0,        NULL);

INSERT INTO etapas_proyecto (id_proyecto, id_estado_etapa, fecha_inicio, fecha_estimada_finalizacion, fecha_finalizacion, id_equipo, facturada, id_factura)
                      VALUES(33,           2,               '19/11/2024', '29/04/2026',                NULL,               'EQUIPO Z', 0,        NULL);

INSERT INTO etapas_proyecto (id_proyecto, id_estado_etapa, fecha_inicio, fecha_estimada_finalizacion, fecha_finalizacion, id_equipo, facturada, id_factura)
                      VALUES(34,          1,               '05/04/2025', '08/03/2027',                NULL,               'EQUIPO X', 0,        NULL);

INSERT INTO etapas_proyecto (id_proyecto, id_estado_etapa, fecha_inicio, fecha_estimada_finalizacion, fecha_finalizacion, id_equipo, facturada, id_factura)
                      VALUES(35,           5,               '09/10/2022', '12/11/2024',                '23/09/2026',       'EQUIPO A', 0,        NULL);

INSERT INTO etapas_proyecto (id_proyecto, id_estado_etapa, fecha_inicio, fecha_estimada_finalizacion, fecha_finalizacion, id_equipo, facturada, id_factura)
                      VALUES(36,           7,               '22/08/2024', '21/12/2025',                NULL,               'EQUIPO C', 0,        NULL);

INSERT INTO etapas_proyecto (id_proyecto, id_estado_etapa, fecha_inicio, fecha_estimada_finalizacion, fecha_finalizacion, id_equipo, facturada, id_factura)
                      VALUES(37,           5,               '12/10/2020', '07/07/2023',                '07/07/2026',       'EQUIPO B', 0,        NULL);

INSERT INTO etapas_proyecto (id_proyecto, id_estado_etapa, fecha_inicio, fecha_estimada_finalizacion, fecha_finalizacion, id_equipo, facturada, id_factura)
                      VALUES(38,           6,               '13/01/2021', '17/03/2024',                '17/03/2025',       'EQUIPO N', 1,        2);

INSERT INTO etapas_proyecto (id_proyecto, id_estado_etapa, fecha_inicio, fecha_estimada_finalizacion, fecha_finalizacion, id_equipo, facturada, id_factura)
                      VALUES(39,           6,               '14/06/2023', '12/03/2025',                '19/04/2025',       'EQUIPO N', 1,        3);

INSERT INTO etapas_proyecto (id_proyecto, id_estado_etapa, fecha_inicio, fecha_estimada_finalizacion, fecha_finalizacion, id_equipo, facturada, id_factura)
                      VALUES(40,           7,               '07/04/2021', '15/01/2024',                NULL,               'EQUIPO F', 0,        NULL);

INSERT INTO etapas_proyecto (id_proyecto, id_estado_etapa, fecha_inicio, fecha_estimada_finalizacion, fecha_finalizacion, id_equipo, facturada, id_factura)
                      VALUES(41,           2,               '19/11/2024', '29/04/2026',                NULL,               'EQUIPO Z', 0,        NULL);

INSERT INTO etapas_proyecto (id_proyecto, id_estado_etapa, fecha_inicio, fecha_estimada_finalizacion, fecha_finalizacion, id_equipo, facturada, id_factura)
                      VALUES(42,          1,               '05/04/2025', '08/03/2027',                NULL,               'EQUIPO X', 0,        NULL);

INSERT INTO etapas_proyecto (id_proyecto, id_estado_etapa, fecha_inicio, fecha_estimada_finalizacion, fecha_finalizacion, id_equipo, facturada, id_factura)
                      VALUES(43,           5,               '09/10/2022', '12/11/2024',                '23/09/2025',       'EQUIPO A', 0,        NULL);

INSERT INTO etapas_proyecto (id_proyecto, id_estado_etapa, fecha_inicio, fecha_estimada_finalizacion, fecha_finalizacion, id_equipo, facturada, id_factura)
                      VALUES(44,           7,               '22/08/2024', '21/12/2025',                NULL,               'EQUIPO C', 0,        NULL);

INSERT INTO etapas_proyecto (id_proyecto, id_estado_etapa, fecha_inicio, fecha_estimada_finalizacion, fecha_finalizacion, id_equipo, facturada, id_factura)
                      VALUES(45,           5,               '12/10/2020', '07/07/2023',                '07/07/2024',       'EQUIPO B', 0,        NULL);

INSERT INTO etapas_proyecto (id_proyecto, id_estado_etapa, fecha_inicio, fecha_estimada_finalizacion, fecha_finalizacion, id_equipo, facturada, id_factura)
                      VALUES(46,           2,               '22/11/2024', '29/04/2026',                NULL,               'EQUIPO Z', 0,        NULL);

INSERT INTO etapas_proyecto (id_proyecto, id_estado_etapa, fecha_inicio, fecha_estimada_finalizacion, fecha_finalizacion, id_equipo, facturada, id_factura)
                      VALUES(47,          1,               '13/04/2025', '08/03/2027',                NULL,               'EQUIPO X', 0,        NULL);

INSERT INTO etapas_proyecto (id_proyecto, id_estado_etapa, fecha_inicio, fecha_estimada_finalizacion, fecha_finalizacion, id_equipo, facturada, id_factura)
                      VALUES(48,           5,               '22/10/2022', '12/11/2024',                '23/12/2024',       'EQUIPO A', 0,        NULL);

INSERT INTO etapas_proyecto (id_proyecto, id_estado_etapa, fecha_inicio, fecha_estimada_finalizacion, fecha_finalizacion, id_equipo, facturada, id_factura)
                      VALUES(49,           7,               '27/08/2024', '21/12/2025',                NULL,               'EQUIPO C', 0,        NULL);

INSERT INTO etapas_proyecto (id_proyecto, id_estado_etapa, fecha_inicio, fecha_estimada_finalizacion, fecha_finalizacion, id_equipo, facturada, id_factura)
                      VALUES(50,           5,               '15/10/2020', '07/07/2023',                '07/08/2023',       'EQUIPO B', 0,        NULL);


-- INSERT GASTOS ETAPAS
		
INSERT INTO gastos_etapas (id_etapa_proyecto, id_rubro, descripcion, monto, fecha)
			 VALUES		  (1, 1, 'Compra materiales iniciales', 150000.00, '20/02/2016');

INSERT INTO gastos_etapas (id_etapa_proyecto, id_rubro, descripcion, monto, fecha)
				VALUES     (2, 2, 'Pago mano de obra fundaciones', 200000.00, '11/09/2000');

INSERT INTO gastos_etapas (id_etapa_proyecto, id_rubro, descripcion, monto, fecha)
				VALUES     (3, 3, 'Adquisición hierro y cemento', 180000.00, '10/06/2010');

INSERT INTO gastos_etapas (id_etapa_proyecto, id_rubro, descripcion, monto, fecha)
				VALUES    (4, 4, 'Instalación eléctrica', 220000.00, '11/11/2025');

INSERT INTO gastos_etapas (id_etapa_proyecto, id_rubro, descripcion, monto, fecha)
				VALUES    (5, 5, 'Pintura y terminaciones', 160000.00, '31/03/2020');

INSERT INTO gastos_etapas (id_etapa_proyecto, id_rubro, descripcion, monto, fecha)
			   VALUES     (6, 1, 'Alquiler grúa torre', 250000.00, '05/12/2025');

INSERT INTO gastos_etapas (id_etapa_proyecto, id_rubro, descripcion, monto, fecha)
				 VALUES   (7, 2, 'Pago arquitecto jefe', 300000.00, '06/07/2010');

INSERT INTO gastos_etapas (id_etapa_proyecto, id_rubro, descripcion, monto, fecha)
				 VALUES   (8, 3, 'Gestión permisos municipales', 50000.00, '23/08/2020');

INSERT INTO gastos_etapas (id_etapa_proyecto, id_rubro, descripcion, monto, fecha)
				 VALUES   (9, 4, 'Campaña de lanzamiento', 35000.00, '21/11/2015');

INSERT INTO gastos_etapas (id_etapa_proyecto, id_rubro, descripcion, monto, fecha)
			     VALUES   (10, 5, 'Reparación maquinaria', 85000.00, '01/01/2010');

INSERT INTO gastos_etapas (id_etapa_proyecto, id_rubro, descripcion, monto, fecha)
				VALUES    (11, 6, 'Compra herramientas nuevas', 92000.00, '12/04/2005');

INSERT INTO gastos_etapas (id_etapa_proyecto, id_rubro, descripcion, monto, fecha)
			     VALUES   (12, 7, 'Kit seguridad obra', 47000.00, '22/10/2015');

INSERT INTO gastos_etapas (id_etapa_proyecto, id_rubro, descripcion, monto, fecha)
	             VALUES   (13, 8, 'Catering inauguración', 20000.00, '14/04/2025');

INSERT INTO gastos_etapas (id_etapa_proyecto, id_rubro, descripcion, monto, fecha)
				VALUES   (14, 9, 'Curso personal técnico', 28000.00, '12/06/2001');

INSERT INTO gastos_etapas (id_etapa_proyecto, id_rubro, descripcion, monto, fecha)
				VALUES   (15, 10, 'Relevamiento inicial', 39000.00, '01/10/2020');

INSERT INTO gastos_etapas (id_etapa_proyecto, id_rubro, descripcion, monto, fecha)
				VALUES   (16, 11, 'Análisis del suelo', 61000.00, '22/07/2015');

INSERT INTO gastos_etapas (id_etapa_proyecto, id_rubro, descripcion, monto, fecha)
				VALUES   (17, 12, 'Asesoría legal', 45000.00, '12/12/2022');

INSERT INTO gastos_etapas (id_etapa_proyecto, id_rubro, descripcion, monto, fecha)
				VALUES   (18, 13, 'Viáticos inspección', 18000.00, '12/09/2024');

INSERT INTO gastos_etapas (id_etapa_proyecto, id_rubro, descripcion, monto, fecha)
				VALUES   (19, 14, 'Supervisión técnica obra', 70000.00, '22/03/2010');

INSERT INTO gastos_etapas (id_etapa_proyecto, id_rubro, descripcion, monto, fecha)
				 VALUES   (20, 15, 'Compra de escritorios', 88000.00, '10/12/2001');

INSERT INTO gastos_etapas (id_etapa_proyecto, id_rubro, descripcion, monto, fecha)
				 VALUES   (21, 16, 'Colocación aislante térmico', 95000.00, '20/08/2010');

INSERT INTO gastos_etapas (id_etapa_proyecto, id_rubro, descripcion, monto, fecha)
				 VALUES   (22, 17, 'Pago de luz', 42000.00, '22/01/2015');

INSERT INTO gastos_etapas (id_etapa_proyecto, id_rubro, descripcion, monto, fecha)
VALUES   (23, 18, 'Instalación de gas', 65000.00, '11/04/2009');

INSERT INTO gastos_etapas (id_etapa_proyecto, id_rubro, descripcion, monto, fecha)
				 VALUES   (24, 19, 'Conexión de agua', 37000.00, '14/06/2020');

INSERT INTO gastos_etapas (id_etapa_proyecto, id_rubro, descripcion, monto, fecha)
				 VALUES   (25, 20, 'Servicios de internet', 28000.00, '12/09/2001');

INSERT INTO gastos_etapas (id_etapa_proyecto, id_rubro, descripcion, monto, fecha)
				 VALUES   (26, 21, 'Revestimiento interior', 130000.00, '04/04/2005');

INSERT INTO gastos_etapas (id_etapa_proyecto, id_rubro, descripcion, monto, fecha)
				 VALUES   (27, 22, 'Obra adicional fachada', 110000.00, '13/02/2025');

INSERT INTO gastos_etapas (id_etapa_proyecto, id_rubro, descripcion, monto, fecha)
				 VALUES   (28, 23, 'Instalación cerraduras', 40000.00, '20/02/2010');

INSERT INTO gastos_etapas (id_etapa_proyecto, id_rubro, descripcion, monto, fecha)
			     VALUES   (29, 24, 'Diseño jardín frontal', 60000.00, '29/06/2001');

INSERT INTO gastos_etapas (id_etapa_proyecto, id_rubro, descripcion, monto, fecha)
				VALUES   (30, 25, 'Demolición pared vieja', 45000.00, '20/08/2010');

-- INSERT AVANCE ETAPAS

INSERT INTO avance_etapas (id_etapa_proyecto, porcentaje_avance, fecha_registro, observaciones)
			  	 VALUES   (1, 12.3, '12/03/2025', 'Inicio de obra');

INSERT INTO avance_etapas (id_etapa_proyecto, porcentaje_avance, fecha_registro, observaciones)
				 VALUES   (2, 27.8, '11/10/2007', 'Fundaciones casi terminadas');

INSERT INTO avance_etapas (id_etapa_proyecto, porcentaje_avance, fecha_registro, observaciones)
				 VALUES   (3, 43.5, '30/06/2017', 'Estructura avanzada');

INSERT INTO avance_etapas (id_etapa_proyecto, porcentaje_avance, fecha_registro, observaciones)
				 VALUES   (4, 65.0, '21/12/2022', 'Avance en instalaciones eléctricas');

INSERT INTO avance_etapas (id_etapa_proyecto, porcentaje_avance, fecha_registro, observaciones)
				 VALUES   (5, 79.2, '11/08/2012', 'Terminaciones en progreso');

INSERT INTO avance_etapas (id_etapa_proyecto, porcentaje_avance, fecha_registro, observaciones)
				 VALUES   (6, 18.4, '15/01/2012', 'Montaje de grúa torre');

INSERT INTO avance_etapas (id_etapa_proyecto, porcentaje_avance, fecha_registro, observaciones)
				 VALUES   (7, 33.1, '11/07/2017', 'Revisión arquitecto jefe');

INSERT INTO avance_etapas (id_etapa_proyecto, porcentaje_avance, fecha_registro, observaciones)
				 VALUES   (8, 45.9, '31/08/2000', 'Permisos municipales aprobados');

INSERT INTO avance_etapas (id_etapa_proyecto, porcentaje_avance, fecha_registro, observaciones)
				 VALUES   (9, 53.3, '12/11/2022', 'Lanzamiento promocional');

INSERT INTO avance_etapas (id_etapa_proyecto, porcentaje_avance, fecha_registro, observaciones)
				 VALUES   (10, 68.7, '12/01/2017', 'Mantenimiento de maquinaria');

INSERT INTO avance_etapas (id_etapa_proyecto, porcentaje_avance, fecha_registro, observaciones)
				 VALUES   (11, 72.5, '16/04/2015', 'Compra de herramientas');

INSERT INTO avance_etapas (id_etapa_proyecto, porcentaje_avance, fecha_registro, observaciones)
				 VALUES   (12, 48.3, '19/10/2025', 'Implementación seguridad');

INSERT INTO avance_etapas (id_etapa_proyecto, porcentaje_avance, fecha_registro, observaciones)
				 VALUES   (13, 25.7, '12/05/2010', 'Preparativos inauguración');

INSERT INTO avance_etapas (id_etapa_proyecto, porcentaje_avance, fecha_registro, observaciones)
				 VALUES   (14, 37.6, '14/06/2010', 'Capacitación personal técnico');

INSERT INTO avance_etapas (id_etapa_proyecto, porcentaje_avance, fecha_registro, observaciones)
				 VALUES   (15, 50.8, '13/10/2013', 'Relevamiento de obra');

INSERT INTO avance_etapas (id_etapa_proyecto, porcentaje_avance, fecha_registro, observaciones)
				 VALUES   (16, 64.1, '17/07/2020', 'Estudios de suelo realizados');

INSERT INTO avance_etapas (id_etapa_proyecto, porcentaje_avance, fecha_registro, observaciones)
				 VALUES   (17, 44.4, '21/01/2005', 'Asesoría legal finalizada');

INSERT INTO avance_etapas (id_etapa_proyecto, porcentaje_avance, fecha_registro, observaciones)
				 VALUES   (18, 20.5, '22/09/2010', 'Viáticos asignados');

INSERT INTO avance_etapas (id_etapa_proyecto, porcentaje_avance, fecha_registro, observaciones)
			     VALUES   (19, 72.9, '23/03/2020', 'Supervisión técnica constante');

INSERT INTO avance_etapas (id_etapa_proyecto, porcentaje_avance, fecha_registro, observaciones)
				 VALUES   (20, 81.3, '10/12/2015', 'Montaje de mobiliario');

INSERT INTO avance_etapas (id_etapa_proyecto, porcentaje_avance, fecha_registro, observaciones)
				 VALUES   (21, 90.0, '24/08/2021', 'Colocación aislante térmico');

INSERT INTO avance_etapas (id_etapa_proyecto, porcentaje_avance, fecha_registro, observaciones)
				 VALUES   (22, 40.7, '25/01/2023', 'Pago de luz realizado');

INSERT INTO avance_etapas (id_etapa_proyecto, porcentaje_avance, fecha_registro, observaciones)
				 VALUES   (23, 67.2, '26/04/2015', 'Instalación de gas completada');

INSERT INTO avance_etapas (id_etapa_proyecto, porcentaje_avance, fecha_registro, observaciones)
				 VALUES   (24, 34.9, '21/06/2018', 'Conexión de agua aprobada');

INSERT INTO avance_etapas (id_etapa_proyecto, porcentaje_avance, fecha_registro, observaciones)
				 VALUES   (25, 29.6, '22/02/2012', 'Servicios de internet activos');

INSERT INTO avance_etapas (id_etapa_proyecto, porcentaje_avance, fecha_registro, observaciones)
				 VALUES   (26, 53.8, '28/04/2015', 'Revestimientos interiores');

INSERT INTO avance_etapas (id_etapa_proyecto, porcentaje_avance, fecha_registro, observaciones)
				 VALUES   (27, 48.2, '30/11/2010', 'Fachada terminada');

INSERT INTO avance_etapas (id_etapa_proyecto, porcentaje_avance, fecha_registro, observaciones)
				 VALUES   (28, 60.6, '21/02/2021', 'Instalación de cerraduras');

INSERT INTO avance_etapas (id_etapa_proyecto, porcentaje_avance, fecha_registro, observaciones)
				 VALUES   (29, 68.7, '15/06/17', 'Diseño jardín completado');

INSERT INTO avance_etapas (id_etapa_proyecto, porcentaje_avance, fecha_registro, observaciones)
				 VALUES   (30, 78.9, '12/08/20', 'Demolición finalizada');

INSERT INTO socios (razon_social, cuil, id_tipo_documento, id_direccion, fecha_incorporacion, id_nivel_socio)
			VALUES('Tech Solutions S.A.', '30-11223344-5', 2, 1, '10/01/2022', 5);

INSERT INTO socios (razon_social, cuil, id_tipo_documento, id_direccion, fecha_incorporacion, id_nivel_socio)
			VALUES('Grupo Aventura', '30-22345678-2', 2, 1, '10/01/2021', 5);

INSERT INTO socios (razon_social, cuil, id_tipo_documento, id_direccion, fecha_incorporacion, id_nivel_socio)
			VALUES('Estilo Urbano SRL', '30-32345678-3', 2, 1, '10/01/2023', 5);

INSERT INTO socios (razon_social, cuil, id_tipo_documento, id_direccion, fecha_incorporacion, id_nivel_socio)
			VALUES('Perspectiva 3D Constructora S.A.', '30-42345678-4', 2, 1, '10/01/2024', 4);

INSERT INTO socios (razon_social, cuil, id_tipo_documento, id_direccion, fecha_incorporacion, id_nivel_socio)
			VALUES('Forma y Estructura S.R.L', '30-52345678-5', 2, 1, '10/01/2025', 4);

INSERT INTO socios (razon_social, cuil, id_tipo_documento, id_direccion, fecha_incorporacion, id_nivel_socio)
			VALUES('Habitat Moderno', '30-62345678-6', 2, 1, '10/01/2021', 4);

INSERT INTO socios (razon_social, cuil, id_tipo_documento, id_direccion, fecha_incorporacion, id_nivel_socio)
			VALUES('Diseño & Espacio Integral SRL', '30-72345678-7', 2, 1, '10/01/2023', 3);

INSERT INTO socios (razon_social, cuil, id_tipo_documento, id_direccion, fecha_incorporacion, id_nivel_socio)
			VALUES('Nova Proyectos S.A.', '30-82345678-8', 2, 1, '10/01/2022', 3);

INSERT INTO socios (razon_social, cuil, id_tipo_documento, id_direccion, fecha_incorporacion, id_nivel_socio)
			VALUES('Studio CBA City', '30-92345678-9', 2, 1, '10/01/2013', 3);

INSERT INTO socios (razon_social, cuil, id_tipo_documento, id_direccion, fecha_incorporacion, id_nivel_socio)
			VALUES('Obra Modular Argentina S.R.L', '30-10345678-0', 2, 1, '10/01/2021', 2);

INSERT INTO socios (razon_social, cuil, id_tipo_documento, id_direccion, fecha_incorporacion, id_nivel_socio)
			VALUES('Potente', '30-11345678-1', 2, 1, '20-08-2010', 2);

INSERT INTO socios (razon_social, cuil, id_tipo_documento, id_direccion, fecha_incorporacion, id_nivel_socio)
			VALUES('Zenta Arq S.R.L', '30-12345678-2', 2, 1, '10/01/2020', 2);

INSERT INTO socios (razon_social, cuil, id_tipo_documento, id_direccion, fecha_incorporacion, id_nivel_socio)
			VALUES('Grupo Proyectar', '30-13345678-3', 2, 1, '10/01/2010', 1);

INSERT INTO socios (razon_social, cuil, id_tipo_documento, id_direccion, fecha_incorporacion, id_nivel_socio)
			VALUES('Studio Metrópolis S.R.L', '30-14345678-4', 2, 1, '10/01/2000', 1);

INSERT INTO socios (razon_social, cuil, id_tipo_documento, id_direccion, fecha_incorporacion, id_nivel_socio)
			VALUES('Urbanismo S.A', '30-15345678-5', 2, 1, '10/01/20', 1);

INSERT INTO socios (razon_social, cuil, id_tipo_documento, id_direccion, fecha_incorporacion, id_nivel_socio)
			VALUES('Construcciones Futuras S.R.L.', '30-16345678-6', 2, 2, '10/01/2000', 5);

INSERT INTO socios (razon_social, cuil, id_tipo_documento, id_direccion, fecha_incorporacion, id_nivel_socio)
			VALUES('Desarrollos Integrales S.A.', '30-20345678-7', 2, 3, '10/01/2020', 4);

INSERT INTO socios (razon_social, cuil, id_tipo_documento, id_direccion, fecha_incorporacion, id_nivel_socio)
			VALUES('Innovación Edilicia S.R.L.', '30-18345678-8', 2, 4, '10/01/2021', 3);

INSERT INTO socios (razon_social, cuil, id_tipo_documento, id_direccion, fecha_incorporacion, id_nivel_socio)
			VALUES('Master Builders S.A.', '30-19345678-9', 2, 5, '10/01/2023', 2);

INSERT INTO socios (razon_social, cuil, id_tipo_documento, id_direccion, fecha_incorporacion, id_nivel_socio)
			VALUES('Pioneros del Diseño S.R.L.', '30-20345678-0', 2, 6, '10/01/2024', 1);

INSERT INTO socios (razon_social, cuil, id_tipo_documento, id_direccion, fecha_incorporacion, id_nivel_socio)
			VALUES('Soluciones Arquitectónicas S.A.', '30-21345678-1', 2, 7, '10/01/2023', 5);

INSERT INTO socios (razon_social, cuil, id_tipo_documento, id_direccion, fecha_incorporacion, id_nivel_socio)
			VALUES('Visionarios Constructores SRL', '30-22345678-2', 2, 8, '10/01/2021', 4);

INSERT INTO socios (razon_social, cuil, id_tipo_documento, id_direccion, fecha_incorporacion, id_nivel_socio)
			VALUES('Horizonte Urbano S.A.', '30-23345678-3', 2, 9, '10/01/2025', 3);

INSERT INTO socios (razon_social, cuil, id_tipo_documento, id_direccion, fecha_incorporacion, id_nivel_socio)
			VALUES ('Espacios Creativos S.R.L.', '30-24345678-4', 2, 10, '10/01/2021', 2);

INSERT INTO socios (razon_social, cuil, id_tipo_documento, id_direccion, fecha_incorporacion, id_nivel_socio)
			VALUES ('Grupo Edificar S.A.', '30-25345678-5', 2, 11, '10/01/2024', 1);

INSERT INTO socios (razon_social, cuil, id_tipo_documento, id_direccion, fecha_incorporacion, id_nivel_socio)
			VALUES ('Futura Edificaciones SRL', '30-26345678-6', 2, 12, '10-09-2020', 5);

INSERT INTO socios (razon_social, cuil, id_tipo_documento, id_direccion, fecha_incorporacion, id_nivel_socio)
			VALUES ('Diseño Vanguardista S.A.', '30-27345678-7', 2, 13, '10/01/2020', 4);

INSERT INTO socios (razon_social, cuil, id_tipo_documento, id_direccion, fecha_incorporacion, id_nivel_socio)
			VALUES ('Constructora del Sol S.R.L.', '30-28345678-8', 2, 14, '10/01/2020', 3);

INSERT INTO socios (razon_social, cuil, id_tipo_documento, id_direccion, fecha_incorporacion, id_nivel_socio)
			VALUES('Ingeniería Maestra S.A.', '30-29345678-9', 2, 15, '10/01/2000', 2);

INSERT INTO socios (razon_social, cuil, id_tipo_documento, id_direccion, fecha_incorporacion, id_nivel_socio)
			VALUES('Mega Obras S.R.L.', '30-30345678-0', 2, 16, '10/01/2000', 1);




INSERT INTO socios_proyectos (id_socio, id_proyecto, actividad)
				VALUES		 (2,		    1,		'Evaluacion del terreno y su entorno');

INSERT INTO socios_proyectos (id_socio, id_proyecto, actividad)
				VALUES		 (4,			2,	     'Relevamiento del terreno');

INSERT INTO socios_proyectos (id_socio, id_proyecto, actividad)
				VALUES		 (6,			3,		'Analisis de normativas urbanisticas');

INSERT INTO socios_proyectos (id_socio, id_proyecto, actividad)
				VALUES		(8,				4,		 'Desarrollo de anteproyecto');

INSERT INTO socios_proyectos (id_socio, id_proyecto, actividad)
				VALUES		 (10,		    5,		'Presentacion ante cliente');

INSERT INTO socios_proyectos (id_socio, id_proyecto, actividad)
				VALUES		 (12,			6,		'Diseño de planos arquitectonicos');

INSERT INTO socios_proyectos (id_socio, id_proyecto, actividad)
				VALUES		 (14,			7,		'Calculo estructural y definicion tecnica');

INSERT INTO socios_proyectos (id_socio, id_proyecto, actividad)
				VALUES		 (15,			8,		'Renderizado 3D del proyecto');

INSERT INTO socios_proyectos (id_socio, id_proyecto, actividad)
				VALUES		 (13,			9,		'Gestion de permisos municipales');

INSERT INTO socios_proyectos (id_socio, id_proyecto, actividad)
				VALUES		 (11,			10,		'Planificacion de etapas del proyecto');

INSERT INTO socios_proyectos (id_socio, id_proyecto, actividad)
				VALUES		 (9,			 11,	'Coordinacion de contratistas y proveedores');

INSERT INTO socios_proyectos (id_socio, id_proyecto, actividad)
				VALUES		 (7,			12,		'Supervision de obra y control de calidad');

INSERT INTO socios_proyectos (id_socio, id_proyecto, actividad)
				VALUES		(5,				13,		'Gestion de cronograma y presupuesto');

INSERT INTO socios_proyectos (id_socio, id_proyecto, actividad)
				VALUES		 (3,			14,		'Tramitacion de habilitaciones finales');

INSERT INTO socios_proyectos (id_socio, id_proyecto, actividad)
				VALUES		 (1,			15,		 'Cierre tecnico y documentacion del proyecto');

INSERT INTO socios_proyectos (id_socio, id_proyecto, actividad)
				VALUES		 (2,			16,		'Inspección de avance de obra');

INSERT INTO socios_proyectos (id_socio, id_proyecto, actividad)
				VALUES		 (4,			17,		'Actualización de planos y documentación');

INSERT INTO socios_proyectos (id_socio, id_proyecto, actividad)
				VALUES		 (6,			18,		'Selección de materiales y acabados');

INSERT INTO socios_proyectos (id_socio, id_proyecto, actividad)
				VALUES(8,					19,		'Reuniones de progreso con el cliente');

INSERT INTO socios_proyectos (id_socio, id_proyecto, actividad)
				VALUES		 (10,			20,		 'Gestión de cambios y modificaciones al proyecto');

INSERT INTO socios_proyectos (id_socio, id_proyecto, actividad)
				VALUES		 (12,			21,		 'Evaluación de impacto ambiental');

INSERT INTO socios_proyectos (id_socio, id_proyecto, actividad)
				VALUES		 (14,			22,		 'Asesoramiento en eficiencia energética');

INSERT INTO socios_proyectos (id_socio, id_proyecto, actividad)
				VALUES		 (15,			23,		'Estudio de viabilidad económica');

INSERT INTO socios_proyectos (id_socio, id_proyecto, actividad)
				VALUES       (13,			 24,	'Preparación de licitaciones y contratos');

INSERT INTO socios_proyectos (id_socio, id_proyecto, actividad)
				VALUES		 (11,			25,		'Negociación con proveedores');

INSERT INTO socios_proyectos (id_socio, id_proyecto, actividad)
				VALUES		 (9,			26,		'Análisis de riesgo del proyecto');

INSERT INTO socios_proyectos (id_socio, id_proyecto, actividad)
				VALUES		 (7,			 27,	 'Desarrollo de prototipos y maquetas');

INSERT INTO socios_proyectos (id_socio, id_proyecto, actividad)
				VALUES		 (5,			28,		'Control de calidad en la ejecución');

INSERT INTO socios_proyectos (id_socio, id_proyecto, actividad)
				VALUES		 (3,			29,		'Capacitación al personal de obra');

INSERT INTO socios_proyectos (id_socio, id_proyecto, actividad)
				VALUES		 (1,			30,		'Implementación de nuevas tecnologías constructivas');

INSERT INTO socios_proyectos (id_socio, id_proyecto, actividad)
				VALUES		 (2,			31,		 'Monitoreo de seguridad en la obra');

INSERT INTO socios_proyectos (id_socio, id_proyecto, actividad)
				VALUES		 (4,			32,		'Auditoría de costos del proyecto');

INSERT INTO socios_proyectos (id_socio, id_proyecto, actividad)
				VALUES		 (6,		    33,		'Preparación de informes de avance');

INSERT INTO socios_proyectos (id_socio, id_proyecto, actividad)
				VALUES		 (8,			34,		'Gestión de recursos humanos en el proyecto');

INSERT INTO socios_proyectos (id_socio, id_proyecto, actividad)
				VALUES		 (10,			35,		'Resolución de conflictos en obra');

INSERT INTO socios_proyectos (id_socio, id_proyecto, actividad)
				VALUES		 (12,			36,		'Certificación de cumplimiento normativo');

INSERT INTO socios_proyectos (id_socio, id_proyecto, actividad)
				VALUES		 (14,		    37,		'Documentación fotográfica del proceso');

INSERT INTO socios_proyectos (id_socio, id_proyecto, actividad)
				VALUES		 (15,			38,		'Participación en eventos de la industria');

INSERT INTO socios_proyectos (id_socio, id_proyecto, actividad)
				VALUES		 (13,			39,		'Investigación de nuevos materiales');

INSERT INTO socios_proyectos (id_socio, id_proyecto, actividad)
				VALUES		(11, 40, 'Desarrollo de estrategias de marketing para el proyecto');


--INSERT TABLA CONTACTOS
INSERT INTO contactos (contacto, id_tipo_contacto, matricula_arquitecto, id_socio, id_cliente)
VALUES   ('Juan Perez', 1, 'ARQ0001', 1, 1);

INSERT INTO contactos (contacto, id_tipo_contacto, matricula_arquitecto, id_socio, id_cliente)
VALUES   ('Maria Gomez', 2, 'ARQ0002', 2, 2);

INSERT INTO contactos (contacto, id_tipo_contacto, matricula_arquitecto, id_socio, id_cliente)
VALUES   ('Carlos Avellaneda', 3, 'ARQ0003', 3, 3);

INSERT INTO contactos (contacto, id_tipo_contacto, matricula_arquitecto, id_socio, id_cliente)
VALUES   ('Sofia Vergara', 4, 'ARQ0004', 4, 4);

INSERT INTO contactos (contacto, id_tipo_contacto, matricula_arquitecto, id_socio, id_cliente)
VALUES   ('Martina Pineda', 5, 'ARQ0005', 5, 5);

INSERT INTO contactos (contacto, id_tipo_contacto, matricula_arquitecto, id_socio, id_cliente)
VALUES   ('Bruno López', 1, 'ARQ0006', 6, 6);

INSERT INTO contactos (contacto, id_tipo_contacto, matricula_arquitecto, id_socio, id_cliente)
VALUES   ('Lucía Ortega', 2, 'ARQ0007', 7, 7);

INSERT INTO contactos (contacto, id_tipo_contacto, matricula_arquitecto, id_socio, id_cliente)
VALUES   ('Santiago Díaz', 3, 'ARQ0008', 8, 8);

INSERT INTO contactos (contacto, id_tipo_contacto, matricula_arquitecto, id_socio, id_cliente)
VALUES   ('Valeria Molina', 4, 'ARQ0009', 9, 9);

INSERT INTO contactos (contacto, id_tipo_contacto, matricula_arquitecto, id_socio, id_cliente)
VALUES   ('Tomás Herrera', 5, 'ARQ0010', 10, 10);

INSERT INTO contactos (contacto, id_tipo_contacto, matricula_arquitecto, id_socio, id_cliente)
VALUES   ('Romina Ríos', 1, 'ARQ0011', 11, 11);

INSERT INTO contactos (contacto, id_tipo_contacto, matricula_arquitecto, id_socio, id_cliente)
VALUES   ('Esteban Ayala', 2, 'ARQ0012', 12, 12);

INSERT INTO contactos (contacto, id_tipo_contacto, matricula_arquitecto, id_socio, id_cliente)
VALUES   ('Martina Campos', 3, 'ARQ0013', 13, 13);

INSERT INTO contactos (contacto, id_tipo_contacto, matricula_arquitecto, id_socio, id_cliente)
VALUES   ('Julián Quiroga', 4, 'ARQ0014', 14, 14);

INSERT INTO contactos (contacto, id_tipo_contacto, matricula_arquitecto, id_socio, id_cliente)
VALUES   ('Florencia Acosta', 5, 'ARQ0015', 15, 15);

INSERT INTO contactos (contacto, id_tipo_contacto, matricula_arquitecto, id_socio, id_cliente)
VALUES   ('Iván Miranda', 1, 'ARQ0016', 16, 16);

INSERT INTO contactos (contacto, id_tipo_contacto, matricula_arquitecto, id_socio, id_cliente)
VALUES   ('Camila Suárez', 2, 'ARQ0017', 17, 17);

INSERT INTO contactos (contacto, id_tipo_contacto, matricula_arquitecto, id_socio, id_cliente)
VALUES   ('Kevin Blanco', 3, 'ARQ0018', 18, 18);

INSERT INTO contactos (contacto, id_tipo_contacto, matricula_arquitecto, id_socio, id_cliente)
VALUES   ('Bárbara Giménez', 4, 'ARQ0001', 19, 19);

INSERT INTO contactos (contacto, id_tipo_contacto, matricula_arquitecto, id_socio, id_cliente)
VALUES   ('Emilio Méndez', 5, 'ARQ0002', 20, 20);

INSERT INTO contactos (contacto, id_tipo_contacto, matricula_arquitecto, id_socio, id_cliente)
VALUES   ('Lourdes Varela', 1, 'ARQ0003', 21, 21);

INSERT INTO contactos (contacto, id_tipo_contacto, matricula_arquitecto, id_socio, id_cliente)
VALUES   ('Franco Sosa', 2, 'ARQ0004', 22, 22);

INSERT INTO contactos (contacto, id_tipo_contacto, matricula_arquitecto, id_socio, id_cliente)
VALUES   ('Nadia Ponce', 3, 'ARQ0005', 23, 23);

INSERT INTO contactos (contacto, id_tipo_contacto, matricula_arquitecto, id_socio, id_cliente)
VALUES   ('Ramiro Toledo', 4, 'ARQ0006', 24, 24);

INSERT INTO contactos (contacto, id_tipo_contacto, matricula_arquitecto, id_socio, id_cliente)
VALUES   ('Juliana Roldán', 5, 'ARQ0007', 25, 25);

INSERT INTO contactos (contacto, id_tipo_contacto, matricula_arquitecto, id_socio, id_cliente)
VALUES   ('Gonzalo Benítez', 1, 'ARQ0008', 26, 26);

INSERT INTO contactos (contacto, id_tipo_contacto, matricula_arquitecto, id_socio, id_cliente)
VALUES   ('Mariana Vega', 2, 'ARQ0009', 27, 27);

INSERT INTO contactos (contacto, id_tipo_contacto, matricula_arquitecto, id_socio, id_cliente)
VALUES   ('Felipe Cardozo', 3, 'ARQ0010', 28, 28);

INSERT INTO contactos (contacto, id_tipo_contacto, matricula_arquitecto, id_socio, id_cliente)
VALUES   ('Andrea Salazar', 4, 'ARQ0011', 29, 29);

INSERT INTO contactos (contacto, id_tipo_contacto, matricula_arquitecto, id_socio, id_cliente)
VALUES   ('Pablo Godoy', 5, 'ARQ0012', 30, 30);


INSERT INTO factura_tipos_pago (id_factura, id_tipo_pago, monto_pago)
                         VALUES(1         , 1           , 5000.00);

INSERT INTO factura_tipos_pago (id_factura, id_tipo_pago, monto_pago)
                         VALUES(1         , 2           , 5000.00);

INSERT INTO factura_tipos_pago (id_factura, id_tipo_pago, monto_pago)
                         VALUES(2         , 3           , 10000.00);

INSERT INTO factura_tipos_pago (id_factura, id_tipo_pago, monto_pago)
                         VALUES(2         , 4           , 10000.00);

INSERT INTO factura_tipos_pago (id_factura, id_tipo_pago, monto_pago)
                         VALUES(3         , 5           , 15000.00);

INSERT INTO factura_tipos_pago (id_factura, id_tipo_pago, monto_pago)
                         VALUES(3         , 6           , 15000.00);

INSERT INTO factura_tipos_pago (id_factura, id_tipo_pago, monto_pago)
                         VALUES(4         , 3           , 20000.00);

INSERT INTO factura_tipos_pago (id_factura, id_tipo_pago, monto_pago)
                         VALUES(4         , 6           , 20000.00);

INSERT INTO factura_tipos_pago (id_factura, id_tipo_pago, monto_pago)
                         VALUES(5         , 2           , 25000.00);

INSERT INTO factura_tipos_pago (id_factura, id_tipo_pago, monto_pago)
                         VALUES(5         , 3           , 25000.00);

INSERT INTO factura_tipos_pago (id_factura, id_tipo_pago, monto_pago)
                         VALUES(6         , 1           , 30000.00);

INSERT INTO factura_tipos_pago (id_factura, id_tipo_pago, monto_pago)
                         VALUES(6         , 2           , 30000.00);

INSERT INTO factura_tipos_pago (id_factura, id_tipo_pago, monto_pago)
                         VALUES(7         , 1           , 35000.00);

INSERT INTO factura_tipos_pago (id_factura, id_tipo_pago, monto_pago)
                         VALUES(7         , 2           , 35000.00);

INSERT INTO factura_tipos_pago (id_factura, id_tipo_pago, monto_pago)
                         VALUES(8         , 1           , 40000.00);

INSERT INTO factura_tipos_pago (id_factura, id_tipo_pago, monto_pago)
                         VALUES(8         , 2           , 40000.00);

--INSERT TABLA FORMAS DE PAGOS USADAS EN RECIBOS
INSERT INTO formas_pago_recibos (id_recibo, id_tipo_pago, monto_pago)
VALUES   (1, 1, 1500.00);

INSERT INTO formas_pago_recibos (id_recibo, id_tipo_pago, monto_pago)
VALUES   (2, 2, 2000.00);

INSERT INTO formas_pago_recibos (id_recibo, id_tipo_pago, monto_pago)
VALUES   (3, 1, 1200.00);

INSERT INTO formas_pago_recibos (id_recibo, id_tipo_pago, monto_pago)
VALUES   (4, 3, 1800.00);

INSERT INTO formas_pago_recibos (id_recibo, id_tipo_pago, monto_pago)
VALUES   (5, 2, 1600.00);

INSERT INTO formas_pago_recibos (id_recibo, id_tipo_pago, monto_pago)
VALUES   (6, 1, 1200.00);

INSERT INTO formas_pago_recibos (id_recibo, id_tipo_pago, monto_pago)
VALUES   (7, 2, 1350.50);

INSERT INTO formas_pago_recibos (id_recibo, id_tipo_pago, monto_pago)
VALUES   (8, 3, 1425.00);

INSERT INTO formas_pago_recibos (id_recibo, id_tipo_pago, monto_pago)
VALUES   (9, 1, 1800.75);

INSERT INTO formas_pago_recibos (id_recibo, id_tipo_pago, monto_pago)
VALUES   (10, 2, 1550.00);

INSERT INTO formas_pago_recibos (id_recibo, id_tipo_pago, monto_pago)
VALUES   (11, 3, 1320.20);

INSERT INTO formas_pago_recibos (id_recibo, id_tipo_pago, monto_pago)
VALUES   (12, 1, 1499.99);

INSERT INTO formas_pago_recibos (id_recibo, id_tipo_pago, monto_pago)
VALUES   (13, 2, 1750.00);

INSERT INTO formas_pago_recibos (id_recibo, id_tipo_pago, monto_pago)
VALUES   (14, 3, 1600.00);

INSERT INTO formas_pago_recibos (id_recibo, id_tipo_pago, monto_pago)
VALUES   (15, 1, 1700.00);

INSERT INTO formas_pago_recibos (id_recibo, id_tipo_pago, monto_pago)
VALUES   (16, 2, 1590.30);


	SET DATEFORMAT dmy;



-- 1
-- Listar codigo del proyecto, nombre del arquietco y su pais de origen y el estado de 10 proyectos cuyo nombre del arquitecto inicie con una letra de la "C" a la "I" por 
-- algun arquitecto que tenga direccion argentina y que su estado de etapa sea Planificada o Finalizada sin facturar o Finalizada y facturada o cuyo gasto exeda de 1.000.000 de pesos y su fecha estimada de 
-- finalizacion sea para dentro de 1, 2 o 3 años.
SELECT p.id_proyecto AS 'codigo proyecto',a.nombre + SPACE(1) + a.apellido AS 'Nombre completo',pa.nombre AS 'Pais de origen'
FROM proyectos p
JOIN arquitectos_proyectos ap ON p.id_proyecto = ap.id_proyecto
JOIN arquitectos a ON a.matricula_habilitante = ap.matricula_arquitecto
JOIN direcciones d ON d.id_direccion = a.id_direccion
JOIN localidades l ON l.id_localidad = d.id_localidad
JOIN provincias pr ON pr.id_provincia = l.id_provincia
JOIN paises pa ON pa.id_pais = pr.id_pais 
JOIN etapas_proyecto e ON e.id_proyecto = p.id_proyecto
JOIN estado_etapas ee ON ee.id_estado_etapa = e.id_estado_etapa
JOIN gastos_etapas g ON g.id_etapa_proyecto = e.id_etapa_proyecto
WHERE a.nombre like '[C-i]%'AND LOWER(pa.nombre) = 'argentina' 
  AND (ee.descripcion in('Planificada','Finalizada sin facturar','Finalizada y facturada'))
  OR (g.monto >= 1000000 AND DATEDIFF(YEAR, GETDATE(), p.fecha_fin_estimado) between 1 and 3)


-- Mostrar los proyectos que:
-- La fecha de finalización estimada está dentro de los próximos 60 días.
-- El precio por metro cuadrado es mayor o igual a 1000.
-- La superficie del proyecto está entre 100 y 800 metros cuadrados.
-- El número catastral empieza con 'NC-00'.
-- La descripción del tipo de proyecto no es nula.

SELECT 
    p.id_proyecto,
    p.numero_catastral,
    p.fecha_inicio,
    p.fecha_fin,
    p.fecha_fin_estimado,
    DATEDIFF(DAY, GETDATE(), p.fecha_fin_estimado) AS dias_para_entrega,
    p.superficie_proyecto,
    p.precio_m2,
    tp.descripcion
FROM 
    proyectos p
LEFT JOIN 
    tipos_proyectos tp ON p.id_tipo_proyecto = tp.id_tipo_proyecto
WHERE 
    p.fecha_fin_estimado BETWEEN GETDATE() AND DATEADD(DAY, 60, GETDATE()) AND
    p.precio_m2 >= 1000 AND
    p.superficie_proyecto BETWEEN 100 AND 800 AND
    p.numero_catastral LIKE 'NC-00%' AND
    tp.descripcion IS NOT NULL



-- Mostrar una versión modificada de la descripción de aquellos planos que:
-- Fueron creados hace más de 5 años.. (Concatenandole un prefijo -old).
-- Mostrar el cálculo del precio total del proyecto multiplicando el precio por metro cuadrado por la superficie del terreno, en una columna llamada precio_total
-- Que son tipo "Plano de obra o Plano de arquitectura".
-- Están asociados a proyectos cuyo precio por metro cuadrado es 1000, 1200 o 1500.
-- Que el tipo pago de la factura sea Tarjeta de crédito.


SELECT 
    p.descripcion + '-old' AS descripcion_modificada,
    pr.precio_m2,
    pr.superficie_terreno,
    pr.precio_m2 * pr.superficie_terreno AS precio_total,
    tp.descripcion AS tipo_pago_descripcion
FROM planos p
JOIN proyectos pr ON p.id_proyecto = pr.id_proyecto
JOIN facturas f ON f.id_cliente = pr.id_cliente
JOIN factura_tipos_pago ftp ON ftp.id_factura = f.id_factura
JOIN tipos_pagos tp ON tp.id_tipo_pago = ftp.id_tipo_pago
WHERE DATEDIFF(year, p.fecha_creacion, GETDATE()) > 5
  AND pr.precio_m2 IN (1000, 1200, 1500)
  AND p.id_tipo_plano IN (1, 6)
  AND tp.id_tipo_pago = 2;