# 🐧 Script Bash – Informe y Gestión de Procesos por Terminal

## 📌 Descripción

Este proyecto consiste en un **script en Bash** que permite generar un **informe de los procesos en ejecución de un usuario** en un sistema GNU/Linux, con la posibilidad de **filtrar por terminal (TTY)** y **finalizar procesos de forma interactiva**.

El script está orientado a tareas de **administración de sistemas**, auditoría básica y aprendizaje del uso de herramientas de monitorización y control de procesos en Linux.

---

## 🎯 Objetivos del script

* Obtener un informe de los procesos activos de un usuario concreto.
* Filtrar los procesos por una terminal específica (TTY).
* Guardar los informes y acciones en archivos de log.
* Permitir la eliminación interactiva de procesos.

---

## ⚙️ Funcionamiento general

El script:

1. Crea un directorio de logs si no existe.
2. Registra la ejecución del script en un archivo de log.
3. Procesa las opciones introducidas por línea de comandos.
4. Genera un informe con los procesos del usuario indicado.
5. Pregunta al usuario si desea finalizar alguno de los procesos listados.
6. Registra todas las acciones realizadas.

---

## 📂 Estructura de archivos generados

```
logs/
├── log.txt                  # Log general de ejecuciones
└── procesos_<usuario>.log   # Informe de procesos del usuario
```

---

## 🧾 Opciones disponibles

El script acepta las siguientes opciones:

* `-u <usuario>` → Usuario del que se quieren obtener los procesos (**obligatorio**).
* `-t <tty>` → Terminal (TTY) desde la que se quieren filtrar los procesos (opcional).

### Ejemplo de uso

```bash
./scropstty.sh -u juan
```

```bash
./scropstty.sh -u juan -t pts/0
```

---

## 🧰 Funcionalidades

* Comprobación de existencia del usuario en el sistema.
* Generación automática de logs.
* Creación de informes de procesos mediante `ps`.
* Filtrado por terminal usando `grep`.
* Eliminación interactiva de procesos mediante `kill -9`.
* Contabilización de procesos registrados y eliminados.

---

## 📝 Logs

Todas las acciones quedan registradas en:

```text
logs/log.txt
```

Incluye información sobre:

* Usuario que ejecuta el script.
* Fecha de ejecución.
* Procesos eliminados.
* Resumen final de la ejecución.

---

## ⚠️ Advertencias importantes

* El script **finaliza procesos reales del sistema**.
* Se recomienda usarlo únicamente en:

  * Entornos de pruebas
  * Máquinas virtuales
  * Sistemas no productivos

El uso incorrecto puede provocar inestabilidad en el sistema.

---

## 🚀 Requisitos

* Sistema operativo **GNU/Linux**
* **Bash**
* Comandos disponibles:

  * `ps`
  * `grep`
  * `awk`
  * `kill`
  * `whoami`
  * `date`

---

## 📄 Licencia

Proyecto de uso educativo y libre. Se permite su modificación y redistribución citando al autor original.

---

##
