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
vpath %.generated $(OUTPUT_DIR)

.PHONY : all clean

all : $(JS_HEADERS) $(JS_IMPLS)

JS%.cpp JS%.h : $(OUTPUT_DIR)/Bindings.generated ;

$(OUTPUT_DIR)/Bindings.generated : $(IDL_FILES) serializer-and-generator.pl
	$(info Running serializer-and-generator recipe: $@ | $?)
	./serializer-and-generator.pl --output=$(OUTPUT_DIR) $(IDL_FILES:%=--i %) $(filter-out serializer-and-generator.pl,$(if $(filter serializer-and-generator.pl,$?),$^,$?))
	@touch $(OUTPUT_DIR)/Bindings.generated

clean :
	$(info Cleaning up)
	rm -dfr $(OUTPUT_DIR)

