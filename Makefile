PYTHON = python3

VENV   = $(CURDIR)/.venv
PIP    = $(VENV)/bin/pip
TRIADE = $(VENV)/bin/triade

ifndef XDG_DATA_HOME
    XDG_DATA_HOME = $(HOME)/.local/share
endif

MODS_DIR = $(XDG_DATA_HOME)/Steam/steamapps/common/Xenonauts/assets/mods
OUTPUT_DIR = $(MODS_DIR)/RankedLoadouts

all: loadouts.xml

$(VENV): requirements.txt
	if test ! -d "$@"; then $(PYTHON) -m venv "$@"; fi
	$(PIP) install --upgrade pip -r $<
	touch "$@"

install: loadouts.xml modinfo.xml strings.xml dist $(OUTPUT_DIR)
	cp loadouts.xml modinfo.xml strings.xml dist

loadouts.xml: data/loadouts/*.yml | $(VENV)
	cat $^ | $(TRIADE) -I yaml -o $@

link: $(OUTPUT_DIR)

unlink:
	if test -d "$(OUTPUT_DIR)"; then unlink "$(OUTPUT_DIR)"; fi

$(OUTPUT_DIR): | dist
	if test ! -e "$@"; then ln -s "$(CURDIR)/dist" "$@"; fi

dist:
	mkdir -p dist

.PHONY: all

.SILENT: $(VENV) loadouts.xml
