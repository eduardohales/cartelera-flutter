# Cartelera

El objetivo es crear una aplicación que permita a un usuario ver las peliculas que están actualmente en cartelera y guardar aquellas que desea ver.

Para ello, primeramente se debe crear un backend que permita registrar y loguear al usuario. Posterior a esto, ingresará a la pantalla principal, para la cual deberá consumir el siguiente servicio:

https://api.themoviedb.org/3/discover/movie?api_key=bf8fd38dca5a76f8943629f454221dac

Las imágenes se cargan de la siguiente forma: En el json viene el atributo

"poster_path": "/2uNW4WbgBXL25BAbXGLnLqX71Sw.jpg"

A este path se le concatena la url https://image.tmdb.org/t/p/w500, quedando:

https://image.tmdb.org/t/p/w500/2uNW4WbgBXL25BAbXGLnLqX71Sw.jpg

La que pueden cargar en la vista.

## Requisitos:

- Backend en NodeJS
- Base de datos MongoDB
- App móvil Android
- MVP como patrón de arquitectura de la aplicación
