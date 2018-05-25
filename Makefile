
all: test
	./test

test: test.vala libcmark.vapi
	valac --vapidir . --pkg libcmark test.vala


