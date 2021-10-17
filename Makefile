serve:
	docker run -v $(PWD):/code -w /code -p 8000:8000 squidfunk/mkdocs-material:6.2.8 serve -a 0.0.0.0:8000
