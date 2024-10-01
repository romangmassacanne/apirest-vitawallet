# README

Instructivo para comenzar a utilizar la API REST
¡Bienvenido a la API REST para transacciones! Sigue estos pasos para empezar a utilizarla:

Instalar las dependencias:
- `bundle install`

Crear la base:
- `rails db:create`

Correr las migraciones: 
Ejecuta el siguiente comando para migrar la base de datos: 
- `rails db:migrate`

Correr el seed: 
Utilizar el comando a continuación para sembrar la base de datos con datos iniciales, incluyendo la configuración del tipo de moneda USD, que servirá como la moneda base para el sistema y la BTC para interactuar: 
- `rails db:seed`

Esto asegurará que tengamos una moneda base configurada para comenzar a trabajar.

Iniciar el servicio: Para poner en marcha nuestra API, ejecuta el siguiente comando: 
- `rails s`.

Corre en: http://127.0.0.1:3000/api/v1 .

Es necesario iniciar sesión para poder obtener el token y de esta manera colocarlo en el header para poder realizar las peticiones.
Esto en la ruta: "http://127.0.0.1:3000/api/v1/auth/login"


email: `admin@gmail.com`
password: `admin`

Te entrega un token similar a este:
token: eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxLCJleHAiOjE3MjgwMTEwOTZ9.87jpvZPIfOvec7VuezpAZnL5hObnD4-i7ZU071Z1uLc .


Para ver la documentación es necesario ingresar al link:

- `http://localhost:3000/apidocs`.

Para realizar correr los test es necesario cambiar de ambiente para no realizar las pruebas sobre el ambiente de desarrollo:

- `bin/rails db:environment:set RAILS_ENV=test`.

Y luego corremos los tests:

- `rspec`.

Despues para volver a correr en el ambiente de desarrollo colocamos el comando:

- `bin/rails db:environment:set RAILS_ENV=development`

Aclaraciones Generales:
Comentarios en el código: Puedes encontrar comentarios en el código que explican situaciones específicas debido al alcance de la API.

Protección del dinero: La API no posee protección del dinero en caso de falla u otros escenarios.

Presentación de datos: En caso de necesitar presentar los datos de alguna manera específica, se puede utilizar una gema como Jbuilder o un serializador para cada clase.

Funcionalidades no implementadas: La capacidad de ingresar y retirar dinero no se ha modelado en la API. Los usuarios comienzan con un saldo inicial de 10.000 dólares y este se va actualizando conforme realizan transacciones.
