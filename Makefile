.PHONY: clean-pyc clean-build clean develop tdd
define BROWSER_PYSCRIPT
import os, webbrowser, sys
try:
	from urllib import pathname2url
except:
	from urllib.request import pathname2url

webbrowser.open("file://" + pathname2url(os.path.abspath(sys.argv[1])))
endef
export BROWSER_PYSCRIPT
BROWSER := python -c "$$BROWSER_PYSCRIPT"

help:
	@echo "clean - remove all build, test, coverage and Python artifacts"
	@echo "clean-build - remove build artifacts"
	@echo "clean-pyc - remove Python file artifacts"
	@echo "clean-test - remove test and coverage artifacts"
	@echo "lint - check style with flake8"
	@echo "test - run tests quickly with the default Python"
	@echo "test-all - run tests on every Python version with tox"
	@echo "coverage - check code coverage quickly with the default Python"
	@echo "release - package and upload a release"
	@echo "dist - package"
	@echo "develop - install development dependencies"
	@echo "install - install the package to the active Python's site-packages"

clean: clean-build clean-pyc clean-test

clean-build:
	rm -fr build/
	rm -fr dist/
	rm -fr .eggs/
	find . -name '*.egg-info' -exec rm -fr {} +
	find . -name '*.egg' -exec rm -rf {} +

clean-pyc:
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -fr {} +

clean-test:
	rm -fr .tox/
	rm -f .coverage
	rm -fr htmlcov/

lint:
	flake8 percy tests

test:
	py.test tests/

tdd:
	pip install pytest-xdist
	py.test -f -v tests

test-all:
	tox

coverage:
	coverage run --source percy py.test

	coverage report -m
	coverage html
	$(BROWSER) htmlcov/index.html

bumpversion_patch: clean
	bumpversion patch

bumpversion_minor: clean
	bumpversion minor

bumpversion_major: clean
	bumpversion major

release: clean
	git push
	git push --tags
	python setup.py sdist
	python setup.py bdist_wheel
	twine upload dist/*

dist: clean
	python setup.py sdist
	python setup.py bdist_wheel
	ls -l dist

develop: clean
	pip install -r requirements_dev.txt

install: clean
	python setup.py install
