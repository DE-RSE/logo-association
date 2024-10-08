# This Makefile is intended to generate various other image formats from the
# svg versions within this directory. Those files will end up in a directory
# "build" (see the OUTDIR variable below), and will be generated using
# "inkscape" (see INKSCAPE variable below).
#
# To generate those files, type "make"
# To delete the generated files again, use "make clean"

INKSCAPE :=inkscape
OUTDIR   :=build

# input
SVG := $(wildcard *.svg)

# output
PNG_HEIGHTS := 32 48 64 128 256 512 1000 1024
PNG := $(foreach HEIGHT, $(PNG_HEIGHTS), $(addprefix $(OUTDIR)/,$(SVG:.svg=_$(HEIGHT).png)))

PDF := $(addprefix $(OUTDIR)/,$(SVG:.svg=.pdf))

# targets

all: $(OUTDIR) ${PNG} ${PDF}

clean:
	# Do not simply "rm -rf" the $(OUTPUT) directory, as users might have saved
	# extra files in there. Only delete files with names of those we generated.
	rm -f ${PNG} ${PDF}
	if [ -d $(OUTDIR) ]; then rmdir --ignore-fail-on-non-empty $(OUTDIR); fi

$(OUTDIR):
	mkdir -p $@

# define make targets for different png sizes from the list PNG_HEIGHTS
define png_target =
$$(OUTDIR)/%_$(1).png: %.svg $(OUTDIR)
	$$(INKSCAPE) --export-area-page -D --export-height=$(1) -e $$@ $$<
endef
$(foreach HEIGHT, $(PNG_HEIGHTS), $(eval $(call png_target,$(HEIGHT))))

$(OUTDIR)/%.pdf: %.svg $(OUTDIR)
	$(INKSCAPE) -D -A $@ $<

