IDL_FILES = Foo.idl Bar.idl
IDL_FILES_NO_SUFFIX=$(basename $(notdir $(IDL_FILES)))

SERIALIZED_IDL_FILES = $(IDL_FILES_NO_SUFFIX:%=%.serialized)
JS_HEADERS = $(IDL_FILES_NO_SUFFIX:%=JS%.h)
JS_IMPLS = $(IDL_FILES_NO_SUFFIX:%=JS%.cpp)

OUTPUT_DIR=out
SERIALIZED_DIR=$(OUTPUT_DIR)/serialized
GENERATED_DIR=$(OUTPUT_DIR)/generated

vpath %.serialized $(SERIALIZED_DIR)
vpath %.h $(GENERATED_DIR)
vpath %.cpp $(GENERATED_DIR)

.PHONY : all clean

all : $(JS_HEADERS) $(JS_IMPLS)

JS%.cpp JS%.h : %.serialized generator.pl | Bindings.serialized
	$(info Running generator recipe: $?)
	./generator.pl --output=$(GENERATED_DIR) $?

Bindings.serialized : $(IDL_FILES) serializer.pl
	$(info Running serializer recipe: $?)
	./serializer.pl --output=$(SERIALIZED_DIR) $?

clean :
	$(info Cleaning up)
	rm -dfr $(OUTPUT_DIR)

