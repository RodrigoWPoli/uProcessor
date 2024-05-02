# description:
#   run with make simulate tb=testBenchxxxxx

CC = ghdl
SIM = gtkwave
WORKDIR = debug
WAVEDIR = wave
QUIET = @

tb?= testBench

# analyze these first since some other circuits depend on these
VHDL_SOURCES += rtl/mux2.vhd
VHDL_SOURCES += rtl/register16bits.vhd
VHDL_SOURCES += rtl/ula.vhd

# add rest of the files in rtl directory for analyzing
VHDL_SOURCES += $(wildcard rtl/*.vhd)


TBS = $(wildcard tb/testBench*.vhd)

TB = $(tb)

CFLAGS += --warn-binding
CFLAGS += --warn-no-library # turn off warning on design replace with same name


.PHONY: analyze
analyze: clean
	@echo ">>> analyzing designs..."
	$(QUIET)mkdir -p $(WORKDIR)
	$(QUIET)$(CC) -a $(CFLAGS) --workdir=$(WORKDIR) $(VHDL_SOURCES) $(TBS)

.PHONY: elaborate
elaborate: analyze
	@echo ">>> elaborating designs.."
	@echo ">>> sources..."
	$(QUIET)mkdir -p $(WORKDIR)
	$(QUIET)$(CC) -e $(CFLAGS) --workdir=$(WORKDIR) mux2
	$(QUIET)$(CC) -e $(CFLAGS) --workdir=$(WORKDIR) register16bits
	$(QUIET)$(CC) -e $(CFLAGS) --workdir=$(WORKDIR) ula
	$(QUIET)$(CC) -e $(CFLAGS) --workdir=$(WORKDIR) registerBank
	$(QUIET)$(CC) -e $(CFLAGS) --workdir=$(WORKDIR) ulaBankTL
	$(QUIET)$(CC) -e $(CFLAGS) --workdir=$(WORKDIR) rom
	$(QUIET)$(CC) -e $(CFLAGS) --workdir=$(WORKDIR) stateMachine
#	$(QUIET)$(CC) -e $(CFLAGS) --workdir=$(WORKDIR) programCounter 
	@echo ">>> test benches..."
	$(QUIET)$(CC) -e $(CFLAGS) --workdir=$(WORKDIR) testBenchULA
	$(QUIET)$(CC) -e $(CFLAGS) --workdir=$(WORKDIR) testBenchRegister
	$(QUIET)$(CC) -e $(CFLAGS) --workdir=$(WORKDIR) testBenchRegBank
	$(QUIET)$(CC) -e $(CFLAGS) --workdir=$(WORKDIR) testBenchRBU
#	$(QUIET)$(CC) -e $(CFLAGS) --workdir=$(WORKDIR) testBenchPC

.PHONY: simulate
simulate: elaborate
	@echo ">>> simulating design:" $(TB)
	$(QUIET)mkdir -p $(WAVEDIR)
	$(QUIET)$(CC) -r $(CFLAGS) --workdir=$(WORKDIR) $(TB) --wave=$(WAVEDIR)/$(TB).ghw 
	$(QUIET)$(SIM) $(WAVEDIR)/$(TB).ghw 
	

.PHONY: clean
clean:
	@echo ">>> cleaning design..."
	$(QUIET)ghdl --remove --workdir=$(WORKDIR)
	$(QUIET)rm -f $(WORKDIR)/*
	$(QUIET)rm -rf $(WORKDIR)
	$(QUIET)ghdl --remove --workdir=$(WAVEDIR)
	$(QUIET)rm -f $(WAVEDIR)/*
	$(QUIET)rm -rf $(WAVEDIR)
	@echo ">>> done..."