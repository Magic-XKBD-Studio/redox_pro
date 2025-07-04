SDK_ROOT ?= sdk
TEMPLATE_PATH = $(SDK_ROOT)/components/toolchain/gcc
KEYMAP?=raw

# GNU_INSTALL_ROOT ?= D:/software/QMK_MSYS/mingw64/bin/
# GNU_VERSION ?= 9.3.1
GNU_PREFIX := arm-none-eabi

# Toolchain commands
CC              := '$(GNU_INSTALL_ROOT)$(GNU_PREFIX)-gcc'
AS              := '$(GNU_INSTALL_ROOT)$(GNU_PREFIX)-as'
AR              := '$(GNU_INSTALL_ROOT)$(GNU_PREFIX)-ar' -r
LD              := '$(GNU_INSTALL_ROOT)$(GNU_PREFIX)-ld'
NM              := '$(GNU_INSTALL_ROOT)$(GNU_PREFIX)-nm'
OBJDUMP         := '$(GNU_INSTALL_ROOT)$(GNU_PREFIX)-objdump'
OBJCOPY         := '$(GNU_INSTALL_ROOT)$(GNU_PREFIX)-objcopy'
SIZE            := '$(GNU_INSTALL_ROOT)$(GNU_PREFIX)-size'

BUILD_DIR := _build
OBJ_DIR := $(BUILD_DIR)/obj
BIN_DIR := $(BUILD_DIR)/bin

MAIN_SRC := main.c
LEFT_LIB := lib/left.a
RIGHT_LIB := lib/right.a
LINKER_SCRIPT := gzll_gcc_nrf51.ld
LIBS = lib/gzll_gcc.a

CFLAGS  = -DNRF51
CFLAGS += -DGAZELL_PRESENT
CFLAGS += -DBOARD_CUSTOM
CFLAGS += -DBSP_DEFINES_ONLY
CFLAGS += -DNRF_LOG_USES_RTT=1
CFLAGS += -DGPIO_COUNT=0
CFLAGS += -mcpu=cortex-m0
CFLAGS += -mthumb -mabi=aapcs --std=gnu99
CFLAGS += -Wall -Os -g
CFLAGS += -Wno-unused-function
CFLAGS += -Wno-unused-variable
CFLAGS += -mfloat-abi=soft
# keep every function in separate section. This will allow linker to dump unused functions
CFLAGS += -ffunction-sections -fdata-sections -fno-strict-aliasing
CFLAGS += -fno-builtin --short-enums
CFLAGS += -Wno-format

# keep every function in separate section. This will allow linker to dump unused functions
LDFLAGS += -mthumb -mabi=aapcs -L $(TEMPLATE_PATH) -T$(LINKER_SCRIPT)
LDFLAGS += -mcpu=cortex-m0
# let linker to dump unused sections
LDFLAGS += -Wl,--gc-sections
# use newlib in nano version
LDFLAGS += --specs=nano.specs -lc -lnosys
#suppress wchar errors
LDFLAGS += -Wl,--no-wchar-size-warning

# Assembler flags
ASMFLAGS += -x assembler-with-cpp
ASMFLAGS += -DNRF51
ASMFLAGS += -DGAZELL_PRESENT
ASMFLAGS += -DBOARD_CUSTOM
ASMFLAGS += -DBSP_DEFINES_ONLY

$(shell mkdir -p $(OBJ_DIR) $(BIN_DIR))
INC_PATHS = -I$(abspath qmk24_keymaps/${KEYMAP})

all: $(BIN_DIR)/left_kbd_${KEYMAP}.hex $(BIN_DIR)/right_kbd_${KEYMAP}.hex

$(OBJ_DIR)/main-left.o: $(MAIN_SRC)
	@echo "Compiling left main: $<"
	$(CC) $(CFLAGS) $(INC_PATHS) -DCOMPILE_LEFT -c $< -o $@

$(OBJ_DIR)/main-right.o: $(MAIN_SRC)
	@echo "Compiling right main: $<"
	$(CC) $(CFLAGS) $(INC_PATHS) -DCOMPILE_RIGHT -c $< -o $@

$(BIN_DIR)/left_kbd.out: $(OBJ_DIR)/main-left.o $(LEFT_LIB)
	@echo "Linking left firmware"
	$(CC) $(LDFLAGS) $^ $(LIBS) -lm -o $@

$(BIN_DIR)/right_kbd.out: $(OBJ_DIR)/main-right.o $(RIGHT_LIB)
	@echo "Linking right firmware"
	$(CC) $(LDFLAGS) $^ $(LIBS) -lm -o $@

$(BIN_DIR)/left_kbd_${KEYMAP}.hex: $(BIN_DIR)/left_kbd.out
	@echo "Creating HEX: $@"
	$(OBJCOPY) -O ihex $< $@

$(BIN_DIR)/right_kbd_${KEYMAP}.hex: $(BIN_DIR)/right_kbd.out
	@echo "Creating HEX: $@"
	$(OBJCOPY) -O ihex $< $@

clean:
	rm -rf $(BUILD_DIR)

.PHONY: all clean