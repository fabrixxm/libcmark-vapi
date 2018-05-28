VERSION:=`pkg-config --modversion libcmark`

.PHONY: clean, all, docs
all: test
	./test

test: test.vala libcmark.vapi
	valac  --Xcc=-O0 --vapidir . --pkg libcmark test.vala

docs:
	rm -fr docs/
	valadoc -o docs --vapidir . --package-name=libcmark --package-version=$(VERSION) libcmark.vapi

clean:
	rm -fr docs/
	rm test

