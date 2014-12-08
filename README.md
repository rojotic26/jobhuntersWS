====================
JOBHUNTERS
---------------------
[ ![Codeship Status for rojotic26/jobhuntersWS](https://codeship.io/projects/398aace0-487e-0132-a261-22cfb918076e/status)](https://codeship.io/projects/45892)

## Usage

This elemental WebService consumes the gem jobhunters to obtain information of some job offers in CA.

## Handles:

## URL in Heroku: http://jobhunters.herokuapp.com/

##GET

- GET /api/v1/
	- returns JSON of job offers info: category (category), job_offers(Array of joboffers)

- GET with categories:
			>[http://jobhunters.herokuapp.com/api/v1/job_openings/marketing.json](http://jobhunters.herokuapp.com/api/v1/job_openings/marketing.json)

	-This returns:
>{"type of job":"marketing-ventas","kind":"openings","jobs":[{"id":"Asesor de Ventas Retail ESET","date":"2014-12-01","city":"Guatemala"},{"id":"Ejecutivo de Cuentas Claves Guatemala","date":"2014-12-01","city":"Guatemala"},{"id":"Ejecutivo de Cuentas Claves El Salvador","date":"2014-12-01","city":"El Salvador"},{"id":"Demo Vendedor El Salvador","date":"2014-12-01","city":"El Salvador"},{"id":"Asesor Comercial","date":"2014-12-01","city":"El Salvador"},{"id":"Asesores de Ventas y Auxiliares de Bodega","date":"2014-12-01","city":"El Salvador"},{"id":"ASESOR AGRICOLA","date":"2014-11-30","city":"El Salvador"},{"id":"VENDEDOR VETERINARIO","date":"2014-11-30","city":"El Salvador"},{"id":"Ejecutivo de Ventas de Sistemas y Proyectos ","date":"2014-11-12","city":"Guatemala"},{"id":"Vendedor Senior ","date":"2014-11-14","city":"Guatemala"},{"id":"Vendedor Senior ","date":"2014-11-14","city":"Guatemala"},{"id":"Ejecutivo de Ventas Consumo Masivo ","date":"2014-11-28","city":"Guatemala"},{"id":"Supervisor de Ventas ","date":"2014-11-20","city":"Guatemala"},{"id":"Ejecutivo de Ventas Senior ","date":"2014-11-30","city":"Costa Rica"},{"id":"PREVENDEDOR","date":"2014-11-08","city":"Nicaragua"}]}

##POST

- POST /api/v1/all
	- returns JSON of all of the job offers info: category, id, title, city, details.
>	curl -v -H "Accept: application/json" -H "Content-type: application/json" \
>	-X POST -d "{\"categories\":[\"marketing-ventas\"]}" \
>	http://jobhunters.herokuapp.com/api/v1/all

- POST /api/v1/offers
	- record a query with the parameters you send
> curl -v -H "Accept: application/json" -H "Content-type: application/json" \      -X POST -d "{\"category\":[\"marketing-ventas\"]}" \      http://127.0.0.1:9292/api/v1/joboffers

- GET /api/v1/offers/:id
	- Takes: Id's (1,2,3)
	- Returns: List of jobs available of stored category

## Team Members

- Mauricio Jaime - mjboyarov@gmail.com / Nicaragua (毛里求 - 尼加拉瓜)
- Roger Gomez - rojotic26@gmail.com / Nicaragua (羅傑 - 尼加拉瓜)
- Edwin Mejia - eddwin@live.com / El Salvador (埃德温 - 薩爾瓦多)
