index := $(PROJECT_ROOT)/dist/index.html

.PHONY: build clean deploy

build: $(index)

$(index):
	@website build

deploy: build
	@website deploy

clean:
	@website clean
